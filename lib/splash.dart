import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:my_music/hom.dart';
import 'dart:async';
import 'package:my_music/navbar.dart';


class ScreenSplash extends StatefulWidget {
  const ScreenSplash({Key? key}) : super(key: key);

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    super.initState();
  }


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
      nextScreen:const Navbar(),
      
      
    )
      ),
    );
  }
}
