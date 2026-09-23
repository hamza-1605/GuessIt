import 'package:flutter/material.dart';

class GameActionButton extends StatelessWidget {
  const GameActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = Colors.black,
    this.bgColor = Colors.transparent
  });

  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        backgroundColor: bgColor,
        side: BorderSide(
          color: color,
          width: 2,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: Text(label),
    );
  }
}