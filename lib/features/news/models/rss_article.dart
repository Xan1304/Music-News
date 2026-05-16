class RssArticle {
  final String title;
  final String link;
  final String pubDate;
  final String thumbnail;
  final String description;
  final String source;

  RssArticle({
    required this.title,
    required this.link,
    required this.pubDate,
    required this.thumbnail,
    required this.description,
    required this.source,
  });

  RssArticle copyWith({
    String? title,
    String? link,
    String? pubDate,
    String? thumbnail,
    String? description,
    String? source,
  }) {
    return RssArticle(
      title: title ?? this.title,
      link: link ?? this.link,
      pubDate: pubDate ?? this.pubDate,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      source: source ?? this.source,
    );
  }
}
