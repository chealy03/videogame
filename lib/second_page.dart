import 'package:flutter/material.dart';
import 'package:videogame/brickbreaker/brickbreaker.dart';
import 'package:videogame/pacman/pacman.dart';
import 'package:videogame/snake/snake.dart';
import 'package:videogame/tetris/tetris.dart';

class Secondpage extends StatelessWidget {
  const Secondpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF333333),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title text
            Text(
              'Choose a game',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'to play',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 80),

            // First row of game icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pacman
                gameOption('img/Group 2.png', 'Pacman', context),
                SizedBox(width: 50),
                // Tetris
                gameOption('img/tetrisGame.png', 'Tetris', context),
              ],
            ),

            SizedBox(height: 100),

            // Second row of game icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Brick Breaker
                gameOption('img/Group 3.png', 'Brick Breaker', context),
                SizedBox(width: 50),
                // Snake
                gameOption('img/Group 1.png', 'Snake', context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget gameOption(String imagePath, String title, BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (title == 'Pacman') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PacmanGamePage()),
              );
            } else if (title == 'Tetris') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyTertisGamePage()),
              );
            } else if (title == 'Brick Breaker') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BrickBreakerGamePage()),
              );
            } else if (title == 'Snake') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SnakeGamePage()),
              );
            }
          },
          child: Image.asset(
            imagePath,
            width: 150,
            height: 150,
          ),
        ),
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
