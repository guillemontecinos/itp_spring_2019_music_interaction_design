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

    // ====== AR STUFF ======== //
    ARSession * session;
    ARRef processor;
    
    //=============== Mesh Stuff ===============
    ofVec3f base;
    ofVec3f vec1;
    ofVec3f vec2;
    ofVec3f vec3;
    ofVec3f vecOut;
    ofVec3f rotVec1;
    ofVec3f rotVec2;
    ofVec3f rotVec3;
    ofQuaternion qRot1;
    ofQuaternion qRot2;
    ofQuaternion qRot3;
    ofMesh baseMesh;
    ofMesh drawMesh;
    vector<ofVec3f> offsets;
    //=============== Mesh Stuff ===============
};


