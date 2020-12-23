import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gamesnl/listenplayers.dart';
import 'package:gamesnl/roomscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gamesnl/signin.dart';
import 'package:gamesnl/home.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({this.name, this.email, this.uid});
  final String name;
  final String email;
  final String uid;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  var fontdesign = GoogleFonts.ultra(
      textStyle: TextStyle(fontSize: 20, color: Colors.white));
  String roomToken;
  TextEditingController rcodecontroller = new TextEditingController();
  getRoomToken() async {
    var url = 'https://sanskrut-interns.appspot.com/apis/createRoom';
    String token = await DatabaseMethods().getToken();
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

  joinRoom() async {
    var url = 'https://sanskrut-interns.appspot.com/apis/joinroom';
    String token = await DatabaseMethods().getToken();
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
          backgroundColor: Colors.brown[800],
          actions: [
            IconButton(
              // label: Text('Sign out'),
              icon: Icon(Icons.logout),
              onPressed: () {
                try {
                  databaseMethods.signOutGoogle();
                  Navigator.pushReplacement(context,
                      new MaterialPageRoute(builder: (context) => Myhome()));
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
              image: DecorationImage(
            image: AssetImage('assets/images/wooden.jpg'),
            fit: BoxFit.cover,
          )),
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Hello   Player :',
                        style: fontdesign,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "'" + widget.name + "'",
                        style: GoogleFonts.pacifico(
                            textStyle:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'TOTAL GAMEPLAYS :',
                              style: fontdesign,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'TOTAL WINS :',
                              style: fontdesign,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100),
                Padding(
                    padding: const EdgeInsets.only(left: 64),
                    child: Row(
                      children: [
                        RaisedButton(
                          color: Colors.brown[700],
                          splashColor: Colors.brown[200],
                          onPressed: () async {
                            pr.show();
                            final roomToken = await getRoomToken();
                            print('==================');
                            print(roomToken);

                            //ListenPlayers(roomToken);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Roomscreen(
                                        roomToken: roomToken,
                                        name: widget.name)));
                          },

                          child: Text(
                            'CREATE ROOM',
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    fontSize: 13, color: Colors.white)),
                          ),

                          // child:
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        RaisedButton(
                          color: Colors.brown[700],
                          splashColor: Colors.brown[200],
                          onPressed: () {
                            setState(() {
                              Alert(
                                  style: AlertStyle(
                                      backgroundColor: Colors.brown[800],
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
                                      width: 200,
                                      color: Colors.brown[400],
                                      onPressed: () {
                                        print(rcodecontroller.text);
                                        rcodecontroller.clear();
                                        joinRoom();

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
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      fontSize: 13, color: Colors.white))),
                        ),
                      ],
                    )),
              ]),
            ),
          ),
        ));
  }
}
