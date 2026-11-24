import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const BandungSpot());
}

class BandungSpot extends StatelessWidget {
  const BandungSpot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BandungSpot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}