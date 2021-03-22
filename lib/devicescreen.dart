import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:gamesnl/home.dart';
import 'package:gamesnl/tvhome.dart';
import 'package:google_fonts/google_fonts.dart';



class Device extends StatefulWidget {
  @override
  _DeviceState createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool isAndroidTV ;
   final _scaffoldKey = GlobalKey<ScaffoldState>();

checkDevice() async {
   print(Platform.isAndroid);
    if (Platform.isAndroid)  {
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  isAndroidTV = androidInfo.systemFeatures
          .contains('android.software.leanback');
          setState(() {
            isAndroidTV = isAndroidTV;
            print(isAndroidTV);
          });
          return isAndroidTV;
}

  }
 void showInSnackBar(String value) {
      final snackBar = SnackBar(content: Text(value));
    _scaffoldKey.currentState.showSnackBar(snackBar);  
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkDevice();
   
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/woods.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Center(
                    child: Text(
                      'SELECT YOUR DEVICE TYPE',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
               Container(
                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 120.0),
                   child: RaisedButton(
                     
                            color: Color(0xff1e272e),
                            splashColor: Colors.grey[100],
                            onPressed: () {
                                 if(isAndroidTV){
                              print("go to next");
                               Navigator.pushReplacement(
                               context, MaterialPageRoute(builder: (context) => TVMyhome()));
                            } else {
                                   showInSnackBar("This is Not Android Tv");
                            }
                            },
                            child: Text(
                              'ANDROID TV',
                              style: GoogleFonts.roboto(
                                  textStyle:
                                      TextStyle(fontSize: 13, color: Colors.white,fontWeight: FontWeight.bold)),
                            ),

                            // child:
                          ),
                 ),
               ),
                 Container(
                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 100.0),
                   child: RaisedButton(
                          
                            color:  Color(0xff1e272e),
                            splashColor: Colors.grey[100],
                            onPressed: () async {
                            if(!isAndroidTV){
                              print("go to next");
                               Navigator.pushReplacement(
                               context, MaterialPageRoute(builder: (context) => Myhome()));
                            } else {
                                   showInSnackBar("This is  Not Android Phone/Tablet");
                            }
                            },
                            child: Text(
                              'ANDROID PHONE/TABLET',
                              style: GoogleFonts.roboto(
                                  textStyle:
                                      TextStyle(fontSize: 13, color: Colors.white,fontWeight: FontWeight.bold)),
                            ),

                            // child:
                          ),
                 ),
               ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
