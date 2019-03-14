public class Word implements Comparable<Word> {
  private String word;
  private int freq;
  
  public Word(String w) {
    word = w;
    freq = 1;
  }
  
  public void inc() { freq++; }
  
  public String getWord() {
    return word;
  }
  public int getFreq() {
    return freq;
  }
  
  public String toString() {
    return word;
  }
  
  public int compareTo(Word other) {
    return other.getFreq() - this.freq;
  }
  
  @Override
  public boolean equals(Object other) {
    return this.word.equals(((Word)other).getWord());
  }
}
