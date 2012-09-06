class Timer {
 
  int savedTime; // Cuando empezo el Timer
  int totalTime; // Cuanto deberia durar el Timer
  
  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }
  
  // Inicia el timer
  void start() {
    // Cuando inicia el timer se almacenan los milisegundos
    savedTime = millis(); 
  }
  
  // The function isFinished() returns true if totalTime ms have passed. 
  // The work of the timer is farmed out to this method.
  boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    } else {
      return false;
    }
  }
  
  int getTiempoTranscurrido(){
    return (millis()- savedTime);
  }
  
  int getSegundosTranscurridos(){
    return ((millis()- savedTime) / 1000);
  }
  
  int getTiempoRestante(){
    int passedTime = millis()- savedTime;
    return (totalTime - passedTime);
  }
  
  int getSegundosRestantes(){
    return (getTiempoRestante() / 1000);
  }
}
