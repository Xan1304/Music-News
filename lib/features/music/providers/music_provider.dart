import 'package:flutter/material.dart';
import '../models/song_models.dart';
import '../services/api_service.dart';
import '../services/audio_service.dart';

class MusicProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final AudioService _audioService = AudioService();

  List<SongModel> songs = [];

  SongModel? currentSong;
  List<SongModel> queue = [];
  bool isLoading = false;
  bool isPlaying = false;
  int currentIndex = -1;
  String? lyricUrl;

  Future<void> loadSongs() async {
    isLoading = true;
    notifyListeners();
    queue = songs;
    songs = await _apiService.getChartSongs();

    isLoading = false;
    notifyListeners();
  }

  Future<void> playSong(SongModel song) async {
    currentIndex = songs.indexOf(song);
    lyricUrl = await _apiService.getLyrics(song.encodeId);
    final streamUrl = await _apiService.getSongStream(song.encodeId);

    if (streamUrl == null) return;

    currentSong = song.copyWith(streamUrl: streamUrl);

    await _audioService.play(streamUrl);

    isPlaying = true;

    notifyListeners();
  }

  Future<void> nextSong() async {
    if (songs.isEmpty) return;

    currentIndex++;

    if (currentIndex >= songs.length) {
      currentIndex = 0;
    }

    await playSong(songs[currentIndex]);
  }

  Future<void> previousSong() async {
    if (songs.isEmpty) return;

    currentIndex--;

    if (currentIndex < 0) {
      currentIndex = songs.length - 1;
    }

    await playSong(songs[currentIndex]);
  }

  Future<void> pauseSong() async {
    await _audioService.pause();

    isPlaying = false;

    notifyListeners();
  }

  Future<void> resumeSong() async {
    await _audioService.resume();

    isPlaying = true;

    notifyListeners();
  }

  Stream<Duration?> get durationStream => _audioService.durationStream;

  Stream<Duration> get positionStream => _audioService.positionStream;

  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
  }

  Future<void> search(String keyword) async {
    if (keyword.trim().isEmpty) return;

    isLoading = true;
    notifyListeners();

    songs = await _apiService.searchSongs(keyword);

    isLoading = false;
    notifyListeners();
  }
}
