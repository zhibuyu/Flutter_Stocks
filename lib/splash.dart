import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mystocks/home.dart';
class SplashPage extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<SplashPage> {

  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = new Timer(const Duration(milliseconds: 1500), () {
      try {
        Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
            builder: (BuildContext context) => new home()), (//跳转到主页
            Route route) => route == null);
      } catch (e) {

      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: new Color.fromARGB(255, 0, 215, 198),
      child: new Padding(
        padding: const EdgeInsets.only(
          top: 150.0,
        ),
        child: new Column(
          children: <Widget>[
            new Text("子不语股票",
              style: new TextStyle(color: Colors.white,
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}