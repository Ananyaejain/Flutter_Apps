import 'package:flutter/material.dart';

class ResetQuiz extends StatelessWidget {
  final VoidCallback resetHandler;
  final VoidCallback homePageHandler;
  final int resultScore;

  const ResetQuiz({
    required this.resetHandler,
    required this.homePageHandler,
    required this.resultScore,
  });

  String get resultPhrase {
    String resultText;
    if (resultScore >= 30) {
      resultText = 'You are awesome!';
      print(resultScore);
    } else if (resultScore >= 20) {
      resultText = 'Pretty likeable!';
      print(resultScore);
    } else if (resultScore >= 10) {
      resultText = 'You need to work more!';
    } else {
      resultText = 'This is a poor score!';
      print(resultScore);
    }
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            resultPhrase,
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'Score' ':$resultScore',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //reset quiz
              ElevatedButton(
                onPressed: resetHandler,
                child: Text("Reset"),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                    Size(100, 50)
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  )
                ),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: homePageHandler,
                child: Text("Home Page"),
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                        Size(150, 50)
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    )
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
