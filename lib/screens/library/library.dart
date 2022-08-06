

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_music/screens/library/playlist.dart';

import 'package:my_music/models/playlist_model.dart';

import 'package:my_music/helper/utility.dart';

class ScreenLibrary extends StatelessWidget {
  const ScreenLibrary({Key? key}) : super(key: key);

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
        ]
      )
      ),
      
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Your Library',
            style: Utililty.textStyle,
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    ' New Playlist',
                    style:   TextStyle(fontSize: 25,color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            final _playlistNameController =
                                TextEditingController();
                            return AlertDialog(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.0))),
                              title: const Text(' Playlist Name',style: TextStyle(color:Color.fromARGB(255, 16, 62, 99), ),),
                              content: TextFormField(
                                controller: _playlistNameController,
                                decoration:
                                    const InputDecoration(hintText: 'name'),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      if (_playlistNameController
                                          .text.isEmpty) {
                                        return;
                                      } else {
                                        final data =
                                            _playlistNameController.text;
                            
                                        List<int> songs = [];
                                        Hive.box<MyPlaylistModel>(
                                                'my playlistDB')
                                            .add(MyPlaylistModel(
                                                name: data, songIds: songs));
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text(
                                      'Create',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 16, 62, 99),
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            );
                          });
                    },
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    color: Colors.white60
                  )
                ],
              ),
              ValueListenableBuilder(
                  valueListenable:
                      Hive.box<MyPlaylistModel>('my playlistDB').listenable(),
                  builder: (BuildContext ctx, Box<MyPlaylistModel> playlistBox,
                      chiled) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: playlistBox.values.length,
                          itemBuilder: (context, index) {
                            MyPlaylistModel playlist =
                                playlistBox.getAt(index)!;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                onTap: () {
                                 
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ScreenPlaylist(playlist: playlist)));
                                },
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
                                      fontSize: 20, color: Colors.white),
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
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Cancel',
                                                  style:  TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                              trailing: TextButton(
                                                onPressed: () {
                                                  playlist.delete();
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Ok',
                                                  style:  TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                      },
                                    icon: const Icon(
                                      Icons.delete,
                                    ),color: Colors.white.withOpacity(.4),),
                              ),
                            );
                          }),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
