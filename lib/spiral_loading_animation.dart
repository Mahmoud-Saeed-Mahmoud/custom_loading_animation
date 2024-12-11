import 'dart:math';

import 'package:flutter/material.dart';

class SpiralLoadingAnimation extends StatefulWidget {
  const SpiralLoadingAnimation({super.key});

  @override
  SpiralLoadingAnimationState createState() => SpiralLoadingAnimationState();
}

class SpiralLoadingAnimationState extends State<SpiralLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SpiralLoadingPainter(animation: _controller),
      child: const SizedBox(
        width: 150,
        height: 150,
      ),
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
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }
}

class _SpiralLoadingPainter extends CustomPainter {
  final Animation<double> animation;

  _SpiralLoadingPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Draw a spiral
    const totalSpins = 5;
    final maxRadius = size.width / 2;
    for (double t = 0; t < 1; t += 0.01) {
      final angle = totalSpins * 2 * pi * t + animation.value * 2 * pi;
      final radius = maxRadius * t;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      paint.color = Color.lerp(Colors.blue, Colors.purple, t) ?? Colors.blue;
      canvas.drawCircle(Offset(x, y), 2, paint);
    }

    // Rotating particles
    const particleCount = 12;
    final particleRadius = maxRadius / 4 + sin(animation.value * 2 * pi) * 10;
    for (int i = 0; i < particleCount; i++) {
      final angle = (2 * pi / particleCount) * i + animation.value * 2 * pi;
      final particleOffset = Offset(
        center.dx + cos(angle) * particleRadius,
        center.dy + sin(angle) * particleRadius,
      );
      paint.color = Colors.orangeAccent;
      canvas.drawCircle(particleOffset, 5, paint);
    }

    // Expanding concentric circles
    final circlePaint = Paint()
      ..color = Colors.cyan.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    final expandingRadius =
        maxRadius * (0.5 + 0.5 * sin(animation.value * 2 * pi));
    for (double i = 0.1; i <= 1; i += 0.3) {
      canvas.drawCircle(center, expandingRadius * i, circlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
