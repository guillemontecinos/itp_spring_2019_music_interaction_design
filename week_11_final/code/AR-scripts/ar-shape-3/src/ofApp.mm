#include "ofApp.h"


//--------------------------------------------------------------
ofApp :: ofApp (ARSession * session){
    this->session = session;
    cout << "creating ofApp" << endl;
}

ofApp::ofApp(){}

//--------------------------------------------------------------
ofApp :: ~ofApp () {
    cout << "destroying ofApp" << endl;
}

//--------------------------------------------------------------
void ofApp::setup() {
//    ofBackground(127);
    
    img.load("OpenFrameworks.png");
    
    //=============== GUI Stuff ===============
    ofxGuiSetFont("Questrial-Regular.ttf",20,true,true);
    ofxGuiSetTextPadding(4);
    ofxGuiSetDefaultWidth(500);
    ofxGuiSetDefaultHeight(50);
    
    gui.setup("Settings");
    gui.add(lambda.set( "Bass Wave Length", 140, 10, 50));
    //=============== GUI Stuff ===============
    
    //=============== AR Stuff ===============
    processor = ARProcessor::create(session);
    processor->setup();
    //=============== AR Stuff ===============
    
    meshSet = false;
    
    //=============== Mesh Stuff ===============
    lambda = 10;
    stepSize = .1;
    numSteps = 20;
    mesh.setMode(OF_PRIMITIVE_LINES);
    for(float x = 0; x <= stepSize * numSteps; x += stepSize){
        for(float y = 0; y <= stepSize * numSteps; y += stepSize){
            ofVec3f pos(x, y, 0);
            mesh.addVertex(pos);
        }
    }
    
    float connectionDistance = .11;
    int numVerts = mesh.getNumVertices();
    for (int a = 0; a < numVerts; a++) {
        ofVec3f verta = mesh.getVertex(a);
        for (int b = a + 1; b < numVerts; b++) {
            ofVec3f vertb = mesh.getVertex(b);
            float distance = verta.distance(vertb);
            if (distance <= connectionDistance) {
                mesh.addIndex(a);
                mesh.addIndex(b);
            }
        }
    }
    //=============== Mesh Stuff ===============
    
    //=============== Sound Stuff ===============
    bass.load("bass-1.mp3");
    bass.setLoop(true);
    //=============== Sound Stuff ===============
    
}

vector < matrix_float4x4 > mats;

//--------------------------------------------------------------
void ofApp::update(){
    processor->update();
    
    if(processor->anchorController->getNumPlanes() < 1){
        processor->updatePlanes();
    }
    
    mats.clear();
    
    //=============== Mesh Stuff ===============
//    lambda = ofMap(ofGetMouseY(), 0, ofGetHeight(), 10, 50);
    
    int numVerts = mesh.getNumVertices();
    float time = ofGetElapsedTimef();
    for (int i = 0; i < numVerts; i++) {
        ofVec3f vert = mesh.getVertex(i);
        float row = i % int(numSteps);
        vert.z = 0.15 + 0.15 * cos(2 * (PI / lambda) * (row - 20 * time));
        mesh.setVertex(i, vert);
    }
    //=============== Mesh Stuff ===============
    
    //=============== Sound Stuff ===============
        bass.setSpeed(ofMap(lambda, 10, 50, 1.5, 0.1));
    //=============== Sound Stuff ===============
}

//--------------------------------------------------------------
void ofApp::draw() {
    ofEnableAlphaBlending();
    
    //draw camera
    ofDisableDepthTest();
    processor->draw();
    
    ofEnableDepthTest();
    
    //load planes
    processor->anchorController->loopPlaneAnchors([=](PlaneAnchorObject obj)->void {
    
        camera.begin();
        processor->setARCameraMatrices();
        
        ofVec3f translation;
        ofQuaternion rotation;
        ofVec3f scale;
        ofQuaternion so;
        
        ofPushMatrix();
        //this line does the same of below but with the original matrix
        ofMultMatrix(obj.transform);
        
        
        //=============== Debug Camera Position ===============
//        obj.transform.decompose(translation,rotation,scale,so);
//        cout << "obj: " << translation.x << ", " << translation.y << ", " << translation.z << ", d:  " << translation.length() << ", t: " << ofGetElapsedTimef() << endl;
//
//        ofVec3f cam_pos = processor->getCameraPosition();
//        cout << "cam: " << cam_pos.x << ", " << cam_pos.y << ", " << cam_pos.z << ", d:  " << cam_pos.length() << ", t: " << ofGetElapsedTimef() << endl;
        //=============== Debug Camera Position ===============
        
        //rotation around x-axis
        ofVec3f axis;
        float angle;
        ofQuaternion curRot(90, ofVec3f(1,0,0));
        curRot.getRotate(angle, axis);
        ofRotateDeg(angle, axis.x, axis.y, axis.z);
        
        if(meshSet == false){
            ofSetColor(255, 100);
            ofDrawRectangle(0, 0, 1, 1);
        }
        else{
            ofSetColor(235, 205, 60, 50);
            glLineWidth(5);
            mesh.draw();
        }
        
        ofPopMatrix();
        
        camera.end();
        
    });
    
    ofDisableDepthTest();
    // ========== DEBUG STUFF ============= //
    
    ofSetColor(255, 100);

//    processor->debugInfo.drawDebugInformation(font);
    //draw gui
    gui.draw();
}

//--------------------------------------------------------------
void ofApp::exit() {
    //
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs &touch){
    //sets the mesh in the position of the plane
    if(meshSet == false && processor->anchorController->getNumPlanes() > 0){
        meshSet = true;
        bass.play();
    }
    
//    processor->addAnchor(ofVec3f(touch.x,touch.y,-0.2));
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs &touch){
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs &touch){
    
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs &touch){
    
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
    processor->deviceOrientationChanged(newOrientation);
}


//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs& args){
    
}


