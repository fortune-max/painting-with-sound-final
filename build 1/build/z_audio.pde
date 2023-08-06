// ****************************************************************************************************

// AUDIO, HELL YEAH

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim       minim;
FFT         myAudioFFT; // Fast Fourier Transform / convert the audio into numbers

AudioPlayer myAudioPlayer;

boolean 	showViz         = false;

int         myAudioRange    = 32;   // 128 (2 bands), 64 (4 bands), 32 (8 bands), 16 (16 bands), 8 (32 bands)
int         myAudioMax      = 100;  // rect height
float       myAudioAmp      = 40.0; // lets amplify the numbers using multiplication
int         myAudioBandSize = 13;   // width of the rect

float       myAudioEase     = 0.075; // this is a friction for smoothing

float[]     myAudioData     = new float[myAudioRange]; // lets store the NUMBERS
float[]     myAudioDataEase = new float[myAudioRange]; // lets store the NUMBERS EASY BABY

int[]       pickedIndex     = new int[listeningElems]; // pick a random range to listen to

int         vizW = 30 + (myAudioRange * myAudioBandSize);
int         vizH = 150; // 25 100 25

// ****************************************************************************************************

void audioSetup() {
	minim = new Minim(this);
	myAudioPlayer = minim.loadFile(dataPath + whichAudio);
	myAudioPlayer.loop(); // loop the audio file until the world burns
	// myAudioPlayer.play(); // plays just 1 time
	// myAudioPlayer.mute(); // mute the audio file

	myAudioFFT = new FFT(myAudioPlayer.bufferSize(), myAudioPlayer.sampleRate());
	myAudioFFT.linAverages(myAudioRange); // number of band in the audio frequency
	myAudioFFT.window(FFT.GAUSS);

	for (int i = 0; i < listeningElems; ++i) {
		pickedIndex[i] = (int)random(myAudioRange);
	}
}

// ****************************************************************************************************

void audioUpdate() {
	// myAudioPlayer.skip(4000);
	myAudioFFT.forward(myAudioPlayer.mix);

	for (int i = 0; i < myAudioRange; ++i) {
		float _tempIndexAvg = ( float((i+1)/1) / float(myAudioRange) ) * exp(1.0);
		_tempIndexAvg *= myAudioFFT.getAvg(i);
		_tempIndexAvg *= myAudioAmp;
		_tempIndexAvg = constrain(_tempIndexAvg, 0, myAudioMax); // 0 - 100
		myAudioData[i] = _tempIndexAvg; // our array of 32 numbers

		float d = ((myAudioData[i]*2) - myAudioDataEase[i]) * myAudioEase;
		myAudioDataEase[i] += d; // ease energy
		myAudioDataEase[i] = constrain(myAudioDataEase[i], 0, myAudioMax);
	}
}

// ****************************************************************************************************

// AUDIO VISUALIZER

void audioViz() {
	noLights();
	noTint();
	hint(DISABLE_DEPTH_TEST);
	noStroke();
	fill(0, 245); // black, alpha
	rectMode(CENTER);
	perspective();

	push();
		translate(width/2, height/2, 0);
		rect(0, 0, vizW, vizH);

		strokeWeight(1);
		stroke(#333333);
		noFill();
		line( -(vizW/2), -(myAudioMax/2), vizW/2, -(myAudioMax/2) );
		line( -(vizW/2),  (myAudioMax/2), vizW/2,  (myAudioMax/2) );

		stroke(#666666);
		line( -(vizW/2), 0, vizW/2, 0 );

		for (int i = 0; i < myAudioRange; ++i) {
			float _curAudioData1 = myAudioDataEase[i];
			float _curAudioData2 = myAudioData[i];

			noStroke();
			fill(#333333);
			rect( -(vizW/2)+((i*myAudioBandSize)+20), 0, myAudioBandSize-1, _curAudioData1+2);

			if(_curAudioData2<=2)                            fill(#666666); // no audio
			else if(_curAudioData2>2  && _curAudioData2<=10) fill(#2EA893); // 2 - 10
			else if(_curAudioData2>10 && _curAudioData2<=20) fill(#64BE7A); // 11 - 20
			else if(_curAudioData2>20 && _curAudioData2<=30) fill(#9AD561); // 21 - 30
			else if(_curAudioData2>30 && _curAudioData2<=40) fill(#CCEA4A); // 31 - 40
			else if(_curAudioData2>40 && _curAudioData2<=50) fill(#FFFF33); // 41 - 50
			else if(_curAudioData2>50 && _curAudioData2<=60) fill(#F8EF33); // 51 - 60
			else if(_curAudioData2>60 && _curAudioData2<=70) fill(#FFC725); // 61 - 70
			else if(_curAudioData2>70 && _curAudioData2<=80) fill(#FF9519); // 71 - 80
			else if(_curAudioData2>80 && _curAudioData2<=90) fill(#FF620C); // 81 - 90
			else                                             fill(#ff3300); // 91 - 100

			rect( -(vizW/2)+((i*myAudioBandSize)+20), 0, myAudioBandSize-1, _curAudioData2+2);

			textAlign(CENTER, CENTER); // horizontal, vertical
			textSize(9);
			text(i, -(vizW/2)+((i*myAudioBandSize)+20), (vizH/2)-13 );
		}
	pop();

	rectMode(CORNER);
	hint(ENABLE_DEPTH_TEST);
}

// ****************************************************************************************************

void stop() {
	myAudioPlayer.close();
	minim.stop();
	super.stop();
}

// ****************************************************************************************************


