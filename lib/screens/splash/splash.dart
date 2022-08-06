import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music/screens/navbar/navbar.dart';

class ScreenSplash extends GetView {
  const ScreenSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedSplashScreen(
          splashIconSize: 150,
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.black,
          duration: 3000,
          splash: 'assets/play_store_512.png',
          nextScreen:  Navbar(),
        ),
      ),
    );
  }
}
