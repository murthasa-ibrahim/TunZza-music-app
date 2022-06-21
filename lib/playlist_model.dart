import 'package:hive_flutter/hive_flutter.dart';

part 'playlist_model.g.dart';

@HiveType(typeId: 1)
class MyPlaylistModel extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  List<int> songIds;

  MyPlaylistModel({required this.name, required this.songIds});

  add(int id) {
    songIds.add(id);
    save();
  }

  remove(int id) {
    songIds.remove(id);
    save();
  }
       
  bool isInPlaylist(int id) {
   return songIds.contains(id);
  }
  
  
}
