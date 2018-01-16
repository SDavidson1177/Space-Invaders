class Object{
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector dimensions;
  Animator animation;
  
  Object(int x, int y){
    position = new PVector (x, y);
    velocity = new PVector (0, 0);
    acceleration = new PVector (0, 0);
    animation = new Animator();
    dimensions = new PVector(100, 100);
  }
  
  Object(int x, int y, Animator inputAnimation){
    position = new PVector (x, y);
    velocity = new PVector (0, 0);
    acceleration = new PVector (0, 0);
    animation = new Animator();
    animation = inputAnimation;
    dimensions = new PVector(100, 100);
  }
  
  Object(int x, int y, int w, int h){
    position = new PVector (x, y);
    velocity = new PVector (0, 0);
    acceleration = new PVector (0, 0);
    animation = new Animator();
    dimensions = new PVector(w, h);
  }
  
  Object(int x, int y, int w, int h, Animator inputAnimation){
    position = new PVector (x, y);
    velocity = new PVector (0, 0);
    acceleration = new PVector (0, 0);
    animation = new Animator();
    animation = inputAnimation;
    dimensions = new PVector(w, h);
  }
  
  void addSlide(String fullFilePath){
    animation.addSlide(fullFilePath);
  }
  
  void display(){
    velocity.add(acceleration);
    position.add(velocity);
    animation.display(position.x, position.y, dimensions);
  }
}