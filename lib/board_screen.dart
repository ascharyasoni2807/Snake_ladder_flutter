import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audio_cache.dart';

void main() {
  runApp(BoardScreen());
}

class BoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/wooden.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Board(),
          ),
        ),
      ),
    );
  }
}

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  void playSound() {
    final player1 = AudioCache();
    player1.play('sound2.mp3');
  }

  int diceNumber = 1;
  int playerNumber = 1;
  void changeDiceFace() {
    playSound();
    Future.delayed(const Duration(milliseconds: 1100), () {
      setState(() {
        diceNumber = Random().nextInt(6) + 1;
        diceNumber == 6 ? playerNumber = playerNumber : playerNumber++;
        if (playerNumber == 5) {
          playerNumber = 1;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 4,
          child: Image.asset('asstes/images/board.png'),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Tap on Dice to play',
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Player $playerNumber',
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
          ),
        ),
        Expanded(
          child: FlatButton(
            onPressed: () {
              changeDiceFace();
            },
            child: Image.asset('assets/images/$diceNumber.png'),
          ),
        )
      ],
    );
  }
}
