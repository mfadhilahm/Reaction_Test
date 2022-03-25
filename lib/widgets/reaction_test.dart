import 'package:flutter/material.dart';
import 'package:esense_flutter/esense.dart';
import 'dart:async';

import 'gyro_stream.dart';

class ReactionTest extends StatefulWidget {
  const ReactionTest({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ReactionTestState createState() => _ReactionTestState();
}

class _ReactionTestState extends State<ReactionTest> {
  final String _eSenseName = "eSense-0830";

  @override
  void initState() {
    super.initState();
    _connectToESense();
  }

  Future<void> _connectToESense() async {
    await ESenseManager().disconnect();
    bool hasSuccessfulConneted = await ESenseManager().connect(_eSenseName);
    print("hasSuccessfulConneted: $hasSuccessfulConneted");
  }

  List<double> _handleGyro(SensorEvent event) {
    if (event.gyro != null) {
      return [
        event.gyro![0].toDouble(),
        event.gyro![1].toDouble(),
        event.gyro![2].toDouble(),
      ];
    } else {
      return [0.0, 0.0, 0.0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<ConnectionEvent>(
        stream: ESenseManager().connectionEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.type) {
              case ConnectionType.connected:
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GyroStream<SensorEvent>(
                          stream: ESenseManager().sensorEvents,
                          handler: _handleGyro
                        ),
                      ),
                    ),
                  ],
                );
              case ConnectionType.unknown:
                return ReconnectButton(
                  child: const Text("Connection: Unknown"),
                  onPressed: _connectToESense,
                );
              case ConnectionType.disconnected:
                return ReconnectButton(
                  child: const Text("Connection: Disconnected"),
                  onPressed: _connectToESense,
                );
              case ConnectionType.device_found:
                return const Center(child: Text("Connection: Device found"));
              case ConnectionType.device_not_found:
                return ReconnectButton(
                  child: Text("Connection: Device not found - $_eSenseName"),
                  onPressed: _connectToESense,
                );
            }
          } else {
            return const Center(child: Text("Waiting for Connection Data..."));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    ESenseManager().disconnect();
    super.dispose();
  }
}

class ReconnectButton extends StatelessWidget {
  const ReconnectButton({Key? key, required this.child, required this.onPressed}) : super(key: key);

  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        child,
        ElevatedButton(
          onPressed: onPressed,
          child: const Text("Connect To eSense"),
        )
      ]),
    );
  }
}
