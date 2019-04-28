#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    pos.set(0,0,0);
//=============== Animation Stuff ===============
    triggerIn = false;
    triggerOut = false;
    durationIn = 0.2; //seconds
    durationOut = 0.3; //seconds
    radScale = 3;
    rad = 20;
    currentRad = rad;
//=============== Animation Stuff ===============
}

//--------------------------------------------------------------
void ofApp::update(){
//=============== Animation In ===============
//Quintic Ease Out function for In animation
    if(triggerIn == true && triggerOut == false && t < durationIn){
        t = ofGetElapsedTimef() - t1;
        float tInMapped = ofMap(t, 0, durationIn, 1, 0);
        float quinticOut = 1 - (tInMapped * tInMapped * tInMapped * tInMapped * tInMapped);
        currentRad = ofMap(quinticOut, 0, 1, rad, radScale * rad);
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
        currentRad = ofMap(linearOut, 1, 0, radScale * rad, rad);
    }
    if(triggerIn == false && triggerOut == true && t >= durationOut){
        triggerIn = false;
        triggerOut = false;
        t = 0;
    }
//=============== Animation Out ==============
    cout << currentRad << endl;
}

//--------------------------------------------------------------
void ofApp::draw(){
    cam.begin();
    ofDrawGrid(4,50);
    ofDrawSphere(pos.x, pos.y, pos.z, currentRad);
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
    triggerIn = true;
    triggerOut = false;
    t1 = ofGetElapsedTimef();
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
