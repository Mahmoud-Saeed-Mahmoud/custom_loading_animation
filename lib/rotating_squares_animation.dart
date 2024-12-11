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
          child: RotatingSquaresAnimation(),
        ),
      ),
    );
  }
}

class RotatingSquaresAnimation extends StatefulWidget {
  const RotatingSquaresAnimation({super.key});

  @override
  RotatingSquaresAnimationState createState() =>
      RotatingSquaresAnimationState();
}

class RotatingSquaresAnimationState extends State<RotatingSquaresAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100, 100),
      painter: RotatingSquaresPainter(_controller),
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

class RotatingSquaresPainter extends CustomPainter {
  final Animation<double> animation;

  RotatingSquaresPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Define parameters for squares
    final List<double> offsets = [0, 1, 2, 3]; // Four squares
    const double squareSize = 20;

    for (int i = 0; i < offsets.length; i++) {
      // Calculate rotation angle and scale
      double angle = animation.value * 2 * pi + (i * pi / 2);
      double scale = 1 + 0.5 * sin(animation.value * 2 * pi + (i * pi / 2));

      // Set color for each square
      paint.color = Colors.primaries[i % Colors.primaries.length];

      // Calculate the position of each square
      double x = size.width / 2 + (30 * scale) * cos(angle);
      double y = size.height / 2 + (30 * scale) * sin(angle);

      // Draw the square
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);
      canvas.drawRect(
          Rect.fromCenter(
              center: const Offset(0, 0),
              width: squareSize * scale,
              height: squareSize * scale),
          paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
