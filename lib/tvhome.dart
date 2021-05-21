import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:gamesnl/Helperfunctions';
import 'package:gamesnl/signin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:gamesnl/tvprofiledata.dart';

final String endpointBase = 'https://sanskrut-interns.appspot.com/apis';
String getUrl(endpoint) {
  return '$endpointBase/$endpoint';
}

class TVMyhome extends StatefulWidget {
  TVMyhome({Key key, this.name, this.email, this.uid});
  final String name;
  final String email;
  final String uid;
  @override
  _TVMyhomeState createState() => _TVMyhomeState();
}

ProgressDialog pr;

class _TVMyhomeState extends State<TVMyhome> {
  DatabaseMethods databasesMethods = dbInstance;

  //  TVMyhome({Key key, @required this.databasesMethods}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;
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

    setUser(names, emails, uids) async {
      var url = getUrl('setUser');
      String token = await dbInstance.getToken();
      final headers = {
        'authorization': 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      print(token);
      final req = {
        'uid': uids,
        'name': names,
        'email': emails,
      };
      try {
        var response =
            await http.post(url, headers: headers, body: jsonEncode(req));
        print(response.statusCode);
        return true;
      } catch (e) {
        return null;
      }
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            // color: Color(0xff3d3d3d),
            image: DecorationImage(
          image: AssetImage(
            'assets/images/woods.jpg',
          ),
          fit: BoxFit.cover,
        )),
        // width: MediaQuery.of(context).size.width,
        // color: Colors.orange,
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            /*   */
            Container(
              height: s.height * 0.4,
              width: s.width,
              child: Image.asset("assets/images/SnakeLadderLogo.png"),
              // decoration: BoxDecoration(
              //     image: DecorationImage(
              //         image: AssetImage('assets/images/SnakeLadderLogo.png'),
              //         fit: BoxFit.fill)),
            ),
            SizedBox(height: 20),
            Container(
              width: 250,
              child: Align(
                alignment: Alignment.center,
                child: RaisedButton(
                  splashColor: Colors.grey,
                  // ignore: deprecated_member_use
                  onPressed: () async {
                    pr.show();
                    dynamic result = await DatabaseMethods().signInAnon();
                    User user = result;
                    print(user.uid);

                    if (user != null) {
                      Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => ProfileScreen(
                                    uid: user.uid,
                                  )));
                    } else {
                      print('error');
                    }

                    // databasesMethods.signInWithGoogle().then((value) async {
                    //   // print(value);

                    //   if (value != null) {
                    //     var emails = databasesMethods.email;

                    //     var names = databasesMethods.name;
                    //     var uids = databasesMethods.uid;
                    //     //   HelperFunctions.saveUserLoggedInSharedPreference(true);

                    //     try {
                    //       setUser(names, emails, uids);
                    //       //  pr.show();
                    //       Navigator.pushReplacement(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => ProfileScreen(
                    //                   name: databasesMethods.name,
                    //                   email: databasesMethods.email,
                    //                   uid: databasesMethods.uid)));
                    //     } catch (e) {
                    //       print(e);
                    //     }
                    //     print(databasesMethods.email);
                    //   }
                    // });
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
