Counter[] counters = new Counter[2];

void setup() {
  size(400, 250);
  counters[0] = new Counter(50, 50);
  counters[1] = new Counter(220, 50);
}

void draw() {
  background(30);
  for (int i = 0; i < counters.length; i++) {
    counters[i].draw();
  }
}

void mousePressed() {
  for (int i = 0; i < counters.length; i++) {
    counters[i].checkClick(mouseX, mouseY);
  }
}

class Counter {
  float x, y;
  int count = 0;
  float buttonW = 30, buttonH = 30;

  Counter(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void checkClick(int mx, int my) {
    // minus button, on the left
    if (mx > x && mx < x + buttonW && my > y && my < y + buttonH) {
      if (count > 0) count--; // never below zero
    }
    // plus button, on the right
    if (mx > x + 80 && mx < x + 80 + buttonW && my > y && my < y + buttonH) {
      count++;
    }
  }

  void draw() {
    fill(200, 100, 100);
    rect(x, y, buttonW, buttonH); // minus button
    fill(100, 200, 100);
    rect(x + 80, y, buttonW, buttonH); // plus button

    fill(255);
    textAlign(CENTER, CENTER);
    text("-", x + buttonW/2, y + buttonH/2);
    text("+", x + 80 + buttonW/2, y + buttonH/2);

    textSize(20);
    text(count, x + 55, y + buttonH/2);
    textSize(12);
  }
}
