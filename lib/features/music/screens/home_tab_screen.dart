import 'package:flutter/material.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Trang chủ',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF8B4A2A)),
      ),
    );
  }
}
