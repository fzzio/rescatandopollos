/*  ******************
 Rescatando pollos
 ******************  */
PImage imgFondo;

Jugador jugadorA;
Jugador jugadorB;


void setup()
{
  size(1024, 700);
  frameRate(30);
  
  imgFondo = loadImage("img/fondo.png");
  
  jugadorA = new Jugador();
  jugadorB = new Jugador();
}

void draw()
{
  background(imgFondo);
  ellipse(mouseX, mouseY, 100, 100);
}
