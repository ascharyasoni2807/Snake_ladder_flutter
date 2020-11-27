import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:snake/gamescreen.dart';
import 'package:snake/home.dart';
import 'package:snake/profiledata.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:snake/signin.dart';
import 'package:snake/gamescreen.dart';

import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Myhome()));
      },
    );
  }

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