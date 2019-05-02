#pragma once

#include "ofxiOS.h"
#include <ARKit/ARKit.h>
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
    ofVec3f base, vec1, vec2, vec3, vecOut, rotVec1, rotVec2, rotVec3;
    ofQuaternion qRot1, qRot2, qRot3;
    ofMesh baseMesh, drawMesh;
    vector<ofVec3f> offsets;
    float scale;
    //=============== Mesh Stuff ===============
    
    //============ Animation Stuff ===============
    bool triggerIn, triggerOut;
    float t, t1, durationIn, durationOut, maxScale;
    int span;
    //============ Animation Stuff ===============
    
    //============ Sound Stuff ===============
    ofSoundPlayer kick;
    //============ Sound Stuff ===============
};


