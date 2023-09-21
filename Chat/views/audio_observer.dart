import 'package:audioplayers/audioplayers.dart';
import 'package:get/get_navigation/src/routes/observers/route_observer.dart';

class AudioPlayerObserver extends GetObserver {
  final AudioPlayer audioPlayer;

  AudioPlayerObserver(this.audioPlayer);

  @override
  void onDetached() {
    print("ondetached ....");
    audioPlayer.stop();
  }
}