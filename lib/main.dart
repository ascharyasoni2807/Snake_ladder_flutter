import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:snake/home.dart';
import 'package:snake/profiledata.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:snake/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/": (context) => Myhome(),
          "/profile": (context) => ProfileScreen(
              name: databaseMethods.name, email: databaseMethods.email),
        });
  }
}
