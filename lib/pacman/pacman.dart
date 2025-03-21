import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:videogame/pacman/ghost_pacman.dart';

import 'package:videogame/pacman/path_pacman.dart';
import 'package:videogame/pacman/pixel_pacman.dart';
import 'package:videogame/pacman/player_pacman.dart';

class PacmanGamePage extends StatefulWidget {
  const PacmanGamePage({super.key});

  @override
  State<PacmanGamePage> createState() => _PacmanGamePageState();
}

class _PacmanGamePageState extends State<PacmanGamePage> {
  static const int numberInRow = 11;
  final int numberOfSquare = numberInRow * 17;
  int player = numberInRow * 15 + 1;
  int ghost = numberInRow * 2 + 5; 
  
  bool preGame = true;
  bool mouthClosed = false;
  int score = 0;
  bool ghostActive = true; 
  
  // For controlling player movement speed
  int playerMovementCounter = 0;
  int playerMovementSpeed = 2; 
  
  // For controlling ghost movement speed
  int ghostMovementCounter = 0;
  int ghostMovementSpeed = 4; 

  List<int> barries = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    22,
    33,
    44,
    55,
    66,
    77,
    99,
    110,
    121,
    132,
    143,
    154,
    165,
    176,
    177,
    178,
    179,
    180,
    181,
    182,
    183,
    184,
    185,
    186,
    175,
    164,
    153,
    142,
    131,
    120,
    109,
    87,
    76,
    65,
    54,
    43,
    32,
    21,
    24,
    35,
    46,
    57,
    26,
    37,
    38,
    28,
    39,
    30,
    41,
    52,
    63,
    78,
    79,
    80,
    81,
    70,
    59,
    61,
    72,
    83,
    84,
    85,
    86,
    87,
    100,
    101,
    102,
    103,
    114,
    125,
    127,
    116,
    105,
    106,
    107,
    108,
    123,
    134,
    145,
    156,
    153,
    147,
    148,
    149,
    160,
    129,
    140,
    151,
    162,
    158
  ];

  List<int> food = [];
  Timer? gameTimer;
  String direction = 'right';

  void startGame() {
    if (gameTimer != null) {
      gameTimer!.cancel();
    }
    
    setState(() {
      preGame = false;
      score = 0;
      player = numberInRow * 15 + 1;
      ghost = numberInRow * 2 + 5;
      ghostActive = true; 
      direction = 'right';
      food.clear();
      playerMovementCounter = 0;
      ghostMovementCounter = 0;
    });
    
    getFood();
    
    gameTimer = Timer.periodic(Duration(milliseconds: 120), (timer) {
      setState(() {
        mouthClosed = !mouthClosed;
      });

      if (player == ghost && ghostActive) {
        setState(() {
          ghostActive = false; 
          score += 50; 
        });
      }

      if (food.contains(player)) {
        setState(() {
          food.remove(player);
          score++;
        });
      }

      playerMovementCounter++;
      
      if (playerMovementCounter >= playerMovementSpeed) {
        switch (direction) {
          case "left":
            moveLeft();
            break;
          case "right":
            moveRight();
            break;
          case "up":
            moveUp();
            break;
          case "down":
            moveDown();
            break;
        }
        playerMovementCounter = 0;
      }
      
      if (ghostActive) {
        ghostMovementCounter++;
        if (ghostMovementCounter >= ghostMovementSpeed) {
          moveGhost();
          ghostMovementCounter = 0;
        }
      }
      
      if (food.isEmpty) {
        gameWon();
      }
    });
  }
  
  void gameOver() {
    gameTimer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('You were caught by the ghost! Your score: $score'),
          actions: [
            TextButton(
              child: Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
            ),
          ],
        );
      },
    );
  }
  
  void gameWon() {
    gameTimer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You Won!'),
          content: Text('Congratulations! Your score: $score'),
          actions: [
            TextButton(
              child: Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
            ),
          ],
        );
      },
    );
  }

  void moveGhost() {
    List<int> possibleMoves = [];
 
    if (!barries.contains(ghost - 1)) {
      possibleMoves.add(ghost - 1); // Left
    }
    if (!barries.contains(ghost + 1)) {
      possibleMoves.add(ghost + 1); // Right
    }
    if (!barries.contains(ghost - numberInRow)) {
      possibleMoves.add(ghost - numberInRow); // Up
    }
    if (!barries.contains(ghost + numberInRow)) {
      possibleMoves.add(ghost + numberInRow); // Down
    }
    
    if (possibleMoves.isEmpty) {
      return; // Ghost is trapped
    }
    
    int bestMove = possibleMoves[0];
    int bestDistance = calculateDistance(possibleMoves[0], player);
    
    for (int move in possibleMoves) {
      int distance = calculateDistance(move, player);
      
      if (distance < bestDistance) {
        bestDistance = distance;
        bestMove = move;
      }
    }
    
    setState(() {
      ghost = bestMove;
    });
  }
  
  int calculateDistance(int pos1, int pos2) {
    int x1 = pos1 % numberInRow;
    int y1 = pos1 ~/ numberInRow;
    int x2 = pos2 % numberInRow;
    int y2 = pos2 ~/ numberInRow;
    
    return (x1 - x2).abs() + (y1 - y2).abs();
  }

  void getFood() {
    for (int i = 0; i < numberOfSquare; i++) {
      if (!barries.contains(i) && i != player && i != ghost) {
        food.add(i);
      }
    }
  }

  void moveLeft() {
    if (!barries.contains(player - 1)) {
      setState(() {
        player--;
      });
    }
  }

  void moveRight() {
    if (!barries.contains(player + 1)) {
      setState(() {
        player++;
      });
    }
  }

  void moveUp() {
    if (!barries.contains(player - numberInRow)) {
      setState(() {
        player -= numberInRow;
      });
    }
  }

  void moveDown() {
    if (!barries.contains(player + numberInRow)) {
      setState(() {
        player += numberInRow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            gameTimer?.cancel();
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Pacman',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  direction = "down";
                } else if (details.delta.dy < 0) {
                  direction = "up";
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0) {
                  direction = "right";
                } else if (details.delta.dx < 0) {
                  direction = "left";
                }
              },
              child: Container(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: numberOfSquare,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numberInRow,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (ghostActive && ghost == index) {
                      return MyGhost();
                    } else if (mouthClosed && player == index) {
                      return Padding(
                          padding: EdgeInsets.all(4),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.yellow, shape: BoxShape.circle),
                          ));
                    } else if (player == index) {
                      switch (direction) {
                        case "left":
                          return Transform.rotate(angle: pi, child: MyPlayer());
                        case "right":
                          return MyPlayer();
                        case "up":
                          return Transform.rotate(
                              angle: 3 * pi / 2, child: MyPlayer());
                        case "down":
                          return Transform.rotate(
                              angle: pi / 2, child: MyPlayer());
                        default:
                          return MyPlayer();
                      }
                    } else if (barries.contains(index)) {
                      return MyPixel(
                        innerColor: Colors.blue[800],
                        outerColor: Colors.blue[900],
                      );
                    } else if (food.contains(index)) {
                      return MyPath(
                        innerColor: Colors.yellow,
                        outerColor: Colors.black,
                      );
                    } else {
                      return Container(color: Colors.black);
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Score: $score",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  GestureDetector(
                    onTap: startGame,
                    child: Text(
                      "P L A Y",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}