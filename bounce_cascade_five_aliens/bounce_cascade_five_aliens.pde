Alien1[] invaders = new Alien1[5];
PImage invaderImg;

void setup() {
  size(600, 500);
  invaderImg = loadImage("invader.GIF");

  for (int i = 0; i < invaders.length; i++) {
    invaders[i] = new Alien1(i * 100, height/2);
  }
}

void draw() {
  background(0);
  for (int i = 0; i < invaders.length; i++) {
    invaders[i].move();
    invaders[i].draw();
  }
}

class Alien1 {
  float x, y;
  float dx;
  int direction = 1;

  Alien1(float startX, float startY) {
    x = startX;
    y = startY;
    dx = random(1, 4); // each alien gets its own random speed
  }

  void move() {
    // stop once it reaches the bottom
    if (y >= height - 30) {
      y = height - 30;
      return;
    }

    x += dx * direction;

    if (x > width - 30 || x < 0) {
      direction *= -1;
      y += 30; // move down by its own height
    }
  }

  void draw() {
    image(invaderImg, x, y, 30, 30);
  }
}
