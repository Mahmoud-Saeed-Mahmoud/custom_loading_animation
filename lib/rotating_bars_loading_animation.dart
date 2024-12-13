import 'dart:math';

import 'package:flutter/material.dart';

class RotatingBarsLoadingAnimation extends StatefulWidget {
  const RotatingBarsLoadingAnimation({super.key});

  @override
  RotatingBarsLoadingAnimationState createState() =>
      RotatingBarsLoadingAnimationState();
}

class RotatingBarsLoadingAnimationState
    extends State<RotatingBarsLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int _barCount = 5;
  late List<Animation<double>> _animations = [];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: AspectRatio(
          aspectRatio: 1,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: RotatingBarsPainter(
                    animationValues: _animations,
                    color: Theme.of(context).colorScheme.tertiary),
              );
            },
          ),
        ),
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
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _initAnimations();
  }

  void _initAnimations() {
    _animations = List.generate(_barCount, (index) {
      final beginDelay = (index * 1.0 / _barCount); // Offset the begin times
      const endDelay = 1.0;

      return TweenSequence([
        TweenSequenceItem(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            weight: endDelay / 2), //Scale up
        TweenSequenceItem(
            tween: Tween<double>(begin: 1.0, end: 0.0),
            weight: endDelay / 2), // Scale down
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(beginDelay, endDelay, curve: Curves.easeInOut),
        ),
      );
    });
  }
}

class RotatingBarsPainter extends CustomPainter {
  final List<Animation<double>> animationValues;
  final Color color;

  RotatingBarsPainter({required this.animationValues, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final barLength = min(size.width, size.height) * 0.4;
    const barWidth = 4.0;
    const maxRotationAngle = pi * 2;

    for (int i = 0; i < animationValues.length; i++) {
      final animationValue = animationValues[i].value;
      final currentAngle =
          maxRotationAngle * _getCurrentRotation(animationValue, i);

      final startPoint = center +
          Offset(barLength / 2 * cos(currentAngle),
              barLength / 2 * sin(currentAngle));
      final endPoint = center -
          Offset(barLength / 2 * cos(currentAngle),
              barLength / 2 * sin(currentAngle));

      final paint = Paint()
        ..color = color
        ..strokeWidth = barWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(startPoint, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(covariant RotatingBarsPainter oldDelegate) {
    return true; // Repaint for each animation frame.
  }

  double _getCurrentRotation(double animationValue, int index) {
    // Stagger the angles so bars spin sequentially
    double individualRotation = animationValue;

    // Calculate additional rotation based on animation value
    return individualRotation;
  }
}
