#pragma once

#include "ofxiOS.h"
#include "maximilian.h"

class ofApp : public ofxiOSApp {
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
	
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);

        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
    
    // Audio output and input methods
    void audioOut(float * output, int bufferSize, int nChannels);
    void audioIn(float * input, int bufferSize, int nChannels);
    
    int        bufferSize;
    int        sampleRate;
    
    maxiSample sample;
    maxiMix mymix;
    double wave;
    double outputs[2];
    float speed;
    float xPos, volume;
    ofSoundStream stream;
    vector<double> volArray;

};


