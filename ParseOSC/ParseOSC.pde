/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;
import controlP5.*;

String points[] = {"F3", "FC6", "P7", "T8", "F7", "F8", "T7", "P8", "AF4", "F4", "AF3", "O2", "O1", "FC5"};

OscP5 oscP5;
ControlP5 cp5;
Chart chart;

void setup() {
  size(800,600);
  cp5 = new ControlP5(this);
  
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,9997);
  chart = cp5.addChart("data")
               .setPosition(10, 10)
               .setSize(780, 200)
               .setRange(-0.2, 0.2)
               .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
               ;
  for(String p : points) {  
    chart.addDataSet(p);
    chart.setColors(p, randomColor(),randomColor());
    chart.setData(p, new float[100]);
  }
}

color randomColor() {
  return color(random(255),random(255),random(255));
}

void draw() {
  background(0);  
}

void oscEvent(OscMessage msg) {
  if(msg.checkAddrPattern("/data")) {
    println(msg.addrPattern());
  
    int i = 0;
    for (String s : points) {
       float v = msg.get(i++).floatValue();       
       chart.unshift(s, v);
    }
    println(chart.size());
  }
}
