#include "ofApp.h"
#include "ofxMaxim.h"


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
    bass.load(ofToDataPath("bass-1.wav"));
    
    sampleRate     = 44100; /* Sampling Rate */
    bufferSize    = 512; /* Buffer Size. you have to fill this buffer with sound using the for loop in the audioOut method */
    volume = .5;
    ofxMaxiSettings::setup(sampleRate, 2, bufferSize);
    // the higher the value, the more accurate will be the fft analysis
    speed = 1.;
    /* this has to happen at the end of setup - it switches on the DAC */
    ofSoundStreamSetup(2,2,this, sampleRate, bufferSize, 4);
    ofSoundStreamStart();
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
    
    //=============== Distance Calculation ===============
    ofVec3f cam_pos = processor->getCameraPosition();
    
    if(processor->anchorController->getPlaneAnchors().size() > 0){
        planeMat = ofMatrix4x4(processor->anchorController->getPlaneAnchors()[0].transform);
        ofMultMatrix(planeMat);
        ofVec3f translation;
        ofQuaternion rotation;
        ofVec3f scale;
        ofQuaternion so;
        planeMat.decompose(translation, rotation, scale, so);
        ofVec3f delta = cam_pos - translation;
        float dist = delta.length();
        cout << "distance: " << dist << endl;
        if (dist > 2.5) {
            volume = .01;
        }
        else{
            //set volume = .8; as max just in case
            volume = ofMap(dist, 0., 2.5, .9, .01);
        }
    }
    else{
        volume = 0.;
    }
    //=============== Distance Calculation ===============
    
    //=============== Sound Stuff ===============
        speed = ofMap(lambda, 10, 50, 1.5, 0.1);
    //=============== Sound Stuff ===============
}

//--------------------------------------------------------------
void ofApp::draw() {
    ofEnableAlphaBlending();
    
    //draw camera
    ofDisableDepthTest();
    processor->draw();
    
    ofEnableDepthTest();
    
    camera.begin();
    processor->setARCameraMatrices();
    
    ofPushMatrix();

    if(processor->anchorController->getPlaneAnchors().size() > 0){
        ofMultMatrix(planeMat);
        //for debugging
        ofVec3f translation;
        ofQuaternion rotation;
        ofVec3f scale;
        ofQuaternion so;
        planeMat.decompose(translation, rotation, scale, so);
        ofDrawSphere(translation, .1);
        //for debugging
        ofTranslate(translation.x - stepSize * numSteps * .5, 0, translation.y + stepSize * numSteps * .25);
        //rotation around x-axis
        ofVec3f axis;
        float angle;
        ofQuaternion curRot(90, ofVec3f(1,0,0));
        curRot.getRotate(angle, axis);
        ofRotateDeg(angle, axis.x, axis.y, axis.z);
        
        if(!meshSet){
            ofSetColor(255, 100);
            ofDrawRectangle(0, 0, 1, 1);
        }
        else{
            ofSetColor(235, 205, 60, 50);
            glLineWidth(5);
            mesh.draw();
            ofSetColor(255, 50);
            
        }
    }
    
    ofPopMatrix();
    
    camera.end();
    
    ofDisableDepthTest();
    
    // ========== DEBUG STUFF ============= //
    //draw gui
    gui.draw();
}

//--------------------------------------------------------------
void ofApp::exit() {
    
}

void ofApp::audioOut(float * output, int bufferSize, int nChannels) {
    
    if (meshSet) {
        for (int i = 0; i < bufferSize; i++){
            //============ Volume avg
            volArray.push_back(volume);
            if(volArray.size() > 10){
                for(int i = 0; i < volArray.size() - 1; i++){
                    volArray[i] = volArray[i + 1];
                }
                volArray.pop_back();
            }
            
            for (int i = 0; i < volArray.size() - 1; i++) {
                gain += volArray[i];
            }
            gain /= volArray.size();
            
//            cout << "gain: " << gain << endl;
            //============ Volume avg
            
            wave = bass.play(speed);
            mymix.stereo(wave * gain, outputs, .5);
            
            output[i*nChannels    ] = outputs[0];
            output[i*nChannels + 1] = outputs[1];
        }
    }
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


