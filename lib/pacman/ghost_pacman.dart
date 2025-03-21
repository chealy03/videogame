import 'package:flutter/material.dart';

class MyGhost extends StatelessWidget {
  const MyGhost({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding( 
      padding: EdgeInsets.all(2.0),
      child:  Image.asset(
        'img/ghost.png'
      )
    );
  }
}