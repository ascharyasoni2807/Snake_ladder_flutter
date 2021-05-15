import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamesnl/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:gamesnl/signin.dart';

class Winnerpopup extends StatefulWidget {
  final String passname;
  Winnerpopup({this.passname});

  @override
  _WinnerpopupState createState() => _WinnerpopupState();
}

class _WinnerpopupState extends State<Winnerpopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 280,
          child: AlertDialog(
            backgroundColor: Color(0xff1e272e),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            title: Text(
              'Winner Is :',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              children: [
                Container(
                  child: Text(widget.passname,
                      style: GoogleFonts.raleway(color: Colors.white)),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text('Thank you for playing',
                      style: GoogleFonts.raleway(color: Colors.white)),
                ),
              ],
            ),
            actions: [
              FlatButton(
                child: Text("Exit",
                    style: GoogleFonts.raleway(color: Colors.white)),
                onPressed: () {
                  try {
                    dbInstance.signOutGoogle();
                    Navigator.pushReplacement(context,
                        new CupertinoPageRoute(builder: (context) => Myhome()));
                  } catch (e) {
                    print(e);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
