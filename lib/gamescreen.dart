import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.brown[800],
            title: Text("Snake And Ladders")),
        body: Container(
            //      color: Colors.blue,
            height: 500,
            // width: 410,
            //  width: MediaQuery.of(context).size.width,
            // width: 1000,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/board.png'),
              //   // fit: BoxFit.cover,
              // )))
            ))));
  }
}
