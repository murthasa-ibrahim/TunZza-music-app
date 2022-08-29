import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeController extends GetxController {
  
  final OnAudioQuery audioQuery = OnAudioQuery();

  requestPermission() async {
    log('problem resolved ');
    if (!kIsWeb) {
      log('does\'t have permission 1');
      bool permissionStatus = await audioQuery.permissionsStatus();
      if (!permissionStatus) {
        log('does\'t have permission ');
        await audioQuery.permissionsRequest();
      }
      update();
    }
  }
}
