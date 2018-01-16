import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import processing.sound.*;
import processing.video.*; //load the video library

Capture cam; // create a camera
PVector [] massCoor = {new PVector (0, 0), new PVector (0, 0)}; // Cool mass detection stuff
PImage hiddenImage;

//ArrayList for images
Animator enemyBackLine;
Animator enemyFrontLine;

Spaceship spaceship; //the class object for the main spaceship
boolean keyDown = false;
boolean mouseDown = false;
ArrayList <mainProjectile> yourBullets;
ArrayList <Alien> aliens;
ArrayList <Wall> walls;
Timer moveTimer;
Timer alienShotTimer;
String gameState = "menu";

//Menu variables
ImageButton playButton;
int instructionsIndex = 0;
String [] instructions = { "Move around the red sensor", "to control the position of the ship.",
"Cover the sensor with your hand", "to fire bullets at the aliens.",
"Clear the skies to win.", "Don't let them get you!",
"Move cursor inside of box and", "cover the cursor to calibrate!"};

//Global variables for tween
PFont spaceAgeFont;
float livesRotationAngle = 0.0;
PImage gameBackground;
PImage menuBackground;
ArrayList <Stars> stars;
Timer starTimer;
float textAlpha = 255;
Alien cursor;
Minim minim;
AudioPlayer loopedMusic;
SoundFile gunSound;
SoundFile explosion;
SoundFile appear;

//Global variables for game functionality
float movesPerSecond = 0.5;
float xMove = width/3;
int randomShot = 20;
final int maxRandomShot = 20;
final float minMovesPerSecond = 0.5;
boolean justMoved = false;

//Main character attributes
Timer shotTimer;
float shotsPerSecond = 1.0;
int lives = 3;
PImage livesImage;
int score = 0;

void setup(){
  //display stuff and initializations
  size(640, 480);
  imageMode(CENTER);
  hiddenImage = get();
  spaceAgeFont = createFont("../data/Fonts/space.ttf", 20);
  textFont(spaceAgeFont);
  starTimer = new Timer();
  starTimer.startTimer();
  livesImage = loadImage("../data/Spaceship_art_pack_larger/Blue/mothership_blue.png");
  gameBackground = loadImage("../data/Spaceship_art_pack_larger/Background/background.jpg");
  menuBackground = loadImage("../data/Spaceship_art_pack_larger/Background/menuBackground.jpg");
  
  //sound
  minim = new Minim(this);
  loopedMusic = minim.loadFile("../data/Sounds/Rameses_B-Nova.mp3");
  gunSound = new SoundFile(this, sketchPath("../data/Sounds/gun.mp3"));
  explosion = new SoundFile(this, sketchPath("../data/Sounds/ex2.wav"));
  explosion.amp(1.2);
  appear = new SoundFile(this, sketchPath("../data/Sounds/app.wav"));
  appear.play();
  loopedMusic.loop();
  
  //image loading
  enemyBackLine = new Animator();
  enemyBackLine.addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/1.png");
  enemyBackLine.addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/2.png");
  enemyBackLine.addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/3.png");
  enemyBackLine.addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/4.png");
  enemyBackLine.addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/5.png");
  enemyBackLine.addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/6.png");
  enemyBackLine.addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/7.png");
  enemyBackLine.addSlide("../data/Spaceship_art_pack_larger/Red/Enemy_animation/8.png");
  
  enemyFrontLine = new Animator();
  enemyFrontLine.addSlide("../data/Spaceship_art_pack_larger/Red/small_ship_Animation/1.png");
  enemyFrontLine.addSlide("../data/Spaceship_art_pack_larger/Red/small_ship_Animation/2.png");
  enemyFrontLine.addSlide("../data/Spaceship_art_pack_larger/Red/small_ship_Animation/3.png");
  enemyFrontLine.addSlide("../data/Spaceship_art_pack_larger/Red/small_ship_Animation/4.png");
  enemyFrontLine.addSlide("../data/Spaceship_art_pack_larger/Red/small_ship_Animation/5.png");
  
  //initialize the cameras
  String[] cameras = Capture.list();
  
  //load the camera
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();   
  }
  
  //menu
  playButton = new ImageButton("../data/Spaceship_art_pack_larger/Menu Screen/play_buttons_pressed_blue.png", int(width/2), height/2, int(width*0.2), int(height*0.2));
  cursor = new Alien(0, 0, 30, 30);
  
  //Game functionalities
  moveTimer = new Timer();
  moveTimer.startTimer();
  alienShotTimer = new Timer();
  alienShotTimer.startTimer();
  stars = new ArrayList<Stars>();
  
  //set up the main character. Create bullet array and load the sprites
  yourBullets = new ArrayList <mainProjectile>();
  shotTimer = new Timer();
  shotTimer.startTimer();
  walls = new ArrayList <Wall>();
  
  //setup the walls
  wallUp();
  
  spaceship = new Spaceship(width/2, int(height*0.9));
  
  //set up the aliens
  aliens = new ArrayList <Alien>();
  spawn();
}

