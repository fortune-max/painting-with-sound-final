// ****************************************************************************************************

Object[] obj = new Object[texLen];

void spriteSetup() {
	for (int i = 0; i < texLen; ++i) {
		PImage _p = loadImage( dataPath + texNames[i] );

		if( paintWith.equals("HSprite") ){
			HSprite _obj = new HSprite();
			_obj.texture(_p);
			obj[i] = (Object) _obj;
		}

		if( paintWith.equals("HBox") ){
			HBox _obj = new HBox();
			_obj.texture(_p);
			obj[i] = (Object) _obj;
		}

		if( paintWith.equals("HCylinder") ){
			HCylinder _obj = new HCylinder();
			_obj.sides(20);
			_obj.drawTop(false).drawBottom(false);
			_obj.texture(_p);
			obj[i] = (Object) _obj;
		}

		if( paintWith.equals("HIcosahedron") ){
			HIcosahedron _obj = new HIcosahedron();
			obj[i] = (Object) _obj;
		}
	}

	for (int i = 0; i < layout1Num; ++i) texRan[i] = (int)random(texLen);
}
