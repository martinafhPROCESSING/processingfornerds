Alien[] theAliens = new Alien[8];
PImage invaderImg;

void setup() {
  size(500, 500);
  invaderImg = loadImage("invader.GIF");

  for (int i = 0; i < theAliens.length; i++) {
    theAliens[i] = new Alien(0, i * 20 + 20); // start along the top-left, moving right
  }
}

void draw() {
  background(0);

  for (int i = 0; i < theAliens.length; i++) {
    theAliens[i].move();
    theAliens[i].draw();
  }
}

void mousePressed() {
  for (int i = 0; i < theAliens.length; i++) {
    theAliens[i].turnRight();
  }
}

void keyPressed() {
  if (key == ' ') {
    for (int i = 0; i < theAliens.length; i++) {
      theAliens[i].turnLeft();
    }
  }
}

class Alien {
  float x, y;
  float dx = 2, dy = 0; // starts moving right, toward the top-right corner

  Alien(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void move() {
    x += dx;
    y += dy;
  }

  void turnRight() {
    // rotate the direction vector 90 degrees clockwise
    float newDx = -dy;
    float newDy = dx;
    dx = newDx;
    dy = newDy;
  }

  void turnLeft() {
    // rotate the direction vector 90 degrees counter-clockwise
    float newDx = dy;
    float newDy = -dx;
    dx = newDx;
    dy = newDy;
  }

  void draw() {
    image(invaderImg, x, y, 30, 30);
  }
}
