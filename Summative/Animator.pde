class Animator{
  float fps = 60;
  ArrayList <PImage> sprites;
  int index = 0;
  Timer timer;
  
  Animator(){
    sprites = new ArrayList <PImage>();
    timer = new Timer();
    timer.startTimer();
  }
  
  void addSlide(String fullFilePath){
    sprites.add(loadImage(fullFilePath));
  }
  
  void deleteSlide(int index){
    sprites.remove(index);
  }
  
  void display(float positionX, float positionY, PVector dimensions){
    if(timer.getTime() > 1000/fps){
      timer.startTimer();
      index++;
      if(index >= sprites.size()){
        index = 0;
      }
    }
    if(sprites.size() > 0){
      image(sprites.get(index), positionX, positionY, dimensions.x, dimensions.y);
    }
  }
}