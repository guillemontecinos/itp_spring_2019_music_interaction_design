#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    ofSetFrameRate(60);
    
    baseMesh.setMode(OF_PRIMITIVE_LINES);
    for(int x = 0; x <= 500; x += 10){
        for(int y = 0; y <= 500; y += 10){
            ofVec3f pos(x, y, 0);
            baseMesh.addVertex(pos);
            offsets.push_back(ofVec3f(ofRandom(0,100000), ofRandom(0,100000), ofRandom(0,100000)));
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
}

//--------------------------------------------------------------
void ofApp::update(){
    int numVerts = drawMesh.getNumVertices();
    for (int i = 0; i < numVerts; i++) {
        ofVec3f vert = baseMesh.getVertex(i);
        float time = ofGetElapsedTimef();
        float timeScale = 5.0;
        float displacementScale = 0.75;
//        ofVec3f timeOffsets = offsets[i];
//        vert.z += (ofSignedNoise(time*timeScale+timeOffsets.z)) * displacementScale;
        vert.z = 10 * sin(50 * i + 7.5 * time);
        drawMesh.setVertex(i, vert);
    }
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
