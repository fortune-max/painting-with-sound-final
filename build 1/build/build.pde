import hype.*;
import hype.extended.layout.*;
import hype.extended.behavior.HOscillator;

int         stageW     = 1000;
int         stageH     = 800;
color       clrBg      = #CCCCCC;
String      dataPath   = "../../data/";

// ****************************************************************************************************

// Transitions
String currentAnimation = "spheres";

// ****************************************************************************************************

String whichAudio = "audio/fluorescent.wav";
String imgSrc = dataPath + "sprites/joshua.jpg";
String imgSrc2 = dataPath + "sprites/joshua_fire.jpg";
int listeningElems = 20;

void settings() {
	size(stageW,stageH,P3D);
	fullScreen();
}

void setup() {
	H.init(this);
	audioSetup();
  colorSetup();
  spriteSetup();
}

void draw() {
  if (mousePressed){
		translate(width/2, height/2, 0);
		rotateX(radians(mouseY));
		rotateY(radians(mouseX));
		translate(-width/2, -height/2, 0);
	}
  transition();
  audioUpdate();
  currentDraw();
  // audioViz();
}

void currentDraw() {
  switch (currentAnimation) {
    case "spheres":
      drawSpheres();
      break;
    case "accretion":
      drawAccretion();
      break;
    case "wormhole":
      drawWormhole();
      break;
    case "photo":
      drawPhoto();
      break;
  }
}

void transition() {
  int currAudioPos = myAudioPlayer.position();
  if (currAudioPos > 105000){
    currentAnimation = "photo";
    return;
  }
  if (currAudioPos > 54100){
    currentAnimation = "wormhole";
    return;
  }
  if (currAudioPos > 9200){
    currentAnimation = "accretion";
    return;
  }
  if (currAudioPos > 100){
    setupPhoto();
    return;
  }
}

void myGodItsFullOfStars(){
  int starCount = 1000;
  for(int i=0; i<starCount; i++){
    float x = random(-width, width);
    float y = random(-height, height);
    float z = random(-width, width);
    stroke(255);
    point(x, y, z);
  }
}