void draw(){
  fill(0, 80);
  rect(0, 0, width, height);
  if(gameState == "menu"){
    image(menuBackground, width/2, height/2, width, height);
    textAlign(CENTER);
    textSize(45);
    fill(25, 191, 192);
    text("Space Invaders", width/2, height*0.1);
    
    //menu buttons
    playButton.display();
  }else if(gameState == "calibrate"){
    image(menuBackground, width/2, height/2, width, height);
    textSize(24);
    fill(25, 191, 192, abs(textAlpha));
    textAlpha -= 2;
    if(textAlpha <= -255){
      textAlpha = 255;
    }else if(textAlpha < 5 && textAlpha > -5){
      textAlpha = -5;
      instructionsIndex += 2;
      if(instructionsIndex >= 8){
        instructionsIndex = 0;
      }
    }
    text(instructions[instructionsIndex], width/2, height*0.1);
    text(instructions[instructionsIndex + 1], width/2, height*0.2);
    
    fill(0, 80);
    rect(width*0.4, height*0.4, width*0.2, height*0.2);
    
    //draw the cursor
    detectRed();
    fill(255, 0, 0);
    cursor.destination.x = width - lerp(massCoor[0].x, massCoor[1].x, 0.5);
    cursor.destination.y = lerp(massCoor[0].y, massCoor[1].y, 0.5);
    cursor.display();
    spaceship.display();
    
  }else if(gameState == "over"){
    image(menuBackground, width/2, height/2, width, height);
    textAlign(CENTER);
    textSize(45);
    fill(25, 191, 192);
    text("Game Over!", width/2, height*0.1);
    text("Score: " + score, width/2, height*0.5);
    playButton.position.y = height*0.8;
    playButton.display();
  }else if(gameState == "game"){
    tint(255, 80);
    image(gameBackground, width/2, height/2, width, height);
    shootDown();
    fill(25, 191, 192);
    tint(255);
    
    if(starTimer.getTime() > 2500){
      starTimer.startTimer();
      stars.add(new Stars(random(0, width), 0, 2, 2));
      stars.get(stars.size() - 1).setVelocity(0, 0.5);
    }
    
    //All of the Camera Stuff
    detectRed();
    
    //Display the stars under evertything
    if(stars.size() > 0){
      for(int i = 0; i < stars.size(); i++){
        stars.get(i).display();
      }
    }
    
    //Display the text during the game
    fill(25, 191, 192);
    textAlign(LEFT);
    text("Lives :", width*0.1, height*0.05);
    livesRotationAngle += 2.0;
    if(livesRotationAngle >= 360){
      livesRotationAngle -= 360;
    }
    for(int i = 0; i < lives; i++){
      pushMatrix();
      translate(width*0.1 + textWidth("Lives :") + ((i + 1)*width*0.05), height*0.03);
      image(livesImage, 0, 0, height*0.1, height*0.1);
      popMatrix();
    }
    textAlign(RIGHT);
    text("Score : " + score, width*0.9, height*0.05);
    
    //Aliens controls
    if(moveTimer.getTime() > 1000/movesPerSecond){
      if(aliens.size() > 0){
        moveTimer.startTimer();
        int movedDown = 1;
        for(int i = 0; i < aliens.size(); i++){
          if((aliens.get(i).position.x + aliens.get(i).xShift >= width*0.9 || aliens.get(i).position.x + aliens.get(i).xShift <= width*0.1) && !justMoved){
            xMove *= -1;
            for(int j = 0; j < aliens.size(); j++){
              aliens.get(j).destination.y += abs(xMove);
              movedDown = 2;
              justMoved = true;
              if(aliens.get(j).position.y > height*0.9){
                j = aliens.size();
                gameState = "over";
              }
            }
            i = aliens.size();
          }
        }
        if(movedDown == 1){
          justMoved = false;
        }
        for(int i = 0; i < aliens.size(); i++){
          aliens.get(i).destination.x += xMove*movedDown;
        }
      }
    }
    
    if(aliens.size() > 0){
      if(alienShotTimer.getTime() > 200){
        if(int(random(0, randomShot + 1)) == randomShot){
          int shootingAlienIndex = int(random(0, aliens.size()));
          while(!aliens.get(shootingAlienIndex).bottom){
            shootingAlienIndex = int(random(0, aliens.size()));
          }
          aliens.get(shootingAlienIndex).shoot();
          randomShot = 30;
        }else{
          randomShot -= 1;
        }
        alienShotTimer.startTimer();
      }
    }
    
    //player controls
    if(mouseDown){
      spaceship.destination = mouseX;
    }
    spaceship.display();
    if(aliens.size() > 0){
      for(int i = 0; i < aliens.size(); i++){
        aliens.get(i).display();
      }
    }
    
    if(walls.size() > 0){
      for(int i = 0; i < walls.size(); i++){
        walls.get(i).display();
      }
    }
    
    if(yourBullets.size() > 0){
      for(int i = 0; i < yourBullets.size(); i++){
        if((yourBullets.get(i).position.x < 0 || yourBullets.get(i).position.x > width || yourBullets.get(i).position.y < 0 || yourBullets.get(i).position.y > height)){
          yourBullets.remove(i);
        }else{
          yourBullets.get(i).display();
        }
      }
    }
  }
}

