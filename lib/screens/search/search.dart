// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:my_music/controllers/search_controller.dart';
import 'package:my_music/screens/now_playing/now_playing.dart';
import 'package:my_music/helper/utility.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenSearch extends StatelessWidget {
  ScreenSearch({Key? key}) : super(key: key);
   
  final searchController = TextEditingController();
  final sController = Get.put(SearchController());
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
            Color.fromARGB(255, 38, 110, 141),
            Color.fromARGB(255, 22, 46, 67)
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  
                  onChanged: (value) => sController.searchCheck(value),
                  decoration: InputDecoration(
                    
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      fillColor: Color.fromARGB(255, 10, 56, 93),
                      filled: true,
                      suffixIcon: IconButton(
                        onPressed: () {
                          searchController.clear();
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                      hintText: 'search',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                ),
              ),
              Expanded(
                child: GetBuilder<SearchController>(builder: (controller) {
                  return AnimationLimiter(
                    child: ListView.builder(
                      itemBuilder: ((ctx, index) {
                        final data = controller.searchResult[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 800),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  onTap: () {
                                    Utililty.myPlayer.stop();
                                    FocusScope.of(context).unfocus();

                                    Utililty.myPlayer.setAudioSource(
                                        Utililty.createSongList(
                                            controller.searchResult),
                                        initialIndex: index);

                                    Utililty.myPlayer.play();
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                ScreenNowPlaying(
                                                    song: controller
                                                        .searchResult))));
                                  },
                                  leading: QueryArtworkWidget(
                                      id: data.id, type: ArtworkType.AUDIO),
                                  title: Text(
                                    controller.searchResult[index].title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      itemCount: controller.searchResult.length,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
