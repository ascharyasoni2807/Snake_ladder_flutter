import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:snlgame/signin.dart';
import 'package:snlgame/profiledata.dart';

class Myhome extends StatefulWidget {
  Myhome({Key key, this.name, this.email});
  final String name;
  final String email;
  @override
  _MyhomeState createState() => _MyhomeState();
}

ProgressDialog pr;

class _MyhomeState extends State<Myhome> {
  DatabaseMethods databasesMethods = new DatabaseMethods();

  //  Myhome({Key key, @required this.databasesMethods}) : super(key: key);
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
      // appBar: AppBar(
      //   backgroundColor: Colors.brown[800],
      //   title: Text("Snake And Ladders",
      //       style: GoogleFonts.pacifico(
      //           textStyle: TextStyle(fontSize: 26, color: Colors.white))),
      // ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/wooden.jpg'),
          fit: BoxFit.cover,
        )),
        width: MediaQuery.of(context).size.width,
        // color: Colors.orange,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            /*   */
            Container(
              height: 275,
              width: 400,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/SnakeLadderLogo.png'),
                      fit: BoxFit.fill)),
            ),
            SizedBox(height: 20),
            Container(
              width: 250,
              child: Align(
                alignment: Alignment.center,
                child: RaisedButton(
                  splashColor: Colors.grey,
                  // ignore: deprecated_member_use
                  onPressed: () {
                    pr.show();
                    databasesMethods.signInWithGoogle().then((value) {
                      if (value != null) {
                        try {
                          //  pr.show();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                      name: databasesMethods.name,
                                      email: databasesMethods.email)));
                        } catch (e) {
                          print(e);
                        }
                        print(databasesMethods.email);
                      }
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.google,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        '  Sign In With Google',
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
