//based on this site https://en.wikipedia.org/wiki/Doppler_effect
import ddf.minim.*;
import ddf.minim.spi.*; // for AudioRecordingStream
import ddf.minim.ugens.*;

// declare everything we need to play our file and control the playback rate
Minim minim;
TickRate rateControl;
FilePlayer filePlayer;
AudioOutput out;


float c = 200;//c is the propagation speed of waves in the medium;
float lastDst = Float.NaN;

// you can use your own file by putting it in the data directory of this sketch
// and changing the value assigned to fileName here.
String fileName = "IMSLP501882-PMLP3722-Ro_5-11_(1)_Pictures_at_an_Exhibition_(Modest_Mussorgsky_-_Maurice_Ravel).mp3";

void setup()
{
  // setup the size of the app
  //size(1000, 1000);
  fullScreen();
  
  // create our Minim object for loading audio
  minim = new Minim(this);
                               
  // this opens the file and puts it in the "play" state.                           
  filePlayer = new FilePlayer( minim.loadFileStream(fileName) );
  // and then we'll tell the recording to loop indefinitely
  filePlayer.loop();
  
  // this creates a TickRate UGen with the default playback speed of 1.
  // ie, it will sound as if the file is patched directly to the output
  rateControl = new TickRate(1.f);
  
  // get a line out from Minim. It's important that the file is the same audio format 
  // as our output (i.e. same sample rate, number of channels, etc).
  out = minim.getLineOut();
  
  // patch the file player through the TickRate to the output.
  filePlayer.patch(rateControl).patch(out);
                        
}

// keyPressed is called whenever a key on the keyboard is pressed
void keyPressed()
{
  if ( key == 'i' || key == 'I' )
  {
    // with interpolation on, it will sound as a record would when slowed down or sped up
    rateControl.setInterpolation( true );
  }
}

void keyReleased()
{
  if ( key == 'i' || key == 'I' )
  {
    // with interpolation off, the sound will become "crunchy" when playback is slowed down
    rateControl.setInterpolation( false );
  }
}

// draw is run many times
void draw()
{
  //float rate = map(mouseX, 0, width, 0.0f, 3.f);
  PVector source = new PVector(width/2, height/2);
  PVector receiver = new PVector(mouseX, mouseY);
  if(lastDst == Float.NaN)lastDst = PVector.dist(source, receiver);
  float dst = PVector.dist(source, receiver);
  float rate = (1 + (lastDst-dst)/c);
  
  
  
  lastDst = dst;
  
  rateControl.value.setLastValue(rate);
  
  // erase the window to black
  background( 0 );
  
  ellipse(source.x, source.y, 50, 50);
  ellipse(receiver.x, receiver.y, 20, 20);
  
  // draw using a white stroke
  stroke( 255 );
  // draw the waveforms
  for( int i = 0; i < out.bufferSize() - 1; i++ )
  {
    // find the x position of each buffer value
    float x1  =  map( i, 0, out.bufferSize(), 0, width );
    float x2  =  map( i+1, 0, out.bufferSize(), 0, width );
    // draw a line from one buffer position to the next for both channels
    line( x1, 50  - out.left.get(i)*50,  x2, 50  - out.left.get(i+1)*50);
    line( x1, 150 - out.right.get(i)*50, x2, 150 - out.right.get(i+1)*50);
  }  
}
