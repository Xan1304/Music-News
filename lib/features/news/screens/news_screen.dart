import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/news_provider.dart';
import '../models/rss_article.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<NewsProvider>().loadNews();
    });
  }

  String _formatTime(String pubDate) {
    try {
      final date = DateTime.parse(pubDate);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} phút trước';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} giờ trước';
      } else {
        return '${difference.inDays} ngày trước';
      }
    } catch (_) {
      return pubDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF8B4A2A);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      body: SafeArea(
        child: Consumer<NewsProvider>(
          builder: (context, provider, child) {
            final articles = provider.filteredArticles;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tin tức',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: primaryBrown,
                        ),
                      ),
                      IconButton(
                        onPressed: () => provider.loadNews(),
                        icon: const Icon(Icons.refresh, color: primaryBrown),
                      ),
                    ],
                  ),
                ),

                // Source Filter Chips
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: provider.availableSources.map((source) {
                        final isSelected = provider.selectedSource == source;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(source),
                            selected: isSelected,
                            selectedColor: primaryBrown.withValues(alpha: 0.15),
                            checkmarkColor: primaryBrown,
                            labelStyle: TextStyle(
                              color: isSelected ? primaryBrown : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            shape: StadiumBorder(
                                side: BorderSide(
                              color: isSelected ? primaryBrown : Colors.grey.shade300,
                            )),
                            onSelected: (_) => provider.setSource(isSelected ? null : source),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Articles List
                Expanded(
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : articles.isEmpty
                          ? const Center(child: Text('Không có tin tức nào'))
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: articles.length,
                              itemBuilder: (context, index) {
                                final article = articles[index];

                                if (index == 0 && provider.selectedSource == null) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: _FeaturedCard(
                                      article: article,
                                      onTap: () => _launchArticle(article.link),
                                    ),
                                  );
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _StandardArticleRow(
                                    article: article,
                                    timeAgo: _formatTime(article.pubDate),
                                    onTap: () => _launchArticle(article.link),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _launchArticle(String link) async {
    final uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _FeaturedCard extends StatelessWidget {
  final RssArticle article;
  final VoidCallback onTap;

  const _FeaturedCard({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Ảnh full width
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: article.thumbnail,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(
                height: 220,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                ),
              ),
            ),
          ),
          // Badge NỔI BẬT
          Positioned(
            left: 12,
            bottom: 60,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFCC2222),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'NỔI BẬT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Tiêu đề
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Text(
              article.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _StandardArticleRow extends StatelessWidget {
  final RssArticle article;
  final String timeAgo;
  final VoidCallback onTap;

  const _StandardArticleRow({
    required this.article,
    required this.timeAgo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag nguồn
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCC2222),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    article.source,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                // Tiêu đề
                Text(
                  article.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(height: 6),
                // Nguồn + thời gian
                Text(
                  '${article.source} • $timeAgo',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: article.thumbnail,
              width: 90,
              height: 70,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(
                width: 90,
                height: 70,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
