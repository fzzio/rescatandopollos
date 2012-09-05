// Librerias a usar
import processing.opengl.*;
import javax.swing.*;
//import processing.video.*;
import codeanticode.gsvideo.*;

// Imagenes a usar
PImage imgFondo;

Jugador jugadorA, jugadorB;
ArrayList pollosA, pollosB;
int totalPollos = 30;
int velocidad = 2;
int atrapadosPollosA = 0, atrapadosPollosB = 0;
Nido    nidoA, nidoB;

Timer   timer;
PFont   fuente;
boolean finDelJuego = false;

// Calibraciones y colores de juego
boolean estaCalibrado = false;
color trackColorA, trackColorB;
float aTrackR, aTrackG, aTrackB;
float bTrackR, bTrackG, bTrackB;

String mensaje = "";
//Capture video;
GSCapture video;

int posXInicialA, posXInicialB;

void setup()
{
  size(1024, 700);
  frameRate(30);
  
  //video = new Capture(this,width,height,15);
  video = new GSCapture(this, 640, 480);
  video.start();
  
  imgFondo = loadImage("img/fondo.png");
  jugadorA = new Jugador();
  jugadorB = new Jugador();
  pollosA = new ArrayList(totalPollos);
  pollosB = new ArrayList(totalPollos);
    for(int i=0; i< totalPollos; i++){
      pollosA.add(new Pollo(loadImage("img/polloA.png"), 0, 418, 610));
      pollosB.add(new Pollo(loadImage("img/polloB.png"), 515, 930, 610));
    }
  nidoA = new Nido(loadImage("img/nidoA.png"), 0, 300);
  nidoB = new Nido(loadImage("img/nidoB.png"), 515, 810);
  
  timer = new Timer(1000 * 60); // 60 segundos
  
  
  fuente = createFont("Arial",12,true);

}

void draw()
{
  background(imgFondo);  
  // Caragamos datos de la camara
  if (video.available()) {
    video.read();
  }
  video.loadPixels();

  
  if (!estaCalibrado){
    pushMatrix();
      //float scalX = (width - video.width) / 100;
      //float scalY = (height - video.height) / 100;
      //scale(scalX, scalY);
      image(video, 0, 0);
      //image(video, (width - video.width)/2, (height - video.height)/2);
    popMatrix();
    dibujarColoresDetectados();
    pushMatrix();
      textFont(fuente,30);
      textAlign(CENTER);
      text(mensaje, width/2, 620);
    popMatrix();
    // una vez calibrado empezamos el juego
    //estaCalibrado = true;
    //timer.start();
  }else{
    if (finDelJuego) {
      textFont(fuente,48);
      textAlign(CENTER);
      fill(0);
      text("FIN DEL JUEGO",width/2,height/2);
      textFont(fuente,20);
      text("Jugador A: " + jugadorA.getPuntos() + " puntos.", width/2, height/2 + 40);
      text("Jugador B: " + jugadorB.getPuntos() + " puntos.", width/2, height/2 + 70);
    } 
    else{
      
      for(int i=0; i<totalPollos; i++){
        
          // Jugador A
          ((Pollo)pollosA.get(i)).dibujarPollo();
          ((Pollo)pollosA.get(i)).caer();
          
          // si fue atrapado por un nido
          if(((Pollo)pollosA.get(i)).getPosY() <= ((Pollo)pollosA.get(i)).getLimiteMaxY()){
            
            if (polloAtrapado((Pollo)pollosA.get(i), nidoA)){
             jugadorA.aumentarPuntos(); 
            }else{
             jugadorA.reducirPuntos();
            }
            pollosA.remove(i);
          }
          
          // Jugador B
          ((Pollo)pollosB.get(i)).dibujarPollo();
          ((Pollo)pollosB.get(i)).caer();
          
          // si fue atrapado por un nido
          if(((Pollo)pollosB.get(i)).getPosY() <= ((Pollo)pollosB.get(i)).getLimiteMaxY()){
            
            if (polloAtrapado((Pollo)pollosB.get(i), nidoB)){
             jugadorB.aumentarPuntos(); 
            }else{
             jugadorB.reducirPuntos();
            }
            pollosB.remove(i);
          }
      }


      asignarPosicionesDetectadas();
      //Dibujamos Nidos segun posiciones detectadas
      nidoA.dibujarNido();
      nidoB.dibujarNido();
      
      if(timer.isFinished()){
        finDelJuego = true;
      }
    }
  }
}

void keyPressed(){
  if(!estaCalibrado && mouseX < video.width && mouseY < video.height){
    if(key == '1'){
      int loc = mouseX + mouseY*video.width;
      trackColorA = video.pixels[loc];
      aTrackR = red(trackColorA);
      aTrackG = green(trackColorA);
      aTrackB = blue(trackColorA);
      mensaje = "Calibrando color para Jugador A: [" + aTrackR + ", " + aTrackG + ", " + aTrackB + "].";
    }else if(key == '2'){
      int loc = mouseX + mouseY*video.width;
      trackColorB = video.pixels[loc];
      bTrackR = red(trackColorB);
      bTrackG = green(trackColorB);
      bTrackB = blue(trackColorB);
      mensaje = "Calibrando color para Jugador B: [" + bTrackR + ", " + bTrackG + ", " + bTrackB + "].";
    }else if(key == '3'){
      estaCalibrado = true;
    }
  }
}

