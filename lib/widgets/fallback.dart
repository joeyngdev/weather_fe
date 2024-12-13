import 'package:flutter/material.dart';

class Fallback extends StatelessWidget {
  const Fallback(
      {super.key, required this.title, this.img = "asset/cloud.png"});
  final String title;
  final String img;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          img,
          width: 500,
          height: 500,
        ),
        Text(
          title,
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 22,
              fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}
