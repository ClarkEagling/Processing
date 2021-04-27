int[][] result;
float t, c;

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p < 0.5) 
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

float mn = .5*sqrt(3), ia = atan(sqrt(.5));

void push() {
  pushMatrix();
  pushStyle();
}

void pop() {
  popStyle();
  popMatrix();
}

void draw() {

  if (!recording) {
    t = mouseX*1.0/width;
    c = mouseY*1.0/height;
    if (mousePressed)
      println(c);
    draw_();
  } else {
    for (int i=0; i<width*height; i++)
      for (int a=0; a<3; a++)
        result[i][a] = 0;

    c = 0;
    for (int sa=0; sa<samplesPerFrame; sa++) {
      t = map(frameCount-1 + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
      draw_();
      loadPixels();
      for (int i=0; i<pixels.length; i++) {
        result[i][0] += pixels[i] >> 16 & 0xff;
        result[i][1] += pixels[i] >> 8 & 0xff;
        result[i][2] += pixels[i] & 0xff;
      }
    }

    loadPixels();
    for (int i=0; i<pixels.length; i++)
      pixels[i] = 0xff << 24 | 
        int(result[i][0]*1.0/samplesPerFrame) << 16 | 
        int(result[i][1]*1.0/samplesPerFrame) << 8 | 
        int(result[i][2]*1.0/samplesPerFrame);
    updatePixels();

    saveFrame("fr###.png");
    println(frameCount,"/",numFrames);
    if (frameCount==numFrames)
      exit();
  }
}

int n = 3000;
 
class Thing{
  float x = random(0, 128);
  float y = random(0, 256);
  float radius = random(2,15);
  float size = random(1,2.5);
  //float offset = random(0, TWO_PI);
  float offset = 9*noise(0.02*x, 0.02*y);
   
  void show(){
    stroke(153,153,0,200);
    strokeWeight(size);
    point(x + radius*cos(TWO_PI*t + offset), y + radius*sin(TWO_PI*t + offset));
  }
}
 
Thing[] array = new Thing[n];
 
//////////////////////////////////////////////////////////////////////
 
int samplesPerFrame = 5;
int numFrames = 100;        
float shutterAngle = 1.5;
 
boolean recording = false;
 
void setup(){
  size(128,256);
  result = new int[width*height][3];
    for(int i=0;i<n;i++){
    array[i] = new Thing();
    }
}
 
void draw_(){
  background(0);
 
  stroke(153, 51, 255);
  strokeWeight(5);
 
 // point(64+50*cos(TWO_PI*t),128+50*sin(TWO_PI*t));
  
arc(64, 128, 50, 50, 0, TWO_PI*t);
noFill();
arc(64, 128, 70, 70, HALF_PI, TWO_PI*t);
arc(64, 128, 90, 90, PI, PI+TWO_PI*t);
arc(64, 128, 110, 110, PI+QUARTER_PI, TWO_PI*t);
  
   
  for(int i=0;i<n;i++){
    array[i].show();
   
}
}
