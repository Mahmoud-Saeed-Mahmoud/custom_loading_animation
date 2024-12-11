import 'dart:math';

import 'package:flutter/material.dart';

class SpiralLinesLoadingAnimation extends StatefulWidget {
  const SpiralLinesLoadingAnimation({super.key});

  @override
  SpiralLinesLoadingAnimationState createState() =>
      SpiralLinesLoadingAnimationState();
}

class SpiralLinesLoadingAnimationState
    extends State<SpiralLinesLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100, 100),
      painter: SpiralLoadingPainter(_animation),
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
    )..repeat(reverse: true); // Enable reverse animation

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }
}

class SpiralLoadingPainter extends CustomPainter {
  final Animation<double> animation;

  SpiralLoadingPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Define parameters for the spiral
    const int numberOfLines = 12;
    final double radius = size.width / 2;

    for (int i = 0; i < numberOfLines; i++) {
      // Calculate angle and distance from center
      double angle = animation.value * 2 * pi + (i * (2 * pi / numberOfLines));
      double distance = radius * animation.value;

      // Set color for each line
      paint.color = Colors.primaries[i % Colors.primaries.length];

      // Calculate the position of each line
      double x = size.width / 2 + distance * cos(angle);
      double y = size.height / 2 + distance * sin(angle);

      // Draw the line
      canvas.drawLine(
        Offset(size.width / 2, size.height / 2),
        Offset(x, y),
        paint..strokeWidth = 4,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
