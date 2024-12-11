import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});

  @override
  LoadingAnimationState createState() => LoadingAnimationState();
}

class LoadingAnimationPainter extends CustomPainter {
  final Animation<double> animation;

  LoadingAnimationPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    double radius = size.width / 2 * animation.value;
    canvas.drawCircle(size.center(Offset.zero), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LoadingAnimationState extends State<LoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100, 100),
      painter: LoadingAnimationPainter(_controller),
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
          child: LoadingAnimation(),
        ),
      ),
    );
  }
}
