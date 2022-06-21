import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:my_music/about.dart';

import 'package:my_music/helper_favourite.dart';

import 'package:my_music/now_playing.dart';
import 'package:my_music/splash.dart';
import 'package:my_music/utility.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  @override
  void initState() {
    super.initState();
    requeatPermission();
  }

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
          actions: [
            PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => const ScreenAbout())));
                            },
                            child: const Text("About")),
                      ),
                      PopupMenuItem(
                        child: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text(
                                            'Do you really want to reset your app'),
                                        actions: [
                                          ListTile(
                                            leading: TextButton(
                                              onPressed: (() =>
                                                  Navigator.of(context).pop()),
                                              child: const Text('Cancel'),
                                            ),
                                            trailing: TextButton(
                                              onPressed: (() {
                                                Favourite.dbClear();
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: ((context) =>
                                                            const ScreenSplash())));
                                              }),
                                              child: const Text('Ok'),
                                            ),
                                          )
                                        ],
                                      ));
                            },
                            child: const Text(
                              "Rest App",
                            )),
                      ),
                    ])
          ],
          title: const Text(
            'My Music',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: FutureBuilder<List<SongModel>>(
              future: audioQuery.querySongs(
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

                if (!Favourite.isInitialised) {
                  Favourite.initialis(item.data!);
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
                            columnCount:item.data!.length,
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
                                          style:
                                              const TextStyle(color: Colors.white),
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
                      }),
                );
              }),
        ),
      ),
    );
  }

  void requeatPermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }
}

class FavBtn extends StatefulWidget {
  const FavBtn({
    Key? key,
    required this.song,
  }) : super(key: key);
  final SongModel song;
  @override
  State<FavBtn> createState() => _FavBtnState();
}

class _FavBtnState extends State<FavBtn> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          if (Favourite.isfav(widget.song)) {
            Favourite.remove(widget.song.id);
            const snackBar = SnackBar(
                backgroundColor: Colors.white,
                content: Text(
                  'removed from favourite',
                  style: TextStyle(color: Colors.black),
                ));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            Favourite.add(widget.song);
            const snackBar = SnackBar(
                backgroundColor: Colors.white,
                content: Text(
                  'added to favourite',
                  style: TextStyle(color: Colors.black),
                ));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          setState(() {});
        },
        icon: Favourite.isfav(widget.song)
            ? const Icon(
                Icons.favorite,
                color: Color.fromARGB(255, 217, 204, 171),
              )
            : const Icon(
                Icons.favorite_outline,
                color: Colors.white,
              ));
  }
}
