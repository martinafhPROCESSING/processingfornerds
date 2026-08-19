PImage invaderImg;

float x, y;
float dx = 3, dy = 3;
int state = 0; // 0 = whole, 1 = split apart, 2 = returning

float sx1, sy1, sx2, sy2;
float vx1, vy1, vx2, vy2;
float centerX, centerY;
int splitTimer = 0;
int splitCount = 0;
int joinCount = 0;

void setup() {
  size(600, 500);
  invaderImg = loadImage("invader.GIF");
  x = width/2;
  y = height/2;
}

void draw() {
  background(0);

  if (state == 0) {
    x += dx;
    y += dy;

    // bounce off any edge, then split at that point
    boolean hit = false;
    if (x > width - 30 || x < 0) { dx *= -1; hit = true; }
    if (y > height - 30 || y < 0) { dy *= -1; hit = true; }

    if (hit) {
      x = constrain(x, 0, width - 30);
      y = constrain(y, 0, height - 30);
      centerX = x;
      centerY = y;
      sx1 = sx2 = x;
      sy1 = sy2 = y;

      float a1 = random(TWO_PI);
      float a2 = random(TWO_PI);
      vx1 = cos(a1) * 4; vy1 = sin(a1) * 4;
      vx2 = cos(a2) * 4; vy2 = sin(a2) * 4;

      splitTimer = 0;
      splitCount++;
      state = 1;
    }

    image(invaderImg, x, y, 30, 30);

  } else if (state == 1) {
    sx1 += vx1; sy1 += vy1;
    sx2 += vx2; sy2 += vy2;
    splitTimer++;

    if (splitTimer > 60) {
      state = 2; // start heading back
    }

    image(invaderImg, sx1, sy1, 15, 15);
    image(invaderImg, sx2, sy2, 15, 15);

  } else if (state == 2) {
    sx1 += (centerX - sx1) * 0.08;
    sy1 += (centerY - sy1) * 0.08;
    sx2 += (centerX - sx2) * 0.08;
    sy2 += (centerY - sy2) * 0.08;

    float d1 = dist(sx1, sy1, centerX, centerY);
    float d2 = dist(sx2, sy2, centerX, centerY);

    if (d1 < 4 && d2 < 4) {
      x = centerX;
      y = centerY;
      joinCount++;
      state = 0;
    }

    image(invaderImg, sx1, sy1, 15, 15);
    image(invaderImg, sx2, sy2, 15, 15);
  }

  fill(255);
  text("Splits: " + splitCount + "   Joins: " + joinCount, 10, 20);
}
