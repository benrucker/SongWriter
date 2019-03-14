import java.util.Scanner;
import java.io.*;
import java.util.Map;
import java.util.Map.Entry;
import java.util.List;
import java.util.Set;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;

String[] artistNames = {"EDEN", "Jon Bellion", "Post Malone", "Watsky", "Glass Animals","Shawn Mendes","Drake","Ariana Grande","alt-J"};
//String[] artistNames = {"EDEN","Glass Animals"};
Artist[] artists = new Artist[artistNames.length];

NewSong topSong;

color bg = color(40, 50, 60);

boolean isNextSong;

float lineHeight;
float defaultX, defaultY;

float defaultSpeed = .72;
float speed = defaultSpeed;

int prevSongIndex = 0;

PFont lyricFont;
PFont artistFont;

void setup() {
  size(1280, 800);
  background(bg);

  defaultX = 250;
  defaultY = height;

  for (int x = 0; x < artistNames.length; x++)
    artists[x] = new Artist(artistNames[x]);


  // ---------------------------------------------------------------
  // SETUP FONT
  //String[] fontList = PFont.list();
  //printArray(fontList);
  //PFont myFont = createFont("Monospaced.bold", 12);
  //PFont myFont = createFont("HelveticaNeue-UltraLight", 24);
  //PFont myFont = createFont("CourierNewPSMT", 14);
  //PFont myFont = createFont("CourierNewPS-BoldMT", 14);
  //PFont myFont = createFont("Courier", 14);
  //lyricFont = createFont("PTMono-Regular", 14);
  //artistFont = createFont("PTMono-Regular", 26);
  lyricFont = createFont("Monospaced.bold", 18);
  artistFont = createFont("Monospaced.bold", 32);
  textFont(lyricFont);

  //print(songToString(songs));


  // ----------------------------------------------------------------
  // DRAW INFO
  //noLoop();

  artists[0].generateNewSong();

  NewSong song = artists[0].getNewSong();

  //text(song.getSong(), 20,20);
  //println(song.getSong());
  topSong = song;
  isNextSong = false;

  lineHeight = textDescent() + textAscent() + 7.5;
}

//int num = 100;
void draw() {
  background(bg);

  drawLyrics();

  if (topSong.getEndY() < 0 ) { 
    println("removing topSong");
    topSong = topSong.getNext();
    isNextSong = false;
  }    
  if (!isNextSong) {

    println("creating next song");
    thread("addNextSong");
    isNextSong = true;
  }

  topSong.move();
}

void drawLyrics() {
  NewSong temp = topSong;
  int count = 0;
  while (temp != null) {
    
    // draw lyrics
    textFont(lyricFont);
    textAlign(LEFT);
    text(temp.getSong(), temp.getX(), temp.getY());
    
    // draw the artist name
    // the gross min(,max()) expression will keep the artist name on screen until the song
    // is almost completely off screen
    textFont(artistFont);
    textAlign(RIGHT);
    float textY = min(temp.getEndY() - 120 , max(30,temp.getY()) );
    text(temp.getArtist(), 10, textY , temp.getX() - 30, textY + 1000);
    
    // draw positions
    textFont(lyricFont);
    //text(temp.getX() + ":" + temp.getY(), 800, 20 + count++*lineHeight);


    temp = temp.getNext();
  }
}


// run on new thread!!
void addNextSong() {
  int num;
  do
    num = int(random(artists.length));
  while (num == prevSongIndex);
  
  artists[num].generateNewSong();
  topSong.setNext(artists[num].getNewSong());
  topSong.getNext().setPos(topSong.getX(), topSong.getEndY() + 50);
  println("created nextsong");
  //isNextSong = true;
  
  prevSongIndex = num;
}

void keyPressed() {
  speed = 9;
}

void keyReleased() {
  speed = defaultSpeed;
}
