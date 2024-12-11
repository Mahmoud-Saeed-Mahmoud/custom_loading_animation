import 'dart:math';

import 'package:flutter/material.dart';

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
          child: WaveLoadingAnimation(),
        ),
      ),
    );
  }
}

class WaveLoadingAnimation extends StatefulWidget {
  const WaveLoadingAnimation({super.key});

  @override
  WaveLoadingAnimationState createState() => WaveLoadingAnimationState();
}

class WaveLoadingAnimationState extends State<WaveLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100, 100),
      painter: WaveLoadingPainter(_controller),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }
}

class WaveLoadingPainter extends CustomPainter {
  final Animation<double> animation;

  WaveLoadingPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Define parameters for the wave
    const int numberOfLines = 5;
    const double waveHeight = 20.0;
    final double spacing = size.width / (numberOfLines + 1);

    for (int i = 0; i < numberOfLines; i++) {
      // Calculate the y position based on the animation value
      double yOffset =
          sin(animation.value * 2 * pi + (i * pi / 2)) * waveHeight;

      // Set color for each line
      paint.color = Colors.primaries[i % Colors.primaries.length];

      // Draw the line
      canvas.drawLine(
        Offset((i + 1) * spacing, size.height / 2 + yOffset),
        Offset((i + 1) * spacing, size.height / 2 - waveHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
