import 'package:flutter/material.dart';

class CoverScreen extends StatelessWidget {
  final bool hasGameStarted;
  final bool isGameOver;

  const CoverScreen({
    Key? key,
    required this.hasGameStarted,
    required this.isGameOver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return hasGameStarted
        ? Container()
        : !isGameOver
            ? Container(
                alignment: const Alignment(0, -0.2),
                child: const Text(
                  'Tap To Play',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 25),
                ),
              )
            : Container();
  }
}