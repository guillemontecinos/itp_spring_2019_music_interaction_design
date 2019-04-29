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
    ofVec3f base, vec1, vec2, vec3, vecOut, rotVec1, rotVec2, rotVec3;
    ofQuaternion qRot1, qRot2, qRot3;
    ofMesh baseMesh, drawMesh;
    vector<ofVec3f> offsets;
    ofSoundPlayer star;
//    ofColor c;
//    int hue;
		
};
