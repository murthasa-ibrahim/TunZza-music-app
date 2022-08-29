import 'package:get/get.dart';
import 'package:my_music/helper/utility.dart';

class NowPlayingController extends GetxController{

  int currentIndex = 0;
   

void changeCurrentIndex(){
    Utililty.myPlayer.currentIndexStream.listen((index) {
      
        if (index != null) {
          currentIndex = index;
          Utililty.currentIndex = index;
          update();
        }
        
    });
}



  @override
  void onInit() {
    changeCurrentIndex();
   
    super.onInit();
  }
}