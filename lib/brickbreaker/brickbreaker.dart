import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:videogame/brickbreaker/ball.dart';
import 'package:videogame/brickbreaker/brick.dart';
import 'package:videogame/brickbreaker/coverscreen.dart';
import 'package:videogame/brickbreaker/gameover_screen.dart';
import 'package:videogame/pacman/player_pacman.dart';


class BrickBreakerGamePage extends StatefulWidget {
  const BrickBreakerGamePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum Direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<BrickBreakerGamePage> {
  // ball variables
  double ballX = 0;
  double ballY = 0;
  double ballXincrements = 0.02;
  double ballYincrements = 0.01;
  var ballYDirection = Direction.DOWN;
  var ballXDirection = Direction.LEFT;

  // player variables
  double playerX = -0.2;
  double playerWidth = 0.4; // out of 2

  // brick variables
  static double firstBrickX = -1 + wallGap;
  static double firstBrickY = -0.9;
  static double brickWidth = 0.4; // out of 2
  static double brickHeight = 0.05; // out of 2
  static double brickGap = 0.2;
  static int numberOfBricksInRow = 3;
  static double wallGap = 0.5 * 
    (2 -
    numberOfBricksInRow * brickWidth - 
    (numberOfBricksInRow-1)*brickGap);

  List myBricks = [
    // [x, y, broken = true/false]
    [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false]
  ];

  // game setting 
  bool hasGameStarted = false;
  bool isGameOver = false;
  
  // Focus node for keyboard input
  final FocusNode _focusNode = FocusNode();

  //start game
  void startGame() {
    setState(() {
      hasGameStarted = true;
    });
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      // update direction
      updateDirection();

      // move ball
      moveBall();

      // check if player dead
      if (isPlayerDead()) {
        timer.cancel();
        setState(() {
          isGameOver = true;
        });
      }
      
      // check if the brick is hit
      checkForBrokenBricks();
    }); //Timer.periodic
  }

  void checkForBrokenBricks() {
    // check for when ball is inside the Brick (aka hits brick)
    for (int i = 0; i < myBricks.length; i++) {
      if (ballX >= myBricks[i][0] && 
          ballX <= myBricks[i][0] + brickWidth && 
          ballY <= myBricks[i][1] + brickHeight &&
          ballY >= myBricks[i][1] &&
          myBricks[i][2] == false) {
        setState(() {
          myBricks[i][2] = true;

          // since brick is broken, update direction of ball
          // based on which side of the brick it hit
          // to do this, calculate the distance of the ball from each of the 4 sides.
          // the smallest distance is the side the ball has hit

          double leftSideDist = (myBricks[i][0] - ballX).abs();
          double rightSideDist = (myBricks[i][0] + brickWidth - ballX).abs();
          double topSideDist = (myBricks[i][1] - ballY).abs();
          double bottomSideDist = (myBricks[i][1] + brickHeight - ballY).abs();

          String min = findMin(leftSideDist, rightSideDist, topSideDist, bottomSideDist);

          switch (min) {
            case 'left':
              ballXDirection = Direction.LEFT;
              break;
            case 'right':
              ballXDirection = Direction.RIGHT;
              break;
            case 'top':
              ballYDirection = Direction.UP;
              break;
            case 'bottom':
              ballYDirection = Direction.DOWN;
              break;
          }
        });
      }
    }
  }

  // returns the smallest side
  String findMin(double a, double b, double c, double d) {
    List<double> myList = [
      a,
      b,
      c,
      d,
    ];

    double currentMin = a;
    for (int i = 0; i < myList.length; i++) {
      if (myList[i] < currentMin) {
        currentMin = myList[i];
      }
    }

    if ((currentMin - a).abs() < 0.01) {
      return 'left';
    } else if ((currentMin - b).abs() < 0.01) {
      return 'right';
    } else if ((currentMin - c).abs() < 0.01) {
      return 'top';
    } else if ((currentMin - d).abs() < 0.01) {
      return 'bottom';
    }

    return '';
  }

  // is player dead
  bool isPlayerDead() {
    // player dies if ball reaches the bottom of screen
    if (ballY >= 1) {
      return true;
    }
    return false;
  }

  // move ball 
  void moveBall() {
    setState(() {
      // move horizontally
      if (ballXDirection == Direction.LEFT) {
        ballX -= ballXincrements;
      } else if (ballXDirection == Direction.RIGHT) {
        ballX += ballXincrements;
      }

      // move vertically
      if (ballYDirection == Direction.DOWN) {
        ballY += ballYincrements;
      } else if (ballYDirection == Direction.UP) {
        ballY -= ballYincrements;
      }
    });
  }
  
  //update direction of the ball
  void updateDirection() {
    setState(() {
      // ball goes up when it hits player
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidth) {
        ballYDirection = Direction.UP;
      } 
      // ball goes down when it hits the top of screen
      else if(ballY <= -1) {
        ballYDirection = Direction.DOWN;
      }

      // ball goes left when it hits right wall
      if (ballX >= 1) {
        ballXDirection = Direction.LEFT;
      }
      // ball goes right when it hits left wall
      else if (ballX <= -1) {
        ballXDirection = Direction.RIGHT;
      }
    });
  }

  // move player left
  void moveLeft() {
    setState(() {
      //only move left if moving left doesn't move player off the screen
      if (!(playerX - 0.2 < -1))
        playerX -= 0.2;
    });
  }
   
  // move player right
  void moveRight() {
    setState(() {
      //only move right if moving right doesn't move player off the screen
      if (!(playerX + playerWidth >= 1))
        playerX += 0.2;
    });
  }

  //reset game back to initial values when user hits play again 
  void resetGame() {
    setState(() {
      playerX = -0.2;
      ballX = 0;
      ballY = 0;
      isGameOver = false;
      hasGameStarted = false;

      myBricks = [
        // [x, y, broken = true/false]
        [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false]
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            moveLeft();
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            moveRight();
          }
        }
      },
      child: GestureDetector(
        onTap: startGame,
        child: Scaffold(
          backgroundColor: Colors.deepPurple[100],
          body: Center(
            child: Stack(
              children: [
                //tap to play
                CoverScreen(
                  hasGameStarted: hasGameStarted,
                  isGameOver: isGameOver,
                ),

                // game over screen 
                GameOverScreen(
                  isGameOver: isGameOver, 
                  function: resetGame,
                ),

                //ball
                MyBall(
                  ballX: ballX,
                  ballY: ballY,
                  hasGameStarted: hasGameStarted,
                  isGameOver: isGameOver,
                ),
                
                //player
                MyPlayer(
                  
                ),
                
                //bricks
                MyBrick(
                  brickX: myBricks[0][0],
                  brickY: myBricks[0][1],
                  brickBroken: myBricks[0][2],
                  brickWidth: brickWidth,
                  brickHeight: brickHeight,
                ),
                MyBrick(
                  brickX: myBricks[1][0],
                  brickY: myBricks[1][1],
                  brickBroken: myBricks[1][2],
                  brickWidth: brickWidth,
                  brickHeight: brickHeight,
                ),
                MyBrick(
                  brickX: myBricks[2][0],
                  brickY: myBricks[2][1],
                  brickBroken: myBricks[2][2],
                  brickWidth: brickWidth,
                  brickHeight: brickHeight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}