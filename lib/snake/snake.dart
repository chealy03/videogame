import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SnakeGamePage extends StatefulWidget {
  const SnakeGamePage({super.key});

  @override
  State<SnakeGamePage> createState() => _SnakeGameState();
}

enum Direction { up, down, left, right }

class _SnakeGameState extends State<SnakeGamePage> {
  int row = 16, column = 15;
  List<int> borderList = [];
  List<int> snakePosition = [];
  int snakeHead = 0;
  int score = 0;
  late Direction direction;
  late int food;

  @override
  void initState() {
    startGame();
    super.initState();
  }

  void startGame() {
    setState(() {
      // Reset game state
      score = 0;
      direction = Direction.right;
      borderList.clear();
      snakePosition = [45, 46, 47];
      snakeHead = snakePosition.first;

      // Initialize game elements
      makeBorder();
      generateFood();
    });

    // Start game loop
    Timer.periodic(const Duration(milliseconds: 160), (timer) {
      setState(() {
        updateSnake();
        if (checkCollision()) {
          timer.cancel();
          showGameOver();
        }
      });
    });
  }

  void showGameOver() {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Oh noo! Game Over"),
          content: Text("You are suck<3"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  startGame();
                },
                child: Text("Wanna go again?")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // This will exit the game screen
                },
                child: Text("Leave"))
          ],
        );
      });
}

  bool checkCollision() {
    if (borderList.contains(snakeHead)) return true;
    if (borderList.length > 1 && borderList.sublist(1).contains(snakeHead))
      return true;

    return false;
  }

  void generateFood() {
    food = Random().nextInt(row * column);
    if (borderList.contains(food)) {
      generateFood();
    }
  }

  void updateSnake() {
    setState(() {
      switch (direction) {
        case Direction.up:
          snakePosition.insert(0, snakeHead - column);
          break;
        case Direction.down:
          snakePosition.insert(0, snakeHead + column);
          break;
        case Direction.right:
          snakePosition.insert(0, snakeHead + 1);
          break;
        case Direction.left:
          snakePosition.insert(0, snakeHead - 1);
          break;
      }
    });
    if (snakeHead == food) {
      score++;
      generateFood();
    } else {
      snakePosition.removeLast();
    }
    snakeHead = snakePosition.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Game title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const Text(
                  "Snake Game",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 48), // Balance the back button
              ],
            ),
            // Game grid
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double gameSize = constraints.maxWidth;
                  // If height is smaller than width, use height as size
                  if (constraints.maxHeight < gameSize) {
                    gameSize = constraints.maxHeight;
                  }
                  return SizedBox(
                    width: gameSize,
                    height: gameSize,
                    child: gameView(),
                  );
                },
              ),
            ),
            // Score display
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Score: $score",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            // Game controls
            gameControl(),
          ],
        ),
      ),
    );
  }

  Widget gameView() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: column,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: fillBoxColor(index),
            borderRadius: BorderRadius.circular(6),
          ),
        );
      },
      itemCount: row * column,
    );
  }

  Widget gameControl() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              if (direction != Direction.down) direction = Direction.up;
            },
            icon: const Icon(Icons.arrow_circle_up, color: Colors.white),
            iconSize: 80,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(
              onPressed: () {
                if (direction != Direction.right) direction = Direction.left;
              },
              icon: const Icon(Icons.arrow_circle_left_outlined,
                  color: Colors.white),
              iconSize: 80,
            ),
            const SizedBox(width: 100),
            IconButton(
              onPressed: () {
                if (direction != Direction.left) direction = Direction.right;
              },
              icon: const Icon(Icons.arrow_circle_right_outlined,
                  color: Colors.white),
              iconSize: 80,
            ),
          ]),
          IconButton(
            onPressed: () {
              if (direction != Direction.up) direction = Direction.down;
            },
            icon: const Icon(Icons.arrow_circle_down_outlined,
                color: Colors.white),
            iconSize: 80,
          ),
        ],
      ),
    );
  }

  Color fillBoxColor(int index) {
    if (borderList.contains(index))
      return Colors.yellow;
    else {
      if (snakePosition.contains(index)) {
        if (snakeHead == index) {
          return const Color.fromARGB(255, 211, 92, 132);
        } else {
          return Colors.white;
        }
      } else {
        if (index == food) {
          return Colors.red;
        }
      }
    }
    return Colors.grey.withOpacity(0.05);
  }

  void makeBorder() {
    borderList.clear(); // Clear existing borders

    // Add top border
    for (int i = 0; i < column; i++) {
      borderList.add(i);
    }

    // Add left border
    for (int i = 0; i < row * column; i += column) {
      if (!borderList.contains(i)) borderList.add(i);
    }

    // Add right border
    for (int i = column - 1; i < row * column; i += column) {
      if (!borderList.contains(i)) borderList.add(i);
    }

    // Add bottom border
    for (int i = (row * column) - column; i < row * column; i++) {
      if (!borderList.contains(i)) borderList.add(i);
    }
  }
}
