import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mood_tracker/data/mood.entity.dart';
import 'package:mood_tracker/theme.dart';
import 'package:mood_tracker/utils/extensions.dart';

final moodTypeProvider = StateProvider.autoDispose<MoodType>(
  (_) => MoodType.excellent,
);

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(moodTypeProvider);
    return SafeArea(
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 500,
        ),
        color: _moodColor(type),
        child: Column(
          children: [
            Flexible(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 32.0,
                    right: 32.0,
                    bottom: 32.0,
                    top: 64,
                  ),
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _moodPaint(type),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: MoodType.values.map((t) => MoodButton(t)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _moodColor(MoodType type) {
    switch (type) {
      case MoodType.excellent:
        return MoodTrackerTheme.yellow;
      case MoodType.happy:
        return MoodTrackerTheme.green;
      case MoodType.average:
        return MoodTrackerTheme.green2;
      case MoodType.sad:
        return MoodTrackerTheme.pink;
      case MoodType.sorrowful:
        return MoodTrackerTheme.blue;
    }
  }

  CustomPainter? _moodPaint(MoodType type) {
    switch (type) {
      case MoodType.happy:
        return HappyPainter();
      default:
        return AveragePainter();
    }
  }
}

class MoodButton extends HookConsumerWidget {
  const MoodButton(this.type, {Key? key}) : super(key: key);

  final MoodType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              side: BorderSide(color: Colors.black)),
        ),
        onPressed: () => ref.read(moodTypeProvider.notifier).state = type,
        child: Text(
          describeEnum(type).capitalize(),
          style: Theme.of(context).textTheme.headline4?.copyWith(
                color: Colors.black,
              ),
        ),
      ),
    );
  }
}

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

class AveragePainter extends CustomPainter {
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
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(third.width + 30, third.height * 2),
      Offset((third.width * 2) - 30, third.height * 2),
      mouthPaint,
    );

    // eyes
    final eyePaint = Paint()..color = Colors.black;

    canvas.drawCircle(Offset(third.width, third.height + 40), 20, eyePaint);
    canvas.drawCircle(
        Offset(size.width - third.width, third.height + 40), 20, eyePaint);

    // eyebrows
    // 1rad × 180/π = 57,296°
    final eyeBrowPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(third.width, third.height + 40),
        width: 90,
        height: 90,
      ),
      -7 * pi / 12,
      pi / 6,
      false,
      eyeBrowPaint,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width - third.width, third.height + 40),
        width: 90,
        height: 90,
      ),
      -5 * pi / 12,
      -pi / 6,
      false,
      eyeBrowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
