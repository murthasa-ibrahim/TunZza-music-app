import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:my_music/models/playlist_model.dart';

import 'package:my_music/screens/splash/splash.dart';

import 'controllers/home_controller.dart';

Future<void> main() async {
  HomeController().requestPermission();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
  await Hive.initFlutter();
  await Hive.openBox<int>('favouriteDB');
  Hive.registerAdapter(MyPlaylistModelAdapter());
  await Hive.openBox<MyPlaylistModel>('my playlistDB');
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('I am worked');
    return const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music Player',
        home: ScreenSplash());
  }
}
