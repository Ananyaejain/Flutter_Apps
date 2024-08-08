import 'package:flutter/material.dart';
import 'package:quiz_app_final/models/flutter_screen.dart';
import 'package:quiz_app_final/models/java_screen.dart';
import 'package:quiz_app_final/models/maths_screen.dart';
import 'package:quiz_app_final/models/pyhon_screen.dart';
import 'package:quiz_app_final/utils/category_btns.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Quiz App:Choose a Topic",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
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
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CategoryBtns(
                  screenHandler: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MathScreen(),
                      ),
                    );
                  },
                  assetImage: 'lib/assets/images/math_logo.png',
                ),
                SizedBox(width: 20),
                CategoryBtns(
                  screenHandler: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PyhtonScreen(),
                      ),
                    );
                  },
                  assetImage: 'lib/assets/images/python_logo.png',
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CategoryBtns(
                  screenHandler: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JavaScreen(),
                      ),
                    );
                  },
                  assetImage: 'lib/assets/images/java_logo.png',
                ),
                SizedBox(width: 20),
                CategoryBtns(
                  screenHandler: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlutterScreen(),
                      ),
                    );
                  },
                  assetImage: 'lib/assets/images/flutter_logo.png',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
