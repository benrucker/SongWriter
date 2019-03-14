class SongGenerator { //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//

  String generateSong(Song[] examples, Map<String, List<Entry<String, Double>>> sortedWordProb) {
    // TODO this method should generate a new song
    // by pulling a random song length, averaging the words per line,
    // pulling the average number of stanzas, getting the words that start stanzas (or lines),
    // then using the word probabilities to fill up the output string

    // Song fields: title, str[] lyrics, map str str[] stanzas, str[] stanzanames
    // int avglinesperstanza, int avgwordsperline

    int structureIndex = (int)random(examples.length);
    ArrayList<String> stanzaNameSet = examples[structureIndex].getOrderedStanzaNames();
    String[] stanzaNames = new String[stanzaNameSet.size()];
    stanzaNames = stanzaNameSet.toArray(stanzaNames);

    ArrayList<String> allStarters = new ArrayList<String>();

    int avgLinesPerStanza = 0, avgWordsPerLine = 0, avgStanzas = 0;

    // ------------------------------------------------------------------------------------
    // Get the stats from the songs. Also get the words that start stanzas in the songs
    for (Song s : examples) {
      avgLinesPerStanza += s.getAvgLines();
      avgWordsPerLine += s.getAvgWordsPerLine();
      avgStanzas += s.getStanzaMap().size();
      allStarters.addAll(Arrays.asList(s.getStanzaStarters()));
    }
    avgLinesPerStanza /= examples.length;
    avgWordsPerLine /= examples.length;
    avgStanzas /= examples.length;



    // ------------------------------------------------------------------------------------
    // Generate the fuckin song
    String out = "";
    String previousWord = "";
    try {

      for (int stanza = 0; stanza < stanzaNames.length; stanza++) {

        // Generate random values to modify line and stanza length
        int[] rand = new int[2];
        for (int x = 0; x < rand.length; x++) {
          rand[x] = (int)random(x+1); // up to 1 for lines, up to 2 for words
        }
        //print(previousWord);
        out += "\n[" + stanzaNames[stanza] + "]\n";
        previousWord = allStarters.get((int)random(allStarters.size()));
        //print(previousWord);

        out += capitalize(previousWord) + " ";
        int word = 1;

        for (int line = 0; line < avgLinesPerStanza + rand[0]; line++) {

          while (word < avgWordsPerLine + rand[1]) {

            previousWord = getNextWord(sortedWordProb.get(previousWord));
            out += (word == 0 ? capitalize(previousWord) : previousWord) + " ";
            word++;
          }
          word = 0;
          out += "\n";
        }
      }
    }
    catch(Exception e) {
      println("song gen");
      e.printStackTrace();
    }
    return out;
  }

  private String getNextWord(List<Entry<String, Double>> words) {
    float rand = random(1);
    double sum = 0;

    for (Entry word : words) {
      sum += (double)word.getValue();
      if (rand <= sum)
        return (String)word.getKey();
    }

    return "error";
  }

  String capitalize(String word) {
    return word.substring(0, 1).toUpperCase() + word.substring(1);
  }
}
