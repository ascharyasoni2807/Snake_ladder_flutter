import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
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
      final player1 = AudioCache();
      player1.play('sound2.mp3');
    });
  }

  getCurrentUser() {
    var currentuser = dbInstance.user;

    print(currentuser.uid);
    //print(currentuser);
  }

  int diceNumber = 0;
  int playerNumber = 1;
  List playerUIDS = [];
  List playersin = [];
  List positionsofplayers = [];
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
        playerUIDS.add(playersin[i]['playerUID']);
      }

      for (var i = 0; i <= playersin.length - 1; i++) {
        positionsofplayers.add(playersin[i]['position']);
      }

      for (var i = 0; i <= playersin.length - 1; i++) {
        naming.add(playersin[i]['name']);
      }
      setState(() {});
      print(naming);
    });
  }

  player() {
    FirebaseDatabase.instance
        .reference()
        .child('/rooms/room_' + widget.roomToken.toString() + '/players')
        .onValue
        .listen((event) {
      print(event.snapshot.value);
      print(event.snapshot.value['position']);
      print('hello');
      setState(() {
        //playerPosition();
      });
    });
  }

  boardValue(currentPlayerPos, whichPlayer, diceVal) async {
    var url =
        'https://sanskrut-interns.appspot.com/apis/board/${widget.roomToken}';
    String token = await dbInstance.getToken();
    // var url = 'https://localhost:8080/apis/joinroom';
    final headers = {
      'Authorization': 'Bearer ${token}',
      HttpHeaders.contentTypeHeader: 'application/json'
    };

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

      //diceNumber = diceVal;
      print(body);
      print(naming);
      liveDice();
      player();
    }
    liveDice();
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: Colors.brown[800],
    ));
  }

  List positions = [0, 0];
  List valuesofplayer = [];
  playerPosition() {
    FirebaseDatabase.instance
        .reference()
        .child('/rooms/room_' + widget.roomToken.toString() + '/players')
        // .onValue
        // .listen((event) {
        .once()
        .then((DataSnapshot snapshot) {
      print('in playerposition');
      print(snapshot.value);
      final Map val = snapshot.value;

      valuesofplayer = val.values.toList();

      //valuesofplayer = val.values.toList();

      //  print(values[0]['position']);

      // for (var i = 0; i < valuesofplayer.length; i++) {
      //   print(valuesofplayer[i]['name']);
      //   // positions.add(values[i]['position']);
      //   positions.add(valuesofplayer[i]['position']);
      //   print(positions);
      // }
      print(positions);
      final mem = memberChance;
      positions[mem - 1] = positions[mem - 1] + diceNumber;
      print('positionsssssssssssssssssssssssssssssssssssssssss');
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

      print('playerposition');

      boardValue(positions[mem - 1], memberChance, diceNumber);

      //return diceNumber;
    });
  }

  liveDice() {
    FirebaseDatabase.instance
        .reference()
        .child('/rooms/room_' + widget.roomToken.toString())
        .onValue
        .listen((event) {
      print(event.snapshot.value['dice']);
      diceNumber = event.snapshot.value['dice'];

      setState(() {
        memberChance = event.snapshot.value['memberChance'];
        // playerPosition();
      });

      //playerPosition();
      return memberChance;
    });
    // playerPosition();
  }

  @override
  void initState() {
    Board();
    readPlayers();
    //playerPosition();
    print(widget.roomToken);
    getCurrentUser();
    // setState(() {});

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

    if (response.statusCode == 200) {
      print("body part");
      // print(data);
      diceNumber = data;
      playerPosition();

      return diceNumber;
    } else {
      throw ErrorDescription("error in this");
    }
  }

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
                  Container(
                      height: 100,
                      alignment: Alignment.bottomCenter,
                      child: Center(
                        child: Column(children: [
                          valuesofplayer.length > 0
                              ? index == valuesofplayer[0]['position']
                                  // valuesofplayer[0]['position'] != null
                                  ? Container(
                                      height: 11,
                                      alignment: Alignment.center,
                                      child:
                                          Image.asset('assets/images/tok0.png'))
                                  : SizedBox.shrink()
                              : SizedBox.shrink(),
                          valuesofplayer.length > 1
                              ? index == valuesofplayer[1]['position']
                                  ? Container(
                                      height: 11,
                                      alignment: Alignment.center,
                                      child:
                                          Image.asset('assets/images/tok1.png'))
                                  : SizedBox.shrink()
                              : SizedBox.shrink(),
                          valuesofplayer.length > 2
                              ? index == valuesofplayer[2]['position'] &&
                                      valuesofplayer[2]['position'] != null
                                  //  values[2]['position'] != null
                                  ? Container(
                                      height: 10,
                                      alignment: Alignment.center,
                                      child:
                                          Image.asset('assets/images/tok2.png'))
                                  : SizedBox.shrink()
                              : SizedBox.shrink(),
                          valuesofplayer.length > 3
                              ? index == valuesofplayer[3]['position'] &&
                                      valuesofplayer[3]['position'] != null
                                  ? Container(
                                      height: 10,
                                      alignment: Alignment.center,
                                      child:
                                          Image.asset('assets/images/tok3.png'))
                                  : SizedBox.shrink()
                              : SizedBox.shrink()
                          // ],
                        ]),
                      )),
                  // : SizedBox.shrink(),
                  Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Center(
                        child: (index == 0 || index == 99)
                            ? Text('')
                            : Text((((index) + 1)).toString()))
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
              'CHANCE of  :  ' + naming[memberChance - 1].toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold),
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
                          //height: 40,
                          //minWidth: 20,
                          onPressed: () async {
                            //  index = valuess(index);
                            //    changeDiceFace();
                            String loggedid = dbInstance.uid;

                            if (playerUIDS[memberChance - 1] != loggedid) {
                              print('not your turn');
                              getCurrentUser();
                              showInSnackBar('not your turn');
                              print(positions);
                              print(valuesofplayer);
                              liveDice();
                              // playerPosition();
                            } else {
                              playSound();
                              //playerPosition();
                              diceNumber = await rollDiceChance();

                              // liveDice();
                              // //  playSound();
                              // print('======');

                              setState(() {});
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
