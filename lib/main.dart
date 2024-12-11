import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class BouncingDotsAnimation extends StatefulWidget {
  const BouncingDotsAnimation({super.key});

  @override
  BouncingDotsAnimationState createState() => BouncingDotsAnimationState();
}

class BouncingDotsAnimationState extends State<BouncingDotsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100, 100),
      painter: BouncingDotsPainter(_controller),
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
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }
}

class BouncingDotsPainter extends CustomPainter {
  final Animation<double> animation;

  BouncingDotsPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Define parameters for dots
    final List<double> offsets = [0, 1, 2]; // Three dots
    const double radius = 10;

    for (int i = 0; i < offsets.length; i++) {
      // Calculate the y position based on the animation value
      double yOffset = sin(animation.value * 2 * pi + (i * pi / 1.5)) * 10;
      paint.color = Colors.primaries[i % Colors.primaries.length];

      // Draw the dot
      canvas.drawCircle(
        Offset(size.width / 2 + (i - 1) * 30, size.height / 2 + yOffset),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: BouncingDotsAnimation(),
        ),
      ),
    );
  }
}
