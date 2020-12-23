// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:gamesnl/signin.dart';
import 'package:google_fonts/google_fonts.dart';

class Roomscreen extends StatefulWidget {
  final int roomToken;
  final String name;

  Roomscreen({this.roomToken, this.name});

  @override
  _RoomscreenState createState() => _RoomscreenState();
}

class _RoomscreenState extends State<Roomscreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  String name = DatabaseMethods().name;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              SizedBox(height: MediaQuery.of(context).size.width * 0.050),
              /*   */
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        "Room Creater : ",
                        style: GoogleFonts.roboto(
                            textStyle:
                                TextStyle(fontSize: 19, color: Colors.white)),
                      ),
                    ),
                    Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/tok1.png')),
                        )),
                    SizedBox(
                      width: 2,
                    ),
                    Container(
                      child: Text(
                        widget.name,
                        style: GoogleFonts.roboto(
                            textStyle:
                                TextStyle(fontSize: 19, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  'Room number :',
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(fontSize: 25, color: Colors.white)),
                ),
              ),
              SizedBox(height: 1),
              Container(
                child: Text(
                  widget.roomToken.toString(),
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(fontSize: 25, color: Colors.white)),
                ),
              ),

              // Container(
              //   height: 250,
              //   width: MediaQuery.of(context).size.width*.90
              //   child: ListenPlayers(widget.roomToken),
              // )

              Container(
                width: 250,
                child: Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                        onPressed: () {
                          print(widget.roomToken);
                          print(widget.name);
                        },
                        splashColor: Colors.grey,
                        color: Colors.white,
                        child: Text('Start'))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
