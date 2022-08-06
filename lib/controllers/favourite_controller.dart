import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_music/helper/utility.dart';
import 'package:my_music/models/playlist_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavouriteControlller extends GetxController{

   bool isInitialised = false;
   ///////////////////////////
   
   final box = Hive.box<int>('favouriteDB');
   ///////////////////////////
   
  List<SongModel> favSongs = [];

  ///////////////////////////
  
   initialis(List<SongModel> songs) {
    for (SongModel song in songs) {
      if (isfav(song)) {
        favSongs.add(song);
      }
    }
    isInitialised = true;
    update();
  }
 
  ///////////////////////////////
  
   add(SongModel song) async {
    box.add(song.id);
    favSongs.add(song);
    update();
  }
   
  ////////////////////////////// 
  
   remove(int id) {
    int dkey = 0;
    if (!box.values.contains(id)) {
      return;
    }

    final Map<dynamic, int> favouriteMap = box.toMap();

    favouriteMap.forEach((key, value) {
      if (value == id) {
        dkey = key;
      }
    });
    box.delete(dkey);
    favSongs.removeWhere((song) => song.id == id);
    update();
  }

/////////////////////////////////////////////////


   bool isfav(SongModel song) {
    if (box.values.contains(song.id)) {
      return true;
    }

    return false;
  }

///////////////////////////////////////////


   dbClear() {
    if(Utililty.myPlayer.playing){
      Utililty.myPlayer.stop();
    }
    Utililty.currentIndex = -1;
   box.clear();
   favSongs.clear();
    final plylstDB = Hive.box<MyPlaylistModel>('my playlistDB');
    plylstDB.clear();
  
  }
  
} 