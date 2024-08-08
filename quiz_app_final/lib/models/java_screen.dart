import 'package:flutter/material.dart';
import 'package:quiz_app_final/models/quiz.dart';
import 'package:quiz_app_final/models/reset_quiz.dart';

import '../category_screen.dart';

class JavaScreen extends StatefulWidget {
  const JavaScreen({super.key});

  @override
  State<JavaScreen> createState() => _JavaScreenState();
}

class _JavaScreenState extends State<JavaScreen> {
  final questions = [
    {
      'quesText':
          'What is the purpose of the "public" access modifier in Java?',
      'answers': [
        {
          'text':
              'To make a class, method, or variable accessible only within the same package',
          'score': 0,
        },
        {
          'text':
              'To make a class, method, or variable accessible only within the same class',
          'score': 0,
        },
        {
          'text':
              'To make a class, method, or variable accessible from anywhere in the program',
          'score': 10,
        },
        {
          'text':
              'To make a class, method, or variable accessible only to subclasses',
          'score': 0,
        },
      ],
    },
    {
      'quesText': 'What is the purpose of the "static" keyword in Java?',
      'answers': [
        {
          'text': 'To create an instance of a class',
          'score': 0,
        },
        {
          'text':
              'To create a method that can be called without creating an instance of the class',
          'score': 10,
        },
        {
          'text':
              'To create a variable that is unique to each instance of a class',
          'score': 0,
        },
        {
          'text':
              'To create a method that can only be called from within the same class',
          'score': 0,
        },
      ],
    },
    {
      'quesText': 'What is the purpose of the "extends" keyword in Java?',
      'answers': [
        {
          'text':
              'To create a new class that inherits properties and methods from an existing class',
          'score': 10,
        },
        {
          'text':
              'To create a new interface that inherits properties and methods from an existing interface',
          'score': 0,
        },
        {
          'text': 'To create a new class that implements an existing interface',
          'score': 0,
        },
        {
          'text':
              'To create a new class that is a subclass of an existing class',
          'score': 0,
        },
      ],
    },
    {
      'quesText':
          'What is the output of the following code?\n\nint x = 5;\nint y = 2;\nSystem.out.println(x / y);',
      'answers': [
        {
          'text': '2.5',
          'score': 0,
        },
        {
          'text': '2',
          'score': 10,
        },
        {
          'text': '2.0',
          'score': 0,
        },
        {
          'text': 'It will raise an error',
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
        title: Text("Java Quiz"),
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
