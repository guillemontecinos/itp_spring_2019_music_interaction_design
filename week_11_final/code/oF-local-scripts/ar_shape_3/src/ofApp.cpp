#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    ofSetFrameRate(60);
    
    //=============== Mesh Stuff ===============
    stepSize = 10;
    numSteps = 50;
    mesh.setMode(OF_PRIMITIVE_LINES);
    for(int x = 0; x <= stepSize * numSteps; x += stepSize){
        for(int y = 0; y <= stepSize * numSteps; y += stepSize){
            ofVec3f pos(x, y, 0);
            mesh.addVertex(pos);
        }
    }
    
    float connectionDistance = 14.0;
    int numVerts = mesh.getNumVertices();
    for (int a = 0; a < numVerts; a++) {
        ofVec3f verta = mesh.getVertex(a);
        for (int b = a + 1; b < numVerts; b++) {
            ofVec3f vertb = mesh.getVertex(b);
            float distance = verta.distance(vertb);
            if (distance <= connectionDistance) {
                mesh.addIndex(a);
                mesh.addIndex(b);
            }
        }
    }
    //=============== Mesh Stuff ===============
    
    //=============== Sound Stuff ===============
    bass.load("bass-1.wav");
    bass.setLoop(true);
    bass.play();
    //=============== Sound Stuff ===============
}

//--------------------------------------------------------------
void ofApp::update(){
    //=============== Mesh Stuff ===============
    lambda = ofMap(ofGetMouseY(), 0, ofGetHeight(), 10, 50);
    
    int numVerts = mesh.getNumVertices();
    float time = ofGetElapsedTimef();
    for (int i = 0; i < numVerts; i++) {
        ofVec3f vert = mesh.getVertex(i);
        float row = i % (numSteps + 1);
        vert.z = 20 * cos(2 * (PI / lambda) * (row - 50 * time));
        mesh.setVertex(i, vert);
    }
    //=============== Mesh Stuff ===============
    
    //=============== Sound Stuff ===============
    bass.setSpeed(ofMap(lambda, 1, 100, 1.5, 0.5));
    //=============== Sound Stuff ===============
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofBackground(0, 0, 0);
    ofSetColor(165, 160, 170, 50);
    cam.begin();
    ofPushMatrix();
    ofTranslate(-ofGetWidth()/4, -ofGetHeight()/2);
    ofSetLineWidth(2);
    mesh.draw();
//    for (int i = 0; i < mesh.getNumVertices(); i++) {
//        ofVec3f vert = mesh.getVertex(i);
//        ofDrawSphere(vert, 1);
//    }
    ofPopMatrix();
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
