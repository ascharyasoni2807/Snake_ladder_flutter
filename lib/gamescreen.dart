import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:gamesnl/winnerpopup.dart';
import 'package:gamesnl/signin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

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
              // width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Color(0xff1e272e),
                // image: DecorationImage(
                //   image: AssetImage('assets/images/wooden.jpg'),
                //   fit: BoxFit.cover,
                // ),
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

  winningbox(name) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Winnerpopup(
                passname: name,
              )));
    });
  }

  String indexToBoard(int actualIndex) {
    if ((actualIndex ~/ 10) % 2 == 0) {
      actualIndex += 1;
      return actualIndex.toString();
    } else {
      if (actualIndex % 10 >= 0 && actualIndex % 10 <= 4) {
        actualIndex = actualIndex + (9 - ((actualIndex % 10) * 2));
      } else {
        actualIndex = ((actualIndex ~/ 10) * 10) + (9 - ((actualIndex % 10)));
      }
      actualIndex += 1;
      return actualIndex.toString();
    }
  }

  int boardToIndex(int boardIndex) {
    boardIndex -= 1;
    if ((boardIndex ~/ 10) % 2 == 0) {
      // boardIndex += 1;
      return boardIndex;
    } else {
      if (boardIndex % 10 >= 0 && boardIndex % 10 <= 4) {
        boardIndex = boardIndex + (9 - ((boardIndex % 10) * 2));
        // boardIndex += 1;
        return boardIndex;
      } else {
        boardIndex = ((boardIndex ~/ 10) * 10) + (9 - ((boardIndex % 10)));
        // boardIndex += 1;
        return boardIndex;
      }
    }
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
  List positionsofplayers = [0, 0, 0, 0];
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
        naming.add(playersin[i]['name']);
      }
      setState(() {});
      print(naming);
      print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiin");
      // print(boardToIndex(valuesofplayer[0]['position']));
      print(boardToIndex(100));
    });
  }

  player() {
    FirebaseDatabase.instance
        .reference()
        .child(
            '/rooms/room_' + widget.roomToken.toString() + '/players/player_1')
        .onValue
        .listen((event) {
      final Map value = event.snapshot.value;
      var positionofp = value.values.toList();
      if (positionofp[2] == 100) {
        print('winner mem cahnce');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Winnerpopup(
                    passname: valuesofplayer[memberChance - 1]['name'])));
        // winner();
      }
    });
  }

  boardValue(currentPlayerPos, whichPlayer, diceVal) async {
    var url =
        'https://sanskrut-interns.appspot.com/apis/board/${widget.roomToken}';
    String token = await dbInstance.getToken();
    // var url = 'https://localhost:8080/apis/joinroom';
    final headers = {
      'Authorization': 'Bearer $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    // currentPlayerPos = boardToIndex(currentPlayerPos);
    print(currentPlayerPos);
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
      // liveDice();
      readPlayers();
      // readplayersPos(); //  player();
    }
    //  liveDice();
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: Colors.brown[800],
    ));
  }

  List positions = [0, 0];
  List valuesofplayer = [];
  playerPosition() async {
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

      print(positions);
      final mem = memberChance;
      valuesofplayer[mem - 1]['position'] =
          valuesofplayer[mem - 1]['position'] + diceNumber;
      print('positionsssssssssssssssssssssssssssssssssssssssss');
      print(positions);
      if (valuesofplayer[mem - 1]['position'] == boardToIndex(100)) {
        print('winner mem cahnce');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Winnerpopup(passname: valuesofplayer[mem - 1]['name'])));
        // winner();
      } else if (valuesofplayer[mem - 1]['position'] > 100) {
        valuesofplayer[mem - 1]['position'] =
            valuesofplayer[mem - 1]['position'] - diceNumber;
      } else {
        print(valuesofplayer[mem - 1]['position']);
      }

      print('playerposition');

      boardValue(valuesofplayer[mem - 1]['position'], memberChance, diceNumber);

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
      print(event.snapshot.value);

      // final Map k = Map();
      // k.values.toList();

      valuesofplayer = event.snapshot.value['players'].values.toList();

      setState(() {
        memberChance = event.snapshot.value['memberChance'];
      });

      //    playerPosition();
      return memberChance;
    });

    //playerPosition();
  }

  @override
  void initState() {
    Board();
    getCurrentUser();
    readPlayers();
    //playerPosition();
    print(widget.roomToken);
    liveDice();

    // setState(() {});

    //print(widget.roomToken + '==================');
  }

  winpopup(name) {
    setState(() {
      Alert(
          style: AlertStyle(
              backgroundColor: Colors.brown[800],
              alertBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
                side: BorderSide(
                  color: Colors.white,
                ),
              ),
              titleStyle: TextStyle(color: Colors.white)),
          context: context,
          title: 'WINNER IS',
          content: Column(
            children: <Widget>[],
          ),
          buttons: [
            DialogButton(
              width: 180,
              color: Colors.brown[400],
              onPressed: () async {},
              child: Text(
                name,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ]).show();
    });
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
    var s = MediaQuery.of(context).size;
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    color: Colors.white,
                    // width: side,
                  ),
                ),
                Image.asset(
                  'assets/images/board3.png',
                  // height: side,
                  fit: BoxFit.cover,
                ),
                GridView.builder(
                  primary: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 100,
                  reverse: true,
                  shrinkWrap: true,
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
                                  ? index == 0
                                      ? SizedBox.shrink()
                                      : index ==
                                                  boardToIndex(valuesofplayer[0]
                                                      ['position']) &&
                                              boardToIndex(valuesofplayer[0]
                                                      ['position']) !=
                                                  null &&
                                              boardToIndex(valuesofplayer[0]
                                                      ['position']) !=
                                                  100
                                          // valuesofplayer[0]['position'] != null
                                          ? Container(
                                              height: 20,
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                  'assets/images/tok0.png'))
                                          : index != 0 &&
                                                  boardToIndex(valuesofplayer[0]
                                                          ['position']) ==
                                                      90
                                              ? winningbox(
                                                  valuesofplayer[0]['name'])
                                              : SizedBox.shrink()
                                  : SizedBox.shrink(),
                              valuesofplayer.length > 1
                                  ? index == 0
                                      ? SizedBox.shrink()
                                      : index ==
                                                  boardToIndex(valuesofplayer[1]
                                                      ['position']) &&
                                              boardToIndex(valuesofplayer[1]
                                                      ['position']) !=
                                                  null &&
                                              boardToIndex(valuesofplayer[1]
                                                      ['position']) !=
                                                  100
                                          ? Container(
                                              height: 11,
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                  'assets/images/tok1.png'))
                                          : index != 0 &&
                                                  boardToIndex(valuesofplayer[1]
                                                          ['position']) ==
                                                      90
                                              ? winningbox(
                                                  valuesofplayer[1]['name'])
                                              : SizedBox.shrink()
                                  : SizedBox.shrink(),
                              valuesofplayer.length > 2
                                  ? index == 0
                                      ? SizedBox.shrink()
                                      : index ==
                                                  boardToIndex(valuesofplayer[2]
                                                      ['position']) &&
                                              boardToIndex(valuesofplayer[2]
                                                      ['position']) !=
                                                  null &&
                                              boardToIndex(valuesofplayer[2]
                                                      ['position']) !=
                                                  100
                                          //  values[2]['position'] != null
                                          ? Container(
                                              height: 20,
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                  'assets/images/tok2.png'))
                                          : index != 0 &&
                                                  boardToIndex(valuesofplayer[2]
                                                          ['position']) ==
                                                      90
                                              ? winningbox(
                                                  valuesofplayer[2]['name'])
                                              : SizedBox.shrink()
                                  : SizedBox.shrink(),
                              valuesofplayer.length > 3
                                  ? index == 0
                                      ? SizedBox.shrink()
                                      : index ==
                                                  boardToIndex(valuesofplayer[3]
                                                      ['position']) &&
                                              boardToIndex(valuesofplayer[3]
                                                      ['position']) !=
                                                  null &&
                                              boardToIndex(valuesofplayer[3]
                                                      ['position']) !=
                                                  100
                                          ? Container(
                                              height: 10,
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                  'assets/images/tok3.png'))
                                          : index != 0 &&
                                                  boardToIndex(valuesofplayer[3]
                                                          ['position']) ==
                                                      90
                                              ? winningbox(
                                                  valuesofplayer[3]['name'])
                                              : SizedBox.shrink()
                                  : SizedBox.shrink()
                              // ],
                            ]),
                          )),
                      // : SizedBox.shrink(),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 6,
                              ),
                              index == boardToIndex(100)
                                  ? Center(
                                      child:
                                          Image.asset('assets/images/winn.png'),
                                    )
                                  : index == boardToIndex(1)
                                      ? Center(
                                          child: Image.asset(
                                              'assets/images/arrow.png'),
                                        )
                                      : (index == boardToIndex(96) ||
                                                  index == boardToIndex(94) ||
                                                  index == boardToIndex(75) ||
                                                  index == boardToIndex(37) ||
                                                  index == boardToIndex(47) ||
                                                  index == boardToIndex(28)) ||
                                              index == boardToIndex(4) ||
                                              index == boardToIndex(14) ||
                                              index == boardToIndex(12) ||
                                              index == boardToIndex(22) ||
                                              index == boardToIndex(41) ||
                                              index == boardToIndex(54)
                                          ? Center(
                                              child: Text(
                                              indexToBoard(index),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w900),
                                            ))
                                          : Center(
                                              child: Text(indexToBoard(index)))
                            ],
                          )
                          // color: Colors.yellow,

                          )
                    ]);
                  },
                ),
              ],
            ),
          ),

          //Image.asset('assets/images/board.png'),
          SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Text(
                  'Chance of  :  ',
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Text(
                    naming[memberChance - 1].toString(),
                    style: GoogleFonts.raleway(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 20),
            child: Text(
              'Please press the dice to take your turn.',
              style: GoogleFonts.raleway(
                // fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: FlatButton(
                      //height: 40,
                      //minWidth: 20,
                      onPressed: () async {
                        //  index = valuess(index);
                        //    changeDiceFace();
                        // winpopup(valuesofplayer[0]['name']);
                        String loggedid = dbInstance.uid;

                        if (playerUIDS[memberChance - 1] != loggedid) {
                          print('not your turn');
                          getCurrentUser();
                          showInSnackBar('Not Your Turn');
                          // print(positions);
                          // print(valuesofplayer);
                          // liveDice();
                          // playerPosition();
                        } else {
                          playSound();
                          //playerPosition();
                          diceNumber = await rollDiceChance();

                          print(diceNumber);
                        }
                        var a = indexToBoard(10);
                        print(a);
                      },
                      child: Opacity(
                        opacity: playerUIDS[memberChance - 1] != dbInstance.uid
                            ? 0.5
                            : 1.0,
                        child: Image.asset(
                          'assets/images/$diceNumber.png',
                          width: size.width * 0.3,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Players (scroll)',
                    style: GoogleFonts.raleway(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: playersin.length > 0
                      ? ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 10,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/tok$i.png')),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    playersin[i]['name'],
                                    style: GoogleFonts.raleway(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: i == 0
                                              ? FontWeight.bold
                                              : FontWeight.normal),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: playersin.length,
                        )
                      : CircularProgressIndicator(),
                ),
              ],
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
