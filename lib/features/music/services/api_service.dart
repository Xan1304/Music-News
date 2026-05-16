import 'package:dio/dio.dart';
import '../models/song_models.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api'));

  Future<List<SongModel>> getChartSongs() async {
    final response = await _dio.get('/chart-home');

    final items = response.data['data']['RTChart']['items'] as List;

    return items.map((e) => SongModel.fromJson(e)).toList();
  }

  Future<String?> getSongStream(String songId) async {
    final response = await _dio.get('/song', queryParameters: {'id': songId});

    final data = response.data['data'];

    return data['128'];
  }

  Future<List<SongModel>> searchSongs(String keyword) async {
    final response = await _dio.get(
      '/search',
      queryParameters: {'keyword': keyword},
    );

    final songs = response.data['data']['songs'] as List;

    return songs.map((e) => SongModel.fromJson(e)).toList();
  }

  Future<String?> getLyrics(String songId) async {
    final response = await _dio.get('/lyric', queryParameters: {'id': songId});

    return response.data['data']['file'];
  }
}
