import 'package:get/get.dart';
import 'package:my_music/helper/utility.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchController extends GetxController{
  List<SongModel> searchResult = [];


    searchCheck(String value) {
    if (value.isEmpty) {
      searchResult = Utililty.songsCopy;
    } else {
      searchResult = Utililty.songsCopy
          .where((song) =>
              song.title.toLowerCase().startsWith(value.toLowerCase()))
          .toList();
    }
    update();
  }

}