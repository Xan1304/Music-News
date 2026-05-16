import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/song_models.dart';

class MusicService {
  static const String baseUrl = "http://localhost:3000";

  Future<List<SongModel>> getChartSongs() async {
    final response = await http.get(Uri.parse('$baseUrl/chart'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      List items = data['data']['RTChart']['items'];

      return items.map<SongModel>((e) => SongModel.fromJson(e)).toList();
    }

    throw Exception("Failed to load songs");
  }

  Future<String> getSongUrl(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/song/$id'));

    final data = json.decode(response.body);

    return data['data']['128'];
  }
}
