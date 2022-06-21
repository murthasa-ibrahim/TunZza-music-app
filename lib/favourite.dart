import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:my_music/helper_favourite.dart';
import 'package:my_music/now_playing.dart';
import 'package:my_music/utility.dart';

import 'package:on_audio_query/on_audio_query.dart';

class ScreenFavourite extends StatefulWidget {
  const ScreenFavourite({Key? key}) : super(key: key);

  @override
  State<ScreenFavourite> createState() => _ScreenFavouriteState();
}

class _ScreenFavouriteState extends State<ScreenFavourite> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Color.fromARGB(255, 38, 110, 141),
            // Color.fromARGB(255, 3, 47, 85),
            Color.fromARGB(255, 22, 46, 67)
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'Your Favourite',
            style: Utililty.textStyle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ValueListenableBuilder(
            valueListenable: Favourite.favSongs,
            builder: (BuildContext context, List<SongModel> songsList,
                Widget? child) {
              return AnimationLimiter(
                child: ListView.builder(
                  itemCount: songsList.length,
                  itemBuilder: (ctx, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 800),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClipRect(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(.2),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    onTap: () {
                                      List<SongModel> newList = [...songsList];
                                      Utililty.myPlayer.setAudioSource(
                                          Utililty.createSongList(newList),
                                          initialIndex: index);
                                      // newList.addAll(songsList);
                                      Utililty.myPlayer.play();

                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  ScreenNowPlaying(
                                                      song: newList))));
                                    },
                                    leading: QueryArtworkWidget(
                                      artworkFit: BoxFit.fill,
                                      id: songsList[index].id,
                                      type: ArtworkType.AUDIO,
                                      errorBuilder: (context, excepion, gdg) {
                                        return Image.asset('');
                                      },
                                    ),
                                    title: Text(
                                      songsList[index].title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    subtitle: Text(
                                      songsList[index].displayName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5)),
                                    ),
                                    trailing: IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Do you want to remove'),
                                                  actions: [
                                                    ListTile(
                                                      leading: TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      trailing: TextButton(
                                                        onPressed: () {
                                                          Favourite.remove(
                                                              songsList[index]
                                                                  .id);
                                                          setState(() {});
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          'Ok',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        icon: Favourite.isfav(songsList[index])
                                            ? const Icon(
                                                Icons.favorite,
                                                color: Color.fromARGB(
                                                    255, 217, 204, 171),
                                              )
                                            : Icon(
                                                Icons.favorite_border,
                                                color: Utililty.green,
                                                size: 25,
                                              )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
