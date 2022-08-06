
import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:my_music/screens/now_playing/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Utililty {
  static AudioPlayer myPlayer = AudioPlayer();
  static int currentIndex = -1;
  static ValueNotifier<List<int>> playlist = ValueNotifier([]);
  static TextStyle textStyle = const TextStyle(
      fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white);
  static List<SongModel> songsCopy = [];
  static Color pink = const Color.fromARGB(255, 244, 140, 175);
  static Color green = const Color(0xffb0d7d2);

  static ConcatenatingAudioSource createSongList(List<SongModel> song) {
    List<AudioSource> source = [];
    for (var songs in song) {
      source.add(AudioSource.uri(Uri.parse(songs.uri!),
      tag: MediaItem(id: songs.id.toString(), title: songs.title)
       ));
      ScreenNowPlaying.songCopy.add(songs);
    }
    
    return ConcatenatingAudioSource(children: source);

  }
}
