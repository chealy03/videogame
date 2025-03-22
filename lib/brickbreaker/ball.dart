import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  final double ballX;
  final double ballY;
  final bool hasGameStarted;
  final bool isGameOver;

  const MyBall({
    Key? key,
    required this.ballX,
    required this.ballY,
    required this.hasGameStarted,
    required this.isGameOver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return hasGameStarted && !isGameOver
        ? Container(
            alignment: Alignment(ballX, ballY),
            child: Container(
              width: 15,
              height: 15,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          )
        : Container();
  }
}