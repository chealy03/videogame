import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:videogame/tetris/peice_tetris.dart';
import 'package:videogame/tetris/value_tetris.dart';
import 'pixel_tetris.dart';

class MyTertisGamePage extends StatefulWidget {
  const MyTertisGamePage({super.key});

  @override
  State<MyTertisGamePage> createState() => _MyTertisGamePageState();
}

class _MyTertisGamePageState extends State<MyTertisGamePage> {
  // Define these variables inside the state class
  int rowLength = 10;
  int colLength = 15;

  // Create the game board inside the state class
  late List<List<Tetromino?>> gameBoard =
      List.generate(colLength, (i) => List.generate(rowLength, (j) => null));

  Piece currentPiece = Piece(type: Tetromino.L);

  int currentScore = 0;

  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    // Initialize the game board here
    gameBoard =
        List.generate(colLength, (i) => List.generate(rowLength, (j) => null));
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();

    Duration frameRate = const Duration(milliseconds: 600);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        // Check if the piece can move down
        if (!checkCollision(Direction.down)) {
          currentPiece.movePiece(Direction.down);
        } else {
          // If it can't move down, land it
          for (int i = 0; i < currentPiece.position.length; i++) {
            int row = (currentPiece.position[i] / rowLength).floor();
            int col = currentPiece.position[i] % rowLength;
            if (row >= 0 && col >= 0 && row < colLength && col < rowLength) {
              gameBoard[row][col] = currentPiece.type;
            }
          }

          // Clear lines and create new piece
          clearLines();
          createNewPiece();

          // Check for game over
          if (gameOver) {
            timer.cancel();
            showGameOverDialog();
          }
        }
      });
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Your score is: $currentScore'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      // Clear the game board
      gameBoard = List.generate(
          colLength, (i) => List.generate(rowLength, (j) => null));
      gameOver = false;
      currentScore = 0;

      // Create new piece and start game
      createNewPiece();
      startGame();
    });
  }

  bool checkCollision(Direction direction) {
    // Check each position of the piece
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      // Calculate the next position
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      // First check if the next position is out of bounds
      if (col < 0 || col >= rowLength || row >= colLength) {
        return true;
      }

      // Then check collision with other pieces, but only if we're within bounds
      // and not in the starting position (above the grid)
      if (row >= 0) {
        if (gameBoard[row][col] != null) {
          return true;
        }
      }
    }
    return false;
  }

  void createNewPiece() {
    Random rand = Random();

    // Create and initialize the new piece
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();

    // Check if game is over - if new piece overlaps with existing pieces
    if (isGameOver()) {
      gameOver = true;
    }
  }

  bool isGameOver() {
    // Check if any of the new piece's positions overlap with existing pieces
    for (int pos in currentPiece.position) {
      int row = (pos / rowLength).floor();
      int col = pos % rowLength;

      // If the piece spawns on top of another piece, game is over
      if (row >= 0 && col >= 0 && row < colLength && col < rowLength) {
        if (gameBoard[row][col] != null) {
          return true;
        }
      }
    }

    // Also check if the top row is filled
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }

    return false;
  }

  void moveLeft() {
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  void moveRight() {
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  void rotatePiece() {
    setState(() {
      // Store original positions
      List<int> originalPosition = List.from(currentPiece.position);
      int originalState = currentPiece.rotationState;

      // Try to rotate
      currentPiece.rotatePiece();

      // After rotation, check if any piece is in an invalid position
      bool valid = true;
      for (int pos in currentPiece.position) {
        int row = (pos / rowLength).floor();
        int col = pos % rowLength;

        // Check boundaries
        if (row >= colLength || row < 0 || col < 0 || col >= rowLength) {
          valid = false;
          break;
        }

        // Check collision with placed pieces (only if within bounds)
        if (row >= 0 && col >= 0 && row < colLength && col < rowLength) {
          if (gameBoard[row][col] != null) {
            valid = false;
            break;
          }
        }
      }

      if (!valid) {
        currentPiece.position = originalPosition;
        currentPiece.rotationState = originalState;
      }
    });
  }

  void clearLines() {
    // Check each row from bottom to top
    for (int row = colLength - 1; row >= 0; row--) {
      bool rowIsFull = true;

      // Check if the row is full
      for (int col = 0; col < rowLength; col++) {
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }

      // If row is full, clear it and shift rows down
      if (rowIsFull) {
        // Move all rows above current row down by one
        for (int r = row; r > 0; r--) {
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }

        // Clear the top row
        gameBoard[0] = List.generate(rowLength, (index) => null);

        // Since we moved all rows down, we need to check this row again
        currentScore++;
      }
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
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Tetris',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
                itemCount: rowLength * colLength,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowLength,
                ),
                itemBuilder: (context, index) {
                  // Calculate row and col from index
                  int row = (index / rowLength).floor();
                  int col = index % rowLength;

                  if (currentPiece.position.contains(index)) {
                    return PixelTetris(
                      color: currentPiece.color,
                      
                    );
                  } else if (row < colLength &&
                      col < rowLength &&
                      gameBoard[row][col] != null) {
                    final Tetromino? tetrominoType = gameBoard[row][col];
                    return PixelTetris(
                      color: tetrominoColors[tetrominoType],
                    );
                  } else {
                    return PixelTetris(
                      color: Colors.grey[900],
                      
                    );
                  }
                }),
          ),
          //game Control here

          Text(
            'Score: $currentScore',
            style: TextStyle(color: Colors.white),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 50.0, top: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: moveLeft,
                    color: Colors.white,
                    icon: Icon(Icons.arrow_back_ios_new)),
                IconButton(
                    onPressed: rotatePiece,
                    color: Colors.white,
                    icon: Icon(Icons.rotate_right)),
                IconButton(
                    onPressed: moveRight,
                    color: Colors.white,
                    icon: Icon(Icons.arrow_forward_ios)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
