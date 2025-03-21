import 'package:flutter/material.dart';
import 'package:videogame/tetris/value_tetris.dart';

class Piece {
  Tetromino type;
  int rotationState = 1;

  Piece({required this.type});

  List<int> position = [];

  Color get color {
    return tetrominoColors[type] ?? Color(0xFFFFFFFF);
  }

  void initializePiece() {
    switch (type) {
      case Tetromino.L:
        position = [
          -26,
          -16,
          -6,
          -5,
        ];
        break;
      case Tetromino.J:
        position = [
          -25,
          -15,
          -5,
          -6,
        ];
        break;
      case Tetromino.I:
        position = [
          -4,
          -5,
          -6,
          -7,
        ];
        break;
      case Tetromino.O:
        position = [
          -15,
          -16,
          -5,
          -6,
        ];
        break;
      case Tetromino.S:
        position = [
          -15,
          -14,
          -6,
          -5,
        ];
        break;
      case Tetromino.Z:
        position = [
          -17,
          -16,
          -6,
          -5,
        ];
        break;
      case Tetromino.T:
        position = [
          -15,
          -16,
          -14,
          -5,
        ];
        break;
      default:
    }
  }

  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLength;
        }
        break;
      case Direction.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      case Direction.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
    }
  }

  // Updated to check if rotation is valid
  void rotatePiece() {
    // Store original positions in case we need to revert
    List<int> originalPosition = List.from(position);
    int originalState = rotationState;

    List<int> newPosition = [];

    switch (type) {
      case Tetromino.L:
        switch (rotationState) {
          case 0:
            /*
            o
            o
            o o
            */
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength + 1,
            ];

            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            /*
            o o o
            o
            */
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
            ];

            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            /*
            o o
              o
              o
            */
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength - 1,
            ];

            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            /*
              o
            o o o
            */
            newPosition = [
              position[1] - rowLength + 1,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];

            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;

      case Tetromino.J:
        switch (rotationState) {
          case 0:
            /*
              o
              o
            o o
            */
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength - 1,
            ];

            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            /*
            o
            o o o
            */
            newPosition = [
              position[1] - rowLength - 1,
              position[1] - 1,
              position[1],
              position[1] + 1,
            ];

            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            /*
            o o
            o
            o
            */
            newPosition = [
              position[1] - rowLength + 1,
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
            ];

            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            /*
            o o o
                o
            */
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength + 1,
            ];

            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;

      case Tetromino.I:
        switch (rotationState) {
          case 0:
            /*
            o o o o
            */
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + 2,
            ];

            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 2;
            }
            break;
          case 1:
            /*
            o
            o
            o
            o
            */
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + 2 * rowLength,
            ];

            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 2;
            }
            break;
        }
        break;

      case Tetromino.O:
        // O piece doesn't need to rotate (it's a square)
        return;

      case Tetromino.S:
        switch (rotationState) {
          case 0:
            /*
              o o
            o o
            */
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
              position[1] + rowLength,
            ];

            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 2;
            }
            break;
          case 1:
            /*
            o
            o o
              o
            */
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + 1,
              position[1] + rowLength + 1,
            ];

            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 2;
            }
            break;
        }
        break;

      case Tetromino.Z:
        switch (rotationState) {
          case 0:
            /*
            o o
              o o
            */
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength + 1,
            ];

            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 2;
            }
            break;
          case 1:
            /*
              o
            o o
            o
            */
            newPosition = [
              position[1] - rowLength + 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength,
            ];

            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 2;
            }
            break;
        }
        break;

      case Tetromino.T:
        switch (rotationState) {
          case 0:
            /*
              o
            o o o
            */
            newPosition = [
              position[1] - rowLength, // top middle
              position[1] - 1, // middle left
              position[1], // middle center
              position[1] + 1, // middle right
            ];
            break;
          case 1:
            /*
              o
            o o
              o
            */
            newPosition = [
              position[1] - rowLength, // top
              position[1] - 1, // middle left
              position[1], // middle center
              position[1] + rowLength, // bottom
            ];
            break;
          case 2:
            /*
            o o o
              o
            */
            newPosition = [
              position[1] - 1, // middle left
              position[1], // middle center
              position[1] + 1, // middle right
              position[1] + rowLength, // bottom middle
            ];
            break;
          case 3:
            /*
            o
            o o
            o
            */
            newPosition = [
              position[1] - rowLength, // top
              position[1], // middle center
              position[1] + 1, // middle right
              position[1] + rowLength, // bottom
            ];
            break;
        }

        if (piecePositionIsValid(newPosition)) {
          position = newPosition;
          rotationState = (rotationState + 1) % 4;
        }
        break;
    }
  }

  // Fixed method to check if a position is valid
  bool isPositionValid(int pos) {
    int row = (pos / rowLength).floor();
    int col = pos % rowLength;

    // Check boundaries
    if (row >= colLength || row < 0 || col < 0 || col >= rowLength) {
      return false;
    }

    // Check for existing pieces - note: this is a simplified version
    // In real implementation, you need to pass gameBoard to this method
    return true;
  }

  bool piecePositionIsValid(List<int> piecePosition) {
    for (int pos in piecePosition) {
      if (!isPositionValid(pos)) {
        return false;
      }
    }
    return true;
  }
}
