import 'package:buscagif/UI/homePage.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(
      hintColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintStyle: TextStyle(color: Colors.amber),
      )
    ),
  ));
}