class Timer{
  float startTime;
  boolean state = false;
  
  Timer(){
    startTime = 0.0f;
  }
  
  void startTimer(){
    startTime = millis();
    state = true;
  }
  
  void stopTimer(){
    state = false;
  }
  
  float getTime(){ //get the amount of time in milliseconds since the timer has started
    float x = millis() - startTime;
    if(!state){
      x = 0.0f;
    }
    return x;
  }
}