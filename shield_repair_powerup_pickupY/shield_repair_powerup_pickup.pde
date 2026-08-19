Alien[] theAliens = new Alien[10];
ArrayList<Bullet> bulletList = new ArrayList<Bullet>();
ArrayList<PowerUp> powerUps = new ArrayList<PowerUp>();
Player thePlayer;
Shield shield;
PImage invaderImg, explodeImg;

void setup() {
  size(500, 500);
  invaderImg = loadImage("invader.GIF");
  explodeImg = loadImage("exploding.GIF");

  thePlayer = new Player(width/2, height - 50);
  shield = new Shield(width/2 - 20, height - 150);

  for (int i = 0; i < theAliens.length; i++) {
    theAliens[i] = new Alien(i * 40 + 20, 50);
  }
}

void draw() {
  background(0);

  thePlayer.move(mouseX);
  thePlayer.draw();
  shield.draw();

  for (int i = 0; i < theAliens.length; i++) {
    theAliens[i].move();
    theAliens[i].draw();

    if (theAliens[i].status == 0) {
      // bombs, same as before
      Bomb b = theAliens[i].getBomb();
      if (b != null) {
        b.move();
        b.draw();

        boolean bombGone = false;
        if (shield.alive() && b.collide(shield.x + 20, shield.y + 10, 20)) {
          shield.takeHit(20);
          bombGone = true;
        } else if (b.collide(thePlayer.x + 15, thePlayer.y + 10, 20)) {
          bombGone = true;
        }

        if (b.offScreen() || bombGone) {
          theAliens[i].myBomb = null;
        }
      }

      // occasional power-up drop
      PowerUp p = theAliens[i].tryDropPowerUp();
      if (p != null) powerUps.add(p);
    }
  }

  for (int i = powerUps.size() - 1; i >= 0; i--) {
    PowerUp p = powerUps.get(i);
    p.move();
    p.draw();

    if (p.collide(thePlayer.x + 15, thePlayer.y + 10, 20)) {
      shield.repair(30); // collected: boost shield health
      powerUps.remove(i);
    } else if (p.offScreen()) {
      powerUps.remove(i);
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

  fill(255);
  textAlign(LEFT);
  textSize(14);
  text("Shield health: " + shield.health, 10, 20);
}

void mousePressed() {
  bulletList.add(new Bullet(thePlayer.x, thePlayer.y));
}

// --- POWER-UP CLASS ---
class PowerUp {
  float x, y;
  PowerUp(float x, float y) { this.x = x; this.y = y; }
  void move() { y += 2; }
  void draw() {
    fill(255, 255, 0);
    ellipse(x, y, 12, 12); // small yellow orb
  }
  boolean offScreen() { return (y > height); }
  boolean collide(float tx, float ty, float radius) {
    return dist(x, y, tx, ty) < radius;
  }
}

// --- SHIELD CLASS ---
class Shield {
  float x, y;
  int health = 60; // starts partway damaged so repairs are visible
  int maxHealth = 100;

  Shield(float x, float y) {
    this.x = x;
    this.y = y;
  }

  boolean alive() {
    return health > 0;
  }

  void takeHit(int amount) {
    health -= amount;
    if (health < 0) health = 0;
  }

  void repair(int amount) {
    health += amount;
    if (health > maxHealth) health = maxHealth;
  }

  void draw() {
    if (!alive()) return;

    fill(255, 0, 0);
    rect(x, y - 12, 40, 5);
    fill(0, 255, 0);
    rect(x, y - 12, map(health, 0, maxHealth, 0, 40), 5);

    fill(0, 100, 255, map(health, 0, maxHealth, 60, 255));
    rect(x, y, 40, 20);
  }
}

// --- BOMB CLASS ---
class Bomb {
  float x, y;
  Bomb(float x, float y) { this.x = x; this.y = y; }
  void move() { y += 3; }
  void draw() { fill(255, 0, 0); rect(x, y, 5, 15); }
  boolean offScreen() { return (y > height); }
  boolean collide(float tx, float ty, float radius) {
    return dist(x, y, tx, ty) < radius;
  }
}

// --- ALIEN CLASS ---
class Alien {
  float x, y;
  int direction = 1;
  int status = 0;
  Bomb myBomb;

  Alien(float x, float y) { this.x = x; this.y = y; }

  Bomb getBomb() {
    if (status == 0 && myBomb == null) {
      if (random(0, 500) < 1) {
        myBomb = new Bomb(x, y);
      }
    }
    return myBomb;
  }

  PowerUp tryDropPowerUp() {
    if (random(0, 800) < 1) { // rarer than bombs
      return new PowerUp(x, y);
    }
    return null;
  }

  void move() {
    if (status == 0) {
      x += (2 * direction);
      if (x > width || x < 0) { direction *= -1; y += 30; }
    }
  }

  void draw() {
    if (status == 0) image(invaderImg, x, y, 30, 30);
    else if (status == 1) image(explodeImg, x, y, 30, 30);
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
      if (aliens[i].status == 0 && dist(x, y, aliens[i].x, aliens[i].y) < 20) {
        aliens[i].status = 1;
        return true;
      }
    }
    return false;
  }
}
