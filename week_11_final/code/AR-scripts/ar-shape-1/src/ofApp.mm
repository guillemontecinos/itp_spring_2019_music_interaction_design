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
    
    int fontSize = 8;
    if (ofxiOSGetOFWindow()->isRetinaSupportedOnDevice())
        fontSize *= 2;
    
    font.load("fonts/mono0755.ttf", fontSize);
    
    processor = ARProcessor::create(session);
    processor->setup();
    
    noMesh = true;
    
    //=============== Mesh Stuff ===============
    //all values here are proportianally ported from the local mesh version divided by 300
    base.set(0,0,0);
    vec1.set(0.33,0,0); //(100,0,0)
    vec2.set(0.33,0,0); //(100,0,0)
    vec3.set(0.33,0,0); //(100,0,0)
    
    baseMesh.setMode(OF_PRIMITIVE_LINES);
    //=============== Mesh Stuff ===============
    //=============== Build Mesh ===============
    
    for (float t = 0; t < 60; t += 0.01) {
        vec1.scale(100 * ofNoise(t));
        vec2.scale(200 * ofNoise(2.71828 * t));
        vec3.scale(300 * ofNoise(5000 * t));
        qRot1.makeRotate(200 * t, ofVec3f(0,0,1));
        rotVec1 = qRot1 * vec1;
        qRot2.makeRotate(100 * 2.71828 * t, ofVec3f(0,1,0));
        rotVec2 = qRot2 * vec2;
        vecOut = rotVec1 + rotVec2;
        qRot3.makeRotate(200 * 2.71828 * t, ofVec3f(1,0,0));
        vecOut = vecOut + rotVec3;
        baseMesh.addVertex(vecOut);
        offsets.push_back(ofVec3f(ofNoise(t), ofNoise(t), ofNoise(t)));
    }
    
    //  connect mesh points
    int numVerts = baseMesh.getNumVertices();
    for (int a = 0; a < numVerts - 1; a++) {
        baseMesh.addIndex(a);
        baseMesh.addIndex(a + 1);
    }
    
    //  scale mesh radius
    for (int a = 0; a < numVerts; a++) {
        ofVec3f vert = baseMesh.getVertex(a);
        float len = vert.length();
        vert.scale(len/300);
        baseMesh.setVertex(a, vert);
    }
    
    drawMesh = baseMesh;
    //=============== Build Mesh ===============
    
    //=============== Animation Stuff ===============
    triggerIn = false;
    triggerOut = false;
    durationIn = 0.2; //seconds
    durationOut = 0.2; //seconds
    scale = 1;
    maxScale = 1.2;
    //=============== Animation Stuff ===============
    
    //============ Sound Stuff ===============
    kick.load("BOM_2_h_f_reverb.wav");
    kick.setMultiPlay(true);
    //============ Sound Stuff ===============
}



//--------------------------------------------------------------
void ofApp::update(){
    
    processor->update();
    
    //=============== Animation In ===============
    //Quintic Ease Out function for In animation
    if(triggerIn == true && triggerOut == false && t < durationIn){
        t = ofGetElapsedTimef() - t1;
        float tInMapped = ofMap(t, 0, durationIn, 1, 0);
        float quinticOut = 1 - (tInMapped * tInMapped * tInMapped * tInMapped * tInMapped);
        scale = ofMap(quinticOut, 0, 1, 1, maxScale);
    }
    if(triggerIn == true && triggerOut == false && t >= durationIn){
        triggerIn = false;
        triggerOut = true;
        t1 = ofGetElapsedTimef();
        t = 0;
    }
    //=============== Animation In ===============
    //=============== Animation Out ==============
    //Linear Out animation
    if(triggerIn == false && triggerOut == true && t < durationOut){
        t = ofGetElapsedTimef() - t1;
        float tOutMapped = ofMap(t, 0, durationOut, 0, 1);
        float linearOut = 1 - tOutMapped;
        scale = ofMap(linearOut, 1, 0, maxScale, 1);
    }
    if(triggerIn == false && triggerOut == true && t >= durationOut){
        triggerIn = false;
        triggerOut = false;
        t = 0;
    }
    //=============== Animation Out ==============
    
    //=============== Update Mesh ===============
    int numVerts = drawMesh.getNumVertices();
    for (int i=0; i<numVerts; ++i) {
        ofVec3f vert = baseMesh.getVertex(i);
        float time = ofGetElapsedTimef();
        float timeScale = 0.7;
        ofVec3f timeOffsets = offsets[i];
        float len = vert.length();
        vert.scale(len * (1 + ofMap(ofSignedNoise(time * timeScale + timeOffsets.length()),-1,1,-0.15,0.15)) * scale);
        drawMesh.setVertex(i, vert);
    }
    //=============== Update Mesh ===============
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
    processor->debugInfo.drawDebugInformation(font);
   
    
}

//--------------------------------------------------------------
void ofApp::exit() {
    //
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
    else{
        //=============== Animation Event ===============
        triggerIn = true;
        triggerOut = false;
        t1 = ofGetElapsedTimef();
        //=============== Animation Event ===============
        
        //================ Sound Event ==================
        kick.play();
        //================ Sound Event ==================
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


