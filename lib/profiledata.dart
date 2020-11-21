import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake/signin.dart';
import 'package:snake/home.dart';

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
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Hello User :',
                    style: fontdesign,
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
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'User Email :',
                      style: GoogleFonts.ultra(
                          textStyle:
                              TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Flexible(
                      child: Text(
                        "'" + widget.email + "'",
                        style: GoogleFonts.pacifico(
                            textStyle:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
