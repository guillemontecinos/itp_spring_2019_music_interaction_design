#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    ofSetFrameRate(60);

//    soundPlayer.load("wfishes.mp3");
    soundPlayer.load("frontera.mp3");
//    soundPlayer.load("green_grass.mp3");
    soundPlayer.play();
    numBands = 1024;
    
//freqBandsPrev is used to somooth energy at each band, lets say it's a low pass filter
    freqBandsPrev = new float[numBands];
    for (int i = 0; i < numBands; i++){
        freqBandsPrev[i] = 0;
    }
//create mesh vertexes
    mesh.setMode(OF_PRIMITIVE_LINES);
    numSamplesDrawed = numBands / 4;
    numBuffers = 15;
    vectorMaxLength = numSamplesDrawed * numBuffers;
    int yStep = floor(ofGetHeight() / numBuffers);
    int xStep = floor(ofGetWidth() / numSamplesDrawed);
    for(int y = 0; y < ofGetHeight(); y += yStep){
        for (int x = 0; x < ofGetWidth(); x += xStep) {
            ofVec3f pos(x, y, 0);
            mesh.addVertex(pos);
        }
    }
    
//connect mesh vertex
    float connectionDistance = xStep;
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
}

//--------------------------------------------------------------
void ofApp::update(){
//get and smooth frequency bands
    freqBands = ofSoundGetSpectrum(numBands);
    
//smoothing bands
//    for (int  i = 0; i < numBands; i++) {
//        freqBands[i] = 0.05 * freqBands[i] + 0.95 * freqBandsPrev[i];
//        freqBandsPrev[i] = freqBands[i];
//    }

//filling bandsVec
    if(bandsVec.size() > vectorMaxLength){
        for (int i = numSamplesDrawed; i < bandsVec.size(); i++) {
            bandsVec[i - numSamplesDrawed] = bandsVec[i];
        }
        for (int i = 0; i < numSamplesDrawed; i++) {
            bandsVec.pop_back();
        }
    }
    else{
        for (int  i = 0; i < numSamplesDrawed; i++) {
            bandsVec.push_back(freqBands[i]);
        }
    }

//setting height for each sample
    for (int i = 0; i < mesh.getNumVertices(); i++) {
        ofVec3f vert = mesh.getVertex(i);
        vert.z = bandsVec[i] * 100;
        mesh.setVertex(i, vert);
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofBackground(0, 0, 0);
    cam.begin();
        ofPushMatrix();
            ofTranslate(-ofGetWidth()/2, -ofGetHeight()/2);
            mesh.draw();
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
