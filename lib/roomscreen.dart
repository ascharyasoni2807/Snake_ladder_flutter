// import 'dart:htm
import 'dart:convert';
import 'package:gamesnl/gamescreen.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamesnl/signin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';

class Roomscreen extends StatefulWidget {
  final String roomToken;
  final String name;

  Roomscreen({this.roomToken, this.name});

  @override
  _RoomscreenState createState() => _RoomscreenState();
}

class _RoomscreenState extends State<Roomscreen> {
  DatabaseMethods databaseMethods = dbInstance;
  String name = dbInstance.name;
  List players = [];
  List positions = [];
  List tempState = [];

  listenplayers(roomTokenn) async {
    var databseReference = FirebaseDatabase.instance
        .reference()
        .child('/rooms/room_' + widget.roomToken.toString() + '/players');
    print(roomTokenn);
    print("listenplayers================");
    final roomtokens = roomTokenn;
    databseReference.once().then((DataSnapshot snapshot) {
      final Map value = snapshot.value;
      setState(() {
        players = value.values.toList();
      });
    });
  }

  setgameState() async {
    // var url = 'https://sanskrut-interns.appspot.com/apis/setState';

    String token = await dbInstance.getToken();
    FirebaseDatabase.instance
        .reference()
        .child('/rooms/room_' + widget.roomToken.toString())
        .update({'tempState': true}).then((value) {
      print('done');
      // setState(() {
      tempStateCheck();
      // });
    });

    // databseReference.ref().update({tempState: 'true'});

    // final data = {'roomid': widget.roomToken};
    // String body = jsonEncode(data);
    // try {
    //   tempStateCheck();
    //   if (tempState[4] == true) {
    //     print(true);
    //   } else {
    //     print(false);
    //   }
    // } catch (error) {
    //   print(error);
    //   CircularProgressIndicator();

    // var resp = await http.post(url, headers: headers, body: body);
  }

  tempStateCheck() async {
    var databseReference;
    databseReference = FirebaseDatabase.instance
        .reference()
        .child('/rooms/room_' + widget.roomToken.toString() + '/tempState')
        .onValue
        .listen((event) {
      print("in data");
      print(event.snapshot.value);
      if (event.snapshot.value == false) {
        // navigate to game
        print('not started');
      } else {
        print("game started");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BoardScreen(roomToken: widget.roomToken)));
      }
    });
  }

  @override
  void initState() {
    var databseReference;
    print(databaseMethods.uid);
    // TODO: implement initState
    super.initState();
    databseReference = FirebaseDatabase.instance
        .reference()
        .child('/rooms/room_' + widget.roomToken.toString() + '/players');
    listenplayers(widget.roomToken);
    tempStateCheck();
    databseReference.onChildAdded.listen((_) {
      listenplayers(widget.roomToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ),
                    Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/tok0.png')),
                        )),
                    SizedBox(
                      width: 2,
                    ),
                    Container(
                      child: Expanded(
                        child: Text(
                          players.length > 0
                              ? players[0]['name']
                              : "Loading Creator...",
                          style: GoogleFonts.roboto(
                              textStyle:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ),
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
              SizedBox(
                height: 30,
              ),
              Container(
                height: 50,
                child: Text('Joined Players:',
                    style: GoogleFonts.roboto(
                        textStyle:
                            TextStyle(fontSize: 25, color: Colors.white))),
              ),
              Container(
                //   color: Colors.white,
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: players.length > 0
                    ? ListView.builder(
                        itemBuilder: (BuildContext context, int i) {
                          return i == 0
                              ? SizedBox.shrink()
                              : ListTile(
                                  title: Row(
                                    children: [
                                      Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/tok$i.png')),
                                          )),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        players[i]['name'],
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                                fontWeight: i == 0
                                                    ? FontWeight.bold
                                                    : FontWeight.normal)),
                                      ),
                                    ],
                                  ),
                                );
                        },
                        itemCount: players.length,
                      )
                    : CircularProgressIndicator(),
              ),
              SizedBox(
                height: 30,
              ),
              players.length > 0 && dbInstance.uid == players[0]['playerUID']
                  ? RaisedButton(
                      color: Colors.brown[700],
                      splashColor: Colors.brown[200],
                      onPressed: () {
                        setgameState();
                      },

                      child: Text(
                        'Start Game',
                        style: GoogleFonts.roboto(
                            textStyle:
                                TextStyle(fontSize: 13, color: Colors.white)),
                      ),

                      // child:
                    )
                  : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
