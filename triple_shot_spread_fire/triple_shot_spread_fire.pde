Alien[] theAliens = new Alien[8];
ArrayList<Bullet> bulletList = new ArrayList<Bullet>();
Player thePlayer;
PImage invaderImg, explodeImg;

void setup() {
  size(500, 500);
  invaderImg = loadImage("invader.GIF");
  explodeImg = loadImage("exploding.GIF");

  thePlayer = new Player(width/2, height - 50);

  for (int i = 0; i < theAliens.length; i++) {
    theAliens[i] = new Alien(i * 40 + 20, 50);
  }
}

void draw() {
  background(0);

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
  // fire three bullets at once: straight, angled left, angled right
  bulletList.add(new Bullet(thePlayer.x, thePlayer.y, 0, -5));
  bulletList.add(new Bullet(thePlayer.x, thePlayer.y, -2, -5));
  bulletList.add(new Bullet(thePlayer.x, thePlayer.y, 2, -5));
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
  float x, y;
  int direction = 1;
  int status = 0; // 0 = alive, 1 = exploding/falling

  Alien(float x, float y) { this.x = x; this.y = y; }

  void move() {
    if (status == 0) {
      x += (2 * direction);
      if (x > width || x < 0) {
        direction *= -1;
        y += 30;
      }
    } else if (status == 1) {
      y += 4;
    }
  }

  void draw() {
    if (status == 0) {
      image(invaderImg, x, y, 30, 30);
    } else if (status == 1) {
      image(explodeImg, x, y, 30, 30);
    }
  }
}

class Bullet {
  float x, y;
  float vx, vy;

  Bullet(float x, float y, float vx, float vy) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
  }

  void move() {
    x += vx;
    y += vy;
  }

  void draw() {
    fill(255, 255, 0);
    ellipse(x, y, 5, 10);
  }

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
