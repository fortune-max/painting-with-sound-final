// ****************************************************************************************************

// COLOR

PImage        clr1, clr2;
HOscillator[] clr1OSC  = new HOscillator[layout1Num];
HOscillator[] clr2OSC  = new HOscillator[layout1Num];

color[]       c1  = new color[layout1Num];
color[]       c2  = new color[layout1Num];

// ****************************************************************************************************

void colorSetup() {
	clr1 = loadImage(dataPath + whichClr1);
	clr2 = loadImage(dataPath + whichClr2);

	for (int i = 0; i < layout1Num; ++i) {
		clr1OSC[i] = new HOscillator().range(0, clr1.width-1 ).speed(0.05).currentStep(i);
		clr2OSC[i] = new HOscillator().range(0, clr2.width-1 ).speed(1).currentStep(i*5);
	}
}

// **************************************************

void colorUpdate() {
	for (int i = 0; i < layout1Num; ++i) {
		clr1OSC[i].nextRaw();
		c1[i] = clr1.get( (int)clr1OSC[i].curr(), 1);

		clr2OSC[i].nextRaw();
		c2[i] = clr2.get( (int)clr2OSC[i].curr(), 1);
	}
}

// ****************************************************************************************************


