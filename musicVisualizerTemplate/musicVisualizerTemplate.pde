/*

Music Visualizer Base
Created by Jonathan Champion

This Processing Sketch is a music visualizer template.
It includes a file selection system that allows the user to
select music from their computer to play. 



Credits:
Smoothing Function by Nick Pattison

*/

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
FFT fft;
BeatDetect beat;

boolean songSelected = true;
float level = 0;
PShader shader;

void setup()
{
  size(1000, 800, P2D);
  minim = new Minim(this);
  //shader = loadShader("frag.glsl");
}

void draw()
{
  // If a song exists and is currently playing
  if (song != null && song.isPlaying()) {
    
    // DO SHADER STUFF
    if (shader != null) {
      
    }

    // UPDATE MUSIC INFORMATION
    fft.forward(song.mix);
    level = smoothSignal(song.mix.level(), level, 20);
    beat.detectMode(BeatDetect.FREQ_ENERGY);
    beat.detect(song.mix);

    // CLEAR SCREEN
    noStroke();
    fill(0, 0, 0);
    rect(0, 0, width, height);

    //////////////// DRAW VISUALIZER STUFF HERE //////////////////////////

    fill(250, 0, 0);
    if (beat.isKick()) ellipse(50, 50, 50, 50);




    //////////////// END VISUALIZER DRAWING //////////////////////////////
    
  } else { // MUSIC HAS STOPPED/START OF PROGRAM
    noStroke();
    fill(0, 0, 0);
    rect(0, 0, width, height);
    
    // if a song is still selected it means this is the first time here,
    // we need the user to select a new song
    if (songSelected) {
      // set songSelected to false until user picks a new song
      songSelected = false;
      // tell Input Window to Open
      selectInput("Select a song", "LoadMusic"); //LoadMusic is the function called after
    }
  }
}

//This function takes the File the user selected and sets up Minim if it is a music file
public void LoadMusic(File selection) {

  //check to see if window was closed
  if (selection == null) {
    println("selection window closed");
    //may wish to close program entirely here
    
  } else {
    //get selection name
    String name = selection.getName();
    name.toLowerCase();
    //check if music file
    if (name.endsWith("mp3") || name.endsWith("wav") ||name.endsWith("aiff") ||name.endsWith("au")) {
      //if music file, set up minim and music stuff
      song = minim.loadFile(selection.getAbsolutePath());
      fft = new FFT(song.bufferSize(), song.sampleRate());
      song.play();
      beat = new BeatDetect();

      //volume control
      song.setGain(-20);
    }
  }
  //set songSelected to true
  songSelected = true;
}

//Nick's Smoothing Function
float smoothSignal(float newValue, float oldValue, int oldWeight) {
  return (newValue + oldValue * oldWeight) / (oldWeight + 1);
}