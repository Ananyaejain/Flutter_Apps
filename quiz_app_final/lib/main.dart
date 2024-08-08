import 'package:flutter/material.dart';
import 'category_screen.dart';

void main() => runApp(MyApp());

class MyAppColors {
  static final primaryColor = Colors.white;
  static final secondaryColor = Colors.purple;
}

class MyAppThemes {
  static final darkTheme = ThemeData(
      primaryColor: MyAppColors.primaryColor,
      scaffoldBackgroundColor: MyAppColors.primaryColor,
      brightness: Brightness.light
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MyAppThemes.darkTheme,
      home: CategoryScreen(),
    );
  }
}
