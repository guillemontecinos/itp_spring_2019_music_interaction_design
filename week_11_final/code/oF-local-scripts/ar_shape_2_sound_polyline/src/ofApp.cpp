#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    //    ofSetFrameRate(60);
    
    base.set(0,0,0);
    vec1.set(100,0,0);
    vec2.set(100,0,0);
    vec3.set(100,0,0);
    
    //=============== Sound Stuff ===============
    star.load("star-1.wav");
    star.setLoop(true);
    star.play();
    //=============== Sound Stuff ===============
}

//--------------------------------------------------------------
void ofApp::update(){
    //=============== Pitch Stuff ===============
    //calculate pitch param as a mobile average
    float pitchParam = ofMap(ofGetMouseY(),0,ofGetHeight(), .3, 1.2);
    pitchBuffer.push_back(pitchParam);
    float pitch = 0;
    
    if(pitchBuffer.size() > 10){
        for(int i = 0; i < pitchBuffer.size() - 1; i++){
            pitchBuffer[i] = pitchBuffer[i + 1];
            pitch += pitchBuffer[i];
        }
        pitchBuffer.pop_back();
        pitch /= pitchBuffer.size();
    }
    //=============== Pitch Stuff ===============
    
    //=============== Build Mesh ===============
    float t = ofGetElapsedTimef();
    vec1.scale(100 * ofNoise(t));
    vec2.scale(100 * ofNoise(2.71828 * t));
    vec3.scale(100 * ofNoise(5 * t));
    qRot1.makeRotate(pitch * 300 * t, ofVec3f(0,0,1));
    rotVec1 = qRot1 * vec1;
    qRot2.makeRotate(pitch * 300 * 2.71828 * t, ofVec3f(0,1,0));
    rotVec2 = qRot2 * vec2;
    vecOut = rotVec1 + rotVec2;
    qRot3.makeRotate(pitch * 300 * 2.71828 * t, ofVec3f(1,0,0));
    vecOut = vecOut + rotVec3;
    line.addVertex(vecOut);

    if (line.size() > 100){
        line.getVertices().erase(
                                 line.getVertices().begin()
                                 );
    }
    
    for (auto &vert : line.getVertices()){
        vert.x += ofRandom(-.1, .1);
        vert.y += ofRandom(-.1, .1);
        vert.z += ofRandom(-.1, .1);
    }
    
    //=============== Sound Stuff ===============
    star.setSpeed(ofMap(ofGetMouseY(),0,ofGetHeight(), 0.9f, 1.5f));
    //=============== Sound Stuff ===============
}

//--------------------------------------------------------------
void ofApp::draw(){
    cam.begin();
    ofEnableAlphaBlending();
    ofSetColor(255,100);
    ofSetLineWidth(3);
    line.draw();
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
