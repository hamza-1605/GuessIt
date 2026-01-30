import 'package:flutter/material.dart';

class ItemRow extends StatelessWidget {
  final String label;
  final IconData icondata;
  final VoidCallback onTap;

  const ItemRow({super.key, required this.label, required this.icondata, required this.onTap});
  

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label, 
          style: TextStyle(
            color: Colors.white, 
            fontSize: 25
          )
        ),
        GestureDetector(
          onTap: () {
            onTap();
          },
          child: Icon(
            icondata , 
            color: Colors.white, 
            size: 30
          ),
        ),
      ],
    );
  }
}