import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: PulsatingLoadingAnimation(),
      ),
    ),
  ));
}

class PulsatingLoadingAnimation extends StatefulWidget {
  const PulsatingLoadingAnimation({super.key});

  @override
  PulsatingLoadingAnimationState createState() =>
      PulsatingLoadingAnimationState();
}

class PulsatingLoadingAnimationState extends State<PulsatingLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PulsatingLoadingPainter(animation: _controller),
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

class PulsatingLoadingPainter extends CustomPainter {
  final Animation<double> animation;

  PulsatingLoadingPainter({required this.animation})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Draw rotating arcs
    final arcPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    final startAngle = -pi / 2 + animation.value * 2 * pi;
    for (int i = 0; i < 3; i++) {
      final angleOffset = (2 * pi / 3) * i;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + angleOffset,
        pi / 2,
        false,
        arcPaint,
      );
    }

    // Draw pulsating circles
    final pulsePaint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 6; i++) {
      final angle = (2 * pi / 6) * i;
      final offset = Offset(
        center.dx + cos(angle) * (radius + sin(animation.value * 2 * pi) * 10),
        center.dy + sin(angle) * (radius + sin(animation.value * 2 * pi) * 10),
      );
      canvas.drawCircle(offset, 5, pulsePaint);
    }

    // Draw expanding and contracting central shape
    final shapeRadius = radius / 4 + sin(animation.value * 2 * pi) * 10;
    final shapePaint = Paint()
      ..color = Colors.blue.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (2 * pi / 5) * i;
      final x = center.dx + cos(angle) * shapeRadius;
      final y = center.dy + sin(angle) * shapeRadius;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, shapePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
