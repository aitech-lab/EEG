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

ArrayList<float[]> data;

void setup() {
  
  size(1024,768);
  
  frameRate(25);

  oscP5 = new OscP5(this,9997);
  background(0);
}

void draw() {
  
  
  if(x==0) {
    noStroke();
    fill(0, 100);
    rect(0,0,width, height);
  }

      
  if (line != null) {
    
    OscMessage msg = new OscMessage("/data");
    int i=0;
    
    for(String s : split(line, " ")) { 
      
      float f = float(s);
      
      atr1[i]+= (f-atr1[i])/20.0;
      atr2[i]+= (f-atr2[i])/10.0;
      
      stroke(p0[i%p0.length],230);  
      line(
        x, height/2.0+atr2[i]*500,
        x, height/2.0+atr1[i]*500);
      
      stroke(p0[i%p0.length],100);  
      point(x,height/2.0+f*500);   
      msg.add(f);
      i++;
      
    }
    oscP5.send(msg, remote);
    
    x++;
    x%=width;
  }
  
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
  }
}
