import 'package:flutter/material.dart';

class RestartButton extends StatelessWidget {
  const RestartButton({
    Key? key,
    required this.finished,
    required this.onPressed
  }) : super(key: key);
  final bool finished;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
      if (finished) {
      return ElevatedButton(
        onPressed: onPressed,
        child: Text("START"),
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 40)
        )
      );
    } else {
      return ElevatedButton( 
        onPressed: null, 
        child: Text("START"),
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 40)
        )
      );
    }
  }
}