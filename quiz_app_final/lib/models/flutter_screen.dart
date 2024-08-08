import 'package:flutter/material.dart';
import 'package:quiz_app_final/models/quiz.dart';
import 'package:quiz_app_final/models/reset_quiz.dart';

import '../category_screen.dart';

class FlutterScreen extends StatefulWidget {
  const FlutterScreen({super.key});

  @override
  State<FlutterScreen> createState() => _FlutterScreenState();
}

class _FlutterScreenState extends State<FlutterScreen> {
  final questions = [
    {
      'quesText': 'What is Flutter known for?',
      'answers': [
        {'text': 'A programming language', 'score': 0},
        {'text': 'A framework for building user interfaces', 'score': 10},
        {'text': 'A cloud computing service', 'score': 0},
        {'text': 'A version control system', 'score': 0},
      ],
    },
    {
      'quesText':
          'Which programming language is primarily used for Flutter app development?',
      'answers': [
        {'text': 'Java', 'score': 0},
        {'text': 'Dart', 'score': 10},
        {'text': 'Swift', 'score': 0},
        {'text': 'Kotlin', 'score': 0},
      ],
    },
    {
      'quesText': 'What widget in Flutter is used to create a button?',
      'answers': [
        {'text': 'Text', 'score': 0},
        {'text': 'Button', 'score': 0},
        {'text': 'FlatButton', 'score': 10},
        {'text': 'Label', 'score': 0},
      ],
    },
    {
      'quesText': 'Which company developed Flutter?',
      'answers': [
        {'text': 'Facebook', 'score': 0},
        {'text': 'Apple', 'score': 0},
        {'text': 'Microsoft', 'score': 0},
        {'text': 'Google', 'score': 10},
      ],
    },
  ];

  int quesIndex = 0;
  var totalScore = 0;

  void answerQues(int score) {
    totalScore += score;
    setState(() {
      quesIndex += 1;
    });
  }

  void resetQuiz() {
    setState(() {
      quesIndex = 0;
      totalScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Quiz"),
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        height: double.infinity,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.indigo,
                Colors.purple,
              ]),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            quesIndex < questions.length
                ? Quiz(
                    quesIndex: quesIndex,
                    questions: questions,
                    ansHandler: answerQues,
                  )
                : ResetQuiz(
                    resetHandler: resetQuiz,
                    homePageHandler: () {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryScreen(),
                        ),
                      );
                    },
                    resultScore: totalScore,
                  ),
          ],
        ),
      ),
    );
  }
}
