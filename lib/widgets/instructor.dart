import 'package:flutter/material.dart';
import '../models/direction.dart';

class instructor extends StatelessWidget {
  const instructor({
    Key? key,
    required this.testDirection,
    required this.userDirection,
    required this.counting,
    required this.finished,
    required this.correct
  }) : super(key: key);
  final Direction testDirection;
  final Direction userDirection;
  final bool counting;
  final bool finished;
  final bool correct;

  @override
  Widget build(BuildContext context) {
    double iconSize = 100.0;
    if (!finished) {
      if (counting) {
        if (testDirection == Direction.right) {
          return Icon(Icons.arrow_forward, size: iconSize);
        } else if (testDirection == Direction.left) {
          return Icon(Icons.arrow_back, size: iconSize);
        } else if (testDirection == Direction.up) {
          return Icon(Icons.arrow_upward, size: iconSize);
        } else if (testDirection == Direction.down) {
          return Icon(Icons.arrow_downward, size: iconSize);
        }
      } else return Container();
    }
    
    if (correct) {
      return Icon(Icons.check, size: iconSize);
    } else {
      return Icon(Icons.close, size: 100.0);
    }
  }
}
