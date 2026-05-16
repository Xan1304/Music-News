import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/music/providers/music_provider.dart';
import '../features/news/providers/news_provider.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MusicProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music News App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: const Color(0xFF8B4A2A),
            surface: const Color(0xFFF5F0EB),
            onPrimary: Colors.white,
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F0EB),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF5F0EB),
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Color(0xFF8B4A2A),
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Color(0xFF8B4A2A)),
          ),
        ),
        home: const MainNavigationScreen(),
      ),
    );
  }
}
