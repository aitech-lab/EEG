/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remote;

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

BufferedReader reader;
String line;
int x = 0;

float atr1[] = new float[14];
float atr2[] = new float[14];


void setup() {
  
  size(1024,768);
  
  frameRate(60);

  oscP5 = new OscP5(this,9997);
  remote = new NetAddress("127.0.0.1",9997);             
  reader = createReader("data/eeg.txt");
  background(0);
}

void draw() {
  
  
  if(x==0) {
    noStroke();
    fill(0, 100);
    rect(0,0,width, height);
  }
  
  try {
    line = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
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
  } else {
      reader = createReader("data/eeg.txt");
  }
  
}
