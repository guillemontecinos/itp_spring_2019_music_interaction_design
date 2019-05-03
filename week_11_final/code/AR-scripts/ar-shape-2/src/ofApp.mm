#include "ofApp.h"

using namespace ofxARKit::common;

void logSIMD(const simd::float4x4 &matrix)
{
    std::stringstream output;
    int columnCount = sizeof(matrix.columns) / sizeof(matrix.columns[0]);
    for (int column = 0; column < columnCount; column++) {
        int rowCount = sizeof(matrix.columns[column]) / sizeof(matrix.columns[column][0]);
        for (int row = 0; row < rowCount; row++) {
            output << std::setfill(' ') << std::setw(9) << matrix.columns[column][row];
            output << ' ';
        }
        output << std::endl;
    }
    output << std::endl;
}

//--------------------------------------------------------------
ofApp :: ofApp (ARSession * session){
    this->session = session;
    cout << "creating ofApp" << endl;
}

ofApp::ofApp(){}

//--------------------------------------------------------------
ofApp :: ~ofApp () {
    cout << "destroying ofApp" << endl;
}

//--------------------------------------------------------------
void ofApp::setup() {
    ofBackground(127);
    
    img.load("OpenFrameworks.png");
    
//    int fontSize = 8;
//    if (ofxiOSGetOFWindow()->isRetinaSupportedOnDevice())
//        fontSize *= 2;
//
//    font.load("fonts/mono0755.ttf", fontSize);
    
    //=============== GUI Stuff ===============
    ofxGuiSetFont("Questrial-Regular.ttf",20,true,true);
    ofxGuiSetTextPadding(4);
    ofxGuiSetDefaultWidth(500);
    ofxGuiSetDefaultHeight(50);
    
    gui.setup("Settings");
    gui.add(pitch.set("Arp Pitch", 140, 0, 100));
    //=============== GUI Stuff ===============
    
    //=============== AR Stuff ===============
    processor = ARProcessor::create(session);
    processor->setup();
    //=============== AR Stuff ===============
    
    noMesh = true;
    
    //=============== Mesh Stuff ===============
    //all values here are proportianally ported from the local mesh version divided by 300
    base.set(0,0,0);
    vec1.set(0.33,0,0); //(100,0,0)
    vec2.set(0.33,0,0); //(100,0,0)
    vec3.set(0.33,0,0); //(100,0,0)
    
    baseMesh.setMode(OF_PRIMITIVE_LINES);
    //=============== Mesh Stuff ===============
   
    //============ Sound Stuff ===============
    arp.load("star-1.wav");
    arp.setLoop(true);
    arp.play();
    //============ Sound Stuff ===============
}



//--------------------------------------------------------------
void ofApp::update(){
    
    processor->update();
    
    //=============== Build Mesh ===============
    float t = ofGetElapsedTimef();
    vec1.scale(100 * ofNoise(t));
    vec2.scale(100 * ofNoise(2.71828 * t));
    vec3.scale(100 * ofNoise(5 * t));
    qRot1.makeRotate(300 * t, ofVec3f(0,0,1));
    rotVec1 = qRot1 * vec1;
    qRot2.makeRotate(300 * 2.71828 * t, ofVec3f(0,1,0));
    rotVec2 = qRot2 * vec2;
    vecOut = rotVec1 + rotVec2;
    qRot3.makeRotate(300 * 2.71828 * t, ofVec3f(1,0,0));
    vecOut = vecOut + rotVec3;
    baseMesh.addVertex(vecOut);
    
    if (baseMesh.getNumVertices() > 100) {
        baseMesh.removeVertex(0);
    }
    
    int numVerts = baseMesh.getNumVertices();
    for (int a = 0; a < numVerts - 1; a++) {
        baseMesh.addIndex(a);
        baseMesh.addIndex(a + 1);
    }
    
    drawMesh = baseMesh;
    
    for (int a = 0; a < numVerts; a++) {
        ofVec3f vert = baseMesh.getVertex(a);
        float len = vert.length();
        vert.scale(len/300);
        drawMesh.setVertex(a, vert);
    }
    //=============== Build Mesh ===============
    
    //=============== Sound Stuff ===============
    arp.setSpeed(ofMap(pitch, 0, 100, .3, 1.2));
    //=============== Sound Stuff ===============
    
}

//--------------------------------------------------------------
void ofApp::draw() {
    ofEnableAlphaBlending();
    
    ofDisableDepthTest();
    processor->draw();
    ofEnableDepthTest();
    
    
    if (session.currentFrame){
        if (session.currentFrame.camera){
           
            camera.begin();
            processor->setARCameraMatrices();
            
            for (int i = 0; i < session.currentFrame.anchors.count; i++){
                ARAnchor * anchor = session.currentFrame.anchors[i];
                
                // note - if you need to differentiate between different types of anchors, there is a 
                // "isKindOfClass" method in objective-c that could be used. For example, if you wanted to 
                // check for a Plane anchor, you could put this in an if statement.
                // if([anchor isKindOfClass:[ARPlaneAnchor class]]) { // do something if we find a plane anchor}
                // Not important for this example but something good to remember.
                
                ofPushMatrix();
                ofMatrix4x4 mat = convert<matrix_float4x4, ofMatrix4x4>(anchor.transform);
                
                ofMultMatrix(mat);
                
                ofSetColor(255);
                ofRotate(90,0,0,1);
                
                if(i == 0){
                    drawMesh.draw();
                }
                ofPopMatrix();
            }
          
            camera.end();
        }
        
    }
    ofDisableDepthTest();
    // ========== DEBUG STUFF ============= //
//    processor->debugInfo.drawDebugInformation(font);
    gui.draw();
   
    
}

//--------------------------------------------------------------
void ofApp::exit() {

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs &touch){
    if(noMesh == true){
        if (session.currentFrame){
            ARFrame *currentFrame = [session currentFrame];
            
            matrix_float4x4 translation = matrix_identity_float4x4;
            translation.columns[3].z = -0.2;
            matrix_float4x4 transform = matrix_multiply(currentFrame.camera.transform, translation);
            
            // Add a new anchor to the session
            ARAnchor *anchor = [[ARAnchor alloc] initWithTransform:transform];
            
            [session addAnchor:anchor];
        }
        noMesh = false;
    }
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs &touch){
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs &touch){
    
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs &touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){
  
    processor->deviceOrientationChanged(newOrientation);
}


//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs& args){
    
}


