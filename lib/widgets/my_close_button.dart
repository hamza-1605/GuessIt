import 'package:flutter/material.dart';

class MyCloseButton extends StatelessWidget {
  const MyCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: OutlinedButton(
        onPressed: () => Navigator.of(context).pop(),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.pink, 
            width: 1,
          ),
        ),
        child: const Text(
          "CLOSE",
          style: TextStyle(
            color: Colors.pink,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}