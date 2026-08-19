Alien[] theAliens = new Alien[8];
ArrayList<Bullet> bulletList = new ArrayList<Bullet>();
ArrayList<Bomb> bossBombs = new ArrayList<Bomb>();
Player thePlayer;
Boss theBoss;
PImage invaderImg, explodeImg;
boolean gameOver = false;
String message = "";
int killCount = 0;
int killsNeededForBoss = 5;

void setup() {
  size(500, 500);
  invaderImg = loadImage("invader.GIF");
  explodeImg = loadImage("exploding.GIF");

  thePlayer = new Player(width/2, height - 50);

  for (int i = 0; i < theAliens.length; i++) {
    theAliens[i] = new Alien(i * 55 + 20, 50);
  }
}

void draw() {
  background(0);

  if (!gameOver) {
    thePlayer.move(mouseX);
    thePlayer.draw();

    for (int i = 0; i < theAliens.length; i++) {
      theAliens[i].move();
      theAliens[i].draw();
    }

    // boss appears once enough standard aliens are destroyed
    if (theBoss == null && killCount >= killsNeededForBoss) {
      theBoss = new Boss(width/2, 40);
    }

    if (theBoss != null) {
      theBoss.move();
      theBoss.draw();

      Bomb b = theBoss.tryDropBomb();
      if (b != null) bossBombs.add(b);

      for (int i = bossBombs.size() - 1; i >= 0; i--) {
        Bomb bomb = bossBombs.get(i);
        bomb.move();
        bomb.draw();

        if (bomb.collide(thePlayer.x + 15, thePlayer.y + 10, 20)) {
          gameOver = true;
          message = "GAME OVER - BOSS BOMBED YOU!";
        }
        if (bomb.offScreen()) {
          bossBombs.remove(i);
        }
      }
    }

    for (int i = bulletList.size() - 1; i >= 0; i--) {
      Bullet bullet = bulletList.get(i);
      bullet.move();
      bullet.draw();

      boolean hit = bullet.collide(theAliens);
      if (hit) {
        killCount++;
        bulletList.remove(i);
        continue;
      }

      if (theBoss != null && theBoss.alive() && dist(bullet.x, bullet.y, theBoss.x, theBoss.y) < 30) {
        theBoss.takeHit();
        bulletList.remove(i);
        if (!theBoss.alive()) {
          gameOver = true;
          message = "VICTORY!";
        }
      }
    }

    // boss health bar at the top
    if (theBoss != null && theBoss.alive()) {
      fill(255, 0, 0);
      rect(width/2 - 75, 10, 150, 10);
      fill(0, 255, 0);
      rect(width/2 - 75, 10, map(theBoss.health, 0, theBoss.maxHealth, 0, 150), 10);
    }

  } else {
    fill(255);
    textAlign(CENTER);
    textSize(28);
    text(message, width/2, height/2);
  }
}

void mousePressed() {
  if (!gameOver) {
    bulletList.add(new Bullet(thePlayer.x, thePlayer.y));
  }
}

// --- BOSS CLASS ---
class Boss {
  float x, y;
  int direction = 1;
  int health = 5;
  int maxHealth = 5;

  Boss(float x, float y) {
    this.x = x;
    this.y = y;
  }

  boolean alive() {
    return health > 0;
  }

  void takeHit() {
    health--;
  }

  void move() {
    x += (1 * direction); // slow horizontal movement
    if (x > width - 40 || x < 40) direction *= -1;
  }

  Bomb tryDropBomb() {
    if (random(0, 60) < 1) { // drops bombs continuously (frequent chance)
      return new Bomb(x, y);
    }
    return null;
  }

  void draw() {
    fill(150, 0, 200);
    rect(x - 25, y - 15, 50, 30); // boss body, visually bigger than a normal alien
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

  Alien(float x, float y) { this.x = x; this.y = y; }

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
