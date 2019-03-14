class Song { //<>// //<>// //<>// //<>//
  String title;
  String[] _lyrics;

  Map<String, String[]> stanzas;
  String[] stanzaNames;
  ArrayList<String> stanzaNameList;
  String[] stanzaStarters;

  int avgLinesPerStanza, avgWordsPerLine;
  public int lineCount, wordCount;

  public Song(String title, String[] lines) {
    this.title = title;
    stanzas = new HashMap<String, String[]>();
    setLyricsFromLines(lines);
    setStanzaStarters();
  }

  public void setLyricsFromLines(String[] lines) {
    ArrayList<String> temp = new ArrayList<String>();
    stanzaNameList = new ArrayList<String>();
    
    lineCount = 0;
    wordCount = 0;

    for (String line : lines) {
      line = line.trim();
      if (!(line.startsWith("["))) {

        if (!(line.trim().isEmpty())) {
          lineCount++;
          for (String word : line.split(" ")) {
            temp.add(cleanAndFormat(word));
            wordCount++;
          }
        }
      } else {

        String verse = line.substring(1, line.length()-1);

        if (!stanzaNameList.isEmpty()) {
          String[] stanzaLines = new String[temp.size()];
          stanzaLines = temp.toArray(stanzaLines);
          if (stanzaLines != null)
            stanzas.put(stanzaNameList.get(stanzaNameList.size()-1), stanzaLines);
          temp.clear();
        }
        stanzaNameList.add(verse);
      }
    }
    String[] stanzaLines = new String[temp.size()];
    stanzaLines = temp.toArray(stanzaLines);
    if (stanzaLines != null && stanzaNameList.size() != 0)
      stanzas.put(stanzaNameList.get(stanzaNameList.size()-1), stanzaLines);
    temp.clear();

    //for (String s : stanzas.keySet()) {
    //  println(s);
    //  printArray(stanzas.get(s));
    //}
    avgLinesPerStanza = lineCount/stanzas.size();
    avgWordsPerLine = wordCount/lineCount;
    //println(lineCount + " " + stanzas.size() + "= " + avgLinesPerStanza + " : " + avgWordsPerLine); 

    //lyrics = new String[temp.size()];

    //for (int i = 0; i < lyrics.length; i++) {
    //  lyrics[i] = temp.get(i);
    //}
    // ugly-ass code right there
  }

  private void setStanzaStarters() {
    stanzaStarters = new String[getStanzaLyrics().size()];

    int x = 0;
    for (String[] lyrics : getStanzaLyrics()) {
      try {
        if(lyrics[x] == null)
          continue;
        if (!lyrics[x].trim().isEmpty())
          stanzaStarters[x] = lyrics[x++]; //<>// //<>//
      } 
      catch (Exception e) {
      }
    }
  }

  public String getTitle() { 
    return title;
  }
  public String[] getLyrics() {
    if (_lyrics == null)
      setLyrics();
    return _lyrics;
  }
  public void setLyrics() { 
    ArrayList<String> tempLyrics = new ArrayList<String>();
    
    for (String[] stanza : getStanzaMap().values())
      for (String word : stanza)
        tempLyrics.add(word);
    
    String[] lyricsOut = new String[tempLyrics.size()];
    for (int x = 0; x < lyricsOut.length; x++)
      lyricsOut[x] = tempLyrics.get(x);
    
    _lyrics =  lyricsOut;
    //return _lyrics;
  }
  public String getLyricsAsString() {
    String out = "";
    for (String k : stanzas.keySet()) {
      out += k + "\n";
      for (String w : stanzas.get(k)) {
        out += w + " ";
      }
    }
    return out;
  }

  public int getAvgLines() { 
    return avgLinesPerStanza;
  }
  public int getAvgWordsPerLine() { 
    return avgWordsPerLine;
  }

  public Map<String, String[]> getStanzaMap() {
    return stanzas;
  }

  public Collection<String[]> getStanzaLyrics() {
    return stanzas.values();
  }

  public Set<String> getStanzaNames() {
    return stanzas.keySet();
  }
  
  public ArrayList<String> getOrderedStanzaNames() {
    return stanzaNameList;
  }

  public String[] getStanzaStarters() {
    return stanzaStarters;
  }

  public ArrayList<Word> getLyricFreqs() {
    ArrayList<Word> out = new ArrayList<Word>();

    for (String lyric : _lyrics) {
      Word newWord = new Word(lyric);

      if (!out.contains(newWord)) {
        out.add(newWord);
        // println("adding " + newWord);
      } else {
        out.get(out.indexOf(newWord)).inc();
        //  println("inc " + newWord);
      }
      //print(out.get(out.indexOf(newWord)).getFreq());
    }

    return out;
  }

  private String cleanAndFormat(String word) {
    return word.replaceAll("[^a-zA-z&&[^'&&[^-&&[\\D]]]]", "").toLowerCase();
  }
}
