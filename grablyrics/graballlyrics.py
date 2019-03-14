# Created by Jack Schultz
# https://bigishdata.com/2016/09/27/getting-song-lyrics-from-geniuss-api-scraping/

import requests
from bs4 import BeautifulSoup
import re

base_url = "https://api.genius.com"
headers = {'Authorization': 'Bearer 0zk4LHeyTxuG4ESQThVkrJpmxxlyy2WznoaFZUkWKhPUJSPrrMTpnSK3HDzDZZyd'}

artists = []

def get_songs(artist):
    with open(artist+'.txt') as f:
        songs = []
        song_names = f.read().split("\n")
        #print(song_names)
        for song in song_names:
            if song.strip() != "":
                songs.append(song)
        return song_names

def lyrics_from_song_api_path(song_api_path):
    song_url = base_url + song_api_path
    response = requests.get(song_url, headers=headers)
    json = response.json()
    path = json["response"]["song"]["path"]
    #gotta go regular html scraping... come on Genius
    page_url = "http://genius.com" + path
    page = requests.get(page_url)
    html = BeautifulSoup(page.text, "html.parser")
    #remove script tags that they put in the middle of the lyrics
    [h.extract() for h in html('script')]
    #at least Genius is nice and has a tag called 'lyrics'!
    lyrics = html.find("div", class_="lyrics").get_text() #updated css where the lyrics are based in HTML"
    return lyrics

def getArtistLyrics(artist):
    song_names = get_songs(artist);

    output = open(artist+'----lyrics.txt','w')

    for song in song_names:
        lyrics = str(getLyrics(song,artist))
        if lyrics == "None":
            print("--------------- ERROR ON " + song + " ---------------")
        else:
            try:
                output.write("\n----\n" + lyrics)
            except Exception as e:
                print(e)
                continue;
    
def getLyrics(search_term, artist):
    # generic search
    search_url = base_url + "/search"
    #print(search_url)
    #for x in range(2):
    #    data = {'q': song_names[x] + " " + artist_name}
    data = {'q': search_term + " " + artist}
    print(data)
    response = requests.get(search_url, data=data, headers=headers)
    print(response)
    json = response.json()
    #print(json)
    song_info = None
    for hit in json["response"]["hits"]:
        #print("\n",hit)
        if hit["result"]["primary_artist"]["name"] == artist:
           #print("hit")
            song_info = hit
            break
    if song_info:
        song_api_path = song_info["result"]["api_path"]
        lyrics = lyrics_from_song_api_path(song_api_path)
        #lyrics = re.sub("([\(\[]).*?([\)\]])", "\g<1>\g<2>", lyrics)
        #lyrics = re.sub('\[.*?\]','', lyrics)
        #print(lyrics)
        return(search_term + "\n--\n" + lyrics)
            
if __name__ == "__main__":
    with open("artists.txt") as file:
        artists = file.read().split("\n")
    print(artists)
    for artist in artists:
        if artist.strip() != "":
            try:
                getArtistLyrics(artist)
            except Exception as e:
                print(e)
                continue