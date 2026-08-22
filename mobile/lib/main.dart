import 'package:flutter/material.dart';

import 'pages/home_page.dart';


void main() {
  runApp(const PlantIdentifierApp());
}


class PlantIdentifierApp extends StatelessWidget {
  const PlantIdentifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plant Identifier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}