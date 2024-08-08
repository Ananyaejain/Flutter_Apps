import 'package:flutter/material.dart';
import 'package:quiz_app_final/models/quiz.dart';
import 'package:quiz_app_final/models/reset_quiz.dart';

import '../category_screen.dart';

class PyhtonScreen extends StatefulWidget {
  const PyhtonScreen({super.key});

  @override
  State<PyhtonScreen> createState() => _PyhtonScreenState();
}

class _PyhtonScreenState extends State<PyhtonScreen> {
  final questions = [
    {
      'quesText': 'What is the purpose of the "import" statement in Python?',
      'answers': [
        {
          'text': 'To define a variable',
          'score': 0,
        },
        {
          'text': 'To define a function',
          'score': 0,
        },
        {
          'text': 'To include external modules or libraries',
          'score': 10,
        },
        {
          'text': 'To print output to the console',
          'score': 0,
        },
      ],
    },
    {
      'quesText':
          'What is the difference between a list and a tuple in Python?',
      'answers': [
        {
          'text': 'Lists are mutable, tuples are immutable',
          'score': 10,
        },
        {
          'text': 'Lists use square brackets, tuples use round brackets',
          'score': 0,
        },
        {
          'text':
              'Lists can only store integers, tuples can store any data type',
          'score': 0,
        },
        {
          'text': 'There is no difference, they are the same',
          'score': 0,
        },
      ],
    },
    {
      'quesText': 'What is the purpose of the "def" keyword in Python?',
      'answers': [
        {
          'text': 'To define a variable',
          'score': 0,
        },
        {
          'text': 'To define a function',
          'score': 10,
        },
        {
          'text': 'To include external modules or libraries',
          'score': 0,
        },
        {
          'text': 'To print output to the console',
          'score': 0,
        },
      ],
    },
    {
      'quesText':
          'What is the output of the following code?\n\nprint(type(5 + 5.0))',
      'answers': [
        {
          'text': '<class int>',
          'score': 0,
        },
        {
          'text': '<class float>',
          'score': 10,
        },
        {
          'text': '<class str>',
          'score': 0,
        },
        {
          'text': 'It will raise a TypeError',
          'score': 0,
        },
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
        title: Text(
          "Python Quiz",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
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
