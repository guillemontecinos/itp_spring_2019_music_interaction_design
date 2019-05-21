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
    
    // ====== AR STUFF ======== //
    ARSession * session;
    ARRef processor;
    ofMatrix4x4 planeMat;
    vector < matrix_float4x4 > mats;
    vector<ARAnchor*> anchors;
    ofTrueTypeFont font;
    ofCamera camera;
    ofImage img;
    //Auxiliary vars
    ofVec3f translation;
    ofQuaternion rotation;
    ofVec3f scale;
    ofQuaternion so;
    // ====== AR STUFF ======== //

    //=============== Global Control Stuff ===============
    vector<bool> meshSet;
    int scene;
    //=============== Global Control Stuff ===============
    
    //=============== Shape 2 Line Stuff ===============
    ofVec3f base, vec1, vec2, vec3, vecOut, rotVec1, rotVec2, rotVec3;
    ofQuaternion qRot1, qRot2, qRot3;
    ofPolyline baseLine, drawLine;
    vector<ofVec3f> offsets;
    vector<float> pitchBuffer;
    vector<ofVec3f> baseArray;
    vector<ofVec3f> drawArray;
    //=============== Shape 2 Line Stuff ===============
    
    //=============== Shape 3 Mesh Stuff ===============
    ofMesh mesh_3;
    float stepSize, numSteps, lambda;
    //=============== Shape 3 Mesh Stuff ===============
    
    //=============== Sound Stuff ===============
    void audioOut(float * output, int bufferSize, int nChannels);
    int        bufferSize;
    int        sampleRate;
    maxiSample bass, arp;
    maxiMix mymix;
    double wave;
    double outputs[2];
    float speedBass, speedArp;
    float gainBass, gainArp, volumeBass, volumeArp;
    ofSoundStream stream;
    vector<double> volArrayBass;
    vector<double> volArrayArp;
    //=============== Sound Stuff ===============
    
    //=============== GUI Stuff ===============
    void resetParamsPressed();
    ofParameter<float> mesh_3_pitch;
    ofParameter<float> pitch;
    ofxButton resetParams;
    ofxPanel gui;
    string uxMessage;
    ofTrueTypeFont messageFont;
    ofRectangle messageBox;
    //=============== GUI Stuff ===============
};


