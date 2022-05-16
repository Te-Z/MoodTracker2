import 'dart:math';
import 'package:flutter/material.dart';

class HappyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size / 2;
    final third = size / 3;

    // head outline
    final circlePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
        Offset(center.width, center.height), center.width, circlePaint);

    // mouth
    final mouthPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 10.0;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.width, third.height * 2),
        width: third.width - 30,
        height: 60,
      ),
      0,
      pi,
      true,
      mouthPaint,
    );

    // eyes
    final eyePaint = Paint()..color = Colors.black;

    canvas.drawCircle(Offset(third.width, third.height + 20), 20, eyePaint);
    canvas.drawCircle(
        Offset(size.width - third.width, third.height + 20), 20, eyePaint);

    // eyebrows
    final eyeBrowPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(third.width, third.height + 20),
        width: 90,
        height: 90,
      ),
      -2 * pi / 3,
      pi / 4,
      false,
      eyeBrowPaint,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width - third.width, third.height + 20),
        width: 90,
        height: 90,
      ),
      -pi / 3,
      -pi / 4,
      false,
      eyeBrowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

