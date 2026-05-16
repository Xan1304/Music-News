import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Cài đặt',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF8B4A2A)),
      ),
    );
  }
}
