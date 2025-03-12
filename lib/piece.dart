import 'dart:ui';
import 'board.dart';
import 'values.dart';

class Piece {
  // the type of tetris piece
  Tetromino type;

  Piece({required this.type});

  // the piece is just a list of integers
  List<int> position = [];

  // initial rotation state
  int rotationState = 1;

  // color of tetris piece
  Color get color {
    return tetrominoColors[type] ??
        const Color(0xFFFFFFFF); // Default to white if no color is found
  }

  // generate the ints
  void initalizePiece() {
    switch (type) {
      case Tetromino.L:
        position = [-26, -16, -6, -5];
        break;
      case Tetromino.J:
        position = [-25, -15, -5, -6];
        break;
      case Tetromino.I:
        position = [-4, -5, -6, -7];
        break;
      case Tetromino.O:
        position = [-15, -16, -5, -6];
        break;
      case Tetromino.S:
        position = [-15, -14, -6, -5];
        break;
      case Tetromino.Z:
        position = [-17, -16, -6, -5];
        break;
      case Tetromino.T:
        position = [-26, -16, -6, -15];
        break;
      default:
    }
  }

  // move piece
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

      default:
    }
  }
void dropPiece() {
  while (piecePositionIsValid(position.map((pos) => pos + rowLength).toList())) {
    for (int i = 0; i < position.length; i++) {
      position[i] += rowLength;
    }
  }
}

  // check for collision
  bool positionIsValid(int position) {
    // get the row and col of position
    int row = (position / rowLength).floor();
    int col = position % rowLength;

    // if the position is taken return false
    if (row < 0 || col < 0 || gameBoard[row][col] != null) {
      return false;
    }

    // position is valid so return true
    else {
      return true;
    }
  }

  // new piece position is valid
  bool piecePositionIsValid(List<int> piecePosition) {
    bool firstColOccupied = false;
    bool lastColOccupied = false;

    for (int pos in piecePosition) {
      // return false if any position is already taken
      if (!positionIsValid(pos)) {
        return false;
      }

      // get the col of position
      int col = pos % rowLength;

      // check if the first or last column is occupied
      if (col == 0) {
        firstColOccupied = true;
      }
      if (col == rowLength - 1) {
        lastColOccupied = true;
      }
    }

    // if there is a piece in the first col and last col, it is going through the wall
    return !(firstColOccupied && lastColOccupied);
  }

  // rotate piece
  void rotatePiece() {
    // new position
    List<int> newPosition = [];

    // Rotate the piece based on its type
    switch (type) {
      case Tetromino.L:
        switch (rotationState) {
          case 0:
            /*

            o
            o
            o o

            */

            // assign new position
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength + 1
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // Update the rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            /*
              
            o o o
            o

            */

            // assign new position
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // Update the rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            /*

            o o
              o
              o

            */

            // assign new position
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength - 1
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // Update the rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            /*

                o
            o o o

            */

            // assign new position
            newPosition = [
              position[1] - rowLength + 1,
              position[1],
              position[1] + 1,
              position[1] - 1
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // Update the rotation state
              rotationState = 0; // Reset rotation state to 0
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
              position[1] + rowLength - 1
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // Update the rotation state
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
              position[1],
              position[1] - 1,
              position[1] + 1
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // Update the rotation state
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
              position[1] - rowLength + 1
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // Update the rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            /*
             
            o o o
                o
              
            */
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] + rowLength + 1
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // Update the rotation state
              rotationState = 0; // Reset rotation state to 0
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
              position[1] + 2
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // Update the rotation state
              rotationState = (rotationState + 1) % 4;
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
              position[1] + 2 * rowLength
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // Update the rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            /*

            o o o o
          
            */
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] - 2
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // Update the rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            /*

            o
            o
            o
            o
          
            */
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - 2 * rowLength
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // Update the rotation state
              rotationState = 0; // Reset rotation state to -1
            }
            break;
        }
        break;

      case Tetromino.O:
        /*
        The O tetromino does not need to be rotated

        o o
        o o

        */
        break;
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
              position[1] + rowLength
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // Update the rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:

            /*

            o
            o o
              o

            */
            newPosition = [
              position[0] - rowLength,
              position[0],
              position[0] + 1,
              position[0] + rowLength + 1
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // Update the rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            /*

            o o
          o o

            */
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
              position[1] + rowLength
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // Update the rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            /*

          o
          o o
            o

            */
            newPosition = [
              position[0] - rowLength,
              position[0],
              position[0] + 1,
              position[0] + rowLength + 1
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // Update the rotation state
              rotationState = 0; // Reset rotation state to 0
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
              position[0] + rowLength - 2,
              position[1],
              position[2] + rowLength - 1,
              position[3] + 1
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // Update the rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            /*
            
              o
            o o
            o

            */
            newPosition = [
              position[0] - rowLength + 2,
              position[1],
              position[2] - rowLength + 1,
              position[3] - 1
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // Update the rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            /*

            o o
              o o
              
            */
            newPosition = [
              position[0] + rowLength - 2,
              position[1],
              position[2] + rowLength - 1,
              position[3] + 1
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // Update the rotation state
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            /*

              o
            o o
            o

            */
            newPosition = [
              position[0] - rowLength + 2,
              position[1],
              position[2] - rowLength + 1,
              position[3] - 1
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              // Update the rotation state
              rotationState = 0; // Reset rotation state to 0
            }
            break;
        }
        break;
      case Tetromino.T:
        switch (rotationState) {
          case 0:
            /*

            o
            o o
            o

            */
            newPosition = [
              position[2] - rowLength,
              position[2],
              position[2] + 1,
              position[2] + rowLength
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
              position[1] + rowLength
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            /*

              o
            o o
              o

            */
            newPosition = [
              position[1] - rowLength,
              position[1] - 1,
              position[1],
              position[1] + rowLength
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
              position[2] - rowLength,
              position[2] - 1,
              position[2],
              position[2] + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = 0; // Reset rotation state to 0
            }
            break;
        }
        break;
    }
  }
}
