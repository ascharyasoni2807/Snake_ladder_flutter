import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gamesnl/tvroomscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gamesnl/signin.dart';
import 'package:gamesnl/tvhome.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({ this.uid});

  final String uid;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DatabaseMethods databaseMethods = dbInstance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var fontdesign = GoogleFonts.ultra(
      textStyle: TextStyle(fontSize: 20, color: Colors.white));
  String roomToken;
  TextEditingController rcodecontroller = new TextEditingController();
  getRoomToken() async {
    var url = 'https://sanskrut-interns.appspot.com/apis/createRoom';
    String token = await dbInstance.getToken();
    final headers = {
      'Authorization': 'Bearer $token',
      // 'accept': 'application/json',
      // HttpHeaders.contentTypeHeader: 'application/json',
    };
    var response = await http.get(url, headers: headers);
    print("response.body====================");
    print(response.body);
    var rest = jsonDecode(response.body);
    final data = rest["room_token"];
    print(data);
    // print(response.statusCode);
    if (response.statusCode == 200) {
      print("body part");
      print(data);
      return data;
    } else {
      throw ErrorDescription("error in this");
    }
  }

  

  // getGameData() async {
  //   final db = await FirebaseDatabase.instance
  //       .reference()
  //       .child('/Users/' + widget.uid);
  //   final DataSnapshot snapshot = await db.once();
  //   dynamic a = snapshot.value;
  //   gameplays = a['gameplay'];

  //   win = a['wins'];
  //   setState(() {});
  // }

  @override
  void initState() {
   
  }

  joinRoom(rcodecontroller) async {
    // print('hello' + rcodecontroller);
    String token = await dbInstance.getToken();

    String roomtoken = rcodecontroller;
    // var names = widget.name;
    var uids = widget.uid;
    print('oohhhh' + roomtoken);
    getUsers() {
      return auth.currentUser;
    }

    final db = FirebaseDatabase.instance.reference().child('/rooms');
    print('room_' + roomtoken.toString());
    final DataSnapshot snapshot = await db.once();
    //print(resp);
    dynamic a = snapshot.value;

    print(a['room_' + roomtoken]);
    if (a['room_' + roomtoken] != null) {
      var url = 'https://sanskrut-interns.appspot.com/apis/joinroom';

      // var url = 'https://localhost:8080/apis/joinroom';
      final headers = {
        'Authorization': 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json'
      };

      final data = {'enterid': roomtoken, 'entername': 'Anonymous', 'uid': uids};
      String body = jsonEncode(data);
      try {
        final dbs = FirebaseDatabase.instance
            .reference()
            .child('/rooms/room_' + roomtoken.toString());
        final DataSnapshot snapshot = await dbs.once();
        dynamic tempstatevalue = snapshot.value;
        print(tempstatevalue['tempState']);
        if (tempstatevalue['tempState'] == true) {
          print('already statred');
          return showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Color(0xff1e272e),
                  title: Text(
                    'Already Started',
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      color: Colors.grey[800],
                      child: Text('close'),
                      onPressed: () {
                        pr.hide();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        } else {
          // var resp = await http.post(url, headers: headers, body: body);
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                  builder: (context) => Roomscreen(
                        roomToken: roomtoken.toString(),
                      )));
        }
      } catch (error) {
        print(error);
      }
    } else {
      pr.hide();
      print('no');
      return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xff1e272e),
              title: Text(
                'No room created',
                style: TextStyle(color: Colors.white),
              ),
              actions: <Widget>[
                FlatButton(
                  color: Colors.grey[800],
                  child: Text('close'),
                  onPressed: () {
                    pr.hide();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(
        message: 'Please Wait...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 8.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff1e272e),
          actions: [
            IconButton(
              // label: Text('Sign out'),
              icon: Icon(Icons.logout),
              onPressed: () {
                try {
                  databaseMethods.signOutGoogle();
                  Navigator.pushReplacement(context,
                       CupertinoPageRoute(builder: (context) => TVMyhome()));
                } catch (e) {
                  print(e);
                }
              },
            )
          ],
          title: Text('User Data',
              style: GoogleFonts.pacifico(
                  textStyle: TextStyle(fontSize: 22, color: Colors.white))),
          // SizedBox(
          //   width: 230,
          // ),
        ),
        body: Container(
          decoration: BoxDecoration(
              // color: Color(0xff1e272e).withOpacity(0.985),

              image: DecorationImage(
            image: AssetImage('assets/images/woods.jpg'),
            fit: BoxFit.cover,
          )),
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      
                      Flexible(
                        child: Text(
                          "'" + "Anonymous" + "'",
                          style: GoogleFonts.pacifico(
                              textStyle:
                                  TextStyle(fontSize: 30, color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              'Enter Room Code To See Board of the GamePlay',
                              style: fontdesign,
                            ),
                          ),
                          
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   
                    RaisedButton(
                      color: Color(0xff1e272e),
                      splashColor: Colors.grey,
                      onPressed: () {
                        setState(() {
                          Alert(
                              style: AlertStyle(
                                  backgroundColor: Color(0xff1e272e),
                                  alertBorder: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(0.0),
                                    side: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  titleStyle:
                                      TextStyle(color: Colors.white)),
                              context: context,
                              title: 'Room Code',
                              content: Column(
                                children: <Widget>[
                                  TextField(
                                    controller: rcodecontroller,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white,
                                              width: 2.0),
                                        ),
                                        labelText: 'Enter Room Code',
                                        labelStyle:
                                            TextStyle(color: Colors.white)
                                        //fillColor: Colors.white,
                                        ),
                                  ),
                                ],
                              ),
                              buttons: [
                                DialogButton(
                                  width: 180,
                                  color: Colors.grey[800],
                                  onPressed: () async {
                                    if (rcodecontroller.text != '') {
                                      print(rcodecontroller.text);
                                      pr.show();
                                      await joinRoom(rcodecontroller.text);

                                      rcodecontroller.clear();
                                    } else {
                                      print("empty");
                                    }
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) {
                                    //       return Roomscreen();
                                    //     },
                                    //   ),
                                    // );
                                  },
                                  child: Text(
                                    "Join Game",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                )
                              ]).show();
                        });
                      },
                      child: Text('JOIN ROOM',
                          style: GoogleFonts.nanumGothic(
                              textStyle: TextStyle(
                                  fontSize: 12, color: Colors.white))),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ));
  }
}
