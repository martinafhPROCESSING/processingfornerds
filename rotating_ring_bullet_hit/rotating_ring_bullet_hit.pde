Alien[] theAliens = new Alien[30];
ArrayList<Bullet> bulletList = new ArrayList<Bullet>();
Player thePlayer;
PImage invaderImg, explodeImg;

float centerX, centerY;
float radius = 150;
float rotationOffset = 0;

void setup() {
  size(500, 500);
  invaderImg = loadImage("invader.GIF");
  explodeImg = loadImage("exploding.GIF");

  centerX = width/2;
  centerY = height/2;

  thePlayer = new Player(width/2, height - 30);

  for (int i = 0; i < theAliens.length; i++) {
    float angle = i * (TWO_PI / theAliens.length);
    theAliens[i] = new Alien(angle);
  }
}

void draw() {
  background(0);

  rotationOffset += 0.01; // spin the whole ring

  thePlayer.move(mouseX);
  thePlayer.draw();

  for (int i = 0; i < theAliens.length; i++) {
    theAliens[i].move();
    theAliens[i].draw();
  }

  for (int i = bulletList.size() - 1; i >= 0; i--) {
    Bullet b = bulletList.get(i);
    b.move();
    b.draw();

    if (b.collide(theAliens)) {
      bulletList.remove(i);
    }
  }
}

void mousePressed() {
  bulletList.add(new Bullet(thePlayer.x, thePlayer.y));
}

class Player {
  float x, y;
  Player(float x, float y) { this.x = x; this.y = y; }
  void move(float targetX) { x = targetX; }
  void draw() {
    fill(0, 255, 0);
    rect(x, y, 30, 20);
  }
}

class Alien {
  float angle;    // fixed slot on the ring
  float x, y;     // current screen position
  int status = 0; // 0 = alive/rotating, 1 = exploding/falling

  Alien(float angle) {
    this.angle = angle;
  }

  void move() {
    if (status == 0) {
      x = centerX + cos(angle + rotationOffset) * radius;
      y = centerY + sin(angle + rotationOffset) * radius;
    } else if (status == 1) {
      y += 4; // drop straight down, stop following the ring
    }
  }

  void draw() {
    if (status == 0) {
      image(invaderImg, x, y, 20, 20);
    } else if (status == 1) {
      image(explodeImg, x, y, 20, 20);
    }
  }
}

class Bullet {
  float x, y;
  Bullet(float x, float y) { this.x = x; this.y = y; }
  void move() { y -= 5; }
  void draw() {
    fill(255, 255, 0);
    ellipse(x, y, 5, 10);
  }
  boolean collide(Alien[] aliens) {
    for (int i = 0; i < aliens.length; i++) {
      if (aliens[i].status == 0 && dist(x, y, aliens[i].x, aliens[i].y) < 15) {
        aliens[i].status = 1;
        return true;
      }
    }
    return false;
  }
}
