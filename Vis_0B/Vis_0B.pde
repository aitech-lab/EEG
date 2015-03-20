/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;

OscP5 oscP5;

int p0[] = 
{0xFFC44D58
,0xFFFF6B6B
,0xFFC7F464
,0xFF4ECDC4
,0xFF556270
,0xFFECD078
,0xFFD95B43
,0xFFC02942
,0xFF542437
,0xFF53777A
,0xFF00A0B0
,0xFF6A4A3C
,0xFFCC333F
,0xFFEB6841
,0xFFEDC951};

String points[] = {"F3", "FC6", "P7", "T8", "F7", "F8", "T7", "P8", "AF4", "F4", "AF3", "O2", "O1", "FC5"};

int x = 0;

float atr1[] = new float[14];
float atr2[] = new float[14];

int clr = 0;
int stp = 0;


ArrayList<float[]> data = new ArrayList< float[] >();

void setup() {
  
  size(720,800,P3D);
  
  frameRate(30);

  oscP5 = new OscP5(this,"239.0.0.1",7777);
  background(0);
}

void draw() {
  
  noStroke();
  fill(0, 10);
  rect(0,0,width, height);
 

  pushMatrix();
  translate(width/2.0, height/2.0);
  
  while(data !=null && data.size()>0) {
    float d[] = data.remove(0);
    if(d==null) break;
    
    for(int i=0; i<d.length; i++) {
      float f = d[i];  
      atr1[i]+= (f-atr1[i])/50.0;
      atr2[i]+= (f-atr2[i])/100.0;
    }
    endShape(CLOSE);    
    
 
    fill(p0[3],50);
    beginShape();
    for(int j=0; j<=d.length+2; j++) {
      int i = j%d.length;
      float f = d[i];  

      float a = i*2.0*PI/14.0;
      
      float dy = (200+atr2[i]*width/3.0)*sin(a+stp/150.0);
      float dx = (200+atr2[i]*width/3.0)*cos(a+stp/150.0);      
      curveVertex(dx,dy);
    }
    endShape(CLOSE);  
 
 
    fill(p0[2],150);
    beginShape();
    for(int j=0; j<=d.length+2; j++) {
      int i = j%d.length;
      float f = d[i];  

      float a = i*2.0*PI/14.0;
      
      float dy = (150+atr1[i]*width/3.0)*sin(a+stp/150.0);
      float dx = (150+atr1[i]*width/3.0)*cos(a+stp/150.0);      
      curveVertex(dx,dy);
    }
    endShape(CLOSE);  

    
    fill(p0[1],200);
    beginShape();
    for(int j=0; j<=d.length+2; j++) {
      int i = j%d.length;
      float f = d[i];  

      float a = i*2.0*PI/14.0;
      
      float dy = (100+f*width/3.0)*sin(a+stp/150.0);
      float dx = (100+f*width/3.0)*cos(a+stp/150.0);      
      curveVertex(dx,dy);
    }
    endShape(CLOSE);    

  }
  popMatrix();
  stp++;
}

void oscEvent(OscMessage msg) {

  if(msg.checkAddrPattern("/data")) {
    int i = 0;
    float d[] = new float[14];
    for (String p : points) {
       float v = msg.get(i).floatValue();
       d[i] = v;
       i++;
    }
    data.add(d);
  }
}
