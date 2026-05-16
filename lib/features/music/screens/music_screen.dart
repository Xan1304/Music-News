import 'package:flutter/material.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Âm nhạc',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF8B4A2A)),
      ),
    );
  }
}
