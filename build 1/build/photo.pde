boolean firstRunPhoto = true;
color photoBg = #000000;
int frameCountStart = -1;

PImage imgToPaint, imgToPaint2;

int imgW, imgH;


int sampleWidth = 7, sampleHeight = 7;
int minElevation = 0, maxElevation = 0;

PVector[][] currentColors, currentColors2;
int         layout1Num    = 256;

PVector[]   layout1Pos    = new PVector[layout1Num];

String[]    texNames   = {
	"sprites/white.png"
};

int         texLen     = texNames.length;
String      paintWith  = "HBox"; // HSprite, HBox, HCylinder, HIcosahedron
int[]       texRan     = new int[layout1Num];

boolean goBeasty;

int         boxMin        = 5;

int         layout1Radius = 300;
int         layout1StartX = 0;
int         layout1StartY = 0;
float       layout1Step   = 360.0/layout1Num;

HCircleLayout layout1;
HOscillator rX, rY, rZ;
HOscillator[] oscS = new HOscillator[layout1Num];
HOscillator[] oscR = new HOscillator[layout1Num];
String      whichClr1 = "colors/rainbow.png";
String      whichClr2 = "colors/rainbow.png";


void setupPhoto() {
	background(photoBg);

  layout1 = new HCircleLayout()
		.radius(layout1Radius)
		.startLoc(layout1StartX, layout1StartY)
		.angleStep(layout1Step)
	;

  for (int i = 0; i < layout1Num; ++i) {
		layout1Pos[i] = layout1.getNextPoint();
		oscS[i] = new HOscillator().range(10, 200).speed(1).currentStep( (int)random(999) );
		oscR[i] = new HOscillator().range(-180, 180).speed(1).currentStep(i*5);
	}

	rX = new HOscillator().range(-180,180).speed(0.05);
	rY = new HOscillator().range(-180,180).speed(0.07);
	rZ = new HOscillator().range(-180,180).speed(0.09);

  imgToPaint = loadImage(imgSrc);
  imgToPaint2 = loadImage(imgSrc2);

  imgW = imgToPaint.width;
  imgH = imgToPaint.height;

  currentColors = new PVector[imgW][imgH];
  currentColors2 = new PVector[imgW][imgH];

  for (int i=0; i<imgW; ++i){
    for (int j=0; j<imgH; ++j){
      currentColors[i][j] = new PVector(0,0,0);
      currentColors2[i][j] = new PVector(0,0,0);
    }
  }

  for(int choiceW=0; choiceW<imgW; choiceW+=sampleWidth){
    for (int choiceH=0; choiceH<imgH; choiceH+=sampleHeight){
      int totalRed = 0, totalGreen = 0, totalBlue = 0;
      int totalRed2 = 0, totalGreen2 = 0, totalBlue2 = 0;
      for(int i=0; i<sampleWidth; i++){
        for(int j=0; j<sampleHeight; j++){
          color c = imgToPaint.get(choiceW+i, choiceH+j);
          color c2 = imgToPaint2.get(choiceW+i, choiceH+j);
          totalRed += red(c);
          totalGreen += green(c);
          totalBlue += blue(c);
          totalRed2 += red(c2);
          totalGreen2 += green(c2);
          totalBlue2 += blue(c2);
        }
      }
      
      int avgRed = totalRed / (sampleWidth * sampleHeight), avgGreen = totalGreen / (sampleWidth * sampleHeight), avgBlue = totalBlue / (sampleWidth * sampleHeight);
      int avgRed2 = totalRed2 / (sampleWidth * sampleHeight), avgGreen2 = totalGreen2 / (sampleWidth * sampleHeight), avgBlue2 = totalBlue2 / (sampleWidth * sampleHeight);
      
      for (int i=0; i<sampleWidth; ++i){
        for (int j=0; j<sampleHeight; ++j){
          if (choiceH+j >= imgH || choiceW+i >= imgW) continue;
          currentColors[choiceW+i][choiceH+j].x = avgRed;
          currentColors[choiceW+i][choiceH+j].y = avgGreen;
          currentColors[choiceW+i][choiceH+j].z = avgBlue;
          currentColors2[choiceW+i][choiceH+j].x = avgRed2;
          currentColors2[choiceW+i][choiceH+j].y = avgGreen2;
          currentColors2[choiceW+i][choiceH+j].z = avgBlue2;
        }
      }
    }
  }

  firstRunPhoto = false;
}

void drawPhoto() {
  colorUpdate();
  if (firstRunPhoto) setupPhoto();
  if (frameCountStart == -1) frameCountStart = frameCount;

  hint(DISABLE_DEPTH_TEST);

	rX.nextRaw();
	rY.nextRaw();
	rZ.nextRaw();

  background(photoBg);

  push();
		translate(width/2, height/2, 0);
		// rotateX(radians(rX.curr()));
		// rotateY(radians(rY.curr()));
		rotateZ(radians(rZ.curr()));

		for (int i = 0; i < layout1Num; ++i) {

			float _d = map(myAudioDataEase[ i%16 ], 0, myAudioMax, boxMin, 3000);

			push();
				translate(layout1Pos[i].x, layout1Pos[i].y, layout1Pos[i].z);
				rotate( radians(90)+(layout1.angleStepRad()*i) );
				oscR[i].nextRaw();
				rotateZ(radians( oscR[i].curr()*0.2 ));
				rotateY(radians( oscR[i].curr()*0.1 ));

				HBox _art = (HBox) obj[texRan[i]];
				_art.noStroke().fill( c2[i] );
				_art.depth(_d).width(boxMin).height(boxMin);
				_art.draw(this.g, true, 0, 0, 1);
			pop();	
		}
	pop();
  
  goBeasty = myAudioData[0] > 35;
  lights();
  myGodItsFullOfStars();
  push();
    translate(width/2-imgW/2, height/2-imgH/2);
    for (int i=0; i<imgW; ++i){
      for (int j=0; j<imgH; ++j){
        int pixelsDrawn = i * imgH + j;
        if (pixelsDrawn > (frameCount - frameCountStart) * 800) break;
        if(pixelsDrawn%2==0){
          if (goBeasty)
            stroke(currentColors2[i][j].x, currentColors2[i][j].y, currentColors2[i][j].z);
          else
            stroke(currentColors[i][j].x, currentColors[i][j].y, currentColors[i][j].z);
          point(i, j, -(frameCount - frameCountStart)*2);
        } else {
          if (goBeasty)
            stroke(currentColors2[imgW-i-1][imgH-j-1].x, currentColors2[imgW-i-1][imgH-j-1].y, currentColors2[imgW-i-1][imgH-j-1].z);
          else
            stroke(currentColors[imgW-i-1][imgH-j-1].x, currentColors[imgW-i-1][imgH-j-1].y, currentColors[imgW-i-1][imgH-j-1].z);
          point(imgW-i, imgH-j, -(frameCount - frameCountStart)*2);
        }
      }
    }
  pop();
}
