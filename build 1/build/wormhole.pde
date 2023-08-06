boolean firstRunWormhole = true;
color wormholeBg = #242424;

// Polar Layout
float layoutTightness = 5;
float layoutAngle = 0.2;
int layoutPointCount = 1000;
HPolarLayout polarLayout;
PVector[] polarLayoutPoints = new PVector[layoutPointCount];

// Elements
float sizeMin = 25, sizeMax = 40, sizeOscSpeed = 2, sizeOscFreq = 3;
HOscillator[] plElemsSize = new HOscillator[layoutPointCount];
float[] zElevation = new float[layoutPointCount];

// Wormhole (one-half)
float wormholeDepth = 85;
float wormholeRadius = layoutPointCount/10;

// **************************************************

void setupWormhole() {
  background(wormholeBg);
  polarLayout = new HPolarLayout(layoutTightness, layoutAngle);

  for (int i = 0; i < layoutPointCount; i++) {
		polarLayoutPoints[i] = polarLayout.getNextPoint();
		plElemsSize[i] = new HOscillator().range(sizeMin, sizeMax).speed(sizeOscSpeed).freq(sizeOscFreq).currentStep(i);
    float dist_to_center = dist(polarLayoutPoints[i].x, polarLayoutPoints[i].y, 0, 0);
    zElevation[i] = map(dist_to_center, 0, wormholeRadius, 0, wormholeDepth);
	}
  firstRunWormhole = false;
}

// **************************************************

void drawWormhole() {
  if (firstRunWormhole) setupWormhole();
	// background(clrBg);
  lights();
  myGodItsFullOfStars();

  sphereDetail(10);
  noStroke();

  push();
    translate(width/2, height/2, 0);
    rotateY(radians(frameCount/2));
    rotateX(radians(30));

    for(int i=0; i<layoutPointCount; ++i) {
      plElemsSize[i].nextRaw();
      push();
        translate(polarLayoutPoints[i].x, polarLayoutPoints[i].y, zElevation[i]);
        fill((int) random(255), (int) random(255), (int) random(255));
        sphere(plElemsSize[i].curr());
      pop();
      push();
        translate(-polarLayoutPoints[i].x, -polarLayoutPoints[i].y, -zElevation[i]);
        fill((int) random(255), (int) random(255), (int) random(255));
        sphere(plElemsSize[i].curr());
      pop();
    }
  pop();
}
