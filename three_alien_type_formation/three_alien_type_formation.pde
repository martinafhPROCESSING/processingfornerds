Alien[] theAliens = new Alien[15]; // 3 rows of 5
ArrayList<Bullet> bulletList = new ArrayList<Bullet>();
Player thePlayer;
PImage invaderImg, explodeImg;

// alien type constants
final int STANDARD = 0;
final int FAST = 1;
final int ARMORED = 2;

void setup() {
  size(500, 500);
  invaderImg = loadImage("invader.GIF");
  explodeImg = loadImage("exploding.GIF");

  thePlayer = new Player(width/2, height - 50);

  int index = 0;
  // row 0: standard aliens
  for (int i = 0; i < 5; i++) {
    theAliens[index] = new Alien(i * 70 + 40, 40, STANDARD);
    index++;
  }
  // row 1: fast aliens
  for (int i = 0; i < 5; i++) {
    theAliens[index] = new Alien(i * 70 + 40, 90, FAST);
    index++;
  }
  // row 2: armored aliens
  for (int i = 0; i < 5; i++) {
    theAliens[index] = new Alien(i * 70 + 40, 140, ARMORED);
    index++;
  }
}

void draw() {
  background(0);

  thePlayer.move(mouseX);
  thePlayer.draw();

  for (int i = 0; i < theAliens.length; i++) {
    theAliens[i].move();
    theAliens[i].draw();

    if (theAliens[i].status == 0) {
      Bomb b = theAliens[i].getBomb();
      if (b != null) {
        b.move();
        b.draw();
        if (b.offScreen()) {
          theAliens[i].myBomb = null;
        }
      }
    }
  }

  for (int i = bulletList.size() - 1; i >= 0; i--) {
    Bullet bullet = bulletList.get(i);
    bullet.move();
    bullet.draw();
    if (bullet.collide(theAliens)) {
      bulletList.remove(i);
    }
  }
}

void mousePressed() {
  bulletList.add(new Bullet(thePlayer.x, thePlayer.y));
}

// --- BOMB CLASS ---
class Bomb {
  float x, y;
  Bomb(float x, float y) { this.x = x; this.y = y; }
  void move() { y += 3; }
  void draw() { fill(255, 0, 0); rect(x, y, 5, 15); }
  boolean offScreen() { return (y > height); }
}

// --- ALIEN CLASS ---
class Alien {
  float x, y;
  int direction = 1;
  int status = 0; // 0 = alive, 1 = exploding
  int type;
  int hitPoints;
  float dx;
  Bomb myBomb;

  Alien(float x, float y, int type) {
    this.x = x;
    this.y = y;
    this.type = type;

    if (type == STANDARD) {
      dx = 2;
      hitPoints = 1;
    } else if (type == FAST) {
      dx = 5;
      hitPoints = 1;
    } else { // ARMORED
      dx = 1;
      hitPoints = 2;
    }
  }

  Bomb getBomb() {
    if (status != 0 || myBomb != null) return myBomb;

    // armored aliens don't bomb, they drop power-ups instead when destroyed
    if (type == STANDARD && random(0, 500) < 1) {
      myBomb = new Bomb(x, y);
    } else if (type == FAST && random(0, 1500) < 1) { // fewer bombs
      myBomb = new Bomb(x, y);
    }
    return myBomb;
  }

  void move() {
    if (status == 0) {
      x += (dx * direction);
      if (x > width || x < 0) { direction *= -1; y += 20; }
    }
  }

  void draw() {
    if (status == 0) {
      // tint gives each type a distinct look using the same sprite
      if (type == STANDARD) {
        tint(255); // normal colour
      } else if (type == FAST) {
        tint(0, 255, 255); // cyan
      } else {
        tint(255, 140, 0); // orange, and draw a border to show it's armored
        noFill();
        stroke(255, 140, 0);
        rect(x - 2, y - 2, 34, 34);
        noStroke();
      }
      image(invaderImg, x, y, 30, 30);
      noTint();
    } else if (status == 1) {
      image(explodeImg, x, y, 30, 30);
    }
  }
}

// --- PLAYER CLASS ---
class Player {
  float x, y;
  Player(float x, float y) { this.x = x; this.y = y; }
  void move(float tx) { x = tx; }
  void draw() { fill(0, 255, 0); rect(x, y, 30, 20); }
}

// --- BULLET CLASS ---
class Bullet {
  float x, y;
  Bullet(float x, float y) { this.x = x; this.y = y; }
  void move() { y -= 5; }
  void draw() { fill(255, 255, 0); ellipse(x, y, 5, 10); }

  boolean collide(Alien[] aliens) {
    for (int i = 0; i < aliens.length; i++) {
      Alien a = aliens[i];
      if (a.status == 0 && dist(x, y, a.x, a.y) < 20) {
        a.hitPoints--; // armored aliens need two hits
        if (a.hitPoints <= 0) {
          a.status = 1;
        }
        return true;
      }
    }
    return false;
  }
}
