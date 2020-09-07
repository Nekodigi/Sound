import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.signals.*;

int Samples = 512;
Minim minim;
AudioInput in;
AudioOutput out;
FFT fft;
SineWave sine;

void setup() {
  size(1024, 400);
  //fullScreen();
  background(255);

  minim = new Minim(this);
  //textFont(createFont("Calibri-Bold-24", 12));
  in = minim.getLineIn(Minim.STEREO, Samples);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  fft.window(FFT.HAMMING);
  
  out = minim.getLineOut(Minim.MONO);
  sine = new SineWave(440*pow(pow(2, 1./12), 1), 0.2, out.sampleRate());
  out.addSignal(sine);sine.noPortamento();
  stroke(255);
  frameRate(30);
  colorMode(HSB);
  strokeWeight(2);
}

void draw(){
  background(0);

  fft.forward(in.mix);
  float[] input = new float[Samples];
  for (int i = 0;i < Samples; i++) {
    input[i] = in.left.get(i);
  }
  float maxBand = 0;
  float maxFreq = 0;
  for (int i = 0;i < Samples; i++) {
    float x = map(i, 0, Samples, 0, width);
    float h = map(i, 0, Samples, 0, 255);
    //stroke(255);
    //line(x, height, x, height - in.left.get(i) * height);
    stroke(h, 255, 255);
    float band = fft.getBand(i);
    line(x, height, x, height - band * height/4);
    if(maxBand < band){
      maxBand = band;
      maxFreq = fft.indexToFreq(i);
    }
  }println(maxFreq);
  sine.setFreq(maxFreq);
}


void stop() {
  minim.stop();
  super.stop();
}
