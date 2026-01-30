import 'package:flutter/material.dart';
import 'package:guess_number/widgets/my_close_button.dart';
import 'package:guess_number/widgets/my_rich_text.dart';

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({
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
            
            MyRichText( heading: "Objective: ", body: "You have to guess the hidden number behind the black box."),
            MyRichText( heading: "Restriction: ", body: "You only have 5 limited guesses."),
            MyRichText( heading: "", body: "After each incorrect guess, you will be provided by a hint; that either your guess is higher than the hidden number or lower. You may vary your guesses accordingly."),
            
            Divider(
              height: 15.0,
              thickness: 0.5,
              color: Colors.pink[800],
              indent: 20.0,
              endIndent: 20.0,
            ),

            MyRichText( heading: "", body: "The range depends as per the difficulty mode:"),
            MyRichText( heading: "Easy: ", body: "0 to 10"),
            MyRichText( heading: "Medium: ", body: "0 to 50"),
            MyRichText( heading: "Hard: ", body: "0 to 99"),
            MyRichText( heading: "", body: "You can hit the reset button at the end of each round."),
                    
            Divider(
              height: 20.0,
              thickness: 0.5,
              color: Colors.pink[800],
              indent: 20.0,
              endIndent: 20.0,
            ),
            Align(alignment: AlignmentGeometry.center, child: MyRichText( heading: "Good luck & have fun!", body: "")),
            
            MyCloseButton(),
          ],
        ),
      ),
    );
  }
}