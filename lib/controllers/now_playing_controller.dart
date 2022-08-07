import 'package:get/get.dart';
import 'package:my_music/helper/utility.dart';

class NowPlayingController extends GetxController{

  int currentIndex = 0;
   

void changeCurrentIndex(){}



  @override
  void onInit() {
    
    Utililty.myPlayer.currentIndexStream.listen((index) {
      
        if (index != null) {
          currentIndex = index;
          Utililty.currentIndex = index;
          update();
        }
        
    });
    super.onInit();
  }
}