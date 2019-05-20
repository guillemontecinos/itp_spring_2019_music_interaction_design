#include "ofApp.h"
#include "ofxMaxim.h"

using namespace ofxARKit::common;

void logSIMD(const simd::float4x4 &matrix)
{
    std::stringstream output;
    int columnCount = sizeof(matrix.columns) / sizeof(matrix.columns[0]);
    for (int column = 0; column < columnCount; column++) {
        int rowCount = sizeof(matrix.columns[column]) / sizeof(matrix.columns[column][0]);
        for (int row = 0; row < rowCount; row++) {
            output << std::setfill(' ') << std::setw(9) << matrix.columns[column][row];
            output << ' ';
        }
        output << std::endl;
    }
    output << std::endl;
}

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
    //=============== Global Control Stuff ===============
    for (int i = 0; i < 3; i++) {
        meshSet.push_back(false);
    }
    scene = 0;
    //=============== Global Control Stuff ===============
    
    img.load("OpenFrameworks.png");
    
    //=============== GUI Stuff ===============
    resetParams.addListener(this, &ofApp::resetParamsPressed);
    ofxGuiSetFont("Questrial-Regular.ttf",30,true,true);
    ofxGuiSetTextPadding(4);
    ofxGuiSetDefaultWidth(600);
    ofxGuiSetDefaultHeight(80);
    gui.setup("Settings");
    gui.add(mesh_3_pitch.set("Element 1 Pitch", 5, 1, 10));
    gui.add(pitch.set("Element 2 Pitch", 1, 0.3, 1.2)); //arp pitch
    gui.add(resetParams.setup("Reset", 600));
    
    messageFont.load("Questrial-Regular.ttf", 50);
    //=============== GUI Stuff ===============
    
    //=============== AR Stuff ===============
    processor = ARProcessor::create(session);
    processor->setup();
    //=============== AR Stuff ===============
    
    //=============== Shape 2 Line Stuff ===============
    //all values here are proportianally ported from the local mesh version divided by 300
    base.set(0,0,0);
    vec1.set(0.33,0,0); //(100,0,0)
    vec2.set(0.33,0,0); //(100,0,0)
    vec3.set(0.33,0,0); //(100,0,0)
    //=============== Shape 2 Line Stuff ===============
    
    //=============== Shape 3 Mesh Stuff ===============
    lambda = 10;
    stepSize = .1;
    numSteps = 20;
    mesh_3.setMode(OF_PRIMITIVE_LINES);
    for(float x = 0; x <= stepSize * numSteps; x += stepSize){
        for(float y = 0; y <= stepSize * numSteps; y += stepSize){
            ofVec3f pos(x, y, 0);
            mesh_3.addVertex(pos);
        }
    }
    
    float connectionDistance = .11;
    int numVerts = mesh_3.getNumVertices();
    for (int a = 0; a < numVerts; a++) {
        ofVec3f verta = mesh_3.getVertex(a);
        for (int b = a + 1; b < numVerts; b++) {
            ofVec3f vertb = mesh_3.getVertex(b);
            float distance = verta.distance(vertb);
            if (distance <= connectionDistance) {
                mesh_3.addIndex(a);
                mesh_3.addIndex(b);
            }
        }
    }
    //=============== Shape 3 Mesh Stuff ===============
    
    //============ Sound Stuff ===============
    arp.load(ofToDataPath("star-1.wav"));
    bass.load(ofToDataPath("bass-1.wav"));
    
    sampleRate     = 44100; /* Sampling Rate */
    bufferSize    = 512; /* Buffer Size. you have to fill this buffer with sound using the for loop in the audioOut method */
    
    volumeBass = .5;
    volumeArp = .5;
    speedBass = 1.;
    speedArp = 1.;
    
    ofxMaxiSettings::setup(sampleRate, 2, bufferSize);
    ofSoundStreamSetup(2,2,this, sampleRate, bufferSize, 4);
    ofSoundStreamStart();
    //============ Sound Stuff ===============
}

