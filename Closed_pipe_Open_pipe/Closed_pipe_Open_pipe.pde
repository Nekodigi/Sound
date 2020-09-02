//based on this site http://www.studyphysics.ca/newnotes/20/unit03_mechanicalwaves/chp141516_waves/lesson51.htm
import ddf.minim.*;
import ddf.minim.signals.*;

boolean closed = true;
Minim minim;
AudioOutput out;
float v = 100000;//500000 velocity of sound in air
int n = 10;//number of overtone
float thickness = 100;//100
SineWave[] sines = new SineWave[n];

void setup() {
  size(500, 500);
  //fullScreen();
  minim = new Minim(this);
  out = minim.getLineOut(Minim.MONO);
  for(int i=0; i<n; i++){
    sines[i] = new SineWave(0, 1, out.sampleRate());
    out.addSignal(sines[i]);
  }
  strokeWeight(20);//20
  stroke(255);
}
void draw() {
  background(0);
  closed = mousePressed;
  float l = mouseX;
  line(0, height/2-thickness, l, height/2-thickness);
  line(0, height/2+thickness, l, height/2+thickness);
  if(closed){
    line(l, height/2-thickness, l, height/2+thickness);
    for(int m=1; m<=n; m++){
      int mi = m;
      m = m*2-1;
      float f = m*v/(4*l);
      sines[mi-1].setAmp(1./m);
      sines[mi-1].setFreq(int(f));
    }
  }else{
    for(int m=1; m<=n; m++){
      float f = m*v/(2*l);
      sines[m-1].setAmp(1./m);
      sines[m-1].setFreq(int(f));
    }
  }
  //sine.noPortamento();
  
}
