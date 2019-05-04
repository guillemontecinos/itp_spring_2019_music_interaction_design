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
    
    //=============== Line Stuff ===============
    //all values here are proportianally ported from the local mesh version divided by 300
    base.set(0,0,0);
    vec1.set(0.33,0,0); //(100,0,0)
    vec2.set(0.33,0,0); //(100,0,0)
    vec3.set(0.33,0,0); //(100,0,0)
    
    //=============== Line Stuff ===============
   
    //============ Sound Stuff ===============
    arp.load("star-1.wav");
    arp.setLoop(true);
    arp.play();
    //============ Sound Stuff ===============
}



//--------------------------------------------------------------
void ofApp::update(){
    
    processor->update();
    
    //=============== Pitch Stuff ===============
    //calculate pitch param as a mobile average
    pitchBuffer.push_back(pitch);
    float pitchAvg = 0;
    
    if(pitchBuffer.size() > 10){
        for(int i = 0; i < pitchBuffer.size() - 1; i++){
            pitchBuffer[i] = pitchBuffer[i + 1];
            pitchAvg += pitchBuffer[i];
        }
        pitchBuffer.pop_back();
        pitchAvg /= pitchBuffer.size();
    }
    //=============== Pitch Stuff ===============
    
    //=============== Build Line ===============
    float t = ofGetElapsedTimef();
    vec1.scale(100 * ofNoise(t));
//    vec1.scale(.33 * ofNoise(t));
    vec2.scale(100 * ofNoise(2.71828 * t));
//    vec2.scale(.33 * ofNoise(2.71828 * t));
    vec3.scale(100 * ofNoise(5 * t));
//    vec3.scale(.33 * ofNoise(5 * t));
    qRot1.makeRotate(300 * t, ofVec3f(0,0,1));
//    qRot1.makeRotate(t, ofVec3f(0,0,1));
    rotVec1 = qRot1 * vec1;
    qRot2.makeRotate(300 * 2.71828 * t, ofVec3f(0,1,0));
//    qRot2.makeRotate(2.71828 * t, ofVec3f(0,1,0));
    rotVec2 = qRot2 * vec2;
    vecOut = rotVec1 + rotVec2;
    qRot3.makeRotate(300 * 2.71828 * t, ofVec3f(1,0,0));
//    qRot3.makeRotate(2.71828 * t, ofVec3f(1,0,0));
    vecOut = vecOut + rotVec3;
    
    baseArray.push_back(vecOut);
    
    if(baseArray.size() > 100){
        for (int i = 0; i < baseArray.size() - 1; i++) {
            baseArray[i] = baseArray[i + 1];
        }
        baseArray.pop_back();
    }
    
    drawLine.clear();
    
    for (int i = 0; i < baseArray.size(); i++) {
        float len = baseArray[i].length();
        drawArray[i].set(baseArray[i].x, baseArray[i].y, baseArray[i].z);
        drawArray[i].scale(len/300);
        drawLine.addVertex(drawArray[i]);
    }
    
//    if (baseLine.size() > 100){
//        baseLine.getVertices().erase(
//                                 baseLine.getVertices().begin()
//                                 );
//    }
//
//    for (auto &vert : baseLine.getVertices()){
//        vert.x += ofRandom(-.1, .1);
//        vert.y += ofRandom(-.1, .1);
//        vert.z += ofRandom(-.1, .1);
//    }
    
//    drawLine = baseLine;
//
//    for (auto &vert : drawLine.getVertices()){
//        ofVec3f aux = ofVec3f(vert);
//        float len = aux.length();
//        aux.scale(len/300);
//        vert.x = aux.x;
//        vert.y = aux.y;
//        vert.z = aux.z;
//    }
    
    
//    for (int a = 0; a < numVerts; a++) {
//        ofVec3f vert = baseMesh.getVertex(a);
//        float len = vert.length();
//        vert.scale(len/300);
//        drawMesh.setVertex(a, vert);
//    }
    //=============== Build Line ===============
    
    //=============== Sound Stuff ===============
    arp.setSpeed(ofMap(pitchAvg, 0, 100, .3, 1.2));
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
//                    drawMesh.draw();
//                    ofSetColor(255, 100);
//                    ofSetLineWidth(3);
                    baseLine.draw();
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


