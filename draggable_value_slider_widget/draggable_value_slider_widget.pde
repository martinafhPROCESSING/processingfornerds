Slider mySlider;

void setup() {
  size(400, 200);
  mySlider = new Slider(50, 100, 300);
}

void draw() {
  background(30);
  mySlider.draw();
}

void mousePressed() {
  mySlider.checkPress(mouseX, mouseY);
}

void mouseDragged() {
  mySlider.drag(mouseX);
}

void mouseReleased() {
  mySlider.dragging = false;
}

class Slider {
  float xStart, y, lineLength;
  float circleX;
  float value = 0; // 0 to 10
  boolean dragging = false;

  Slider(float xStart, float y, float lineLength) {
    this.xStart = xStart;
    this.y = y;
    this.lineLength = lineLength;
    this.circleX = xStart; // starts at 0
  }

  void checkPress(int mx, int my) {
    // dragging only starts if the mouse is pressed directly on the circle
    float radius = map(value, 0, 10, 6, 16);
    if (dist(mx, my, circleX, y) < radius) {
      dragging = true;
    }
  }

  void drag(int mx) {
    if (!dragging) return;

    circleX = constrain(mx, xStart, xStart + lineLength);
    value = map(circleX, xStart, xStart + lineLength, 0, 10);
  }

  void draw() {
    stroke(255);
    line(xStart, y, xStart + lineLength, y);

    noStroke();
    fill(0, 200, 255);
    float radius = map(value, 0, 10, 6, 16); // grows as value increases
    ellipse(circleX, y, radius * 2, radius * 2);

    fill(255);
    textAlign(LEFT, CENTER);
    text("Value: " + nf(value, 1, 1), xStart + lineLength + 20, y);
  }
}
