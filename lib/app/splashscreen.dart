import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hallo_doctor_client/app/intro.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Landing()));

  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        width: 410,
        height: 800,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromRGBO(251, 199, 212, 1),
                  Color.fromRGBO(150, 149, 238, 1),
                  // Color.fromRGBO(251, 199, 212, 1),
                ],
              )
          ),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
                child: new CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),

    );
  }
}