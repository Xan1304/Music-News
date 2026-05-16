class SongModel {
  final String encodeId;
  final String title;
  final String artist;
  final String thumbnail;
  final String? streamUrl;
  final int? duration;

  SongModel({
    required this.encodeId,
    required this.title,
    required this.artist,
    required this.thumbnail,
    this.streamUrl,
    this.duration,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    int? parseDuration(dynamic val) {
      if (val == null) return null;
      if (val is int) return val;
      if (val is String) return int.tryParse(val);
      return null;
    }

    return SongModel(
      encodeId: json['encodeId'] ?? '',
      title: json['title'] ?? '',
      artist: json['artistsNames'] ?? '',
      thumbnail: json['thumbnailM'] ?? '',
      duration: parseDuration(json['duration']),
    );
  }

  String get durationFormatted {
    if (duration == null) return '';
    final m = duration! ~/ 60;
    final s = duration! % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  SongModel copyWith({String? streamUrl, int? duration}) {
    return SongModel(
      encodeId: encodeId,
      title: title,
      artist: artist,
      thumbnail: thumbnail,
      streamUrl: streamUrl ?? this.streamUrl,
      duration: duration ?? this.duration,
    );
  }
}
