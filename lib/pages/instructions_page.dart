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
        
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15.0,
            children: [
              MyRichText(
                heading: "About GuessIt: ",
                body: " GuessIt is a fun number-guessing game where you can either guess a hidden number or make the CPU to guess yours.",
              ),
              
              Divider(
                height: 15.0,
                thickness: 0.5,
                color: Colors.pink[800],
                indent: 20.0,
                endIndent: 20.0,
              ),
              
              // Game Mode 1
              const MyRichText(heading: "Game Mode 1", body: "", color: Colors.amber),
              const MyRichText(
                heading: "Guess the Number: ",
                body:
                    "You have to guess the hidden number. After each incorrect guess, you will receive a hint indicating whether your guess is higher or lower. BEWARE: You have only 5 guesses.",
              ),
      
              const MyRichText(
                heading: "Difficulties:\n",
                body:
                    "Easy: 1 to 10\n"
                    "Medium: 1 to 50\n"
                    "Hard: 1 to 100",
              ),
              const MyRichText(heading: "", body: "The higher the difficulty, the bigger the range, the lesser probability of you guessing."),
      
              Divider(
                height: 15.0,
                thickness: 0.5,
                color: Colors.pink[800],
                indent: 20.0,
                endIndent: 20.0,
              ),
      
              // Game Mode 2
              const MyRichText(heading: "Game Mode 2", body: "", color: Colors.amber),
              const MyRichText(
                heading: "CPU Guesses Your Number: ",
                body:
                    "Think of a number within the selected range, and let the CPU try to guess it. Provide hints by selecting Higher, Lower, or Correct.",
              ),
      
              const MyRichText(
                heading: "Difficulties:\n",
                body:
                    "Easy: 1 to 100\n"
                    "Medium: 1 to 50\n"
                    "Hard: 1 to 10",
              ),
              const MyRichText(heading: "", body: "The higher the difficulty, the smaller the range, the quicker CPU will guess your number."),
                  
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
      ),
    );
  }
}