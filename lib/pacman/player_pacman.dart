import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  const MyPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding( 
      padding: EdgeInsets.all(2.0),
      child:  Image.asset(
        'img/pacmaneee.png'
      )
    );
  }
}