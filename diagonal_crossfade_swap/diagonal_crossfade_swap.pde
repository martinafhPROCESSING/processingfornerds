PImage invaderImg, explodeImg;
float ax, ay, bx, by;
PImage imgA, imgB;
boolean swapped = false;

void setup() {
  size(500, 500); // square screen
  invaderImg = loadImage("invader.GIF");
  explodeImg = loadImage("exploding.GIF");

  ax = 0; ay = 0;              // top-left
  bx = width - 30; by = 0;     // top-right
  imgA = invaderImg;
  imgB = explodeImg;
}

void draw() {
  background(0);

  ax += 2; ay += 2; // down-right
  bx -= 2; by += 2; // down-left

  // swap pictures once, when both are at the same height in the centre
  if (!swapped && ay >= height/2) {
    PImage temp = imgA;
    imgA = imgB;
    imgB = temp;
    swapped = true;
  }

  image(imgA, ax, ay, 30, 30);
  image(imgB, bx, by, 30, 30);
}
