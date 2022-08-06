// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:my_music/screens/now_playing/now_playing.dart';
import 'package:my_music/helper/utility.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenSearch extends StatelessWidget {
  ScreenSearch({Key? key}) : super(key: key);
  final ValueNotifier<List<SongModel>> temp = ValueNotifier([]);

  final searchController = TextEditingController();

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
        appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: Colors.transparent,
            title: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: TextField(
                  onChanged: (String value) {
                    searchCheck(value);
                  },
                  style: TextStyle(color: Colors.white),
                  controller: searchController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          searchController.clear();
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none),
                ),
              ),
            )),
        body: ValueListenableBuilder(
            valueListenable: temp,
            builder:
                (BuildContext ctx, List<SongModel> searchData, Widget? child) {
              return AnimationLimiter(
                child: ListView.builder(
                  itemBuilder: ((ctx, index) {
                    final data = searchData[index];
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
                                final searchIndex = indexCheck(data);

                                temp.value.addAll(Utililty.songsCopy);

                                FocusScope.of(context).unfocus();
                                if (searchIndex != null) {
                                  Utililty.myPlayer.setAudioSource(
                                      Utililty.createSongList(
                                          Utililty.songsCopy),
                                      initialIndex: searchIndex);
                                }
                                Utililty.myPlayer.play();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: ((context) => ScreenNowPlaying(
                                        song: Utililty.songsCopy))));
                              },
                              leading: QueryArtworkWidget(
                                  id: data.id, type: ArtworkType.AUDIO),
                              title: Text(
                                searchData[index].title,
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
                  itemCount: searchData.length,
                ),
              );
            }),
      ),
    );
  }

  searchCheck(String value) {
    if (value.isEmpty) {
      temp.value.clear();
      temp.value.addAll(Utililty.songsCopy);
    } else {
      temp.value.clear();
      for (SongModel item in Utililty.songsCopy) {
        if (item.title.toLowerCase().contains(value.toLowerCase())) {
          temp.value.add(item);
        }
        temp.notifyListeners();
      }
    }
  }

  int? indexCheck(SongModel data) {
    for (int i = 0; i < Utililty.songsCopy.length; i++) {
      if (data.id == Utililty.songsCopy[i].id) {
        return i;
      }
    }
    return null;
  }
}
