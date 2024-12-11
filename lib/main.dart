import 'package:flutter/material.dart';

import 'spiral_lines_loading_animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: SpiralLinesLoadingAnimation(),
        ),
      ),
    );
  }
}
