/* Clase Jugador para manejar todos los eventos que tengan que
  ver con un jugador. */
class Jugador{
  private int puntos;
  
  Jugador(){
    setPuntos(0);
  }
  
  // Getters
  public int getPuntos(){
    return (this.puntos);
  }
  
  // Setters
  public void setPuntos(int puntos){
    this.puntos = puntos;
  }
}
