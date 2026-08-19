PImage invaderImg, explodeImg;
Alien4 zigzag;

void setup() {
  size(600, 500);
  invaderImg = loadImage("invader.GIF");
  explodeImg = loadImage("exploding.GIF");
  zigzag = new Alien4(0, 50);
}

void draw() {
  background(0);
  zigzag.move();
  zigzag.draw();
}

class Alien4 {
  float x, y;
  float dx = 3;
  int direction = 1;

  Alien4(float startX, float startY) {
    x = startX;
    y = startY;
  }

  void move() {
    x += dx * direction;

    if (x > width - 30 || x < 0) {
      direction *= -1;
      y += 30;
    }
  }

  void draw() {
    if (direction == 1) {
      image(invaderImg, x, y, 30, 30); // moving right
    } else {
      image(explodeImg, x, y, 30, 30); // moving left
    }
  }
}
