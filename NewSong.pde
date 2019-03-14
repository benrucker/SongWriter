class NewSong {
  // The new song datatype
  NewSong previousSong, nextSong;

  private float x, y;

  private float endY;

  private String display;
  private String artist;

  private int lineCount;

  public NewSong(String song, String name) {
    this(song, name, defaultX, defaultY);
  }

  public NewSong(String song, String name, float x, float y) {
    display = song.trim();
    this.x = x;
    this.y = y;
    artist = name;
    lineCount = display.split("\n").length;
    setEndPos();
  }

  public String getSong() {
    return display;
  }

  public void setPrevious(NewSong other) {
    previousSong = other;
  }
  public void setNext(NewSong other) {
    nextSong = other;
  }
  public void setPos(float X, float Y) {
    this.x = X;
    this.y = Y;
    setEndPos();
  }

  private void setEndPos() {
    endY = y + lineCount * lineHeight;
  }


  public NewSong getPrevious() {
    return previousSong;
  }
  public NewSong getNext() {
    return nextSong;
  }
  public String getArtist() {
    return artist;
  }
  public float getX() {
    return x;
  }
  public float getY() {
    return y;
  }
  public float getEndY() {
    return endY;
  }

  public void move() {
    if (getNext() != null)
      getNext().move();
    y -= speed;
    setEndPos();
  }
}
