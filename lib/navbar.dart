import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:my_music/favourite.dart';
import 'package:my_music/hom.dart';
import 'package:my_music/library.dart';
import 'package:my_music/now_playing.dart';
import 'package:my_music/search.dart';
import 'package:my_music/utility.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  List<Widget> screens = [
    const ScreenHome(),
    const ScreenLibrary(),
    const ScreenFavourite(),
     ScreenSearch()
  ];
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    Utililty.myPlayer.currentIndexStream.listen((event) {
      if (event != null) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: screens[_selectedIndex],
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          (Utililty.myPlayer.playing ||
                  Utililty.myPlayer.currentIndex != null)&&(Utililty.currentIndex !=-1)
              ? Padding(
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
                          Utililty.myPlayer
                              .seek(const Duration(seconds: 0), index: 0);
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
                          for (int i = 0;
                              i < ScreenNowPlaying.songCopy.length;
                              i++) {
                            songse.add(ScreenNowPlaying.songCopy[i]);
                          }

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) =>
                                  ScreenNowPlaying(song: songse))));
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
                                .songCopy[Utililty.myPlayer.currentIndex!]
                                .title,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                if (Utililty.myPlayer.playing) {
                                  Utililty.myPlayer.pause();
                                } else {
                                  Utililty.myPlayer.play();
                                }
                              });
                            },
                            icon:
                             StreamBuilder<bool>(
                              stream: Utililty.myPlayer.playingStream,
                              builder: (context, snapshot){
                                bool? playingState = snapshot.data;
                                if(playingState != null && playingState){
                                  return const Icon(Icons.pause, size: 27, color: Colors.white70,);
                                }
                                return const Icon(Icons.play_arrow, size: 27, color: Colors.white70,);
                              },
                            ),
                            )
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          FlashyTabBar(
            backgroundColor: Colors.white,
            selectedIndex: _selectedIndex,
            onItemSelected: (index) => setState(() {
              _selectedIndex = index;
            }),
            items: [
              FlashyTabBarItem(
                inactiveColor: const Color.fromARGB(255, 20, 64, 100),
                activeColor: const Color.fromARGB(255, 20, 64, 100),
                icon: const Icon(
                  Icons.music_note,
                ),
                title: const Text('My Music'),
              ),
              FlashyTabBarItem(
                inactiveColor: const Color.fromARGB(255, 20, 64, 100),
                activeColor: const Color.fromARGB(255, 20, 64, 100),
                icon: const Icon(Icons.library_add),
                title: const Text('library'),
              ),
              FlashyTabBarItem(
                inactiveColor: const Color.fromARGB(255, 20, 64, 100),
                activeColor: const Color.fromARGB(255, 20, 64, 100),
                icon: const Icon(Icons.favorite),
                title: const Text('liked songs'),
              ),
              FlashyTabBarItem(
                inactiveColor: const Color.fromARGB(255, 20, 64, 100),
                activeColor: const Color.fromARGB(255, 20, 64, 100),
                icon: const Icon(Icons.search),
                title: const Text('Search'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
