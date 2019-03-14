# SongWriter
This program creates new sets of lyrics based off an artist's previous works. Word choice is markovian, stanza length is randomly chosen from an existing stanza, line length is based on the average of existing lines' lengths. 

## Usage
Requires the Processing IDE to run. Tested on Processing 3.4 on Windows 10 and MacOS.

Run `graballlyrics.py` in `\grablyrics` before running. Move the created text files (ending in `--lyrics.txt`) to `\grablyrics\done`. Open `SongWriter.pde` in Processing and click run.

Adding artists requires Python 3.

## Adding artists
1. Make a text file with the author's name as the filename, e.g. `EDEN.txt`, in `\grablyrics`.
2. In the file, include song titles from the artist that you want to base the new songs off of.
3. Separate the song titles with newlines, e.g. `icarus\nWake Up\nFumes...`.
4. In the same directory, add the artists name to `artists.txt`. Make sure this matches the filename exactly. 

```Note: include a leading newline in artists.txt to make sure it works.```

5. Add your genius API token to `graballlyrics.py` and run it.
6. Move the created file or files to `\grablyrics\done`.
7. Add the artist's name to the artistNames array in `SongWriter.pde`
8. Done!

## Known issues
* `artists.txt` requires a leading newline
* Sometimes a lyrics file can be too big and cause stange errors. Fix this by grabbing fewer songs or manually editing the lyrics file for that artist
* Sometimes the Genius lyric grabber will pull incorrect results. This can only be fixed by scrolling through each lyrics file to find the errors. Most often happens when a song has the same name as its album.
* Artist names cannot contain special characters (dashes, tildes, stuff that isn't exactly URL friendly) or else the Genius lyric grabber will get mad at you. Thankfully, the Genius search is good at working around this, so replace these characters with their closest "normal" counterpart and everything should work fine.
