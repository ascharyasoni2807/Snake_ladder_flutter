import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gamesnl/Helperfunctions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:gamesnl/signin.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gamesnl/profiledata.dart';

final String endpointBase = 'https://sanskrut-interns.appspot.com/apis';
String getUrl(endpoint) {
  return '$endpointBase/$endpoint';
}

class Myhome extends StatefulWidget {
  Myhome({Key key, this.name, this.email, this.uid});
  final String name;
  final String email;
  final String uid;
  @override
  _MyhomeState createState() => _MyhomeState();
}

ProgressDialog pr;

class _MyhomeState extends State<Myhome> {
  DatabaseMethods databasesMethods = dbInstance;

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

    setUser(names, emails, uids) async {
      var url = getUrl('setUser');
      String token =
          // 'eyJhbGciOiJSUzI1NiIsImtpZCI6IjNjYmM4ZjIyMDJmNjZkMWIxZTEwMTY1OTFhZTIxNTZiZTM5NWM2ZDciLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoiMURBMThDUzAyMl9BU0NIQVJZQSBTb25pIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hLS9BT2gxNEdpMTh6RlUwdGpVc2JIai13REVmVERjVkVmcnRZREFneEJKYmg0cD1zOTYtYyIsImlzcyI6Imh0dHBzOi8vc2VjdXJldG9rZW4uZ29vZ2xlLmNvbS9zYW5za3J1dC1pbnRlcm5zIiwiYXVkIjoic2Fuc2tydXQtaW50ZXJucyIsImF1dGhfdGltZSI6MTYwODQ2NDEzMywidXNlcl9pZCI6InJ5dzc0TksxNW1QREt4OWw3WTJqTmc0N0FMTDIiLCJzdWIiOiJyeXc3NE5LMTVtUERLeDlsN1kyak5nNDdBTEwyIiwiaWF0IjoxNjA4NDY0MTMzLCJleHAiOjE2MDg0Njc3MzMsImVtYWlsIjoiYXNjaGFyeWFzb25pMjgwN0Bkci1haXQub3JnIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZ29vZ2xlLmNvbSI6WyIxMDYwNjA0OTM5MzcyNDEwMjAyOTUiXSwiZW1haWwiOlsiYXNjaGFyeWFzb25pMjgwN0Bkci1haXQub3JnIl19LCJzaWduX2luX3Byb3ZpZGVyIjoiZ29vZ2xlLmNvbSJ9fQ.knI8yzCS76IwICJiPZGa6V_PqNKKimV5SfWIpp6J5_96u3lxaSPP55UB1VHuHNn-2qJq-KT8DPDuZz6QxgqPECE55_2nYYqbZDdFIrRnv090ah46pbYICQrxnqbxJ4sWglLe65MHO01_GClHLhujKM7LtxrWaGnZ11aqCeTqXWXODy0RaDR22xbuSjfMng2D7xs3UCwiSxwEj4bKptoZ6jh8JJ67o4-WjE4ZLBZ1wXTxTcFqBxp0WyPFlfV7pc20kCkx1oLir5VU9pyp5Yx2J8l7PonM3aCKr6T1FaMcGGi1lEy5LHAb9R2eU_rc7cOXlSOmdPeR2ZxNWfwKYstdzg';
          await dbInstance.getToken();
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
                    databasesMethods.signInWithGoogle().then((value) async {
                      // print(value);

                      if (value != null) {
                        var emails = databasesMethods.email;

                        var names = databasesMethods.name;
                        var uids = databasesMethods.uid;
                        //   HelperFunctions.saveUserLoggedInSharedPreference(true);

                        try {
                          setUser(names, emails, uids);
                          //  pr.show();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                      name: databasesMethods.name,
                                      email: databasesMethods.email,
                                      uid: databasesMethods.uid)));
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
