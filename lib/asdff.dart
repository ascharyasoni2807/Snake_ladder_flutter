import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:gamesnl/signin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class BoardScreen extends StatelessWidget {
  final roomToken;
  BoardScreen({this.roomToken});

  //final scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          // key: ,
          body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/wooden.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.5),
                child: Board(roomToken: roomToken),
              )),
        ),
      ),
    );
  }
}

class Board extends StatefulWidget {
  final roomToken;
  Board({this.roomToken});

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  DatabaseMethods databaseMethods = dbInstance;
  int memberChance = 1;
  void playSound() {
    setState(() {
      final ausiooo = AudioCache();
      ausiooo.play('sound2.mp3');
    });
  }

  getCurrentUser() {
    var currentuser = dbInstance.user;
    print(currentuser.displayName);
    return currentuser.displayName;
  }

  int diceNumber = 0;
  int playerNumber = 1;
  List positionsofplayers = [];
  List playersin = [];
  //final List positions = [];
  List naming = [];
  readPlayers() {
    var rtoken = widget.roomToken;
    print(rtoken);
    final db = FirebaseDatabase.instance
        .reference()
        .child('/rooms/room_' + rtoken.toString() + '/players');
    print('room_' + rtoken.toString() + 'ooooooooooooooooooo');
    db.once().then((DataSnapshot snapshot) {
      final Map value = snapshot.value;
      playersin = value.values.toList();
      print(playersin);

      for (var i = 0; i <= playersin.length - 1; i++) {
        naming.add(playersin[i]['name']);
      }

      setState(() {});
      print('heelleokeokeoekoko');
      print(naming);
      print(positionsofplayers);
      return naming;
      // positionsofplayers;
      //var a = snapshot.value;
      //   print(a);
    });
  }

