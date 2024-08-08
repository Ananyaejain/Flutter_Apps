import 'package:flutter/material.dart';
import 'package:quiz_app_final/utils/answers.dart';
import 'package:quiz_app_final/utils/questions.dart';

class Quiz extends StatelessWidget {
  final List<Map<String, Object>> questions;
  final int quesIndex;
  final Function ansHandler;

  const Quiz({
    required this.ansHandler,
    required this.questions,
    required this.quesIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Questions(quesText: questions[quesIndex]['quesText'].toString()),
          SizedBox(height: 15,),
          ...(questions[quesIndex]['answers'] as List<Map<String, Object>>)
              .map((answer) {
            return Answers(
              ansText: answer['text'].toString(),
              ansHandler: () => ansHandler(answer['score']),
            );
          }).toList()
        ],
      ),
    );
  }
}
