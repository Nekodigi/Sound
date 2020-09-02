//Inspired by this video https://www.youtube.com/watch?v=H3UqKe_Bwoc
import ddf.minim.*;
import ddf.minim.analysis.*;

float timeGoAround = 100;

Minim minim;
AudioInput in;
FFT fft;
AudioPlayer player;
float ps;//pixel size
float dangle;//delta angle
float angle, r;
float cf;//circumference

void setup() {
  size(1024, 1024);
  //fullScreen();
  background(255);
  delay(1000);
  colorMode(HSB, 360, 100, 100);
  noStroke();
  //setup minim
  minim = new Minim(this);
  player = minim.loadFile("IMSLP501882-PMLP3722-Ro_5-11_(1)_Pictures_at_an_Exhibition_(Modest_Mussorgsky_-_Maurice_Ravel).mp3");//you have to download this sound from https://soundcloud.com/nasa/sun-sonification
  player.play();
  fft = new FFT(player.bufferSize(), player.sampleRate());
  fft.window(FFT.HAMMING);
  //calculate constant
  timeGoAround = player.length()/1000;
  timeGoAround *= frameRate;
  dangle = TWO_PI/timeGoAround;
  r = height/2;
  ps = r/fft.specSize();
  cf = r*TWO_PI;
  ps = max(ps, r*dangle);
  
}

void draw(){
  //background(0);

  if(!player.isPlaying()){
    stop();
  }
  
  fft.forward(player.mix);
  
  
  for (int i = 0;i < fft.specSize(); i++) {
    float rs = map(i, 0, fft.specSize(), r, 0);
    fill(360-(fft.getBand(i))*360);
    PVector pos = PVector.fromAngle(angle).mult(rs).add(width/2, height/2);
    float pst = ps*map(i, 0, fft.specSize(), 1, 0);//pixel size at this radius
    rect(pos.x, pos.y, pst, pst);
  }
  
  angle += dangle;
}


void stop() {
  minim.stop();
  super.stop();
}
