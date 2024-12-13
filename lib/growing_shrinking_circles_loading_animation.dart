import 'dart:math';

import 'package:flutter/material.dart';

class GrowingShrinkingCirclesLoadingAnimation extends StatefulWidget {
  const GrowingShrinkingCirclesLoadingAnimation({super.key});

  @override
  GrowingShrinkingCirclesLoadingAnimationState createState() =>
      GrowingShrinkingCirclesLoadingAnimationState();
}

class GrowingShrinkingCirclesLoadingAnimationState
    extends State<GrowingShrinkingCirclesLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int _circleCount = 3;
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
                painter: GrowingShrinkingCirclesPainter(
                    animationValues: _animations,
                    color: Theme.of(context).colorScheme.secondary),
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
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _initAnimations();
  }

  void _initAnimations() {
    _animations = List.generate(_circleCount, (index) {
      final beginDelay = (index * 1.0 / _circleCount);
      const endDelay = 1.0;

      return TweenSequence([
        TweenSequenceItem(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            weight: endDelay / 2), // Scale up from 0 to 1
        TweenSequenceItem(
            tween: Tween<double>(begin: 1.0, end: 0.0),
            weight: endDelay / 2), // Scale down from 1 to 0
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(beginDelay, endDelay, curve: Curves.easeInOut),
        ),
      );
    });
  }
}

class GrowingShrinkingCirclesPainter extends CustomPainter {
  final List<Animation<double>> animationValues;
  final Color color;

  GrowingShrinkingCirclesPainter(
      {required this.animationValues, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = min(size.width, size.height) / 2 * 0.7;
    // Offset between circles
    final offset = (maxRadius * 0.7) / animationValues.length;

    for (int i = 0; i < animationValues.length; i++) {
      final animationValue = animationValues[i].value;
      final radius = maxRadius * animationValue;

      final paint = Paint()
        ..color = color.withOpacity(1.0 - animationValue) // Transparency change
        ..style = PaintingStyle.fill;

      final circleCenter = center.translate(
          -(animationValues.length / 2 * offset) + (i * offset), 0);
      canvas.drawCircle(circleCenter, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant GrowingShrinkingCirclesPainter oldDelegate) {
    return true; // Repaint for every animation frame
  }
}
