import 'package:flutter/material.dart';
import 'package:guess_number/widgets/my_close_button.dart';
import 'package:guess_number/widgets/my_rich_text.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color.fromARGB(255, 26, 15, 46),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(5),
        side: BorderSide(color: Colors.pink , width: 0.5)
      ),
      alignment: AlignmentGeometry.center,
      elevation: 10.0,
        
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15.0,
          children: [
            
            MyRichText(heading: "Developed by: ", body: "Hamza Sajid"),
            MyRichText(heading: "Contact me on: ", body: '\nhamzasajid1165@gmail.com'),

            Divider(
              height: 20.0,
              thickness: 0.5,
              color: Colors.pink[800],
              indent: 20.0,
              endIndent: 20.0,
            ),

            MyRichText(heading: "Version: ", body: "1.1.1"),
            
            MyCloseButton(),
          ],
        ),
      ),
    );
  }
}