import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp3/Home_screen.dart';

void main() {
  runApp(Pokedex());
}
 class Pokedex extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );

  } 
 }


