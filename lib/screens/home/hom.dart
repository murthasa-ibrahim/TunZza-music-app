import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:my_music/controllers/favourite_controller.dart';
import 'package:my_music/controllers/home_controller.dart';
import 'package:my_music/custom_widgets/fav_button.dart';
import 'package:my_music/custom_widgets/popup_menu.dart';
import 'package:my_music/helper/helper_favourite.dart';
import 'package:my_music/screens/now_playing/now_playing.dart';
import 'package:my_music/helper/utility.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenHome extends GetView<HomeController> {
  ScreenHome({Key? key}) : super(key: key);
  final homeController = Get.put(HomeController());
  final favController = Get.put(FavouriteControlller());
  @override
  Widget build(BuildContext context) {
    return Container(
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: const [PopupMenu()],
          title: const Text(
            'My Music',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          centerTitle: true,
        ),
        body: GetBuilder<HomeController>(
          builder: (controller) {
            return FutureBuilder<List<SongModel>>(
              future: controller.audioQuery.querySongs(
                  sortType: null,
                  orderType: OrderType.ASC_OR_SMALLER,
                  uriType: UriType.EXTERNAL,
                  ignoreCase: true),
              builder: (context, item) {
                if (item.data == null) return const CircularProgressIndicator();
                if (item.data!.isEmpty) {
                  return const Center(
                      child: Text(
                    'No Song found !',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ));
                }

                if (!favController.isInitialised) {
                  favController.initialis(item.data!);
                  Utililty.songsCopy.addAll(item.data!);
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: GridView.builder(
                    itemCount: item.data!.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 3.5,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                    itemBuilder: (ctx, index) {
                      return AnimationConfiguration.staggeredGrid(
                        duration: const Duration(milliseconds: 900),
                        position: index,
                        columnCount: item.data!.length,
                        child: SlideAnimation(
                          child: InkWell(
                            onTap: () {
                              if (Utililty.currentIndex != index) {
                                Utililty.myPlayer.setAudioSource(
                                    Utililty.createSongList(item.data!),
                                    initialIndex: index);
                                Utililty.myPlayer.play();
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return ScreenNowPlaying(
                                    song: item.data!,
                                  );
                                }));
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ScreenNowPlaying(
                                    song: item.data!,
                                  ),
                                ));
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width: 180,
                                    height: 150,
                                    child: QueryArtworkWidget(
                                      id: item.data![index].id,
                                      type: ArtworkType.AUDIO,
                                      artworkBorder: BorderRadius.circular(20),
                                      artworkWidth: 180,
                                      artworkHeight: 150,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.data![index].title,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    FavBtn(
                                      song: item.data![index],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}


