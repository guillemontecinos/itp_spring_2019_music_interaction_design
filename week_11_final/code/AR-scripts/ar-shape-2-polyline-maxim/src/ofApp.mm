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
    ofBackground(127);
    
    img.load("OpenFrameworks.png");
    
    //=============== GUI Stuff ===============
    ofxGuiSetFont("Questrial-Regular.ttf",20,true,true);
    ofxGuiSetTextPadding(4);
    ofxGuiSetDefaultWidth(500);
    ofxGuiSetDefaultHeight(50);
    
    gui.setup("Settings");
    gui.add(pitch.set("Arp Pitch", 1, 0.3, 1.2));
    //=============== GUI Stuff ===============
    
    //=============== AR Stuff ===============
    processor = ARProcessor::create(session);
    processor->setup();
    //=============== AR Stuff ===============
    
    meshSet = false;
    
    //=============== Shape 2 Line Stuff ===============
    //all values here are proportianally ported from the local mesh version divided by 300
    base.set(0,0,0);
    vec1.set(0.33,0,0); //(100,0,0)
    vec2.set(0.33,0,0); //(100,0,0)
    vec3.set(0.33,0,0); //(100,0,0)
    //=============== Shape 2 Line Stuff ===============
   
    //============ Shape 2 Sound Stuff ===============
    sample.load(ofToDataPath("star-1.wav"));
    
    sampleRate     = 44100; /* Sampling Rate */
    bufferSize    = 512; /* Buffer Size. you have to fill this buffer with sound using the for loop in the audioOut method */
    
    ofxMaxiSettings::setup(sampleRate, 2, bufferSize);
    // the higher the value, the more accurate will be the fft analysis
    speed = 1.;
    /* this has to happen at the end of setup - it switches on the DAC */
    ofSoundStreamSetup(2,2,this, sampleRate, bufferSize, 4);
    ofSoundStreamStart();
    //============ Shape 2 Sound Stuff ===============
}



//--------------------------------------------------------------
void ofApp::update(){
    
    processor->update();
    
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
    speed = pitchAvg;
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
    
    //=============== Shape 2 Distance Calculation ===============
    ofVec3f cam_pos = processor->getCameraPosition();
//    cout << "cam: " << cam_pos.x << ", " << cam_pos.y << ", " << cam_pos.z << ", d:  " << cam_pos.length() << ", t: " << ofGetElapsedTimef() << endl;
    
    if (session.currentFrame && session.currentFrame.camera && session.currentFrame.anchors.count > 0){
                ARAnchor * anchor = session.currentFrame.anchors[0];
                ofMatrix4x4 mat = convert<matrix_float4x4, ofMatrix4x4>(anchor.transform);
        ofVec3f translation;
        ofQuaternion rotation;
        ofVec3f scale;
        ofQuaternion so;
        mat.decompose(translation, rotation, scale, so);
//        cout << "obj: " << translation.x << ", " << translation.y << ", " << translation.z << ", d:  " << translation.length() << ", t: " << ofGetElapsedTimef() << endl;
        
        ofVec3f delta = cam_pos - translation;
        float dist = delta.length();
        if (dist > 2) {
            volume = .01;
        }
        else{
            //set volume = .8; as max just in case
            volume = ofMap(dist, 0., 2., .8, .01);
        }
    }
    else{
        volume = 0.;
    }
//    cout << "volume: " << volume << endl;
    //=============== Shape 2 Distance Calculation ===============
    
}

//--------------------------------------------------------------
void ofApp::draw() {
    ofEnableAlphaBlending();
    
    ofDisableDepthTest();
    processor->draw();
    ofEnableDepthTest();
    
    
    if (session.currentFrame){
        if (session.currentFrame.camera){
           
            camera.begin();
            processor->setARCameraMatrices();
            
            for (int i = 0; i < session.currentFrame.anchors.count; i++){
                ARAnchor * anchor = session.currentFrame.anchors[i];
                
                // note - if you need to differentiate between different types of anchors, there is a 
                // "isKindOfClass" method in objective-c that could be used. For example, if you wanted to 
                // check for a Plane anchor, you could put this in an if statement.
                // if([anchor isKindOfClass:[ARPlaneAnchor class]]) { // do something if we find a plane anchor}
                // Not important for this example but something good to remember.
                
                ofPushMatrix();
                ofMatrix4x4 mat = convert<matrix_float4x4, ofMatrix4x4>(anchor.transform);
                
                ofMultMatrix(mat);
                
                ofSetColor(255);
                ofRotate(90,0,0,1);
                
                if(i == 0){
                    ofSetColor(36, 181, 56, 150);
                    glLineWidth(8);
                    drawLine.draw();
                }
                ofPopMatrix();
            }
          
            camera.end();
        }
        
    }
    ofDisableDepthTest();
    // ========== DEBUG STUFF ============= //
//    processor->debugInfo.drawDebugInformation(font);
    gui.draw();
   
    
}

//--------------------------------------------------------------
void ofApp::exit() {

}

//--------------------------------------------------------------
void ofApp::audioOut(float * output, int bufferSize, int nChannels) {
    
    
    for (int i = 0; i < bufferSize; i++){
        if (meshSet) {
            //============ Volume avg
            volArray.push_back(volume);
            if(volArray.size() > 10){
                for(int i = 0; i < volArray.size() - 1; i++){
                    volArray[i] = volArray[i + 1];
                }
                volArray.pop_back();
            }
            
            for (int i = 0; i < volArray.size(); i++) {
                gain += volArray[i];
            }
            gain /= volArray.size();
            
            cout << "gain: " << gain << endl;
            //============ Volume avg
            
            wave = sample.play(speed);
            mymix.stereo(wave * gain, outputs, .5);
        }
        output[i*nChannels    ] = outputs[0];
        output[i*nChannels + 1] = outputs[1];
    }
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs &touch){
    if(!meshSet){
        if (session.currentFrame){
            ARFrame *currentFrame = [session currentFrame];
            
            matrix_float4x4 translation = matrix_identity_float4x4;
            translation.columns[3].z = -0.2;
            matrix_float4x4 transform = matrix_multiply(currentFrame.camera.transform, translation);
            
            // Add a new anchor to the session
            ARAnchor *anchor = [[ARAnchor alloc] initWithTransform:transform];
            
            [session addAnchor:anchor];
        }
        meshSet = true;
    }
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


