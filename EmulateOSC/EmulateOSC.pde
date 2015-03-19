/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remote;

BufferedReader reader;
String line;
int x = 0;

void setup() {
  
  size(1024,768);
  
  frameRate(60);

  oscP5 = new OscP5(this,9997);
  remote = new NetAddress("127.0.0.1",9997);             
  reader = createReader("data/eeg.txt");  
}

void draw() {
  
  if(x==0) background(0);
  
  try {
    line = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    reader = createReader("data/eeg.txt");
    return;
  }
  
  stroke(255);
  
  if (line != null) {
    
    OscMessage msg = new OscMessage("/data");
    for(String s : split(line, " ")) { 
      float f = float(s);
      point(x,height/2.0+f*500);
      msg.add(f);
    }
    oscP5.send(msg, remote);
    
    x++;
    x%=width;
  }
  
}
