#pragma once

#include "ofxiOS.h"
#include <ARKit/ARKit.h>
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
    
    vector < matrix_float4x4 > mats;
    vector<ARAnchor*> anchors;
    ofCamera camera;
    ofTrueTypeFont font;
    ofImage img;
    bool noMesh;

    // ====== AR STUFF ======== //
    ARSession * session;
    ARRef processor;
    
    //=============== Mesh Stuff ===============
    ofEasyCam cam;
    ofVec3f base, vec1, vec2, vec3, vecOut, rotVec1, rotVec2, rotVec3;
    ofQuaternion qRot1, qRot2, qRot3;
    ofPolyline baseLine, drawLine;
    vector<ofVec3f> offsets;
    vector<float> pitchBuffer;
    vector<ofVec3f> baseArray;
    vector<ofVec3f> drawArray;
    //=============== Mesh Stuff ===============
    
    //============ Sound Stuff ===============
    void audioOut(float * output, int bufferSize, int nChannels);
//    void audioIn(float * input, int bufferSize, int nChannels);
    
    int        bufferSize;
    int        sampleRate;
    
    maxiSample sample;
    maxiMix mymix;
    double wave;
    double outputs[2];
    float speed;
    float gain, volume;
    ofSoundStream stream;
    vector<double> volArray;
    //============ Sound Stuff ===============
    
    //=============== GUI Stuff ===============
    ofParameter<float> pitch;
    ofxPanel gui;
    //=============== GUI Stuff ===============
};


