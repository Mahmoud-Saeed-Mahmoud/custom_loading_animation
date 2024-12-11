import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: AnimatedCircleLoader(),
        ),
      ),
    ),
  );
}

class AnimatedCircleLoader extends StatefulWidget {
  const AnimatedCircleLoader({super.key});

  @override
  AnimatedCircleLoaderState createState() => AnimatedCircleLoaderState();
}

class AnimatedCircleLoaderPainter extends CustomPainter {
  final Animation<double> animation;

  AnimatedCircleLoaderPainter({required this.animation})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Rotating arc
    const sweepAngle = pi * 1.5;
    final startAngle = -pi / 2 + animation.value * 2 * pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );

    // Pulsating circle
    final pulseRadius = radius / 2 + sin(animation.value * 2 * pi) * 5;
    final pulsePaint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, pulseRadius, pulsePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AnimatedCircleLoaderState extends State<AnimatedCircleLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AnimatedCircleLoaderPainter(animation: _controller),
      child: const SizedBox(
        width: 100,
        height: 100,
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
      duration: const Duration(seconds: 2),
    )..repeat();
  }
}
