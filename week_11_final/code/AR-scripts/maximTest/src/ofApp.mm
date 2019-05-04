#include "ofApp.h"
#include "ofxMaxim.h"


//--------------------------------------------------------------
void ofApp::setup(){	
    ofSetVerticalSync(true);
    ofEnableAlphaBlending();
    ofEnableSmoothing();
    ofBackground(0,0,0);
    
    sample.load(ofToDataPath("bass-1.wav"));
    
    sampleRate     = 44100; /* Sampling Rate */
    bufferSize    = 512; /* Buffer Size. you have to fill this buffer with sound using the for loop in the audioOut method */
    
    ofxMaxiSettings::setup(sampleRate, 2, bufferSize);
    // the higher the value, the more accurate will be the fft analysis
    speed = 1.;
    volume = .5;
    /* this has to happen at the end of setup - it switches on the DAC */
    ofSoundStreamSetup(2,2,this, sampleRate, bufferSize, 4);
    ofSoundStreamStart();
    ofSetBackgroundColor(255, 200, 0);
}

//--------------------------------------------------------------
void ofApp::update(){
    
}

//--------------------------------------------------------------
void ofApp::draw(){
	
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::audioOut(float * output, int bufferSize, int nChannels) {
    
    
    for (int i = 0; i < bufferSize; i++){
        //============ Volume avg
        volArray.push_back(xPos);
        if(volArray.size() > 10){
            for(int i = 0; i < volArray.size() - 1; i++){
                volArray[i] = volArray[i + 1];
            }
            volArray.pop_back();
        }
        
        for (int i = 0; i < volArray.size(); i++) {
            volume += volArray[i];
        }
        volume /= volArray.size();
        //============ Volume avg
        
        wave = sample.play(speed);
        mymix.stereo(wave * volume, outputs, .5);
        
        output[i*nChannels    ] = outputs[0];
        output[i*nChannels + 1] = outputs[1];
    }
}

//--------------------------------------------------------------
void ofApp::audioIn(float * input, int bufferSize, int nChannels) {
    
}


//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    speed = ofMap(touch.y, 0, ofGetHeight(), 0.1, 1.5);
    xPos = ofMap(touch.x, 0, ofGetWidth(), 0, 1.);
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
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

}
