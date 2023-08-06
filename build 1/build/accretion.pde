boolean firstRunAccretion = true;
color accretionBg = #242424;

// center sphere properties
int initialRadius = 100;
float currentRadius = initialRadius;
int maxCenterSphereRadius = 1000;
PVector centerSpherePos = new PVector(width/2, height/2, -200);

int numAttractedSpheres = 800;
float minSphereSpeed = 0.1, maxSphereSpeed = 0.6;
int minSphereRadius = 5, maxSphereRadius = 20;
int minSpawnDistance = -1000, maxSpawnDistance = 1000;
PVector[] spheresPositions = new PVector[numAttractedSpheres];
PVector[] spheresExtras = new PVector[numAttractedSpheres]; // x - dimensions, y - completion percentage, z - speed

// **************************************************

void setupAccretion() {
	background(accretionBg);

  for (int i=0; i<numAttractedSpheres; ++i) {
    spheresPositions[i] = new PVector(random(minSpawnDistance, maxSpawnDistance), random(minSpawnDistance, maxSpawnDistance), random(minSpawnDistance, maxSpawnDistance));
    spheresExtras[i] = new PVector(random(minSphereRadius, maxSphereRadius), 0, random(minSphereSpeed, maxSphereSpeed));
  }
  firstRunAccretion = false;
}

// **************************************************

void drawAccretion() {
  if (firstRunAccretion) setupAccretion();
	// background(clrBg);
  myGodItsFullOfStars();

  fill(#FFFF00);
  noStroke();

  push();
    translate(width/2, height/2, -200);
    fill(
      (myAudioDataEase[ pickedIndex[0] ] * 13) % 255,
      (myAudioDataEase[ pickedIndex[2] ] * 10) % 255,
      (myAudioDataEase[ pickedIndex[6] ] * 13) % 255
    );
    sphere(currentRadius);

    int lightsUsed = 0;
    for (int i=0; i<numAttractedSpheres; i++){
      PVector currSpherePos = spheresPositions[i];
      currSpherePos.x = currSpherePos.x * (100 - spheresExtras[i].z) / 100;
      currSpherePos.y = currSpherePos.y * (100 - spheresExtras[i].z) / 100;
      currSpherePos.z = currSpherePos.z * (100 - spheresExtras[i].z) / 100;
      spheresExtras[i].y += spheresExtras[i].z;
      push();
        translate(currSpherePos.x, currSpherePos.y, currSpherePos.z);
        fill(
          map(spheresExtras[i].x, minSphereRadius, maxSphereRadius, 0, 255),
          map(spheresExtras[i].z, minSphereSpeed, maxSphereSpeed, 255, 0),
          map(spheresExtras[i].y, 0, 100, 0, 255)
        );
        sphere(spheresExtras[i].x);
        if (lightsUsed < 8 && random(1) > 0.9) {
          lightsUsed++;
          pointLight(
            map(spheresExtras[i].x, minSphereRadius, maxSphereRadius, 0, 255),
            map(spheresExtras[i].z, minSphereSpeed, maxSphereSpeed, 255, 0),
            map(spheresExtras[i].y, 0, 100, 0, 255),
            currSpherePos.x,
            currSpherePos.y,
            currSpherePos.z
          );
        }
      pop();
      if (currSpherePos.x < 20 && currSpherePos.y < 20 && currSpherePos.z < 20) {
        currentRadius += 0.7;
        spheresPositions[i] = new PVector(random(minSpawnDistance, maxSpawnDistance), random(minSpawnDistance, maxSpawnDistance), random(minSpawnDistance, maxSpawnDistance));
        spheresExtras[i] = new PVector(random(minSphereRadius, maxSphereRadius), 0, random(minSphereSpeed, maxSphereSpeed));
      }
    }
  pop();
}