  boardValue(currentPlayerPos, whichPlayer, diceVal) async {
    var url =
        'https://sanskrut-interns.appspot.com/apis/board/${widget.roomToken}';

    // var url = 'https://localhost:8080/apis/joinroom';
    String token = await dbInstance.getToken();
    final headers = {
      'Authorization': 'Bearer ${token}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    print(diceVal);
    final body = {
      'memberChance': whichPlayer,
      'position': currentPlayerPos,
      'dice': diceVal
    };

    String data = jsonEncode(body);

    var response = await http.post(url, headers: headers, body: data);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('updated');
      print(memberChance);
    }
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: Colors.brown[800],
    ));
  }

  playerPosition() {
    FirebaseDatabase.instance
        .reference()
        .child('/rooms/room_' + widget.roomToken.toString() + '/players')
        .once()
        .then((DataSnapshot snapshot) {
      print('in playerposition');
      print(snapshot.value);
      final Map val = snapshot.value;
      List values = [];
      values = val.values.toList();
      //  print(values[0]['position']);
      List positions = [];
      for (var i = 0; i < values.length; i++) {
        print(values[i]['name']);
        positions.add(values[i]['position']);
        // print(positions);
      }
      print(positions);
      final mem = memberChance;
      positions[mem - 1] = positions[mem - 1] + diceNumber;
      print(positions);
      if (positions[mem - 1] == 100) {
        print('winner mem cahnce');
        // winner();
      } else if (positions[mem - 1] > 100) {
        positions[mem - 1] = positions[mem - 1] + diceNumber;
        print(playersin[mem - 1] + ' new position is =' + positions[mem - 1]);
      } else {
        print(playersin[mem - 1].toString() +
            ' new position is =' +
            positions[mem - 1].toString());
      }

      boardValue(positions[mem - 1], memberChance, diceNumber);
      //return positions;
    });
  }

  liveDice() {
    FirebaseDatabase.instance
        .reference()
        .child('/rooms/room_' + widget.roomToken.toString())
        .onValue
        .listen((event) {
      print(event.snapshot.value['dice']);
      setState(() {
        diceNumber = event.snapshot.value['dice'];
        memberChance = event.snapshot.value['memberChance'];
      });
    });
  }

  memChance() {
    FirebaseDatabase.instance
        .reference()
        .child('/rooms/room_' + widget.roomToken.toString())
        .onValue
        .listen((event) {
      print(event.snapshot.value['memberChance']);
    });
  }

  @override
  void initState() {
    Board();
    readPlayers();
    print(widget.roomToken);
    getCurrentUser();
    // memChance();
    // setState(() {
    // liveDice();
    // });

    //print(widget.roomToken + '==================');
  }

  Future<int> rollDiceChance() async {
    var url = 'https://sanskrut-interns.appspot.com/apis/board';
    String token = await dbInstance.getToken();
    final headers = {
      'Authorization': 'Bearer $token',
      // 'accept': 'application/json',
      // HttpHeaders.contentTypeHeader: 'application/json',
    };
    var response = await http.get(url, headers: headers);
    // print("response.body====================");
    // print(response.body);
    var rest = jsonDecode(response.body);
    final data = rest["dice_value"];

    setState(() {
      diceNumber = data;
    });

    // print(response.statusCode);
    if (response.statusCode == 200) {
      print("body part");
      playerPosition();
      // return diceNumber;
    } else {
      throw ErrorDescription("error in this");
    }
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
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            //margin: EdgeInsets.only(top: 5),
            height: 410,
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
                  // index == a
                  Center(
                    child: Container(
                        height: 100,
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: [
                            index == 40
                                ? Container(
                                    height: 10,
                                    alignment: Alignment.topLeft,
                                    child:
                                        Image.asset('assets/images/tok0.png'))
                                : SizedBox.shrink(),
                            index == 40
                                ? Container(
                                    height: 10,
                                    alignment: Alignment.topRight,
                                    child:
                                        Image.asset('assets/images/tok1.png'))
                                : SizedBox.shrink(),
                            index == 40
                                ? Container(
                                    height: 10,
                                    alignment: Alignment.bottomLeft,
                                    child:
                                        Image.asset('assets/images/tok2.png'))
                                : SizedBox.shrink(),
                            index == 40
                                ? Container(
                                    height: 10,
                                    alignment: Alignment.bottomRight,
                                    child:
                                        Image.asset('assets/images/tok3.png'))
                                : SizedBox.shrink()
                          ],
                        )

                        // Image.asset('assets/images/tok1.png'),
                        ),
                  ),
                  // : SizedBox.shrink(),
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
              'Chance of :' + naming[memberChance - 1].toString(),
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              // alignment: Alignment.bottomRight,
              //   color: Colors.white,
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 80,
                        child: FlatButton(
                          disabledColor: Colors.transparent,
                          onPressed: () async {
                            String loggedid = getCurrentUser();

                            if (naming[memberChance - 1] != loggedid) {
                              print('not your turn');
                              showInSnackBar('not your turn');
                            } else {
                              getCurrentUser();
                              playSound();
                              diceNumber = await rollDiceChance();
                              playerPosition();
                              // liveDice();
                              // setState(() {});
                              playSound();
                              print('======');
                              print(diceNumber);
                            }
                          },
                          child: Image.asset('assets/images/$diceNumber.png'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      //color: Colors.white,
                      height: 230,
                      width: MediaQuery.of(context).size.width,
                      child: playersin.length > 0
                          ? ListView.builder(
                              itemBuilder: (BuildContext context, int i) {
                                return ListTile(
                                  title: Row(
                                    children: [
                                      Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/tok$i.png')),
                                          )),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        playersin[i]['name'],
                                        style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: i == 0
                                                    ? FontWeight.bold
                                                    : FontWeight.normal)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: playersin.length,
                            )
                          : CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //  Container(alignment: Alignment.centerLeft, child: readPlayers())
        ],
      ),
    );
  }

  // Object value(index, dicenumber) {
  //   var a = index + diceNumber;
  //   print('====');
  //   print(a);

  //   //  print(diceNumber);
  //   return a;
  // }

  // Object position(index) {
  //   var a = index + diceNumber;
  //   return a;
  // }
}

setwinner(position) {}
