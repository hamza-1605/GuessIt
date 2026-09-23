import 'package:flutter/material.dart';

class MyRichText extends StatelessWidget {
  final String heading;
  final String body;
  final Color color;
  const MyRichText({super.key, required this.heading, required this.body, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: heading.toUpperCase(),
        children: [
          TextSpan(
            text: body,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            )  
          ),
        ],
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
      textAlign: TextAlign.justify,
    );
  }
}