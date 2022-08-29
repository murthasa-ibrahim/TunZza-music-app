
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:my_music/helper/utility.dart';
import 'package:my_music/screens/now_playing/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return 
       Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            int sensitivity = 8;
            if (details.delta.dx > sensitivity) {
              if (Utililty.myPlayer.hasPrevious) {
                Utililty.myPlayer.seekToPrevious();
              } else {
                Utililty.myPlayer.seek(const Duration(seconds: 0),
                    index: ScreenNowPlaying.songCopy.length - 1);
              }
            } else if (details.delta.dx < -sensitivity) {
              if (Utililty.myPlayer.hasNext) {
                Utililty.myPlayer.seekToNext();
              } else {
                Utililty.myPlayer.seek(const Duration(seconds: 0), index: 0);
                if (!Utililty.myPlayer.playing) {}
                Utililty.myPlayer.play();
              }
            }
          },
          child: Container(
            height: 70,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 5, 39, 67),
                borderRadius: BorderRadius.circular(0)),
            child: ListTile(
                onTap: () {
                  List<SongModel> songse = [];
                  for (int i = 0; i < ScreenNowPlaying.songCopy.length; i++) {
                    songse.add(ScreenNowPlaying.songCopy[i]);
                  }
    
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => ScreenNowPlaying(song: songse))));
                },
                leading: QueryArtworkWidget(
                  id: ScreenNowPlaying
                      .songCopy[Utililty.myPlayer.currentIndex!].id,
                  type: ArtworkType.AUDIO,
                ),
                title: SizedBox(
                  child: Marquee(
                    pauseAfterRound: const Duration(seconds: 4),
                    velocity: 30,
                    text: ScreenNowPlaying
                        .songCopy[Utililty.myPlayer.currentIndex!].title,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                   
                      if (Utililty.myPlayer.playing) {
                        Utililty.myPlayer.pause();
                      } else {
                        Utililty.myPlayer.play();
                      }
                    
                  },
                  icon: StreamBuilder<bool>(
                    stream: Utililty.myPlayer.playingStream,
                    builder: (context, snapshot) {
                      bool? playingState = snapshot.data;
                      if (playingState != null && playingState) {
                        return const Icon(
                          Icons.pause,
                          size: 27,
                          color: Colors.white70,
                        );
                      }
                      return const Icon(
                        Icons.play_arrow,
                        size: 27,
                        color: Colors.white70,
                      );
                    },
                  ),
                )),
          ),
        ) );
     
  }
}
