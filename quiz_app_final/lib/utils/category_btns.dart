import 'package:flutter/material.dart';

class CategoryBtns extends StatelessWidget {
  final VoidCallback screenHandler;
  final String assetImage;

  const CategoryBtns({
    required this.screenHandler,
    required this.assetImage,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        splashColor: Colors.black26,
        onTap: screenHandler,
        child: Image.asset(
          assetImage,
          height: 150,
          width: 150,
        ),
      ),
    );
  }
}
