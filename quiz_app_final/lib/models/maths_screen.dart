import 'package:flutter/material.dart';
import 'package:quiz_app_final/category_screen.dart';
import 'package:quiz_app_final/models/quiz.dart';
import 'package:quiz_app_final/models/reset_quiz.dart';

class MathScreen extends StatefulWidget {
  const MathScreen({super.key});

  @override
  State<MathScreen> createState() => _MathScreenState();
}

class _MathScreenState extends State<MathScreen> {
  final _questions = [
    {
      'quesText': 'What is 68/4?',
      'answers': [
        {
          'text': '18',
          'score': 0,
        },
        {
          'text': '16',
          'score': 0,
        },
        {
          'text': '17',
          'score': 10,
        },
        {
          'text': '14',
          'score': 0,
        },
      ],
    },
    {
      'quesText': 'What is (a+b)^2?',
      'answers': [
        {
          'text': 'a^2+b^2',
          'score': 0,
        },
        {
          'text': 'a^2+b^2+2ab',
          'score': 10,
        },
        {
          'text': 'a^2+b^2-2ab',
          'score': 0,
        },
        {'text': '(a+b)^2-2ab', 'score': 0},
      ],
    },
    {
      'quesText': 'What is square root of 625?',
      'answers': [
        {
          'text': '15',
          'score': 0,
        },
        {
          'text': '14',
          'score': 0,
        },
        {
          'text': '25',
          'score': 10,
        },
        {
          'text': '20',
          'score': 0,
        },
      ],
    },
    {
      'quesText': 'What is cube root 512?',
      'answers': [
        {
          'text': '6',
          'score': 0,
        },
        {
          'text': '8',
          'score': 10,
        },
        {
          'text': '9',
          'score': 0,
        },
        {
          'text': '7',
          'score': 0,
        },
      ],
    },
  ];

  var _quesIndex = 0;
  var _totalScore = 0;

  void _answerQues(int score) {
    _totalScore += score;
    setState(() {
      _quesIndex += 1;
    });
  }

  void _resetQuiz() {
    setState(() {
      _quesIndex = 0;
      _totalScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mathematics Quiz"),
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
              height: 20,
            ),
            _quesIndex < _questions.length
                ? Quiz(
                      quesIndex: _quesIndex,
                      questions: _questions,
                      ansHandler: _answerQues,
                    )
                : ResetQuiz(
                    resetHandler: _resetQuiz,
                    homePageHandler: () {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryScreen(),
                        ),
                      );
                    },
                    resultScore: _totalScore,
                  ),
          ],
        ),
      ),
    );
  }
}
