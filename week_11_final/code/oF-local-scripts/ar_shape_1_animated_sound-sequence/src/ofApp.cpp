#include "ofApp.h"
#include "ofxMaxim.h"

//--------------------------------------------------------------
void ofApp::setup(){
    ofSetFrameRate(30);
    
    base.set(0,0,0);
    vec1.set(100,0,0);
    vec2.set(100,0,0);
    vec3.set(100,0,0);
    
    baseMesh.setMode(OF_PRIMITIVE_LINES);
    
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
    
    int numVerts = baseMesh.getNumVertices();
    for (int a = 0; a < numVerts - 1; a++) {
        baseMesh.addIndex(a);
        baseMesh.addIndex(a + 1);
    }
    drawMesh = baseMesh;
    //=============== Build Mesh ===============
    
    //=============== Animation Stuff ===============
    triggerIn = false;
    triggerOut = false;
    durationIn = 0.2; //seconds
    durationOut = 0.2; //seconds
    scale = 1;
    maxScale = 1.5;
    //=============== Animation Stuff ===============
    
    //============ Sound Stuff ===============
    kick.load(ofToDataPath("BOM_2_h_f_reverb.wav"));
    tempo = 60;
//    kick.setMultiPlay(true);
    //============ Sound Stuff ===============
    sampleRate     = 44100; /* Sampling Rate */
    bufferSize    = 512; /* Buffer Size. you have to fill this buffer with sound using the for*/
    ofxMaxiSettings::setup(sampleRate, 2, bufferSize);
    transport.setTicksPerBeat(4);//This sets the number of ticks per beat
    transport.setTempo(60);// This sets the tempo in Beats Per Minute
    ofSoundStreamSetup(2,2,this, sampleRate, bufferSize, 4);
    ofSoundStreamStart();
}

//--------------------------------------------------------------
void ofApp::update(){
    tempo = ofMap(ofGetMouseY(), 0, ofGetHeight(), 20, 150);
    transport.setTempo(tempo);
    
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
        float timeScale = 0.5;
        ofVec3f timeOffsets = offsets[i];
        float len = vert.length();
        vert.scale(len * (1 + ofMap(ofSignedNoise(time * timeScale + timeOffsets.length()),-1,1,-0.2,0.2)) * scale);
        drawMesh.setVertex(i, vert);
    }
    //=============== Update Mesh ===============
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    cam.begin();
    drawMesh.draw();
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
    //=============== Animation Event ===============
//    triggerIn = true;
//    triggerOut = false;
//    t1 = ofGetElapsedTimef();
    //=============== Animation Event ===============
    
    //================ Sound Event ==================
//    kick.trigger();
    //================ Sound Event ==================
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

void ofApp::audioOut (float * output, int bufferSize, int nChannels){
    for (int sample = 0; sample < bufferSize; sample++){
        transport.ticker();
        if (transport.tick && transport.playHead % 2 == 0) {
//        if (transport.tick && transport.playHead % 2 == 0) {
            kick.trigger();
            cout << "beat" << endl;
            //=============== Animation Event ===============
            triggerIn = true;
            triggerOut = false;
            t1 = ofGetElapsedTimef();
            //=============== Animation Event ===============
            
            //================ Sound Event ==================
//            kick.play();
            //================ Sound Event ==================
        }
        wave = kick.playOnce(1.0) * 1.0;
        //add them all together
        myMix.stereo(wave, outputs , 0.5);
        
        //output to speakers
        output [sample * nChannels] = outputs[0];
        output [sample * nChannels + 1] = outputs[1];
    }
}
