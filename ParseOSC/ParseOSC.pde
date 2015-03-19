/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;
import controlP5.*;
import java.util.Map;

String points[] = {"F3", "FC6", "P7", "T8", "F7", "F8", "T7", "P8", "AF4", "F4", "AF3", "O2", "O1", "FC5"};

OscP5 oscP5;
ControlP5 cp5;
Chart chart;
Slider btt;
Slider2D gyro;
int gyro_w = 24;
float data_w = 1.0;

void setup() {
  
  size(1030,410);
  cp5 = new ControlP5(this);
  
  frameRate(25);

  oscP5 = new OscP5(this,9997);
  chart = cp5.addChart("data")
               .setPosition(10, 10)
               .setSize(750, 380)
               .setRange(-data_w, data_w)
               .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
               ;
               
  int i=0;
  for(String p : points) {  
    chart.addDataSet(p);
    chart.setColors(p, randomColor(),randomColor());
    float[] data = new float[200];
    chart.setData(p, data);
    
    cp5.addSlider(p+"-V")
     .setPosition(770, 10+i*20)
     .setRange(-data_w, data_w); 

    cp5.addSlider(p+"-Q")
     .setPosition(900,10+(i++)*20)
     .setRange(0, 8200); 
  }
  
  
  gyro = cp5.addSlider2D("gyro")
     .setPosition(900,10+i*20)
     .setSize(100,100)
     .setMinX(-gyro_w).setMaxX(gyro_w)
     .setMinY(-gyro_w).setMaxY(gyro_w)
     .setArrayValue(new float[] {128.0, 128.0})
     //.disableCrosshair()
     ;
  
 btt = cp5.addSlider("btt")
     .setPosition(770,10+i*20)
     .setSize(10, 100)
     .setMin(0).setMax(100)
     .showTickMarks(true)
     ;
  
         
  
}

color randomColor() {
  return color(random(255),random(255),random(255));
}

void draw() {
  background(0);  
}

void oscEvent(OscMessage msg) {
  if(msg.checkAddrPattern("/data")) {
    
    int i = 0;
    for (String p : points) {
       float v = msg.get(i++).floatValue();       
       chart.unshift(p, v);
       Slider sl = (Slider)cp5.getController(p+"-V");
       sl.setValue(v);
    }
  }
  
  if(msg.checkAddrPattern("/quality")) {
    // msg.print();
    int i = 0;
    for (String p : points) {
       int v = msg.get(i++).intValue(); 
       Slider sl = (Slider)cp5.getController(p+"-Q");
       sl.setValue(v);
    }
  }
  
  if(msg.checkAddrPattern("/battery")) {
    btt.setValue(msg.get(0).intValue());  
  }
  
  if(msg.checkAddrPattern("/gyro")) {
    // msg.print();
    gyro.setArrayValue(new float[] {gyro_w-msg.get(0).intValue(), gyro_w+msg.get(1).intValue()});
  }
  
  
}
