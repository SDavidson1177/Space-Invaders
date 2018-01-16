class Characters extends Object{
  Characters(int x, int y){
    super(x, y);
  }
  
  Characters(int x, int y, Animator animator){
    super(x, y, animator);
  }
  
  Characters(int x, int y, int w, int h){
    super(x, y, w, h);
  }
  
  Characters(int x, int y, int w, int h, Animator animation){
    super(x, y, w, h, animation);
  }
}

class Wall extends Characters{
  float lives;
  float maxLives = 10;
  float lifesAlpha = 0;
  Wall(int x, int y, int w, int h){
    super(x, y, w, h);
    animation.fps = 30;
    lives = maxLives;
    addSlide("../data/Spaceship_art_pack_larger/Blue/Spacebombs/1.png");
    addSlide("../data/Spaceship_art_pack_larger/Blue/Spacebombs/2.png");
    addSlide("../data/Spaceship_art_pack_larger/Blue/Spacebombs/3.png");
  }
  
  void lives(int subtract){
    lives -= subtract;
    lifesAlpha = 300;
  }
  
  void display(){
    super.display();
    if(lifesAlpha > 0){
      lifesAlpha -= 2;
    }else if(lifesAlpha < 0){
      lifesAlpha = 0;
    }
    stroke(0, 255, 0, lifesAlpha);
    strokeWeight(4);
    line(position.x - dimensions.x/2, position.y - (dimensions.y*0.55), (position.x - dimensions.x/2) + (dimensions.x*(lives/maxLives)), position.y - (dimensions.y*0.55));
    noStroke();
  }
}

class Spaceship extends Characters{
  int destination;
  int lives = 3;
  Spaceship(int x, int y){
    super(x, y);
    destination = x;
    addSlide("C:/Users/Levi/Documents/Processing/Projects/Summative/data/Spaceship_art_pack_larger/Blue/Animation/1.png");
    addSlide("C:/Users/Levi/Documents/Processing/Projects/Summative/data/Spaceship_art_pack_larger/Blue/Animation/2.png");
    addSlide("C:/Users/Levi/Documents/Processing/Projects/Summative/data/Spaceship_art_pack_larger/Blue/Animation/3.png");
    addSlide("C:/Users/Levi/Documents/Processing/Projects/Summative/data/Spaceship_art_pack_larger/Blue/Animation/4.png");
    addSlide("C:/Users/Levi/Documents/Processing/Projects/Summative/data/Spaceship_art_pack_larger/Blue/Animation/5.png");
    addSlide("C:/Users/Levi/Documents/Processing/Projects/Summative/data/Spaceship_art_pack_larger/Blue/Animation/6.png");
    addSlide("C:/Users/Levi/Documents/Processing/Projects/Summative/data/Spaceship_art_pack_larger/Blue/Animation/7.png");
    addSlide("C:/Users/Levi/Documents/Processing/Projects/Summative/data/Spaceship_art_pack_larger/Blue/Animation/8.png");
  }
  
  void display(){
    velocity.add(acceleration);
    position.x += (destination - position.x)*0.05;
    animation.display(position.x, position.y, dimensions);
  }
}

class Alien extends Characters{
  PVector destination;
  ArrayList <mainProjectile> projectiles = new ArrayList <mainProjectile>();
  int xShift = 0;
  int yShift = 0;
  int style = 1;
  boolean bottom = false;
    Alien(int x, int y){
      super(x, y);
      destination = new PVector(0, 0);
        addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/1.png");
        addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/2.png");
        addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/3.png");
        addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/4.png");
        addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/5.png");
        addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/6.png");
        addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/7.png");
        addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/8.png");
    }
    
    Alien(int x, int y, Animator animator){
      super(x, y, animator);
    }
    
    Alien(int x, int y, int w, int h){
      super(x, y);
      destination = new PVector(0, 0);
      dimensions.x = w;
      dimensions.y = h;
      addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/1.png");
      addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/2.png");
      addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/3.png");
      addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/4.png");
      addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/5.png");
      addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/6.png");
      addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/7.png");
      addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/8.png");
    }
    
    Alien(int x, int y, int w, int h, Animator animation){
      super(x, y, w, h, animation);
      destination = new PVector(0, 0);
      dimensions.x = w;
      dimensions.y = h;
    }
    
   void style(int style){
      animation.sprites.clear();
      if(style == 1){
        addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/1.png");
        addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/2.png");
        addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/3.png");
        addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/4.png");
        addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/5.png");
        addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/6.png");
        addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/7.png");
        addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/8.png");
      }else if(style == 2){
        addSlide("../data/Spaceship_art_pack_larger/Red/small_ship_Animation/1.png");
        addSlide("../data/Spaceship_art_pack_larger/Red/small_ship_Animation/2.png");
        addSlide("../data/Spaceship_art_pack_larger/Red/small_ship_Animation/3.png");
        addSlide("../data/Spaceship_art_pack_larger/Red/small_ship_Animation/4.png");
        addSlide("../data/Spaceship_art_pack_larger/Red/small_ship_Animation/5.png");
      }
   }
    
   void shoot(){
     projectiles.add(new mainProjectile(int(position.x), int(position.y), 10, 10));
     projectiles.get(projectiles.size() - 1).setVelocity(0, 5.0);
     projectiles.get(projectiles.size() - 1).setSlide("../data/Spaceship_art_pack_larger/Red/bullet_red.png");
   } 
    
  void display(){
    velocity.add(acceleration);
    position.x += (destination.x - position.x)*0.05;
    position.y += (destination.y - position.y)*0.05;
    if(projectiles.size() > 0){
      for(int i = 0; i < projectiles.size(); i++){
        if(projectiles.get(i).position.y > height + 20){
          projectiles.remove(i);
        }else{
          projectiles.get(i).display();
        }
      }
    }
    animation.display(position.x + xShift, position.y + yShift, dimensions);
  }
}