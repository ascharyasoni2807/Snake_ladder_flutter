import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Winnerpopup extends StatefulWidget {
  final String passname;
  Winnerpopup({this.passname});

  @override
  _WinnerpopupState createState() => _WinnerpopupState();
}

class _WinnerpopupState extends State<Winnerpopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      title: Text('Winner Is :'),
      content: Container(
        child: Text(widget.passname),
      ),
    );
  }
}
