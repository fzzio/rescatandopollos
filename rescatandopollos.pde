/*  ******************
 Rescatando pollos
 ******************  */
PImage imgFondo;

void setup()
{
  size(1024, 700);
  frameRate(30);
  
  imgFondo = loadImage("img/fondo.png");
}

void draw()
{
  background(imgFondo);
}
