import 'package:flutter/material.dart';
import 'package:mystocks/SplashPage.dart';

void main() {
  runApp(new MaterialApp(
      title: "子不语股票",
      theme: new ThemeData(
        primaryIconTheme: const IconThemeData(color: Colors.white),
        brightness: Brightness.light,
        primaryColor: new Color.fromARGB(255, 0, 215, 198),
        accentColor: Colors.cyan[300],
      ),
      home: new SplashPage()));
}