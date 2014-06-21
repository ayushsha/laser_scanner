

import processing.video.*;


Capture cam;

PrintWriter output;

float x, y, z=0, rho, angle=(3.14*20)/180, fi=0, inc=(12*3.14)/1260;

int i=0;
color black=color(0);
color white=color(255);


int row;
int col;

float pixBright;
float maxBright=0;
int maxBrightPos=0;


void setup() 
{ 
  size(640, 480);
  smooth();

  cam = new Capture(this, 640, 480, "Logitech HD Webcam C270", 30);
  cam.start(); 
  
  output=createWriter("scan.asc");

} 

void draw() 
{ 
  image(cam, 0, 0);
} 

void captureEvent(Capture c) 
{
  c.read();
  saveFrame("data/screen-"+nf(i, 3)+".jpg");
  i++;
  if (i>230)
  {
    points();
    plot();
    output.close();
    noLoop();
  }
}


void points()
{
  for (i=6;i<216;i++)
  {
    PImage scan=loadImage("data/screen-"+nf(i, 3)+".jpg");
    String str1="result-"+nf(i, 3)+".png";
    PImage result=createImage(cam.width, cam.height, RGB);
    scan.loadPixels();
    result.loadPixels();
    int currentPos;
    for (row=0; row<scan.height; row++) 
    {
      maxBrightPos=0;
      maxBright=0;
      for (col=0; col<scan.width; col++) 
      {
        currentPos = row * scan.width + col;
        pixBright=brightness(scan.pixels[currentPos]);
        if (pixBright>maxBright) 
        {
          maxBright=pixBright;
          maxBrightPos=currentPos;
        }
        result.pixels[currentPos]=black;
      }
      result.pixels[maxBrightPos]=white;
    }
    result.updatePixels();
    result.save(str1);
  }
}


void plot()
{
  for (i=6;i<216;i++)
  {
    String str1="result-"+nf(i, 3)+".png";
    PImage scan=loadImage(str1);
    scan.loadPixels();
    int currentPos;
    for (row=0; row<scan.height; row++)
    {
      for (col=0; col<scan.width; col++)
      {
        currentPos = row * scan.width + col;
        if (scan.pixels[currentPos]==white && col>300)
        {
          fi=(3.14*(i-6)*12)/1260;
          rho=col-320;
          rho=rho/sin(angle);
          x=rho*cos(fi);
          y=rho*sin(fi);
          z=row;
          output.println(x+","+y+","+z);
        }
      }
    }
    output.flush();
  }
}

