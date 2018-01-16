class ImageButton{
  PImage image;
  PVector position;
  PVector dimensions;
  boolean hover = false;
  
  ImageButton(String filePath, int x, int y, int w, int h){
    image = loadImage(filePath);
    position = new PVector(x, y);
    dimensions = new PVector(w, h);
  }
  
  void update(){
    if(!(mouseX < position.x - dimensions.x/2|| mouseX > position.x + dimensions.x/2 || mouseY < position.y - dimensions.y/2 || mouseY > position.y + dimensions.y/2)){
      hover = true;
    }else{
      hover = false;
    }
  }
  
  
  void display(){
    update();
    if(hover){
      tint(255);
    }else{
      tint(200);
    }
    image(image, position.x, position.y, dimensions.x, dimensions.y);
  }
}