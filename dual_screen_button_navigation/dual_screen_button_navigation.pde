Screen screen1, screen2, currentScreen;

void setup() {
  size(400, 400);

  screen1 = new Screen(color(200, 220, 255));
  screen2 = new Screen(color(255, 220, 200));

  screen1.addWidget(new Widget(150, 150, 100, 40, "Go to Screen 2", color(100, 255, 100), "SWITCH_TO_2"));
  screen1.addWidget(new Widget(150, 210, 100, 40, "Print", color(255), "PRINT_1"));

  screen2.addWidget(new Widget(150, 150, 100, 40, "Go to Screen 1", color(255, 100, 100), "SWITCH_TO_1"));
  screen2.addWidget(new Widget(150, 210, 100, 40, "Print", color(255), "PRINT_2"));

  currentScreen = screen1;
}

void draw() {
  currentScreen.draw();
}

void mousePressed() {
  String event = currentScreen.getEvent(mouseX, mouseY);

  if (event.equals("SWITCH_TO_2")) {
    currentScreen = screen2;
  } else if (event.equals("SWITCH_TO_1")) {
    currentScreen = screen1;
  } else if (event.equals("PRINT_1")) {
    println("Button 2 on Screen 1 was pressed!");
  } else if (event.equals("PRINT_2")) {
    println("Button 2 on Screen 2 was pressed!");
  }
}

// --- WIDGET CLASS ---
class Widget {
  float x, y, w, h;
  String label;
  color widgetColor;
  String event;

  Widget(float x, float y, float w, float h, String label, color c, String e) {
    this.x = x; this.y = y; this.w = w; this.h = h;
    this.label = label; this.widgetColor = c; this.event = e;
  }

  void draw() {
    stroke(0);
    fill(widgetColor);
    rect(x, y, w, h);

    fill(0);
    textAlign(CENTER, CENTER);
    text(label, x + w/2, y + h/2);
  }

  boolean contains(int mx, int my) {
    return (mx > x && mx < x+w && my > y && my < y+h);
  }
}

// --- SCREEN CLASS ---
class Screen {
  color bg;
  ArrayList<Widget> widgetList;

  Screen(color bg) {
    this.bg = bg;
    widgetList = new ArrayList<Widget>();
  }

  void addWidget(Widget w) {
    widgetList.add(w);
  }

  void draw() {
    background(bg);
    for (int i = 0; i < widgetList.size(); i++) {
      widgetList.get(i).draw();
    }
  }

  String getEvent(int mx, int my) {
    for (int i = 0; i < widgetList.size(); i++) {
      Widget w = widgetList.get(i);
      if (w.contains(mx, my)) {
        return w.event;
      }
    }
    return "NOTHING";
  }
}
