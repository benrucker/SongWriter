class Artist {
  // This class holds the songs that are made by a certain artist.
  // Also contains a map of the probabilities of words.
  
  String name;

  NewSong songToDisplay;

  ArrayList<Song> songs;
  ArrayList<Song> songsOld;
  ArrayList<String> allWords;

  Map<String, List<Entry<String, Double>>> sortedWordProb;

  public Artist(String n) {


    name = n;

    // LOAD LYRICS
    //String[] lines = loadStrings("grablyrics\\done\\"+name+"----lyrics.txt");
    String[] lines = loadStrings("grablyrics/done/"+name+"----lyrics.txt");
    println(lines.length);
    String input = "";
    sortedWordProb = new HashMap<String, List<Entry<String, Double>>>();
    for (String s : lines)
      input += s + "\n";

    songs = new ArrayList<Song>();

    //print(input);
    String[] songData = input.split("----");
    songsOld = new ArrayList<Song>();

    for (int i = 0; i < songData.length; i++) {
      String str = songData[i];

      if (str.trim().isEmpty()) 
        continue;

      //print(str);
      String[] newStr = str.split("--");
      try {
        songsOld.add(new Song(newStr[0].trim(), newStr[1].split("\n")));
      }
      catch(Exception e) {
        //e.printStackTrace();
        //println(newStr[0] + " failed");
      }
    }

    songData = input.split("----");

    for (int i = 0; i < songData.length; i++) {
      String str = songData[i];

      if (str.trim().isEmpty()) 
        continue;

      //print(str);
      String[] newStr = str.split("--");
      try {
        songs.add(new Song(newStr[0], newStr[1].split("\n")));
      }
      catch (java.lang.ArithmeticException e) {
        println("skipped " + newStr[0].trim() + " by " + name);
      }
    }

    initWords();
  }

  void initWords() {
    Map<String, Map<String, Double>> newWordProbMap = new HashMap<String, Map<String, Double>>();
    getWordProbs(newWordProbMap);
    makeSortedList(newWordProbMap);
  }

  void generateNewSong() {
    SongGenerator gen = new SongGenerator();
    Song[] songArr = new Song[songs.size()];
    songArr = songs.toArray(songArr);
    songToDisplay = new NewSong( gen.generateSong(songArr, sortedWordProb), name);
  }


  NewSong getNewSong() {
    return songToDisplay;
  }

  void makeSortedList(Map<String, Map<String, Double>> newWordProbMap) {
    for (String word : newWordProbMap.keySet()) {
      Map<String, Double> map = newWordProbMap.get(word);

      Set<Entry<String, Double>> set = map.entrySet();
      List<Entry<String, Double>> list = new ArrayList<Entry<String, Double>>(set);
      Collections.sort( list, new Comparator<Map.Entry<String, Double>>()
      {
        public int compare( Map.Entry<String, Double> o1, Map.Entry<String, Double> o2 )
        {
          int result = (o2.getValue()).compareTo( o1.getValue() );
          if (result != 0) {
            return result;
          } else {
            return o1.getKey().compareTo(o2.getKey());
          }
        }
      } 
      );
      sortedWordProb.put(word, list);
    }
  }


  void getWordProbs(Map<String, Map<String, Double>> newWordProbMap) {
    allWords = new ArrayList<String>();
    packAllWords(); // allWords now contains every song's lyrics in order

    Map<String, Map<String, Integer>> wordProbMap = new HashMap<String, Map<String, Integer>>();

    // construct map spine
    // includes al unique words
    for (String str : allWords) {
      if (!wordProbMap.containsKey(str))
        wordProbMap.put(str, null);
    }

    Set<String> keys = wordProbMap.keySet();
    Map<String, Integer> zeroMap = new HashMap<String, Integer>();

    for (String _key : keys) {
      zeroMap.put(_key, new Integer(0));
    }

    for (String _key : keys) {
      wordProbMap.put(_key, new HashMap(zeroMap));
    }

    countAndAverage(wordProbMap, newWordProbMap);
  }



  //void printWordProbs() {
  //  for (String _key : newWordProbMap.keySet()) {
  //    print(_key);
  //    for (String _key2 : newWordProbMap.get(_key).keySet()) {
  //      print(" " + newWordProbMap.get(_key).get(_key2) + " " + _key2);
  //    }
  //    println(".\n.\n");
  //  }
  //}



  void countAndAverage(Map<String, Map<String, Integer>> wordProbMap, Map<String, Map<String, Double>> newWordProbMap) {
    for (int x = 0; x < allWords.size() - 1; x++) {
      String word = allWords.get(x);
      String nextWord = allWords.get(x+1);

      Map<String, Integer> wordEntry = wordProbMap.get(word);
      int val = wordEntry.get(nextWord) + 1;
      //println(val); // checks out
      wordEntry.put(nextWord, val);
      wordProbMap.put(word, wordEntry);
      //println(wordEntry.get(nextWord)); // also good\
      //println(wordProbMap.get(word));
    }
    averageRows(wordProbMap, newWordProbMap);
  }

  void averageRows(Map<String, Map<String, Integer>> wordProbMap, Map<String, Map<String, Double>> newWordProbMap) {
    int print = 0;
    //Map<String, Map<String, Double>> newWordProbMap = new HashMap<String, Map<String, Double>>();
    for (String row : wordProbMap.keySet()) {
      if (print++ < 2) {
        //println(print+"avg:\n\n"+wordProbMap.get(row));
      }
      newWordProbMap.put(row, divideRow(wordProbMap.get(row)));
    }
  }

  Map<String, Double> divideRow(Map<String, Integer> map) {
    int sum = sumRow(map);
    //println("sum " + sum);
    Map<String, Double> newMap = new HashMap<String, Double>();
    for (String _key : map.keySet()) {
      newMap.put(_key, (double)map.get(_key) / (double)sum);
    }
    return newMap;
  }

  int sumRow(Map<String, Integer> map) {
    int sum = 0;
    for (String _key : map.keySet()) {
      //println(map.get(_key));
      //print(map.get(_key)+" ");
      sum += map.get(_key);
    }
    //println(sum);
    return sum;
  }

  void packAllWords() {
    for (Song song : songsOld) {
      for (String w : song.getLyrics()) {
        if (!w.isEmpty())
          allWords.add(w);
      }
    }
  }
  void drawWordCount() {
    for (int i = 0; i < songs.size(); i++) {
      Song song = songs.get(i);
      text(song.getLyrics().length, i*100 + 15, 15);
    }
  }
}
