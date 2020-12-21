// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Roomscreen extends StatefulWidget {
  final int roomToken;

  Roomscreen({this.roomToken});

  @override
  _RoomscreenState createState() => _RoomscreenState();
}

class _RoomscreenState extends State<Roomscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.brown[800],
      //   title: Text("Snake And Ladders",
      //       style: GoogleFonts.pacifico(
      //           textStyle: TextStyle(fontSize: 26, color: Colors.white))),
      // ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/wooden.jpg'),
          fit: BoxFit.cover,
        )),
        width: MediaQuery.of(context).size.width,
        // color: Colors.orange,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.width * 0.50),
            /*   */
            Container(
              child: Text(
                'Room number :',
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(fontSize: 25, color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Text(
                widget.roomToken.toString(),
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(fontSize: 25, color: Colors.white)),
              ),
            ),
            Container(
              width: 250,
              child: Align(
                  alignment: Alignment.center,
                  child: RaisedButton(
                      onPressed: () {
                        print(widget.roomToken);
                      },
                      splashColor: Colors.grey,
                      color: Colors.white,
                      child: Text('Start'))),
            ),
          ],
        ),
      ),
    );
  }
}