void ofApp::resetParamsPressed(){
    if(scene == 4){
        //Reset the entire system. For a weird reason the plane can't be totally cleared
        processor->anchorController->clearAnchors();
        processor->restartSession();
        meshSet[1] = false;
        meshSet[2] = false;
        scene = 1;
        cout << "Reset" << endl;
        cout << "#Anchors: " << session.currentFrame.anchors.count << endl;
    }
    cout << "scene: " << scene << endl;
}

vector < matrix_float4x4 > mats;

//--------------------------------------------------------------
void ofApp::update(){
    processor->update();
    
    //Stop updating planes after 1st is found
    if(processor->anchorController->getNumPlanes() < 1 && scene == 0){
        processor->updatePlanes();
        if (processor->anchorController->getNumPlanes() >= 1 && scene == 0) {
            scene = 1;
        }
    }
//    else{
//        scene = 1;
//    }
    
    mats.clear();
    
    //=============== Shape 2 Pitch Stuff ===============
    //calculate pitch param as a mobile average
    pitchBuffer.push_back(pitch);
    float pitchAvg = 0;
    
    if(pitchBuffer.size() > 10){
        for(int i = 0; i < pitchBuffer.size() - 1; i++){
            pitchBuffer[i] = pitchBuffer[i + 1];
            pitchAvg += pitchBuffer[i];
        }
        pitchBuffer.pop_back();
    }
    pitchAvg /= pitchBuffer.size();
    speedArp = pitchAvg;
    //=============== Shape 2 Pitch Stuff ===============
    
    //=============== Shape 2 Build Line ===============
    float t = ofGetElapsedTimef();
    vec1.scale(100 * ofNoise(t));
    vec2.scale(100 * ofNoise(2.71828 * t));
    vec3.scale(100 * ofNoise(5 * t));
    qRot1.makeRotate(pitchAvg * 300 * t, ofVec3f(0,0,1));
    rotVec1 = qRot1 * vec1;
    qRot2.makeRotate(pitchAvg * 300 * 2.71828 * t, ofVec3f(0,1,0));
    rotVec2 = qRot2 * vec2;
    vecOut = rotVec1 + rotVec2;
    qRot3.makeRotate(pitchAvg * 300 * 2.71828 * t, ofVec3f(1,0,0));
    vecOut = vecOut + rotVec3;
    
    baseArray.push_back(vecOut);
    
    if(baseArray.size() > 100){
        for (int i = 0; i < baseArray.size() - 1; i++) {
            baseArray[i] = baseArray[i + 1];
        }
        baseArray.pop_back();
    }
    
    drawArray = baseArray;
    drawLine.clear();
    
    for (int i = 0; i < baseArray.size(); i++) {
        float len = baseArray[i].length();
        drawArray[i].set(baseArray[i]);
        drawArray[i].scale(len/300);
        drawLine.addVertex(drawArray[i]);
    }
    //=============== Shape 2 Build Line ===============
    
    //=============== Shape 3 Mesh Stuff ===============
    lambda = ofMap(mesh_3_pitch, 1, 10, 50, 10);
    int numVerts = mesh_3.getNumVertices();
    float time = ofGetElapsedTimef();
    for (int i = 0; i < numVerts; i++) {
        ofVec3f vert = mesh_3.getVertex(i);
        float row = i % int(numSteps);
        vert.z = 0.15 + 0.15 * cos(2 * (PI / lambda) * (row - 20 * time));
        mesh_3.setVertex(i, vert);
    }
    //=============== Shape 3 Mesh Stuff ===============
    
    ofVec3f cam_pos = processor->getCameraPosition();
    
    //=============== Shape 2 Distance Calculation ===============
    if (session.currentFrame && session.currentFrame.camera && session.currentFrame.anchors.count > 1){
        ARAnchor * anchor = session.currentFrame.anchors[1];
        ofMatrix4x4 mat = convert<matrix_float4x4, ofMatrix4x4>(anchor.transform);
        mat.decompose(translation, rotation, scale, so);
        
        ofVec3f delta = cam_pos - translation;
        float dist = delta.length();
        if (dist > 2.5) {
            volumeArp = .1;
        }
        else{
            //set volume = .8; as max just in case
            volumeArp = ofMap(dist, 0., 2.5, .75, .1);
        }
    }
    else{
        volumeArp = 0.;
    }
    //=============== Shape 2 Distance Calculation ===============
    
    //=============== Shape 3 Distance Calculation ===============
    if(processor->anchorController->getPlaneAnchors().size() > 0){
        planeMat = ofMatrix4x4(processor->anchorController->getPlaneAnchors()[0].transform);
        ofMultMatrix(planeMat);
        planeMat.decompose(translation, rotation, scale, so);
        ofVec3f delta = cam_pos - translation;
        float dist = delta.length();
        if (dist > 2.5) {
            volumeBass = .1;
        }
        else{
            volumeBass = ofMap(dist, 0., 2.5, 1.1, .1);
        }
    }
    else{
        volumeBass = 0.;
    }
    //=============== Shape 3 Distance Calculation ===============
    
    //=============== Shape 3 Sound Stuff ===============
        speedBass = ofMap(lambda, 10, 50, 2, 0.8);
    //=============== Shape 3 Sound Stuff ===============
}

