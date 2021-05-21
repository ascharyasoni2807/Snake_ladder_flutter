// import 'dart:htm
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:gamesnl/gamescreen.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamesnl/signin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';

import 'home.dart';

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
    setState(() {});
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
      // tempStateCheck();
      // });
    });
  }

  tempStateCheck() async {
    var databseReference;
    databseReference = FirebaseDatabase.instance
        .reference()
        .child('/rooms/room_' + widget.roomToken.toString() + '/tempState')
        .onValue
        .listen((event) {
      //  print("in data");
      print(event.snapshot.value);
      if (event.snapshot.value == false) {
        // navigate to game
        print('not started');
      } else {
        print("game started");
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff1e272e),

          title: Text('Room Screen',
              style: GoogleFonts.pacifico(
                  textStyle: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w700))),
          // SizedBox(
          //   width: 230,
          // ),
        ),
        body: Container(
          decoration: BoxDecoration(
              //  color: Color(0xff1e272e).withOpacity(0.975)
              image: DecorationImage(
            image: AssetImage('assets/images/woods.jpg'),
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
                            textStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
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
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                child: Text(
                  'Room number :',
                  style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              SizedBox(height: 2),
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
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w700))),
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
                                      Flexible(
                                        child: Text(
                                          players[i]['name'],
                                          style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.white,
                                                  fontWeight: i == 0
                                                      ? FontWeight.bold
                                                      : FontWeight.normal)),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        },
                        itemCount: players.length,
                      )
                    : Column(
                        children: [
                          Container(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator()),
                        ],
                      ),
              ),
              SizedBox(
                height: 30,
              ),
              players.length > 0 && dbInstance.uid == players[0]['playerUID']
                  ? Opacity(
                      opacity: players.length > 1 ? 1 : 0.5,
                      child: RaisedButton(
                        color: Color(0xff1e272e),
                        splashColor: Colors.grey[100],
                        onPressed: () {
                          setState(() {
                            players.length <= 1
                                ? print('not starting')
                                : setgameState();
                          });
                        },

                        child: Text(
                          'Start Game',
                          style: GoogleFonts.nanumGothic(
                              textStyle:
                                  TextStyle(fontSize: 13, color: Colors.white)),
                        ),

                        // child:
                      ),
                    )
                  : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
