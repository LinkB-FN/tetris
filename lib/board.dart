import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'piece.dart';
import 'tile.dart';
import 'values.dart';
import 'package:audioplayers/audioplayers.dart';

int rowLength = 10;
int colLength = 15;

List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(rowLength, (j) => null),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late AudioPlayer _audioPlayer;
  late Piece currentPiece;
  int currentScore = 0;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    currentPiece = Piece(type: Tetromino.T);
    startGame();
    playMusic();
  }

  void playMusic() async {
  await _audioPlayer.setReleaseMode(ReleaseMode.loop);
  try {
    print("Attempting to play audio...");
    await _audioPlayer.play(AssetSource('sounds/notification.mp3')); // No 'assets/'
    print("Audio should be playing now.");
  } catch (e) {
    print("Error playing audio: $e");
  }
}


  void stopMusic() async {
    print("Stopping audio...");
    await _audioPlayer.stop();
    print("Audio stopped.");
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void startGame() {
    currentPiece.initalizePiece();
    Duration frameRate = const Duration(milliseconds: 400);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      if (gameOver) {
        timer.cancel();
        showGameOverDialog();
      } else {
        setState(() {
          clearLines();
          checkLanding();
          currentPiece.movePiece(Direction.down);
        });
      }
    });
  }

  void showGameOverDialog() {
    stopMusic();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('Your score is: $currentScore'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                resetGame();
                playMusic();
                Navigator.of(context).pop();
              },
              child: const Text('PLAY AGAIN'),
            ),
          ],
        );
      },
    );
  }

  void checkLanding() {
    if (checkCollision(direction: Direction.down)) {
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }
      createNewPiece();
    }
  }

  bool checkCollision({Direction? direction}) {
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;
      if (direction == Direction.left) col -= 1;
      if (direction == Direction.right) col += 1;
      if (direction == Direction.down) row += 1;
      if (row >= colLength || col < 0 || col >= rowLength) return true;
      if (row >= 0 && col >= 0 && gameBoard[row][col] != null) return true;
    }
    return false;
  }

  void createNewPiece() {
    Random rand = Random();
    Tetromino randomType = Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initalizePiece();
    if (isGameOver()) {
      setState(() {
        gameOver = true;
      });
    }
  }

  void clearLines() {
    for (int row = colLength - 1; row >= 0; row--) {
      bool rowIsFull = gameBoard[row].every((tile) => tile != null);
      if (rowIsFull) {
        for (int r = row; r > 0; r--) {
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }
        gameBoard[0] = List.generate(rowLength, (col) => null);
        setState(() {
          currentScore++;
        });
      }
    }
  }

  bool isGameOver() {
    return gameBoard[0].any((tile) => tile != null);
  }

  void moveLeft() {
    if (!checkCollision(direction: Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  void moveRight() {
    if (!checkCollision(direction: Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  void resetGame() {
    setState(() {
      gameBoard = List.generate(colLength, (i) => List.generate(rowLength, (j) => null));
      gameOver = false;
      currentScore = 0;
      createNewPiece();
      startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: rowLength * colLength,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowLength,
                ),
                itemBuilder: (context, index) {
                  int row = (index / rowLength).floor();
                  int col = index % rowLength;

                  // tetromino tile
                  if (currentPiece.position.contains(index)) {
                    return Tile(
                      color: currentPiece.color,
                    );
                  }

                  // game board tile
                  else if (gameBoard[row][col] != null) {
                    final Tetromino? tetrominoType = gameBoard[row][col];
                    return Tile(
                      color: tetrominoColors[tetrominoType],
                    );
                  }

                  // blank tile
                  else {
                    return Tile(
                      color: Colors.grey[900],);
                  }
                },
              ),
            ),
               Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                "SCORE: $currentScore",
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            // Control buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Move left button
                      IconButton(
                        onPressed: moveLeft,
                        color: Colors.grey,
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                      // Rotate piece button
                      IconButton(
                        onPressed: rotatePiece,
                        color: Colors.grey,
                        icon: const Icon(Icons.rotate_right),
                      ),
                      // Move right button
                      IconButton(
                        onPressed: moveRight,
                        color: Colors.grey,
                        icon: const Icon(Icons.arrow_forward_ios),
                      ),
                      // Drop piece button
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentPiece.dropPiece(); // Call the dropPiece function
                          });
                        },
                        child: const Text("Drop"),
                      ),
                    ],
                  ),
                  // Reset game button
                  ElevatedButton(
                    onPressed: resetGame,
                    child: const Text('Reset Game'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
