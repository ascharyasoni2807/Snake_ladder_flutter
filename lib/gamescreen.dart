import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

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
    setState(() {
      final player1 = AudioCache();
      player1.play('sound2.mp3');
    });
  }

  int diceNumber = 1;
  int playerNumber = 1;
  void changeDiceFace() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        playSound();
        diceNumber = Random().nextInt(6) + 1;
        diceNumber == 6 ? playerNumber = playerNumber : playerNumber++;
        if (playerNumber == 5) {
          playerNumber = 1;
        }
      });
    });
  }

  createroom() {
    Map<String, dynamic> roomMap = {
      "users": "name",
      "chatroomId": "roomnumber",
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 420,
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage('assets/images/board.png'),
          //         fit: BoxFit.fitHeight)),
          //  color: Colors.blue,
          child: GridView.builder(
            itemCount: 100,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10,
              //  childAspectRatio: 1.1,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => print(index),
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.yellow[700])),
                    child: Center(
                      child: Text(
                        '$index',
                        // index.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    )
                    // color: Colors.yellow,
                    // child: Text('$index'),
                    ),
              );
            },
          ),
          //s color: Colors.blue,

          //     Image.asset('assets/images/board.png')
        ),

        //Image.asset('assets/images/board.png'),
        SizedBox(height: 10),
        Center(
          child: Text(
            'Tap on Dice to play',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Text(
            'Player $playerNumber',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 90,
          width: 60,
          //   color: Colors.white,
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
