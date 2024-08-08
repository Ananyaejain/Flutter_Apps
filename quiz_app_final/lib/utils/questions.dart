import 'package:flutter/material.dart';

class Questions extends StatelessWidget {
  final String quesText;

  Questions({required this.quesText});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        quesText,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
