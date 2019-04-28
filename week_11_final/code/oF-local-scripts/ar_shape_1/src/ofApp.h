#pragma once

#include "ofMain.h"

class ofApp : public ofBaseApp{

	public:
		void setup();
		void update();
		void draw();

		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void mouseEntered(int x, int y);
		void mouseExited(int x, int y);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);
		
    ofEasyCam cam;
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
    
//    float scale;
};
