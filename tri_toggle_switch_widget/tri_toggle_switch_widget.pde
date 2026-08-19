ToggleSwitch[] toggles = new ToggleSwitch[3];

void setup() {
  size(400, 300);
  toggles[0] = new ToggleSwitch(50, 50);
  toggles[1] = new ToggleSwitch(50, 120);
  toggles[2] = new ToggleSwitch(50, 190);
}

void draw() {
  background(30);
  for (int i = 0; i < toggles.length; i++) {
    toggles[i].draw();
  }
}

void mousePressed() {
  for (int i = 0; i < toggles.length; i++) {
    toggles[i].checkClick(mouseX, mouseY);
  }
}

class ToggleSwitch {
  float x, y, w = 100, h = 40;
  boolean isOn = false;

  ToggleSwitch(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void checkClick(int mx, int my) {
    if (mx > x && mx < x + w && my > y && my < y + h) {
      isOn = !isOn; // flip the state
    }
  }

  void draw() {
    if (isOn) {
      fill(0, 200, 0); // green for ON
    } else {
      fill(120); // grey for OFF
    }
    rect(x, y, w, h);

    fill(255);
    textAlign(CENTER, CENTER);
    text(isOn ? "ON" : "OFF", x + w/2, y + h/2);
  }
}
