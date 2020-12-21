import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
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
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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

              SizedBox(height: 150),

              Padding(
                padding: const EdgeInsets.only(left: 76),
                child: Row(
                  children: [
                    RaisedButton(
                      color: Colors.brown[700],
                      splashColor: Colors.brown[200],
                      onPressed: () async {
                        final roomToken = await getRoomToken();
                        print('==================');
                        print(roomToken);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Roomscreen(roomToken: roomToken)));
                      },

                      child: Text(
                        'CREATE ROOM',
                        style: GoogleFonts.roboto(
                            textStyle:
                                TextStyle(fontSize: 13, color: Colors.white)),
                      ),

                      // child:
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    RaisedButton(
                      color: Colors.brown[700],
                      splashColor: Colors.brown[200],
                      onPressed: () {},
                      child: Text('JOIN ROOM',
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  fontSize: 13, color: Colors.white))),
                    ),

                    // child:
                  ],
                ),
              )

              //TO show email oF the User.
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   child: Row(
              //     children: [
              //       SizedBox(
              //         width: 20,
              //       ),
              //       Text(
              //         'User Email :',
              //         style: GoogleFonts.ultra(
              //             textStyle:
              //                 TextStyle(fontSize: 20, color: Colors.white)),
              //       ),
              //       SizedBox(
              //         width: 25,
              //       ),
              //       Flexible(
              //         child: Text(
              //           "'" + widget.email + "'",
              //           style: GoogleFonts.pacifico(
              //               textStyle:
              //                   TextStyle(fontSize: 20, color: Colors.white)),
              //         ),
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
