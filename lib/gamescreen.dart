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

  int diceNumber = null;
  int playerNumber = 1;

  int changeDiceFace() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        print(diceNumber);
        playSound();
        diceNumber = Random().nextInt(6) + 1;
        diceNumber == 6 ? playerNumber = playerNumber : playerNumber++;
        if (playerNumber == 5) {
          playerNumber = 1;
        }
        print(diceNumber);
      });
    });
    return diceNumber;
  }

  // createroom() {
  //   Map<String, dynamic> roomMap = {
  //     "users": "name",
  //     "chatroomId": "roomnumber",
  //   };
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            //margin: EdgeInsets.only(top: 5),
            height: 413,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage('assets/images/board3.png'),
                  fit: BoxFit.fill),
            ),
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage('assets/images/board.png'),
            //         fit: BoxFit.fitHeight)),
            //  color: Colors.blue,
            child: GridView.builder(
              itemCount: 100,
              reverse: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 10,
                //  childAspectRatio: 1.1,
              ),
              itemBuilder: (BuildContext context, int index) {
                //  key:
                // list[index];
                return Stack(children: [
                  index == position()
                      ? Container(
                          height: 20,
                          alignment: Alignment.bottomCenter,
                          child: Image.asset('assets/images/tok1.png'),
                        )
                      : SizedBox.shrink(),
                  Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Center(child: Text(((index) + 1).toString()))
                    // color: Colors.yellow,
                    ,
                  ),
                ]);
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
            height: 80,
            width: 20,
            //   color: Colors.white,
            child: FlatButton(
              //height: 40,
              //minWidth: 20,
              onPressed: () {
                index = valuess(index);
                changeDiceFace();
              },
              child: Image.asset('assets/images/$diceNumber.png'),
            ),
          )
        ],
      ),
    );
  }

  Object value(index, dicenumber) {
    var a = index + diceNumber;
    print('====');
    print(a);

    //  print(diceNumber);
    return a;
  }

  Object position() {}
}
