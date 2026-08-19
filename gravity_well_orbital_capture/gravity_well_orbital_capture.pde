Alien2[] invaders = new Alien2[3];
PImage invaderImg;

float[] wellX = {150, 450, 300};
float[] wellY = {150, 150, 400};

void setup() {
  size(600, 500);
  invaderImg = loadImage("invader.GIF");

  for (int i = 0; i < invaders.length; i++) {
    invaders[i] = new Alien2(random(width));
  }
}

void draw() {
  background(0);

  // draw the wells
  fill(255, 150, 0);
  noStroke();
  for (int i = 0; i < wellX.length; i++) {
    ellipse(wellX[i], wellY[i], 15, 15);
  }

  for (int i = 0; i < invaders.length; i++) {
    invaders[i].move();
    invaders[i].draw();
  }
}

class Alien2 {
  float x, y;
  float vx = 0, vy = 1;
  boolean circling = false;
  boolean launched = false;
  float angle = 0;
  int circleTimer = 0;

  Alien2(float startX) {
    x = startX;
    y = 0;
  }

  void move() {
    if (launched) {
      x += vx;
      y += vy;
      return;
    }

    // find the nearest well
    int nearest = 0;
    float best = 999999;
    for (int i = 0; i < wellX.length; i++) {
      float d = dist(x, y, wellX[i], wellY[i]);
      if (d < best) {
        best = d;
        nearest = i;
      }
    }

    float nx = wellX[nearest];
    float ny = wellY[nearest];

    if (circling) {
      angle += 0.15;
      x = nx + cos(angle) * 20;
      y = ny + sin(angle) * 20;
      circleTimer++;
      if (circleTimer > 60) {
        launched = true;
        vx = cos(angle) * 6; // faster launch speed
        vy = sin(angle) * 6;
      }
    } else if (best < 40) {
      circling = true; // close enough to start orbiting
    } else {
      // pull toward the well, stronger when closer
      float pull = map(best, 0, 400, 0.3, 0.02);
      x += (nx - x) * pull;
      y += (ny - y) * pull;
    }

    // faint line to show the pull
    stroke(255, 60);
    line(x, y, nx, ny);
    noStroke();
  }

  void draw() {
    image(invaderImg, x, y, 30, 30);
  }
}