//--------------------------------------------------------------
void ofApp::draw() {
    //======== Processor Camera Drawing ========
    ofEnableAlphaBlending();
    ofDisableDepthTest();
    processor->draw();
    ofEnableDepthTest();
    //======== Processor Camera Drawing ========
    
    if (session.currentFrame){
        if (session.currentFrame.camera){
            
            camera.begin();
            processor->setARCameraMatrices();
            
            //=============== Shape 2 Drawing ===============
            for (int i = 0; i < session.currentFrame.anchors.count; i++){
                ARAnchor * anchor = session.currentFrame.anchors[i];
                if(![anchor isKindOfClass:[ARPlaneAnchor class]]){
                    ofPushMatrix();
                    ofMatrix4x4 mat = convert<matrix_float4x4, ofMatrix4x4>(anchor.transform);
                    ofMultMatrix(mat);
                    ofSetColor(255);
                    ofRotate(90,0,0,1);
                    ofSetColor(242, 226, 50, 120);
                    glLineWidth(7);
                    drawLine.draw();
                    ofPopMatrix();
                }
            }
            //=============== Shape 2 Drawing ===============
            
            //=============== Shape 3 Drawing ===============
            ofPushMatrix();
            if(processor->anchorController->getPlaneAnchors().size() > 0){
                ofMultMatrix(planeMat);
                //for debugging
                planeMat.decompose(translation, rotation, scale, so);
                ofTranslate(translation.x - stepSize * numSteps * .5, 0, translation.y + stepSize * numSteps * .25);
                //rotation around x-axis
                ofVec3f axis;
                float angle;
                ofQuaternion curRot(90, ofVec3f(1,0,0));
                curRot.getRotate(angle, axis);
                ofRotateDeg(angle, axis.x, axis.y, axis.z);
                if(!meshSet[2]){
                    ofSetColor(255, 100);
                    ofDrawRectangle(0, 0, 1, 1);
                }
                else{
                    ofSetColor(170, 163, 152, 120);
//                    ofSetColor(64, 64, 188, 120);
                    glLineWidth(10);
                    mesh_3.draw();
                    ofSetColor(255, 50);
                }
            }
            ofPopMatrix();
            //=============== Shape 3 Drawing ===============
            camera.end();
        }
    }
    ofDisableDepthTest();
    //=============== UX Message Drawing ===============
    ofSetColor(255, 100);
    if(scene == 0){
        uxMessage = "Move the iPad around to find a plane.";
    }
    else if (scene == 1){
        uxMessage = "Tap the screen to set a sound element on the floor.";
    }
    else if (scene == 2){
        uxMessage = "Tap to set another element in the space.";
    }
    else if (scene == 3){
        uxMessage = "Modify elements properties using settings interface.";
    }
    else if (scene == 4){
        uxMessage = "";
    }
    //draw message
    messageBox = messageFont.getStringBoundingBox(uxMessage, 0, 0);
    messageFont.drawString(uxMessage, ofGetWidth() / 2 - messageBox.width / 2, ofGetHeight() / 2 - messageBox.height / 2);
    //=============== UX Message Drawing ===============
    
    // ========== GUI STUFF ============= //
    gui.draw();
    // ========== GUI STUFF ============= //
}

