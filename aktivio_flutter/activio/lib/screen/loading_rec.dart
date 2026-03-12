import 'dart:async';
import 'dart:math';
import 'recommendation_res.dart';
import 'package:flutter/material.dart';

class GeneratingRecommendationScreen extends StatefulWidget {
  const GeneratingRecommendationScreen({super.key});

  @override
  State<GeneratingRecommendationScreen> createState() =>
      _GeneratingRecommendationScreenState();
}

class _GeneratingRecommendationScreenState
    extends State<GeneratingRecommendationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    // Navigate after 5 seconds
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const RecommendationResultScreen(), // 🔁 CHANGE THIS
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF375A9A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ===== ANIMATED CIRCLE =====
            SizedBox(
              width: 80,
              height: 80,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  return CustomPaint(
                    painter: DotCirclePainter(_controller.value),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // ===== TEXT =====
            const Text(
              "Recommendations Generating",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class DotCirclePainter extends CustomPainter {
  final double progress;

  DotCirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    const dotCount = 8;
    const radius = 30.0;
    const dotRadius = 4.0;

    final paint = Paint()..color = Colors.white;

    for (int i = 0; i < dotCount; i++) {
      final angle = (2 * 3.1416 / dotCount) * i + (2 * 3.1416 * progress);
      final offset = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawCircle(offset, dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
