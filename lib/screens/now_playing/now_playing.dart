import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music/controllers/now_playing_controller.dart';
import 'package:my_music/custom_widgets/app_bar.dart';
import 'package:my_music/custom_widgets/fav_button.dart';

import 'package:my_music/helper/utility.dart';
import 'package:my_music/screens/now_playing/bottom_sheet.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class ScreenNowPlaying extends StatefulWidget {
  ScreenNowPlaying({Key? key, required this.song}) : super(key: key);
  final nowplayinController = Get.put(NowPlayingController());
  List<SongModel> song;
  static List<SongModel> songCopy = [];
  @override
  State<ScreenNowPlaying> createState() => _ScreenNowPlayingState();
}

class _ScreenNowPlayingState extends State<ScreenNowPlaying> {
  // String currentSongTitle = '';
  // int currentIndex = 0;
  bool isPlaying = true;
  @override
  void initState() {
    // Get.find<FavouriteControlller>() .isfav(widget.song[currentIndex]);
    super.initState();
    // Utililty.myPlayer.playerStateStream.listen((event) {
    //   if (widget.song.isEmpty) {
    //     Utililty.myPlayer.stop();
    //   }

    //     // isPlaying = Utililty.myPlayer.playing;

    // });

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
                const CustomAppBar(),
                GetBuilder<NowPlayingController>(builder: (controller) {
                  return Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 140,
                        child: QueryArtworkWidget(
                          artworkFit: BoxFit.cover,
                          id: widget.song[controller.currentIndex].id,
                          type: ArtworkType.AUDIO,
                          artworkBorder: BorderRadius.circular(150.0),
                          artworkWidth: MediaQuery.of(context).size.width * 0.8,
                          artworkHeight:
                              MediaQuery.of(context).size.width * 0.8,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.song[controller.currentIndex].title,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  );
                }),
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
                                      bottemsheet(
                                          widget
                                              .song[widget.nowplayinController
                                                  .currentIndex]
                                              .id,
                                          context);
                                    },
                                    icon: const Icon(Icons.playlist_add)),
                                FavBtn(
                                    song: widget.song[widget
                                        .nowplayinController.currentIndex]),
                                IconButton(
                                  onPressed: () {
                                    shoufleCheck();
                                  },
                                  icon: const Icon(
                                    Icons.shuffle_outlined,
                                  ),
                                ),
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
                                  child: StreamBuilder<bool>(
                                    stream: Utililty.myPlayer.playingStream,
                                    builder: (context, snapshot) {
                                      bool? playingState = snapshot.data;
                                      if (playingState != null &&
                                          playingState) {
                                        return const Icon(
                                          Icons.pause_circle_filled,
                                          size: 35,
                                          color: Colors.black,
                                        );
                                      }
                                      return const Icon(
                                        Icons.play_circle_filled,
                                        size: 35,
                                        color: Colors.black,
                                      );
                                    },
                                  ),
                                ),
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

  Stream<DurationState> get _durationStateStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, DurationState>(
          Utililty.myPlayer.positionStream,
          Utililty.myPlayer.durationStream,
          (position, duration) => DurationState(
              position: position, total: duration ?? Duration.zero));
}

class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
