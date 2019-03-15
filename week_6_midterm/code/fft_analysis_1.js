// fft analysis trial for sound Visualization
// by Guillermo Montecinos
// for MID, NYU ITP, Spring 2019

let sound;
let fft;

function preload(){
  sound = loadSound('airbag.wav');
  // sound = loadSound('15_step.wav');
}

function setup(){
  createCanvas(716 * .8, 900 * .8);
  fft =  new p5.FFT(.8 , 16);
  rectMode(CENTER);
  angleMode(DEGREES);
}

function draw(){
  background(229,229,204);
  drawMalevich();
}

function getSpectrum(){
  let spectrum16 = fft.analyze();
  let spectrum8 = [];
  for (var i = 0; i < spectrum16.length; i+=2) {
    // calculate the normalized (0-.1) average of two freq bands into one
    spectrum8.push((spectrum16[i] + spectrum16[i + 1]) / (2 * 255 * 10));
  }
  return spectrum8;
}

function drawMalevich(){
  // receives an 8-band spectrum data from FFT
  let spectrum = getSpectrum();

  noStroke();
  // rect 1, yellow on the back
  push();
    rotate(5);
    fill(221, 152, 24);
    rect(.7 * width/2, .8 * height/4,(1 + spectrum[0]) * (.9 * width / 2),(1 + spectrum[0]) * (.9 * width / 2));
  pop();
  // rect 2, red over 1
  push();
    rotate(5);
    fill(173, 60, 43);
    rect(1.05 * width /3, .72 * height/2,(1 + spectrum[1]) * (.85 * width / 5), (1 + spectrum[1]) * (1.1 * height / 2));
  pop();
  // rect 3, green
  push();
    rotate(-2);
    fill(11, 66, 53);
    rect(1.2 * width / 2, .8 * height / 3, (1 + spectrum[2]) * (1.1 * width / 2), (1 + spectrum[2]) * (height / 4));
  pop();
  // rect 4, big black
  push();
    rotate(-1);
    fill(0);
    rect(3 * width / 4, height / 2, (1 + spectrum[3]) * (width / 18), (1 + spectrum[3]) * (.9 * height));
  pop();
  // rect 5, small black
  push();
    rotate(3);
    fill(0);
    rect(1.2 * width / 2, height / 3, (1 + spectrum[4]) * (width / 40), (1 + spectrum[4]) * (.9 * 3 * height / 4));
  pop();
  // rect 6, horizontal smallest black
  push();
    translate(1.2 * width / 2, 3 * height / 4);
    rotate(-10);
    fill(0);
    rect(0, 0, (1 + spectrum[5]) * (3 * width / 4), (1 + spectrum[5]) * (height / 100));
  pop();
}
