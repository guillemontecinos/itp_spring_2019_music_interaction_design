#pragma once

#include "ofxiOS.h"
#include "ofxARKit.h"
#include "ofxGui.h"
#include "maximilian.h"

class ofApp : public ofxiOSApp {
    
public:
    
    ofApp (ARSession * session);
    ofApp();
    ~ofApp ();
    
    void setup();
    void update();
    void draw();
    void exit();
    
    void touchDown(ofTouchEventArgs &touch);
    void touchMoved(ofTouchEventArgs &touch);
    void touchUp(ofTouchEventArgs &touch);
    void touchDoubleTap(ofTouchEventArgs &touch);
    void touchCancelled(ofTouchEventArgs &touch);
    
    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);

    
    ofTrueTypeFont font;
    ofCamera camera;
    ofImage img;
    
    //=============== Mesh Stuff ===============
    ofMesh mesh;
//    float lambda, stepSize, numSteps;
    float stepSize, numSteps;
    bool meshSet;
    //=============== Mesh Stuff ===============
    
    //=============== Sound Stuff ===============
    void audioOut(float * output, int bufferSize, int nChannels);
    //    void audioIn(float * input, int bufferSize, int nChannels);
    
    int        bufferSize;
    int        sampleRate;
    
    maxiSample bass;
    maxiMix mymix;
    double wave;
    double outputs[2];
    float speed;
    float gain, volume;
    ofSoundStream stream;
    vector<double> volArray;
    //=============== Sound Stuff ===============
    
    // ====== AR STUFF ======== //
    ARSession * session;
    ARRef processor;
    ofMatrix4x4 planeMat;
    // ====== AR STUFF ======== //
    
    //=============== GUI Stuff ===============
    ofParameter<float> lambda;
    ofxPanel gui;
    //=============== GUI Stuff ===============
};


