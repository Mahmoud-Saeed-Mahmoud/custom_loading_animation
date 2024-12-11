import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class LoadingAnimationState extends State<SquareWaveLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100, 100),
      painter: SquareWaveLoadingPainter(_controller),
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
    )..repeat(reverse: true);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: SquareWaveLoadingAnimation(),
        ),
      ),
    );
  }
}

class SquareWaveLoadingAnimation extends StatefulWidget {
  const SquareWaveLoadingAnimation({super.key});

  @override
  LoadingAnimationState createState() => LoadingAnimationState();
}

class SquareWaveLoadingPainter extends CustomPainter {
  final Animation<double> animation;

  SquareWaveLoadingPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Define parameters for circles
    final List<double> radii = [20, 30, 40, 50];
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
    ];

    // Calculate rotation angle
    double angle = animation.value * 2 * pi;

    // Draw multiple circles with rotation and color change
    for (int i = 0; i < radii.length; i++) {
      paint.color = colors[i % colors.length].withOpacity(1 - animation.value);
      double radius = radii[i] * animation.value;
      canvas.save();
      canvas.rotate(angle + (i * pi / 4)); // Rotate each circle
      canvas.drawCircle(size.center(Offset.zero), radius, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