//--------------------------------------------------------------
void ofApp::exit() {
    
}

void ofApp::audioOut(float * output, int bufferSize, int nChannels) {
    
    
    for (int i = 0; i < bufferSize; i++){
        if (meshSet[2] || meshSet[1]) {
            //=============== Shape 2 Gain ===============
            volArrayArp.push_back(volumeArp);
            if(volArrayArp.size() > 10){
                for(int i = 0; i < volArrayArp.size() - 1; i++){
                    volArrayArp[i] = volArrayArp[i + 1];
                }
                volArrayArp.pop_back();
            }
            
            for (int i = 0; i < volArrayArp.size() - 1; i++) {
                gainArp += volArrayArp[i];
            }
            gainArp /= volArrayArp.size();
            //=============== Shape 2 Gain ===============
            
            //=============== Shape 3 Gain ===============
            volArrayBass.push_back(volumeBass);
            if(volArrayBass.size() > 10){
                for(int i = 0; i < volArrayBass.size() - 1; i++){
                    volArrayBass[i] = volArrayBass[i + 1];
                }
                volArrayBass.pop_back();
            }
            
            for (int i = 0; i < volArrayBass.size() - 1; i++) {
                gainBass += volArrayBass[i];
            }
            gainBass /= volArrayBass.size();
            //=============== Shape 3 Gain ===============
            
            if (meshSet[2] && !meshSet[1] && !meshSet[0]) {
                wave = bass.play(speedBass) * gainBass;
            }
            else if (meshSet[2] && meshSet[1] && !meshSet[0]) {
                wave = bass.play(speedBass) * gainBass + arp.play(speedArp) * gainArp;
//                wave *= 0.8f; //this is to avoid a gain rise
            }
//            else if (meshSet[2] && meshSet[1] && meshSet[0]) {
//
//            }
            
            mymix.stereo(wave, outputs, .5);
        }
        output[i*nChannels    ] = outputs[0];
        output[i*nChannels + 1] = outputs[1];
    }
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs &touch){
    if(scene == 1){
        //Setting Shape 3
        //sets the mesh in the position of the plane
        if(meshSet[2] == false && processor->anchorController->getNumPlanes() > 0){
            meshSet[2] = true;
            bass.play();
        }
        scene = 2;
    }
    else if(scene == 2){
        //Setting Shape 2
        if(!meshSet[1]){
            if (session.currentFrame){
                ARFrame *currentFrame = [session currentFrame];
                matrix_float4x4 translation = matrix_identity_float4x4;
                translation.columns[3].z = -0.2;
                matrix_float4x4 transform = matrix_multiply(currentFrame.camera.transform, translation);
                
                // Add a new anchor to the session
                ARAnchor *anchor = [[ARAnchor alloc] initWithTransform:transform];
                [session addAnchor:anchor];
                cout << "Anchor added" << endl;
                meshSet[1] = true;
                scene = 3;
            }
        }
    }
    else if(scene == 3){
        //scene 3 displays a message
        scene = 4;
    }
    cout << "scene: " << scene << endl;
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


