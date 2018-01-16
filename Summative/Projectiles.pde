class Projectile extends Object{
  Timer speed = new Timer();
  int updatesPerSeconds;
  
  Projectile(int x, int y){
    super(x, y);
    speed.startTimer();
    updatesPerSeconds = 60;
  }
  
  Projectile(int x, int y, int w, int h){
    super(x, y, w, h);
    speed.startTimer();
    updatesPerSeconds = 60;
  }
  
  boolean hit(Characters c){
    boolean res = false;
    if(!(position.x + (dimensions.x/2) < c.position.x - c.dimensions.x/2 || position.x - (dimensions.x/2) > c.position.x + c.dimensions.x/2 || position.y + (dimensions.y/2) < c.position.y - c.dimensions.y/2 || position.y - (dimensions.y/2) > c.position.y + c.dimensions.y/2)){
      res = true;
    }
    return res;
  }
  
  void setVelocity(float x, float y){
    velocity.x = x;
    velocity.y = y;
  }
  
  void display(){
    if(speed.getTime() > 1000/updatesPerSeconds){
    velocity.add(acceleration);
    position.add(velocity);
    animation.display(position.x, position.y, dimensions);
    }
  }
}

class mainProjectile extends Projectile{
  mainProjectile(int x, int y){
    super(x, y);
    setVelocity(0, -3.0);
    addSlide("C:/Users/Levi/Documents/Processing/Projects/Summative/data/Spaceship_art_pack_larger/Blue/bullet.png");
  }
  
  mainProjectile(int x, int y, int w, int h){
    super(x, y, w, h);
    setVelocity(0, -3.0);
    addSlide("C:/Users/Levi/Documents/Processing/Projects/Summative/data/Spaceship_art_pack_larger/Blue/bullet.png");
  }
  
  void setSlide(String filepath){
    animation.sprites.clear();
    addSlide(filepath);
  }
}