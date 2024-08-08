import 'package:flutter/material.dart';

class Answers extends StatelessWidget {
  final String ansText;
  final VoidCallback ansHandler;

  const Answers({
    required this.ansText,
    required this.ansHandler,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: ansHandler,
          child: Text(ansText),
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all<Size>(
              Size(250, 20)
            )
          ),
        ),
        SizedBox(height: 15,)
      ],
    );
  }
}
