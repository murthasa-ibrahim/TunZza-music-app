// import 'package:flutter/cupertino.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:my_music/models/playlist_model.dart';
// import 'package:my_music/helper/utility.dart';
// import 'package:on_audio_query/on_audio_query.dart';

// class Favourite {
//   static bool isInitialised = false;
//   static final box = Hive.box<int>('favouriteDB');
//   static ValueNotifier<List<SongModel>> favSongs = ValueNotifier([]);
//   static initialis(List<SongModel> songs) {
//     for (SongModel song in songs) {
//       if (isfav(song)) {
//         favSongs.value.add(song);
//       }
//     }
//     isInitialised = true;
//   }

//   static add(SongModel song) async {
//     box.add(song.id);
//     favSongs.value.add(song);
//   }

//   static remove(int id) {
//     int dkey = 0;
//     if (!box.values.contains(id)) {
//       return;
//     }

//     final Map<dynamic, int> favouriteMap = box.toMap();

//     favouriteMap.forEach((key, value) {
//       if (value == id) {
//         dkey = key;
//       }
//     });
//     box.delete(dkey);
//     favSongs.value.removeWhere((song) => song.id == id);
//   }

//   static bool isfav(SongModel song) {
//     if (box.values.contains(song.id)) {
//       return true;
//     }

//     return false;
//   }

//   static dbClear() {
//     if(Utililty.myPlayer.playing){
//       Utililty.myPlayer.stop();
//     }
//     Utililty.currentIndex = -1;
//    box.clear();
//    favSongs.value.clear();
//     final plylstDB = Hive.box<MyPlaylistModel>('my playlistDB');
//     plylstDB.clear();
  
//   }
// }
