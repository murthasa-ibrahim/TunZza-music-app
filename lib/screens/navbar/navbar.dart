import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music/controllers/navbar_controller.dart';
import 'package:my_music/custom_widgets/mini_player.dart';
import 'package:my_music/helper/utility.dart';

class Navbar extends GetView {
   Navbar({Key? key}) : super(key: key);
 
 final nController = Get.put(NavbarController()); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:Obx(() => nController.screens[nController.selectedIndex.value]) ,
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          (Utililty.myPlayer.playing ||
                      Utililty.myPlayer.currentIndex != null) &&
                  (Utililty.currentIndex != -1)
              ? const MiniPlayer()
              : const SizedBox(),
          Obx(() => 
             FlashyTabBar(
              backgroundColor: Colors.white,
              selectedIndex: nController.selectedIndex.value,
              onItemSelected: (index) => 
                nController.selectedIndex.value = index,
              
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
          ),
        ],
      ),
    );
  }
}