void keyReleased(){
  mensaje = "";
}

void asignarPosicionesDetectadas(){
  float worldRecord1 = 500, worldRecord2 = 500;
  int closestX1 = 0, closestX2 = 0;
  int closestY1 = 0, closestY2 = 0;
  
  for(int x = 0; x < video.width; x ++ ) {
    for(int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;

      // Obtenemos los datos para el color actual
      color colorActual = video.pixels[loc];
      float actR = red(colorActual);
      float actG = green(colorActual);
      float actB = blue(colorActual);
      
      //Comparamos con los colores detectados en A con distancia Euclidiana
      float dA = dist(actR, actG, actB, aTrackR, aTrackG, aTrackB);
      float dB = dist(actR, actG, actB, bTrackR, bTrackG, bTrackB);      
      
      if (dA < worldRecord1) {
        worldRecord1 = dA;
        closestX1 = x;
        closestY1 = y;
      }
      if (dB < worldRecord2) {
        worldRecord2 = dB;
        closestX2 = x;
        closestY2 = y;
      }
    }
  }
  
  if (worldRecord1>0) {
    int posActualNA = nidoA.getPosX();
    if((posActualNA - closestX1) > 0){
      // mover a la derecha
      if(posActualNA < nidoA.getLimiteMaxX()){
        posActualNA +=2;
      }else{
        posActualNA = nidoA.getLimiteMaxX();
      }
    }else if((posActualNA - closestX1) < 0){
      // mover a la izquierda      
      if(posActualNA > nidoA.getLimiteMinX()){
        posActualNA +=2;
      }else{
        posActualNA = nidoA.getLimiteMinX();
      }
    }
    nidoA.setPosX(posActualNA);
    nidoA.dibujarNido();

  }
  
  if (worldRecord2 > 0) {
    int posActualNB = nidoB.getPosX();
    
    println("Entra a Nido B");
    if((posActualNB - closestX2) > 0){
      // mover a la derecha
      println("Mover derecha");
      if(posActualNB < nidoB.getLimiteMaxX()){
        posActualNB += 5;
      }else{
        posActualNB = nidoB.getLimiteMaxX();
      }
    }else if((posActualNB - closestX2) < 0){
      // mover a la izquierda
      println("Mover izquierda");      
      if(posActualNB > nidoB.getLimiteMinX()){
        posActualNB =posActualNB - 5;
      }else{
        posActualNB = nidoB.getLimiteMinX();
      }
    }
    nidoB.setPosX(posActualNB);
    
    
  }
}


void dibujarColoresDetectados(){
  float worldRecord1 = 500, worldRecord2 = 500;
  int closestX1 = 0, closestX2 = 0;
  int closestY1 = 0, closestY2 = 0;
  
  for(int x = 0; x < video.width; x ++ ) {
    for(int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;

      // Obtenemos los datos para el color actual
      color colorActual = video.pixels[loc];
      float actR = red(colorActual);
      float actG = green(colorActual);
      float actB = blue(colorActual);
      
      //Comparamos con los colores detectados en A con distancia Euclidiana
      float dA = dist(actR, actG, actB, aTrackR, aTrackG, aTrackB);
      float dB = dist(actR, actG, actB, bTrackR, bTrackG, bTrackB);      
      
      if (dA < worldRecord1) {
        worldRecord1 = dA;
        closestX1 = x;
        closestY1 = y;
      }
      if (dB < worldRecord2) {
        worldRecord2 = dB;
        closestX2 = x;
        closestY2 = y;
      }
    }
  }
  
  if (worldRecord1 < 10) { 
    // Draw a circle at the tracked pixel
    fill(trackColorA);
    strokeWeight(4.0);
    stroke(0);
    ellipse(closestX1,closestY1,20,20);
    posXInicialA = closestX1;
  }
  
  if (worldRecord2 < 10) { 
    // Draw a circle at the tracked pixel
    fill(trackColorB);
    strokeWeight(4.0);
    stroke(0);
    ellipse(closestX2,closestY2,20,20);
    posXInicialB = closestX2;
  }
}

boolean polloAtrapado(Pollo pollo, Nido nido){
  int polloPosMinX, polloPosMaxX;
  int nidoPosMinX, nidoPosMaxX;
  
  polloPosMinX = pollo.getPosX();
  polloPosMaxX = pollo.getPosX() + pollo.getImgPollo().width;

  nidoPosMinX = nido.getPosX();
  nidoPosMaxX = nido.getPosX() + nido.getImgNido().width;
  
  if((polloPosMaxX >= nidoPosMinX) || (polloPosMinX <= nidoPosMaxX)){
    return true;
  }else{
    return false;
  }
  
}
