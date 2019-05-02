#pragma once

#include "ofxiOS.h"
#include "ofxARKit.h"
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
    float lambda, stepSize, numSteps;
    bool meshSet;
    //=============== Mesh Stuff ===============
    
    //=============== Sound Stuff ===============
    ofSoundPlayer bass;
    //=============== Sound Stuff ===============
    
    // ====== AR STUFF ======== //
    ARSession * session;
    ARRef processor;
    // ====== AR STUFF ======== //
    
    
};


