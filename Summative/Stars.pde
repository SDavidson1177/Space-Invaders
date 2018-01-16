class Stars{
  float w, h;
  float x, y;
  PVector velocity;
  PVector acceleration;
  
  
  Stars(float xx, float yy, float ww, float hh){
    x = xx;
    y = yy;
    velocity = new PVector(0, 3);
    acceleration = new PVector(0, 0);
    
    w = ww;
    h = hh;
  }
  
  void setVelocity(float xx, float yy){
    velocity.x = xx;
    velocity.y = yy;
  }
  
  void display(){
    x += velocity.x;
    y += velocity.y; 
    
    fill(255);
    ellipse(x, y, w, h);
  }
}