#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    ofSetFrameRate(60);
    
    baseMesh.setMode(OF_PRIMITIVE_LINES);
    for(int x = 0; x <= 500; x += 10){
        for(int y = 0; y <= 500; y += 10){
            ofVec3f pos(x, y, 0);
            baseMesh.addVertex(pos);
        }
    }
    drawMesh = baseMesh;
    
    float connectionDistance = 14.0;
    int numVerts = drawMesh.getNumVertices();
    for (int a = 0; a < numVerts; a++) {
        ofVec3f verta = drawMesh.getVertex(a);
        for (int b = a + 1; b < numVerts; b++) {
            ofVec3f vertb = drawMesh.getVertex(b);
            float distance = verta.distance(vertb);
            if (distance <= connectionDistance) {
                drawMesh.addIndex(a);
                drawMesh.addIndex(b);
            }
        }
    }
    
    bass.load("bass-1.wav");
    bass.setLoop(true);
    bass.play();
}

//--------------------------------------------------------------
void ofApp::update(){
    lambda = ofMap(ofGetMouseY(), 0, ofGetHeight(), 10, 50);
    
    int numVerts = drawMesh.getNumVertices();
    float time = ofGetElapsedTimef();
    for (int i = 0; i < numVerts; i++) {
        ofVec3f vert = baseMesh.getVertex(i);
        float row = i % 51;
        vert.z = 20 * cos(2 * (PI / lambda) * (row - 50 * time));
        drawMesh.setVertex(i, vert);
    }
    
    bass.setSpeed(ofMap(lambda, 1, 100, 1.5, 0.5));
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofBackground(0, 0, 0);
    cam.begin();
    ofPushMatrix();
    ofTranslate(-ofGetWidth()/2, -ofGetHeight()/2);
    drawMesh.draw();
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
