import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import '../providers/music_provider.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    // Sync rotation with playback state
    final provider = context.read<MusicProvider>();
    if (provider.isPlaying) {
      _rotationController.repeat();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF8B4A2A);
    const backgroundCream = Color(0xFFF5F0EB);

    return Scaffold(
      backgroundColor: backgroundCream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              "ĐANG PHÁT TỪ PLAYLIST",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: primaryBrown.withValues(alpha: 0.7),
                letterSpacing: 1.2,
              ),
            ),
            Consumer<MusicProvider>(
              builder: (context, provider, _) => Text(
                provider.currentSong?.title ?? "",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryBrown,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<MusicProvider>(
        builder: (context, provider, child) {
          final song = provider.currentSong;

          if (song == null) {
            return const Center(child: Text("No song selected"));
          }

          // Handle rotation animation
          if (provider.isPlaying) {
            if (!_rotationController.isAnimating) {
              _rotationController.repeat();
            }
          } else {
            _rotationController.stop();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(),
                // Circular Album Art
                Center(
                  child: RotationTransition(
                    turns: _rotationController,
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          song.thumbnail,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Title and Artist
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            song.artist,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.black54),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.playlist_add, color: Colors.black54),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Progress Bar
                StreamBuilder<Duration>(
                  stream: provider.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    return StreamBuilder<Duration?>(
                      stream: provider.durationStream,
                      builder: (context, snapshot) {
                        final duration = snapshot.data ?? Duration.zero;
                        return ProgressBar(
                          progress: position,
                          total: duration,
                          onSeek: (value) => provider.seek(value),
                          baseBarColor: Colors.black12,
                          progressBarColor: primaryBrown,
                          bufferedBarColor: primaryBrown.withValues(alpha: 0.2),
                          thumbColor: primaryBrown,
                          thumbRadius: 6,
                          timeLabelTextStyle: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shuffle, color: Colors.black54),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_previous_rounded, size: 40, color: Colors.black87),
                      onPressed: () => provider.previousSong(),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (provider.isPlaying) {
                          provider.pauseSong();
                        } else {
                          provider.resumeSong();
                        }
                      },
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryBrown,
                        ),
                        child: Icon(
                          provider.isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                          size: 48,
                          color: backgroundCream,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next_rounded, size: 40, color: Colors.black87),
                      onPressed: () => provider.nextSong(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.repeat, color: Colors.black54),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Bottom Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _bottomAction(Icons.lyrics_outlined, "Lyrics"),
                    _bottomAction(Icons.devices_other, "Devices"),
                    _bottomAction(Icons.queue_music, "Queue"),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _bottomAction(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.black54, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
