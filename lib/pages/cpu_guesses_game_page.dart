import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:guess_number/models/difficulty_level.dart';
import 'package:guess_number/widgets/game_action_button.dart';
import 'package:guess_number/widgets/game_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class CpuGuessesGamePage extends StatefulWidget {
  const CpuGuessesGamePage({super.key, required this.limit, required this.player, required this.sharedPref, required this.difficultyLevel});
  
  final int limit;
  final DifficultyLevel difficultyLevel;
  final AudioPlayer player;
  final SharedPreferences sharedPref;

  @override
  State<CpuGuessesGamePage> createState() => _CpuGuessesGamePageState();
}

class _CpuGuessesGamePageState extends State<CpuGuessesGamePage> {
  bool isReady = false;
  bool loading = false;
  bool gameOver = false;
  int number = 0;
  int min = 0;
  int max = 0;
  int guesses = 1;
  
  late bool soundOn;
  late bool vibrationOn;

  // Initialization
  @override
  void initState() {
    super.initState();
    min = 1;
    max = widget.limit;
    getSoundAndVibrations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Back Button
            Positioned(
              top: 10.0,
              left: 10.0,
              child: IconButton.outlined(
                onPressed: () => backButtonFunction(), 
                icon: Icon(Icons.arrow_back)
              )
            ),

            // Actual Game
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(5.0),
                  child: Column(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Message on top
                      getGameMessage(),

                      SizedBox(height: 15),

                      // Number Box
                      Container(
                        height: 200,
                        width: 225,
                        color: gameOver ? Colors.green : Colors.pink,
                        child: Center(
                          child: loading 
                            ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator( color: Colors.white,))
                            : Text( 
                              isReady ? number.toString() : "?" , 
                              style: TextStyle(color: Colors.white, fontSize: 35)
                            )
                        )
                      ),
                      
                      SizedBox(height: 15),
                      if(!gameOver && isReady) GameText(text: "The guessed number is: ")
                      else if(gameOver && isReady)
                        GameText(
                          text: guesses == 1 
                            ? "It took me $guesses guess."
                            : "It took me $guesses guesses."
                        ),
                      
                      if(gameOver) SizedBox(height: 15),
                      

                      // ready button
                      if(!isReady)
                        GameActionButton(
                          color: Colors.white,
                          bgColor: Colors.black,
                          label: "Ready", 
                          onPressed: () => startGame()
                        ),
                      
                      // in-game button
                      if(!gameOver && isReady) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GameActionButton(
                              color: Colors.green,
                              onPressed: () => wrongGuess(true), 
                              label: "Higher"
                            ),
                            GameActionButton(
                              color: Colors.red,
                              onPressed: () => wrongGuess(false), 
                              label: "Lower"
                            ),
                          ],
                        ),
                        GameActionButton(
                          color: Colors.white,
                          bgColor: Colors.green,
                          onPressed: () => correctGuess(), 
                          label: "Correct",
                        ), 
                      ]
                      else if(gameOver && isReady) ...[
                        GameActionButton(
                          color: Colors.white,
                          bgColor: Colors.red,
                          onPressed: () => reset(), 
                          label: "Reset"
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }



  // Start Game 
  void startGame(){
    setState(() {
      isReady = true;
    });

    getRandomNumber();
  }

  // Guess / Generate a random number
  void getRandomNumber(){
    var random = Random();
    number = min + random.nextInt(max - min + 1) ;
  }

  // Guess is wrong
  void wrongGuess(bool isHigh) async {
    if(gameOver || loading) return;
    
    if(soundOn){
      await widget.player.play(AssetSource('sounds/Click.mp3'));
    }

    setState(() {
      loading = true;
    });


    if(isHigh)  
      max = number-1;
    else  
      min = number+1;
    
    
    if(max == min)
      number = min;
    else if(min > max){
      String message;
      if(number == 1)  message = "Can't go lower than 1.";
      else if(max == widget.limit)  message = "Can't go higher than ${widget.limit.toString()}.";
      else  message = "Thats the only number remaining.";
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
    else{
      getRandomNumber();
      guesses++;
    }
    
    await Future.delayed( Duration(milliseconds: 300) );  


    setState(() {
      loading = false;
    });
  }

  // Guess is Correct
  void correctGuess() async {
    if( vibrationOn ) {
      Vibration.vibrate(pattern: [0, 300, 300, 300]);
    }
    if( soundOn ){
      await widget.player.play(AssetSource('sounds/Victory.mp3'));  
    }

    setState(() {
      gameOver = true;
    });
  }

  // Reset All Values
  void reset() async{
    if(soundOn){
      await widget.player.play(AssetSource('sounds/Click.mp3'));
    }

    setState(() {
      guesses = 1;
      min = 1;
      max = widget.limit;
      getRandomNumber();
      gameOver = false;
      isReady = false;
    });
  }



  // Get sharedPreferences
  void getSoundAndVibrations(){
    soundOn = widget.sharedPref.getBool("soundOn") ?? true;
    vibrationOn = widget.sharedPref.getBool("vibrationOn") ?? true;
  }

  // Back / Exit Button
  void backButtonFunction () {
    FocusScope.of(context).unfocus();
    if( soundOn ){
      widget.player.play(AssetSource('sounds/Click.mp3'));
    }
    Timer(Duration(milliseconds: 700) , (){
      Navigator.of(context).pop();
    });
  }


  // Top message
  Widget getGameMessage() {
    if (!isReady) {
      return GameText(
        text: "${widget.difficultyLevel.name.toUpperCase()} MODE.\nThink of a number from 1 to ${widget.limit}.\nKeep it in your mind, then tap Ready!",
        fontSize: 18,
      );
    }

    if (!gameOver) {
      return const GameText(
        text: "Play fairly. Don't change your number!",
        fontSize: 20,
      );
    }

    if (guesses >= 10) {
      return const GameText(
        text: "UGH! At last... figured it out.",
        fontWeight: FontWeight.bold,
      );
    }

    if (guesses >= 4) {
      return const GameText(
        text: "Finally guessed it right!",
        fontWeight: FontWeight.bold,
      );
    }

    if (guesses >= 2) {
      return const GameText(
        text: "I Win! That was quick.",
        fontWeight: FontWeight.bold,
      );
    }

    return const GameText(
      text: "FIRST TRY! Unbelievable.",
      fontWeight: FontWeight.bold,
    );
  }

}