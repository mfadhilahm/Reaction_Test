import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reaction_test/widgets/announcer.dart';
import 'instructor.dart';
import '../models/direction.dart';
import 'restart_button.dart';

class GyroStream<T> extends StatefulWidget {
  const GyroStream({
    Key? key,
    required this.stream,
    required this.handler
  }) : super(key: key);

  final Stream<T> stream;
  final List<double> Function(T) handler;

  @override
  _GyroStreamState<T> createState() => _GyroStreamState<T>();
}

class _GyroStreamState<T> extends State<GyroStream<T>> {
  late StreamSubscription<List<double>> _subscription;
  List<double> _data = [0.0, 0.0, 0.0];
  Direction testDirection = Direction.none;
  Direction userDirection = Direction.none;
  bool finished = true;
  bool correct = false;
  bool counting = false;
  bool start = false;
  bool welcome = true;
  DateTime startTime = DateTime.now();
  Duration difference = Duration();


  @override
  void initState() {
    super.initState();
    Stream<List<double>> mappedStream = widget.stream.map(widget.handler);
    _subscription = mappedStream.listen((event) {
      setState(() {
        if (DateTime.now().compareTo(startTime) >= 0) {
          counting = true;
        }
        if (userDirection == Direction.none) {
          if (event[0] > 9000) {
            userDirection = Direction.right;
          } else if (event[0] < -9000) {
            userDirection = Direction.left;

          } else if (event[2] < -9000) {
            userDirection = Direction.up;

          } else if (event[2] > 9000) {
            userDirection = Direction.down;
          }
        }
        if (userDirection != Direction.none) {
          if (!finished) {
            difference = DateTime.now().difference(startTime);
            finished = true;
            counting = false;
            start = false;
          }
          if (testDirection == userDirection) {
            correct = true;
          }
        }
      });
    });
  }

  void restart() {
    finished = false;
    correct = false;
    counting = false;
    start = true;
    welcome = false;

    int randomDirection = Random().nextInt(4);
    testDirection = Direction.values[randomDirection];
    userDirection = Direction.none;

    Duration gap = Duration(seconds: 1 + Random().nextInt(7));
    startTime = DateTime.now().add(gap); 
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(55.0),
          child: Center(child: 
            Announcer(welcome: welcome, start: start, correct: correct, duration: difference)
          ),
        ),
        Expanded(
          child: instructor(
            testDirection: testDirection,
            userDirection: userDirection,
            counting: counting,
            finished: finished,
            correct: correct,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(65.0),
          child: RestartButton(finished: finished, onPressed: restart),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