void wallUp(){
  walls.add(new Wall(int(width*0.20), int(height*0.75), int(width*0.1), int(height*0.1)));
  walls.add(new Wall(int(width*0.50), int(height*0.75), int(width*0.1), int(height*0.1)));
  walls.add(new Wall(int(width*0.80), int(height*0.75), int(width*0.1), int(height*0.1)));
}

void detectRed(){ // this function detects all of the red on the screen (The REAL Magic)
  if(cam.available() == true){
     cam.read();
  }
    
  for(int i = 0; i < height; i++){
    for(int j = 0; j < width; j++){
      if(red(cam.get(j, i)) > 180 && green(cam.get(j, i)) < 100 && blue(cam.get(j, i)) < 100){
        hiddenImage.set(j, i, color(255));
      }else{
        hiddenImage.set(j, i, color(0));
      }
    }
  }
  
  for(int i = 0; i < height; i++){
    for(int j = 0; j < width; j++){
      if(hiddenImage.get(j, i) == color(255)){
        massCoor[0] = new PVector(j, i);
        j = width;
        i = height;
      }else{
        if(i == height - 1 && j == width - 1){
          if(gameState == "calibrate" && !(width - lerp(massCoor[0].x, massCoor[1].x, 0.5) < width*0.4 || width - lerp(massCoor[0].x, massCoor[1].x, 0.5) > width*0.6 || lerp(massCoor[0].y, massCoor[1].y, 0.5) < height*0.4 || lerp(massCoor[0].y, massCoor[1].y, 0.5) > height*0.6)){
            gameState = "game";
            shoot();
          }else if(gameState == "game"){
            shoot();
          }
        }else{
          keyDown = false;
        }
      }
    }
  }
  
  for(int i = height; i > -1; i--){
    for(int j = width; j > -1; j--){
      if(hiddenImage.get(j, i) == color(255)){
        massCoor[1] = new PVector(j, i);
        j = -1;
        i = -1;
      }
    }
  }
  
  spaceship.destination = int(width - lerp(massCoor[0].x, massCoor[1].x, 0.5));
}

