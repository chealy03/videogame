import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  // These are the properties that the widget receives from the parent
  final double playerX;
  final double playerWidth;

  // Constructor that requires these properties
  const MyPlayer({
    Key? key,
    required this.playerX,
    required this.playerWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Use the playerX variable for horizontal positioning
      alignment: Alignment(playerX, 0.9),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          // Use playerWidth to set the width of the paddle
          width: MediaQuery.of(context).size.width * playerWidth / 2,
          height: 10,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}