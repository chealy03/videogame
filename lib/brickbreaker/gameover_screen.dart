import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  final bool isGameOver;
  final Function function;

  const GameOverScreen({
    Key? key,
    required this.isGameOver,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isGameOver
        ? Container(
            alignment: const Alignment(0, -0.3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'G A M E  O V E R',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 25),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    function();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Play Again',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}