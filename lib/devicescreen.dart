import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class Device extends StatefulWidget {
  @override
  _DeviceState createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/wooden.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Center(
                    child: Text(
                      'Select your Device type',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 60, right: 60),
                    child: Container(
                      child: Center(
                          child: Text(
                        'Android TV',
                        style: TextStyle(color: Colors.white, fontSize: 50),
                      )),
                      width: 50,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.brown[700],
                        border: Border.all(
                          width: 2,
                          color: Colors.brown[400],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 60, right: 60),
                    child: Container(
                      child: Center(
                          child: Text(
                        'Phone',
                        style: TextStyle(color: Colors.white, fontSize: 50),
                      )),
                      width: 50,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.brown[700],
                        border: Border.all(
                          width: 2,
                          color: Colors.brown[400],
                        ),
                      ),
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
