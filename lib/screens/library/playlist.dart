import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_music/screens/now_playing/now_playing.dart';
import 'package:my_music/models/playlist_model.dart';
import 'package:my_music/helper/utility.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenPlaylist extends StatefulWidget {
  const ScreenPlaylist({
    required this.playlist,
    Key? key,
  }) : super(key: key);
  final MyPlaylistModel playlist;

  @override
  State<ScreenPlaylist> createState() => _ScreenPlaylistState();
}

class _ScreenPlaylistState extends State<ScreenPlaylist>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late List<SongModel> plylstSongs;
  @override
  void initState() {
    controller = BottomSheet.createAnimationController(this);
    controller.duration = const Duration(seconds: 1);
    super.initState();
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
            Color.fromARGB(255, 22, 46, 67)
          ])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      padding: const EdgeInsets.only(top: 6, bottom: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(.2)),
                      child: Row(
                        children: [
                          IconButton(
                              color: Colors.white,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                              )),
                          const SizedBox(
                            width: 50,
                          ),
                          const Text(
                            'Add New Song',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: (() {
                              bottemSheet();
                            }),
                            icon: const Icon(Icons.add_circle),
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                      child: ValueListenableBuilder(
                          valueListenable:
                              Hive.box<MyPlaylistModel>('my playlistDB')
                                  .listenable(),
                          builder: (BuildContext ctx,
                              Box<MyPlaylistModel> plyBox, child) {
                            plylstSongs =
                                listPlayListSongs(widget.playlist.songIds);

                            return AnimationLimiter(
                              child: ListView.builder(
                                itemCount: plylstSongs.length,
                                itemBuilder: ((context, index) {
                                  return Builder(builder: (context) {
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 800),
                                      child: SlideAnimation(
                                         verticalOffset: 50.0,
                                        child: FadeInAnimation(
                                          child: ClipRect(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 10, sigmaY: 10),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          vertical: 7),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(.2),
                                                      borderRadius:
                                                          BorderRadius.circular(8)),
                                                  child: ListTile(
                                                    onTap: () async {
                                                      Utililty.myPlayer.stop();
                                                      await Utililty.myPlayer
                                                          .setAudioSource(
                                                              Utililty
                                                                  .createSongList(
                                                                      plylstSongs),
                                                              initialIndex: index);
                                                      Utililty.myPlayer.play();
                                                                              
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ScreenNowPlaying(
                                                                      song:
                                                                          plylstSongs)));
                                                    },
                                                    leading: QueryArtworkWidget(
                                                      id: plylstSongs[index].id,
                                                      type: ArtworkType.AUDIO,
                                                    ),
                                                    title: Text(
                                                      plylstSongs[index].title,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    trailing: IconButton(
                                                        icon: const Icon(
                                                          Icons.remove,
                                                        ),
                                                        onPressed: (() {
                                                          setState(() {
                                                            widget.playlist.songIds
                                                                .removeAt(index);
                                                            plyBox.listenable();
                                                          });
                                                        })),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                                }),
                              ),
                            );
                          })),
                ],
              ),
            ),
          )),
    );
  }

  List<SongModel> listPlayListSongs(List<int> ids) {
    List<SongModel> plsongs = [];

    for (int i = 0; i < Utililty.songsCopy.length; i++) {
      for (int j = 0; j < ids.length; j++) {
        if (Utililty.songsCopy[i].id == ids[j]) {
          plsongs.add(Utililty.songsCopy[i]);
        }
      }
    }
    return plsongs;
  }

  bottemSheet() {
    showModalBottomSheet(
        transitionAnimationController: controller,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: StatefulBuilder(builder: (context, setState) {
                return ListView.builder(
                    itemCount: Utililty.songsCopy.length,
                    itemBuilder: ((context, index) {
                      final song = Utililty.songsCopy[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white.withOpacity(.2)),
                          child: ListTile(
                            leading: QueryArtworkWidget(
                                id: song.id, type: ArtworkType.AUDIO),
                            title: Text(
                              song.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (!widget.playlist.isInPlaylist(song.id)) {
                                    widget.playlist.add(song.id);
                                  } else {
                                    widget.playlist.remove(song.id);
                                  }
                                });
                              },
                              icon: widget.playlist.isInPlaylist(song.id)
                                  ? const Icon(
                                      Icons.remove,
                                      color: Colors.red,
                                    )
                                  : const Icon(Icons.add),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }));
              }),
            ),
          );
        }).whenComplete(() {
      setState(() {});
    });
  }
}
