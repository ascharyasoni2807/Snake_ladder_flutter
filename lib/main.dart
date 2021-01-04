import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:gamesnl/gamescreen.dart';

import 'package:gamesnl/profiledata.dart';
//import 'package:snlgame/gamescreen.dart';
import 'package:gamesnl/home.dart';
//import 'package:snlgame/profiledata.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:snlgame/signin.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'Helperfunctions.dart';

ProgressDialog pr;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsloggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  getLoggedInfo();
    Future.delayed(
      Duration(seconds: 3),
      () {
        // userIsloggedIn
        //     ? Navigator.pushReplacement(context,
        //         MaterialPageRoute(builder: (context) => ProfileScreen()))
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Myhome()));
      },
    );
  }

  // getLoggedInfo() async {
  //   await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
  //     setState(() {
  //       print(value);
  //       print("batao");
  //       userIsloggedIn = value;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    //   return SplashScreen(
    //     seconds: 5,
    //     navigateAfterSeconds: new Aftersplash(),
    //     title: Text("loading g"),
    //   );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/wooden.jpg'),
                fit: BoxFit.cover)),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(height: 300),
            Center(
              // mainAxisAlignment: MainAxisAlignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.30),
                  CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      strokeWidth: 5,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.brown)),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Loading Game",
                      style: GoogleFonts.ultra(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 14)))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   DatabaseMethods databaseMethods = new DatabaseMethods();
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         initialRoute: "/",
//         routes: {
//           "/": (context) => Myhome(),
//           "/profile": (context) => ProfileScreen(
//               name: databaseMethods.name, email: databaseMethods.email),
//           "/game": (context) => GameScreen()
//         });
//   }
// }

// class Aftersplash extends StatelessWidget {
//   DatabaseMethods databaseMethods = new DatabaseMethods();
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         initialRoute: "/",
//         routes: {
//           "/": (context) => Myhome(),
//           "/profile": (context) => ProfileScreen(
//               name: databaseMethods.name, email: databaseMethods.email),
//           "/game": (context) => GameScreen()
//         });
//   }
// }
