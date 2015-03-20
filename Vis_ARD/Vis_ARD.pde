/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;
import java.util.Arrays;
import java.util.Collections;

import processing.serial.*;

Serial port;

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
  
  size(200,200, P3D);
  port = new Serial(this, "/dev/ttyACM0", 9600);  
  frameRate(1);

  oscP5 = new OscP5(this,"239.0.0.1",7777);
  background(0);
}

void draw() {
  
  noStroke();
  
  fill(0, 10);
  rect(0,0,width, height);
  
  pushMatrix();
  
  while(data !=null && data.size()>0) {
    
    // println(stp,  data.size());
    
    float d[] = data.remove(0);
    
    if(d==null) continue;
    
    float mind = 0;
    float maxd = 0;
    for(int i=0; i<d.length; i++) {
      float f = d[i];  
      atr1[i]+= (f-atr1[i])/ 50.0;
      atr2[i]+= (f-atr2[i])/100.0;
      if(f<mind) mind=f;
      if(f>maxd) maxd=f;
    }
    for(int i=0; i<d.length; i++) { 
      float dd = (d[i] - mind)/(maxd-mind)*64;
      port.write((int)dd);
    }
    data.clear();
     
  }
  popMatrix();
  
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
