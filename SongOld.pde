class SongOld{
  String title;
  String[] lyrics;
  
  public SongOld(String title, String[] lines) {
    this.title = title;
    setLyricsFromLines(lines);
  }
  
  public void setLyricsFromLines(String[] lines) {
    ArrayList<String> temp = new ArrayList<String>();
    
    for (String line : lines) {
      for (String word : line.split(" ")) {
        if (word.trim().isEmpty() || word.startsWith("[") || word.endsWith("]"))
          continue;
        else
          temp.add(cleanAndFormat(word));
      }
    }
    
    lyrics = new String[temp.size()];
    
    for (int i = 0; i < lyrics.length; i++) {
      lyrics[i] = temp.get(i);
    }
    // ugly-ass code right there
  }
  
  public String getTitle() { return title; }
  public String[] getLyrics() { return lyrics; }
  public String getLyricsAsString() {
    return Arrays.toString(lyrics);
  }
  
  public ArrayList<Word> getLyricFreqs() {
    ArrayList<Word> out = new ArrayList<Word>();
    
    for (String lyric : lyrics) {
      Word newWord = new Word(lyric);
      
      if (!out.contains(newWord)) {
        out.add(newWord);
       // println("adding " + newWord);
      }
      else {
        out.get(out.indexOf(newWord)).inc();
      //  println("inc " + newWord);
      }
      //print(out.get(out.indexOf(newWord)).getFreq());
    }
    
    return out;
  }
  
  private String cleanAndFormat(String word) {
    return word.replaceAll("[^a-zA-z&&[^'&&[\\D]]]","").toLowerCase();
  }
}
