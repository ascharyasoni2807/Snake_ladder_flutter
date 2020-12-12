// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snlgame/signin.dart';
import 'package:snlgame/home.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({this.name, this.email});
  final String name;
  final String email;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  var fontdesign = GoogleFonts.ultra(
      textStyle: TextStyle(fontSize: 20, color: Colors.white));

  createroomnymber(rNum) {
    Map<String, dynamic> roomMap = {
      "users": "users",
      "roomId": rNum.toString(),
    };

    print(rNum);
    databaseMethods.createRoomid(rNum.toString(), roomMap);
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
              Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  Flexible(
                    child: Text(
                      'Hello   Player :',
                      style: fontdesign,
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    "'" + widget.name + "'",
                    style: GoogleFonts.pacifico(
                        textStyle:
                            TextStyle(fontSize: 28, color: Colors.white)),
                  )
                ],
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
                        // int min =
                        //     100000; //min and max values act as your 6 digit range
                        // int max = 999999;
                        // var randomizer = new Random();
                        // var rNum = min + randomizer.nextInt(max - min);
                        // print(rNum);
                        // createroomnymber(rNum);

                        var url =
                            'https://sanskrut-interns.appspot.com/apis/createroom';
                        String token = await DatabaseMethods().getToken();
                        print(token);
                        var response = await http.post(url, headers: {
                          HttpHeaders.authorizationHeader: 'Bearer $token'
                        });
                        print(response.body);
                        print(response.statusCode);
                        // print(response.body);
                        // final body = jsonDecode(response.body);

                        // try {
                        //   return await http
                        //       .get(url, headers: {"Authorization": token});

                        //   print(token);
                        //   print('hello');
                        // } catch (e) {
                        //   print(e);
                        // }
                        ;

                        if (response.statusCode == 200) {
                          print("body part");
                        } else {
                          throw ErrorDescription("error");
                        }
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
