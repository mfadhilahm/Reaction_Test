import 'package:flutter/material.dart';

class Announcer extends StatelessWidget {
  const Announcer({
    Key? key,
    required this.welcome,
    required this.start,
    required this.correct,
    required this.duration
   }) : super(key: key);
   final bool welcome;
   final bool start;
   final bool correct;
   final Duration duration;

  @override
  Widget build(BuildContext context) {
    String text;
    if (welcome) {
      text = "WELCOME";
    } else if (start) {
      text = "GET READY";
    } else if (duration.inMicroseconds <= 0) {
      text = "TOO FAST";
    } else if (!correct) {
      text = "WRONG";
    } else {
      String total = duration.inMicroseconds.toStringAsFixed(0).padLeft(7, "0");
      String microseconds = total.substring(total.length - 3, total.length);
      String miliseconds = total.substring(total.length - 6, total.length - 3);
      String seconds = total.substring(0, total.length - 6);
      text = "$seconds:$miliseconds:$microseconds";
    }   

    return 
      Text(
        text,
        style: TextStyle(fontSize: 30)
      );
  }
}