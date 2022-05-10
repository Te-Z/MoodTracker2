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
                    painter: MoodTypePainter(),
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

class MoodTypePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size / 2;
    final third = size / 3;
    final circlePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke;

    final eyePaint = Paint()..color = Colors.black;

    canvas.drawCircle(
        Offset(center.width, center.height), center.width, circlePaint);

    canvas.drawCircle(Offset(third.width, third.height + 20), 20, eyePaint);
    canvas.drawCircle(
        Offset(size.width - third.width, third.height), 20, eyePaint);

    canvas.drawLine(Offset(third.width, third.height * 2),
        Offset(third.width * 2, third.height * 2), circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
