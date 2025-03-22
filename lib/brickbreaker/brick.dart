import 'package:flutter/material.dart';

class MyBrick extends StatelessWidget {
  final double brickX;
  final double brickY;
  final bool brickBroken;
  final double brickWidth;
  final double brickHeight;

  const MyBrick({
    Key? key,
    required this.brickX,
    required this.brickY,
    required this.brickBroken,
    required this.brickWidth,
    required this.brickHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return brickBroken
        ? Container()
        : Container(
            alignment: Alignment(brickX, brickY),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                width: MediaQuery.of(context).size.width * brickWidth / 2,
                height: MediaQuery.of(context).size.height * brickHeight / 2,
                color: Colors.deepPurple,
              ),
            ),
          );
  }
}