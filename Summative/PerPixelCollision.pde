boolean perPixel(Projectile proj, Characters character){ // I will only do per pixel between the enemie projectiles and the player because thats only when it matters (Does not work correctly though)
  boolean collides = false;
  //println(character.position.);
  //println(int(character.position.x - character.dimensions.x/2) + int((character.dimensions.x/2) - character.position.x) + ", " + (int(character.position.x + character.dimensions.x/2) + int((character.dimensions.x/2) - character.position.x)));
    for(int i = int(character.position.y - character.dimensions.y/2); i < int(character.position.y + character.dimensions.y/2); i++){
      for(int j = int(character.position.x - character.dimensions.x/2); j < int(character.position.x + character.dimensions.x/2); j++){
        if(alpha(character.animation.sprites.get(0).get(int(j + (character.dimensions.x/2) - character.position.x), int(i + (character.dimensions.y/2) - character.position.y))) != 0.0){
          println("in");
           if(dist(proj.position.x, proj.position.y, j, i) < 20){
            collides = true;
            i = int(character.position.y + character.dimensions.y/2);
            j = int(character.position.x + character.dimensions.x/2);
          }
        }
      }  
  }
  return collides;
}

boolean spaceshipDetection(Projectile proj){ //hit detection specific for spaceship (more efficient but less effective alternative to per pixel)
  boolean collides = false;
  if(!(proj.position.x + proj.dimensions.x/2 < spaceship.position.x - spaceship.dimensions.x*0.18 || proj.position.x - proj.dimensions.x/2 > spaceship.position.x + spaceship.dimensions.x*0.18)){
    collides = true;
  } 
  if(!collides){
    if(!(proj.position.y + proj.dimensions.y/2 < spaceship.position.y || proj.position.y - proj.dimensions.y/2 > spaceship.position.y + spaceship.dimensions.y*0.4)){
      collides = true;
    }
  }
  return collides;
}