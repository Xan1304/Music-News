import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer player = AudioPlayer();

  Stream<Duration?> get durationStream => player.durationStream;

  Stream<Duration> get positionStream => player.positionStream;

  Future<void> play(String url) async {
    await player.setUrl(url);
    await player.play();
  }

  Future<void> pause() async {
    await player.pause();
  }

  Future<void> resume() async {
    await player.play();
  }

  Future<void> seek(Duration position) async {
    await player.seek(position);
  }
}