void spawn(){
  for(int i = 0; i < 6; i++){
    for(int j = 0; j < 6; j++){
      if(j > 3){
        aliens.add(new Alien (width/2 + int((width*0.06)*(i - 4)), int(height*0.1) + int((height*0.05)*j), 30, 30, enemyFrontLine));
      }else{
        aliens.add(new Alien (width/2 + int((width*0.06)*(i - 4)), int(height*0.1) + int((height*0.05)*j), 30, 30, enemyBackLine));
      }
      aliens.get(aliens.size() - 1).destination.x = width/2 + int((width*0.06)*(i - 4));
      aliens.get(aliens.size() - 1).destination.y = int(height*0.1) + int((height*0.05)*j);
      if(j == 5){
        aliens.get(aliens.size() - 1).bottom = true;
      }
    }
  }
}

void shootDown(){ //projectile collision
  //player to alien/barrier
   for(int i = 0; i < yourBullets.size(); i++){
     for(int j = 0; j < aliens.size(); j++){
       if(yourBullets.size() > 0 && aliens.size() > 0){
         if(i < yourBullets.size()){
           if(yourBullets.get(i).hit(aliens.get(j))){
             yourBullets.remove(i);
             if(aliens.size() > 1 && j != 0 && aliens.get(j).bottom){
               aliens.get(j - 1).bottom = true;
             }
             aliens.remove(j);
             explosion.play();
             score += 10;
             
             if(aliens.size() <= 0){
               spawn();
               if(movesPerSecond < 2.0){
                 movesPerSecond += 0.5;
               }
               if(randomShot > 5){
                 randomShot -= 8;
               }
               /*if(shotsPerSecond < 2.0){
                 shotsPerSecond += 0.2;
               }*/
             }
           }else{
             for(int k = 0; k < walls.size(); k++){
              if(i < yourBullets.size()){
                if(yourBullets.get(i).hit(walls.get(k))){
                  yourBullets.remove(i);
                  walls.get(k).lives(1);
                  if(walls.get(k).lives < 0){
                    walls.remove(k);
                  }
                }
              }
             }
           }
         }
       }
     }
   }
   //alien to player/barrier
   if(aliens.size() > 0){
    for(int i = 0; i < aliens.size(); i++){
      for(int j = 0; j < aliens.get(i).projectiles.size(); j++){
        if(aliens.get(i).projectiles.get(j).hit(spaceship)){
          if(spaceshipDetection(aliens.get(i).projectiles.get(j))){
            lives -= 1;
            aliens.get(i).projectiles.remove(j);
              if(lives <= 0){
                gameState = "over";
              }
            }
        }else{
          for(int k = 0; k < walls.size(); k++){
            if(j < aliens.get(i).projectiles.size()){
              if(aliens.get(i).projectiles.get(j).hit(walls.get(k))){
                aliens.get(i).projectiles.remove(j);
                walls.get(k).lives(1);
                if(walls.get(k).lives <= 0){
                  walls.remove(k);
                }
              }
            }
          }
        }
      }
    }
  }
}

void shoot(){
  if(!keyDown){
    keyDown = true;
    if(shotTimer.getTime() > 1000/shotsPerSecond){
      shotTimer.startTimer();
      gunSound.play();
      yourBullets.add(new mainProjectile(int(spaceship.position.x), int(spaceship.position.y - (spaceship.dimensions.y/2)), 10, 20 ));
      yourBullets.get(yourBullets.size() - 1).setVelocity(0, -5.0);
    }
  }
}

void mousePressed(){
  if(!mouseDown){
    mouseDown = true;
    if(gameState == "menu" || gameState == "over"){
      if(playButton.hover){
        if(gameState == "over"){
          randomShot = maxRandomShot;
          movesPerSecond = minMovesPerSecond;
          score = 0;
          lives = 3;
          shotsPerSecond = 1;
          aliens.clear();
          walls.clear();
          spawn();
          wallUp();
        }
        stroke(0);
        strokeWeight(1);
        gameState = "calibrate";
        textSize(20);
      }
    }
  }
}

void mouseReleased(){
  mouseDown = false;
}

void keyPressed(){
  shoot();
}

void keyReleased(){
  keyDown = false;
}