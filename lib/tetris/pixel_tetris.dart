import 'package:flutter/material.dart';

class PixelTetris extends StatelessWidget {
  final Color? color;


  const PixelTetris({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.all(1), // Make sure this is correctly using the child widget
    );
  }
}
