import 'package:flutter/material.dart';
import '../models/rss_article.dart';
import '../services/rss_service.dart';

class NewsProvider extends ChangeNotifier {
  final RssService _rssService = RssService();

  List<RssArticle> articles = [];
  bool isLoading = false;
  String? selectedSource; // null = hiện tất cả

  List<RssArticle> get filteredArticles {
    if (selectedSource == null) return articles;
    return articles.where((a) => a.source == selectedSource).toList();
  }

  List<String> get availableSources {
    return articles.map((a) => a.source).toSet().toList();
  }

  void setSource(String? source) {
    selectedSource = source;
    notifyListeners();
  }

  Future<void> loadNews() async {
    isLoading = true;
    notifyListeners();

    articles = await _rssService.getNews();

    isLoading = false;
    notifyListeners();
  }
}
