import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_music/models/playlist_model.dart';

void bottemsheet(int songId, BuildContext context) {
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
                            final _textController = TextEditingController();
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
                                      Hive.box<MyPlaylistModel>('My playlistDB')
                                          .add(MyPlaylistModel(
                                              name: _textController.text,
                                              songIds: songIds));
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text(
                                    'Create',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.add),
                      color: Colors.white,
                    )
                  ],
                ),
                ValueListenableBuilder(
                    valueListenable:
                        Hive.box<MyPlaylistModel>('my playlistDB').listenable(),
                    builder: (BuildContext ctx,
                        Box<MyPlaylistModel> playlistBox, child) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: playlistBox.values.length,
                        itemBuilder: (context, index) {
                          MyPlaylistModel playlist = playlistBox.getAt(index)!;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: (() {
                                if (!playlist.isInPlaylist(songId)) {
                                  playlist.add(songId);

                                  final snackBar = SnackBar(
                                      content:
                                          Text('added to ${playlist.name}'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  const snackBar = SnackBar(
                                      content: Text('already in playlist'));
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
    },
  );
}
