#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    //    ofSetFrameRate(60);
    
    base.set(0,0,0);
    vec1.set(100,0,0);
    vec2.set(100,0,0);
    vec3.set(100,0,0);
    
    //=============== Mesh Stuff ===============
    baseMesh.setMode(OF_PRIMITIVE_LINES);
    baseMesh.enableColors();
    //=============== Mesh Stuff ===============
    
    //=============== Sound Stuff ===============
    star.load("star-1.wav");
    star.setLoop(true);
    star.play();
    //=============== Sound Stuff ===============
    
//    c = ofColor(0);
//    hue = 0;
}

//--------------------------------------------------------------
void ofApp::update(){
    float pitch = ofMap(ofGetMouseY(),0,ofGetHeight(), .3, 1.2);
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

//    hue = (int)ofMap(pitch, .3, 1.2, 140, 230);
//    c.setHsb(hue, 255, 200);
//    baseMesh.addColor(c);
//    offsets.push_back(ofVec3f(ofNoise(t), ofNoise(t), ofNoise(t)));
    
    if (baseMesh.getNumVertices() > 100) {
        baseMesh.removeVertex(0);
    }
    
    int numVerts = baseMesh.getNumVertices();
    for (int a = 0; a < numVerts - 1; a++) {
        baseMesh.addIndex(a);
        baseMesh.addIndex(a + 1);
    }
//    drawMesh = baseMesh;
    //=============== Build Mesh ===============
    
    //============== Update Mesh ===============
//    for (int i=0; i<numVerts; ++i) {
//        ofVec3f vert = baseMesh.getVertex(i);
//        float time = ofGetElapsedTimef();
//        float timeScale = 1;
////        ofVec3f timeOffsets = offsets[i];
//        float len = vert.length();
//        //        vert.scale(len * (1 + ofMap(ofSignedNoise(time * timeScale + timeOffsets.length()),-1,1,-0.1,0.1)) * scale);
//        //        vert.scale(len * (1 + ofMap(ofSignedNoise(time * timeScale + timeOffsets.length()),-1,1,-0.15,0.15)));
//        vert.scale(len * (1 + ofMap(ofRandom(pitch),0,pitch,-pitch/30,pitch/30)));
//        drawMesh.setVertex(i, vert);
//    }
    //============== Update Mesh ===============
    
    //=============== Sound Stuff ===============
    star.setSpeed(ofMap(ofGetMouseY(),0,ofGetHeight(), 0.9f, 1.5f));
    //=============== Sound Stuff ===============
}

//--------------------------------------------------------------
void ofApp::draw(){
    cam.begin();
    ofEnableAlphaBlending();
//    drawMesh.draw();
    baseMesh.draw();
    cam.end();
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
    
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){
    
}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){
    
}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){
    
}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){
    
}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){
    
}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){
    
}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){
    
}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){
    
}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){
    
}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){
    
}
