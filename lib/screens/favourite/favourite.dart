import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:my_music/controllers/favourite_controller.dart';
import 'package:my_music/screens/now_playing/now_playing.dart';
import 'package:my_music/helper/utility.dart';

import 'package:on_audio_query/on_audio_query.dart';

class ScreenFavourite extends GetView {
    ScreenFavourite({Key? key}) : super(key: key);
  final favController = Get.find<FavouriteControlller>();
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
          child: GetBuilder<FavouriteControlller>(
            // valueListenable: Favourite.favSongs,
            builder: (controller) {
              return controller.favSongs.isEmpty
                  ? const Center(child:  Text('No favourites !',style: TextStyle(fontSize: 30,color: Colors.white),))
                  : AnimationLimiter(
                      child: ListView.builder(
                        itemCount: controller.favSongs.length,
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
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(.2),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: ListTile(
                                          onTap: () {
                                            Utililty.myPlayer.stop();
                                            List<SongModel> newList = [
                                              ...controller.favSongs
                                            ];
                                            Utililty.myPlayer.setAudioSource(
                                                Utililty.createSongList(
                                                    newList),
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
                                            id: controller.favSongs[index].id,
                                            type: ArtworkType.AUDIO,
                                            errorBuilder:
                                                (context, excepion, gdg) {
                                              return Image.asset('');
                                            },
                                          ),
                                          title: Text(
                                            controller.favSongs[index].title,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          subtitle: Text(
                                            controller.favSongs[index].displayName,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.5)),
                                          ),
                                          trailing: IconButton(
                                              onPressed: () {
                                                showShowDailog(
                                                    context, controller.favSongs, index);
                                              },
                                              icon: controller.isfav(
                                                      controller.favSongs[index])
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

  Future<void> showShowDailog(
      BuildContext context, List<SongModel> songsList, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Do you want to remove'),
          actions: [
            ListTile(
              leading: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              trailing: TextButton(
                onPressed: () {
                  favController.remove(songsList[index].id);
                  // setState(() {});
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
