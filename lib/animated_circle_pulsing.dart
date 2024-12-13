import 'package:flutter/material.dart';

class AnimatedCirclePulse extends StatefulWidget {
  final double size;
  final Color baseColor;
  final Color ringColor;

  const AnimatedCirclePulse({
    super.key,
    this.size = 60.0,
    this.baseColor = Colors.blue,
    this.ringColor = Colors.blueAccent,
  });

  @override
  AnimatedCirclePulseState createState() => AnimatedCirclePulseState();
}

class AnimatedCirclePulseState extends State<AnimatedCirclePulse>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late AnimationController _ringController;
  late Animation<double> _ringAnimation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _ringController]),
        builder: (context, child) {
          return CustomPaint(
            painter: _PulsePainter(
              pulseProgress: _pulseAnimation.value,
              ringProgress: _ringAnimation.value,
              baseColor: widget.baseColor,
              ringColor: widget.ringColor,
              size: widget.size,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Pulse Animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Ring Animation
    _ringController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: false);

    _ringAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ringController,
        curve: Curves.easeInOut,
      ),
    );
  }
}

class _PulsePainter extends CustomPainter {
  final double pulseProgress;
  final double ringProgress;
  final Color baseColor;
  final Color ringColor;
  final double size;

  _PulsePainter({
    required this.pulseProgress,
    required this.ringProgress,
    required this.baseColor,
    required this.ringColor,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = this.size * 0.2 * pulseProgress;

    // Draw the pulsing circle
    final basePaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, baseRadius, basePaint);

    // Draw the expanding rings

    final ringPaint = Paint()
      ..color = ringColor.withValues(
        alpha: 255 * ringProgress,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 1; i <= 3; i++) {
      final ringRadius = (this.size * 0.2 * i * ringProgress) + baseRadius;
      canvas.drawCircle(center, ringRadius, ringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint on every animation frame
  }
}
