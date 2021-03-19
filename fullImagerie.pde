import processing.video.*;

Capture cam;

void setup() {
  size(640, 480);

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    
    //colorMode(HSB, 360, 100, 100);
    cam = new Capture(this, cameras[0]);
    cam.start();     
  }      
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
  
  loadPixels();
  cam.filter(GRAY);
  
  PImage res = results();
  
 
  
  updatePixels();
  image(res, 0, 0);
}

PImage gradientVertical(){
  PImage gradient = createImage(width, height, GRAY);
  
    for (int i=0; i<cam.height; i++){      
      for (int j=1; j<cam.width; j++){
    
      int loc = j + i*width;
      
       float r = red(cam.pixels[loc]);
       float g = green(cam.pixels[loc]);
       float b = blue(cam.pixels[loc]);
       float r_1 = red(cam.pixels[loc-1]);
       float g_1 = green(cam.pixels[loc-1]);
       float b_1 = blue(cam.pixels[loc-1]);
      //float colo = gray(cam.pixels[loc]);
      
      // Image Processing would go here

      // Set the display pixel to the image pixel
      // println(color(cam.pixels[loc]));    
       //println(r + " " + g + " " + b);
      
      //cam.pixels[loc] = color();
      
      gradient.pixels[loc] = color(r - r_1, g - g_1, b - b_1);   
    }
  }  
  return gradient;
}

PImage gradientHorizontal(){
  PImage gradient = createImage(width, height, GRAY);
  
  for (int i = 0; i<cam.height; i++){
    int iP = i * width;
    for (int j=0; j<cam.width; j++){
      int jP = j + iP;
       
       if (i -1 >= 0){
         float r = red(cam.pixels[jP]) - red(cam.pixels[(i-1)*width+j]);
         
         gradient.pixels[jP] = color(r,r,r);
     }   
    }
  }
  
  return gradient;
}

PImage results(){
  PImage gradVert = gradientVertical();
  PImage gradHor = gradientHorizontal();
  PImage res = createImage(width, height, GRAY);
  
  for (int i=0; i<height; i++){
    for (int j=0; j<width; j++){
      int k = j + i*width;
      float s = red(gradVert.pixels[k] + gradHor.pixels[k]);
      res.pixels[k] = color(s,s,s);
           
      if (red(res.pixels[k]) >= 20){
        res.pixels[k] = color(255, 255, 255);
      }
      else
      {
        res.pixels[k] = color(0,0,0);
      }
    }
  }
  return res;
}

/*Pimage convolution(int masque[][]){
  PImage result = createImage(width, height, RGB);
  
}*/
