class Pollo{
  private PImage imgPollo;
  private int limiteMinX;
  private int limiteMaxX;
  private int posX;
  private int posY;
  
  Pollo(){
    // constructor vacio
  }
  
  Pollo(PImage imgPollo, int limiteMinX, int limiteMaxX){
    this();
    setImgPollo(imgPollo);
    setLimiteMinX(limiteMinX);
    setLimiteMaxX(limiteMaxX);
    setPosX((int)random(limiteMinX, limiteMaxX));
    setPosY(0);
  }
  
  // Getters
  public PImage getImgPollo(){
    return (this.imgPollo);    
  }
  
  public int getLimiteMinX(){
    return (this.limiteMinX);
  }
  
  public int getLimiteMaxX(){
    return (this.limiteMaxX);
  }
  
  public int getPosX(){
    return (this.posX);
  }
  
  public int getPosY(){
    return (this.posY);
  }
  
  // Setters
  public void setImgPollo(PImage imgPollo){
    this.imgPollo = imgPollo;
  }
  
  public void setLimiteMinX(int limiteMinX){
    this.limiteMinX = limiteMinX;
  }
  
  public void setLimiteMaxX(int limiteMaxX){
    this.limiteMaxX = limiteMaxX;
  }
  
  public void setPosX(int posX){
    this.posX = posX;
  }
  
  public void setPosY(int posY){
    this.posY = posY;
  }
  
  // Medodos adicionales
  public void dibujarPollo(){
    pushMatrix();
      image(getImgPollo(), getPosX(), getPosY());
    popMatrix();
  }
}
