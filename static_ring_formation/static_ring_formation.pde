Alien[] theAliens = new Alien[30];
PImage invaderImg;

float centerX, centerY;
float radius = 150;

void setup() {
  size(500, 500);
  invaderImg = loadImage("invader.GIF");

  centerX = width/2;
  centerY = height/2;

  for (int i = 0; i < theAliens.length; i++) {
    float angle = i * (TWO_PI / theAliens.length); // evenly spaced around the circle
    theAliens[i] = new Alien(angle);
  }
}

void draw() {
  background(0);

  noFill();
  stroke(255, 80);
  ellipse(centerX, centerY, radius * 2, radius * 2);
  noStroke();

  for (int i = 0; i < theAliens.length; i++) {
    theAliens[i].draw();
  }
}

class Alien {
  float angle; // fixed position around the circle

  Alien(float angle) {
    this.angle = angle;
  }

  void draw() {
    float x = centerX + cos(angle) * radius;
    float y = centerY + sin(angle) * radius;
    image(invaderImg, x, y, 20, 20);
  }
}
