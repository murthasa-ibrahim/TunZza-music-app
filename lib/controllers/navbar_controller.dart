import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music/screens/favourite/favourite.dart';
import 'package:my_music/screens/home/hom.dart';
import 'package:my_music/screens/search/search.dart';

import '../screens/library/library.dart';

class NavbarController extends GetxController{
    
    
  
   List<Widget> screens = [
    ScreenHome(),
    const ScreenLibrary(),
     ScreenFavourite(),
    ScreenSearch()
  ];

  RxInt selectedIndex = 0.obs;

  @override
  void onInit() {
    
    super.onInit();
  }
}