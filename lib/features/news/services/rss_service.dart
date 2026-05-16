import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import '../models/rss_article.dart';

class RssService {
  final Map<String, String> feeds = {
    'VnExpress': 'https://vnexpress.net/rss/tin-moi-nhat.rss',
    'Giải trí (VnE)': 'https://vnexpress.net/rss/giai-tri.rss',
    'Tuổi Trẻ': 'https://tuoitre.vn/rss/tin-moi-nhat.rss',
  };

  Future<List<RssArticle>> getNews() async {
    List<RssArticle> articles = [];

    for (final entry in feeds.entries) {
      try {
        final response = await http.get(Uri.parse(entry.value));
        if (response.statusCode == 200) {
          final feed = RssFeed.parse(utf8.decode(response.bodyBytes));
          final items = feed.items ?? [];
          articles.addAll(items.map((item) => _mapItem(item, entry.key)).toList());
        }
      } catch (e) {
        print('Error fetching RSS from ${entry.key}: $e');
      }
    }

    // Attempt to parse dates for better sorting
    articles.sort((a, b) {
      try {
        final dateA = DateTime.parse(a.pubDate);
        final dateB = DateTime.parse(b.pubDate);
        return dateB.compareTo(dateA);
      } catch (_) {
        return b.pubDate.compareTo(a.pubDate);
      }
    });

    return articles;
  }

  RssArticle _mapItem(RssItem item, String source) {
    final description = item.description ?? '';
    final imageRegex = RegExp(r'<img[^>]+src="([^"]+)"');
    final match = imageRegex.firstMatch(description);
    final imageUrl = match?.group(1) ?? '';

    return RssArticle(
      title: item.title ?? '',
      link: item.link ?? '',
      pubDate: item.pubDate?.toString() ?? '',
      thumbnail: imageUrl,
      description: description,
      source: source,
    );
  }
}
