import 'dart:math';

import 'package:flutter/material.dart';

class SpinningLoaderAnimation extends StatefulWidget {
  const SpinningLoaderAnimation({super.key});

  @override
  SpinningLoaderAnimationState createState() => SpinningLoaderAnimationState();
}

class SpinningLoaderAnimationState extends State<SpinningLoaderAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100, 100),
      painter: SpinningLoaderPainter(_controller),
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

class SpinningLoaderPainter extends CustomPainter {
  final Animation<double> animation;

  SpinningLoaderPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Define parameters for segments
    const int numberOfSegments = 8;
    final double radius = size.width / 2;

    for (int i = 0; i < numberOfSegments; i++) {
      // Calculate rotation angle and scale
      double angle =
          animation.value * 2 * pi + (i * (2 * pi / numberOfSegments));
      double scale = 0.5 +
          0.5 * sin(animation.value * 2 * pi + (i * pi / numberOfSegments));

      // Set color for each segment
      paint.color = Colors.primaries[i % Colors.primaries.length];

      // Calculate the position of each segment
      double x = size.width / 2 + (radius * scale) * cos(angle);
      double y = size.height / 2 + (radius * scale) * sin(angle);

      // Draw the segment
      canvas.drawRect(
        Rect.fromCenter(
            center: Offset(x, y), width: 10 * scale, height: 30 * scale),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
