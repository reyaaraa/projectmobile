import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const ParuGuardApp());
}

class ParuGuardApp extends StatelessWidget {
  const ParuGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParuGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
