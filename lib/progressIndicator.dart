import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressIndicatoring extends StatelessWidget {
  const ProgressIndicatoring({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      // mainAxisAlignment: MainAxisAlignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(width: MediaQuery.of(context).size.width * 0.30),
          CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 5,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey)),
          SizedBox(
            width: 10,
          ),
          Center(
            child: Text("Please Wait",
                style: GoogleFonts.ultra(
                    textStyle: TextStyle(color: Colors.white, fontSize: 14))),
          )
        ],
      ),
    );
  }
}
