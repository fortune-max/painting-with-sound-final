boolean firstRunSphere = true;
color sphereBg = #000000;

// Spheres

int numSpheres = 8;
int sphereRadius = 35;
HSphere[] spheres = new HSphere[numSpheres];

// Circle Layout

int layoutRadius = 300;
float speed = 1.0;
int circleLayoutPoints = (int) (360 / speed);
HCircleLayout circleLayout;
int step = circleLayoutPoints/numSpheres;   // difference between each sphere's position
PVector[] circleLayoutPos = new PVector[circleLayoutPoints];

// **************************************************

void setupSpheres() {
	background(sphereBg);

  circleLayout = new HCircleLayout().radius(layoutRadius).startLoc(0, 0).angleStep(360.0/circleLayoutPoints);

  for (int i=0; i<numSpheres; ++i) spheres[i] = new HSphere(sphereRadius);
  for (int i=0; i<circleLayoutPoints; ++i) circleLayoutPos[i] = circleLayout.getNextPoint();
  firstRunSphere = false;
}

// **************************************************

void drawSpheres() {
  if (firstRunSphere) setupSpheres();

	background(sphereBg);

  fill(#FFFF00);
	lights();

  push();
    translate(width/2, height/2, 0);
    for (int i=0; i<numSpheres; ++i){
      int idx = (frameCount + i*step) % circleLayoutPoints;
      push();
        translate(circleLayoutPos[idx].x, circleLayoutPos[idx].y, 0);
        spheres[i].fill(#FFFF00).noStroke();
        float sphereRadius = map(myAudioDataEase[ pickedIndex[i] ], 0, myAudioMax, 10, 30);
        spheres[i].radius(sphereRadius);
        spheres[i].draw(this.g, true, 0, 0, 1);
      pop();
    }
  pop();
}
