import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_music/controllers/favourite_controller.dart';
import 'package:my_music/custom_widgets/fav_button.dart';


import 'package:my_music/models/playlist_model.dart';
import 'package:my_music/helper/utility.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart'as rxdart;

class ScreenNowPlaying extends StatefulWidget {
  ScreenNowPlaying({Key? key, required this.song}) : super(key: key);

  List<SongModel> song = [];
  static List<SongModel> songCopy = [];
  @override
  State<ScreenNowPlaying> createState() => _ScreenNowPlayingState();
}

class _ScreenNowPlayingState extends State<ScreenNowPlaying> {
  Stream<DurationState> get _durationStateStream =>
     rxdart. Rx.combineLatest2<Duration, Duration?, DurationState>(
          Utililty.myPlayer.positionStream,
          Utililty.myPlayer.durationStream,
          (position, duration) => DurationState(
              position: position, total: duration ?? Duration.zero));

  // String currentSongTitle = '';
  int currentIndex = 0;
  bool isPlaying = true;
  @override
  void initState() {
    Get.find<FavouriteControlller>() .isfav(widget.song[currentIndex]);
    super.initState();
    Utililty.myPlayer.playerStateStream.listen((event) {
      if (widget.song.isEmpty) {
        Utililty.myPlayer.stop();
      }
      
        isPlaying = Utililty.myPlayer.playing;
    
    });
    Utililty.myPlayer.currentIndexStream.listen((index) {
      setState(() {
        if (index != null) {
          currentIndex = index;
          Utililty.currentIndex = currentIndex;
        }
      });
    });
    ScreenNowPlaying.songCopy.clear();
    ScreenNowPlaying.songCopy.addAll(widget.song);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
             Color.fromARGB(255, 38, 110, 141),
            // Color.fromARGB(255, 3, 47, 85),
            Color.fromARGB(255, 22, 46, 67)
          ])),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child:Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(.2)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.keyboard_arrow_down_outlined,
                                size: 35,
                              ),
                              color: Colors.white,
                            ),
                           const Spacer(),
                            const Text(
                              'Now Playing',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            const Spacer(),
                            SizedBox(width: 35,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    int sensitivity = 14;
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
                        Utililty.myPlayer
                            .seek(const Duration(seconds: 0), index: 0);
                        if (!Utililty.myPlayer.playing) {}
                        Utililty.myPlayer.play();
                      }
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 140,
                    child: QueryArtworkWidget(
                      
                      artworkFit: BoxFit.cover,
                      id: widget.song[currentIndex].id,
                      type: ArtworkType.AUDIO,
                      artworkBorder: BorderRadius.circular(150.0),
                      artworkWidth: MediaQuery.of(context).size.width * 0.8,
                      artworkHeight: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ),
                ),
                Text(
                  widget.song[currentIndex].title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            color: Colors.grey.shade200.withOpacity(0.2)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      bottemsheet(widget.song[currentIndex].id);
                                    },
                                    icon: const Icon(Icons.playlist_add)),
                               FavBtn(song: widget.song[currentIndex]),
                                IconButton(
                                    onPressed: () {
                                      shoufleCheck();
                                    },
                                    icon: const Icon(
                                      Icons.shuffle_outlined,
                                    )),
                              ],
                            ),
                            StreamBuilder<DurationState>(
                              stream: _durationStateStream,
                              builder: (context, snapshot) {
                                final durationState = snapshot.data;
                                final progress =
                                    durationState?.position ?? Duration.zero;
                                final total =
                                    durationState?.total ?? Duration.zero;

                                return ProgressBar(
                                  progress: progress,
                                  total: total,
                                  barHeight: 4.0,
                                  baseBarColor: Colors.white.withOpacity(.2),
                                  progressBarColor: Colors.black,
                                  thumbGlowColor: Colors.black.withOpacity(0.1),
                                  thumbGlowRadius: 20,
                                  thumbColor: Colors.black,
                                  thumbRadius: 8,
                                  timeLabelTextStyle: const TextStyle(
                                    fontSize: 15,
                                  ),
                                  onSeek: (duration) {
                                    Utililty.myPlayer.seek(duration);
                                  },
                                );
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    color: Colors.black,
                                    onPressed: () {
                                      if (Utililty.myPlayer.hasPrevious) {
                                        Utililty.myPlayer.seekToPrevious();
                                        Utililty.myPlayer.play();
                                      } else {
                                        Utililty.myPlayer.seek(
                                            const Duration(seconds: 0),
                                            index: widget.song.length - 1);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.skip_previous,
                                      size: 40,
                                    )),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(15),
                                      primary: Colors.white.withOpacity(.2),
                                      onPrimary: Colors.white.withOpacity(1),
                                    ),
                                    onPressed: () {
                                    
                                      if (Utililty.myPlayer.playing) {
                                        Utililty.myPlayer.pause();
                                      } else {
                                        if (Utililty.myPlayer.currentIndex !=
                                            null) {
                                          Utililty.myPlayer.play();
                                        }
                                      }
                                    },
                                    child:
                                    StreamBuilder<bool>(
                              stream: Utililty.myPlayer.playingStream,
                              builder: (context, snapshot){
                                bool? playingState = snapshot.data;
                                if(playingState != null && playingState){
                                  return  Icon(Icons.pause_circle_filled, size: 35, color: Colors.black,);
                                }
                                return const Icon(Icons.play_circle_filled, size: 35, color: Colors.black,);
                              },)),







                                    //  Icon(
                                    //   isPlaying
                                    //       ? Icons.pause_circle_filled
                                    //       : Icons.play_circle_filled,
                                    //   size: 40,
                                    //   color: Colors.black,
                                    // )),
                                IconButton(
                                  color: Colors.black,
                                  onPressed: () {
                                    if (Utililty.myPlayer.hasNext) {
                                      Utililty.myPlayer.seekToNext();
                                      Utililty.myPlayer.play();
                                    } else {
                                      Utililty.myPlayer.seek(
                                          const Duration(seconds: 0),
                                          index: 0);
                                      if (!Utililty.myPlayer.playing) {}
                                      Utililty.myPlayer.play();
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.skip_next,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  shoufleCheck() {
    if (!Utililty.myPlayer.shuffleModeEnabled) {
      Utililty.myPlayer.setShuffleModeEnabled(true);
      const snackBar = SnackBar(
        content: Text('Shoufle mode enabled'),
        duration: Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Utililty.myPlayer.setShuffleModeEnabled(false);
      const snackBar = SnackBar(
          content: Text('Shoufle mode disabled'),
          duration: Duration(seconds: 1));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void bottemsheet(int songId) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.2),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                padding: const EdgeInsets.all(15),
                //  height: MediaQuery.of(context).size.height*.5,

                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Create New Playlist',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  final _textController =
                                      TextEditingController();
                                  return AlertDialog(
                                    content: TextFormField(
                                      controller: _textController,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter name'),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            if (_textController.text.isEmpty) {
                                              return;
                                            } else {
                                              List<int> songIds = [];
                                              Hive.box<MyPlaylistModel>(
                                                      'My playlistDB')
                                                  .add(MyPlaylistModel(
                                                      name:
                                                          _textController.text,
                                                      songIds: songIds));
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text(
                                            'Create',
                                            style: TextStyle(color: Colors.red),
                                          ))
                                    ],
                                  );
                                });
                          },
                          icon: const Icon(Icons.add),
                          color: Colors.white,
                        )
                      ],
                    ),
                    ValueListenableBuilder(
                        valueListenable:
                            Hive.box<MyPlaylistModel>('my playlistDB')
                                .listenable(),
                        builder: (BuildContext ctx,
                            Box<MyPlaylistModel> playlistBox, child) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: playlistBox.values.length,
                            itemBuilder: (context, index) {
                              MyPlaylistModel playlist =
                                  playlistBox.getAt(index)!;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  onTap: (() {
                                    if (!playlist.isInPlaylist(songId)) {
                                      playlist.add(songId);

                                      final snackBar = SnackBar(
                                          content: Text(
                                              'added to ${playlist.name}'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      const snackBar =  SnackBar(
                                          content:  Text(
                                              'already in playlist'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                    Navigator.of(context).pop();
                                  }),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/10a2d91f65223a83d6a44b038657f6ba.jpg',
                                      fit: BoxFit.cover,
                                      height: 80,
                                      width: 70,
                                    ),
                                  ),
                                  title: Text(
                                    playlist.name,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          );
                        })
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
