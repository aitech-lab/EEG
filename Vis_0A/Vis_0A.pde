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

ArrayList<float[]> data = new ArrayList< float[] >();

void setup() {
  
  size(720,800);
  
  frameRate(30);

  oscP5 =new OscP5(this,"239.0.0.1",7777);
  background(0);
}

void draw() {
  
  
  if(x==0) {
    noStroke();
    fill(0, 100);
    rect(0,0,width, height);
  }

      

  while(data !=null && data.size()>0) {
    float d[] = data.remove(0);
    int i=0;
    if(d == null) continue;
    for(float f: d) { 
      atr1[i]+= (f-atr1[i])/20.0;
      atr2[i]+= (f-atr2[i])/10.0;
      
      stroke(p0[i%p0.length],230);  
      line(
        x, height/2.0+atr2[i]*500,
        x, height/2.0+atr1[i]*500);
      
      stroke(p0[i%p0.length],100);  
      point(x,height/2.0+f*500);   
      i++;
    }
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
    data.add(d);
  }
}
