import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music/controllers/favourite_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavBtn extends StatefulWidget {
  final favController = Get.find<FavouriteControlller>();
  FavBtn({
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
     
    return 
    IconButton(
      onPressed: () {
        if (widget.favController.isfav(widget.song)) {
          widget.favController.remove(widget.song.id);
          const snackBar = SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              'removed from favourite',
              style: TextStyle(color: Colors.black),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          widget.favController.add(widget.song);
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
      icon: widget.favController.isfav(widget.song)
          ? const Icon(
              Icons.favorite,
              color: Color.fromARGB(255, 217, 204, 171),
            )
          : const Icon(
              Icons.favorite_outline,
              color: Colors.white,
            ),
    );
  }

  void method(){
    
  }
}
