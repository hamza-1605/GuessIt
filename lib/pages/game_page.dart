import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.limit, required this.player, required this.sharedPref});
  
  final int limit;
  final AudioPlayer player;
  final SharedPreferences sharedPref;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  TextEditingController controller = TextEditingController();
  bool revealNumber = false;
  bool gameOver = false;
  bool victory = false; 
  String message = "";
  List<int> guessedNumbers = [];
  int remainingGuesses = 5;
  late int hiddenNumber; 
  Color boxColor = Colors.deepPurple;

  late bool soundOn;
  late bool vibrationOn;
  



  @override
  void initState() {
    super.initState();
    generateRandomNumber();
    getSoundAndVibrations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Back Button
            Positioned(
              top: 10.0,
              left: 10.0,
              child: IconButton.outlined(
                onPressed: backButtonFunction, 
                icon: Icon(Icons.arrow_back)
              )
            ),
            
            // Actual Game
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    spacing: 5.0,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ranges guide
                      Text(
                        gameOver ? '' : 'Guess the hidden number \nfrom 0 to ${widget.limit}.', 
                        style: TextStyle( fontSize: 24, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      
                      // Guesses remaining or ending message
                      Text(
                        revealNumber 
                        ? ( victory ? 'You Won 😍\nYou took ${5-remainingGuesses} guesses.' : 'You Lost 😭\nYou took all the 5 guesses, and still could not win.\n\nMai to na sehta bhai.') 
                        : 'Guesses Remaining: $remainingGuesses' , 
                        
                        style: TextStyle( 
                          fontSize: 24, 
                          fontWeight: FontWeight.w600,
                          color: revealNumber ? Colors.black : Colors.red
                        ),
                        textAlign: TextAlign.center,
                      ),
            
                      // message after each guess
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          message,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.brown,
                          ),
                        ),
                      ),
            
                      // Animated Box with hidden number.
                      Stack(
                        children: [
                          Container(
                            height: 200,
                            width: 225,
                            color: boxColor,
                            child: Center(child: Text('$hiddenNumber' , style: TextStyle(fontSize: 35, color: Colors.white),)),
                          ),
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 1300),
                            curve: Curves.easeOut,
                            bottom: revealNumber ? 120 : 65,
                            right: 50,
                            child: Container(
                              height: 70.0,
                              width: 125.0,
                              color: Colors.black,
                            ), 
                          ),
                        ],
                      ),
                  
                      SizedBox(height: 20.0),

                      // Guesses
                      Text(
                        'Guessed numbers: ${guessedNumbers.join(" ,  ")}' ,

                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black45
                        ),
                      ),
            
                      // Textbox and Reset button
                      !revealNumber ?
                      Container(
                        height: 40.0,
                        width: 200.0,
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField( 
                                controller: controller,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.go,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counter: SizedBox(),
                                  hintText: "Type here...",
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black38
                                  ),
                                  contentPadding: EdgeInsets.all(10.0)
                                ),
                                maxLength: 2,
                                textAlign: TextAlign.center,
                                onSubmitted: (value) {
                                  final guessed = int.tryParse(value);
                                  if (guessed != null) {
                                    checkGuess(guessed);
                                  }
                                },
                              ),
                            ),
                  
                            TextButton(
                              onPressed: (){
                                final answer = int.tryParse(controller.text); 
                                if( answer != null ){ 
                                  checkGuess(answer);
                                }
                              }, 
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll( Colors.black12 ),
                                foregroundColor: WidgetStatePropertyAll( Colors.black ),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(10.0), 
                                  ),
                                ),
                              ),
                              child: const Text("Guess")
                            ),
                          ],
                        ),
                      ) 
                      :
                      FilledButton(
                        onPressed: resetAll, 
                        child: const Text("RESET"),
                      ),
                  
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  void checkGuess( int guessed ) async{    
    if (gameOver || revealNumber) return;

    // setState(() {
      controller.clear(); 
      remainingGuesses-- ; 
      guessedNumbers.add(guessed);
    // });

    // Guessed Lower
    if (guessed > hiddenNumber) {
          if( remainingGuesses != 0 && vibrationOn ){
            Vibration.vibrate( duration: 150 );
          }
          setState(() {
            message = '$guessed - Too High, try again';
          });
    } 
        // Guessed Higher
    else if (guessed < hiddenNumber) {
          if( remainingGuesses != 0 && vibrationOn ){
              Vibration.vibrate( duration: 150 );
          } 
          setState(() {        
            message = '$guessed - Too Low, try again' ;
          });
    } 
    // Win
    else {
      if( vibrationOn ) {
        Vibration.vibrate(pattern: [0, 300, 300, 300]);
      }
      if( soundOn ){
        await widget.player.play(AssetSource('sounds/Victory.mp3'));  
      }

      setState(() {
        message = '$guessed - Guessed Right!';
        revealNumber = true;
        gameOver = true;
        victory = true;
        boxColor = Colors.green;
        FocusScope.of(context).unfocus();
      });
    }

    // Game Over
    if (remainingGuesses <= 0 && !gameOver ) {
      if( vibrationOn ) {
        Vibration.vibrate(duration: 1000);
      }
      if( soundOn ){
        await widget.player.play(AssetSource('sounds/Fail.mp3'));  
      }

      setState(() {
        gameOver = true;
        revealNumber = true;
        message = 'Game Over! The number was $hiddenNumber';
        boxColor = Colors.red;
        FocusScope.of(context).unfocus();
      });
    }
  }

  void resetAll() async{
    setState(() {
      revealNumber = false;
      gameOver = false;
      message = "";
      guessedNumbers = [];
      remainingGuesses = 5;
      victory = false;
      boxColor = Colors.deepPurple;
      controller.clear(); 
      FocusScope.of(context).unfocus();
    });
    
    
    if(soundOn){
      await widget.player.play(AssetSource('sounds/Click.mp3'));
    }
    Future.delayed( Duration(milliseconds: 1300), () {
      setState(() {
        generateRandomNumber();
      });
    });
  }

  void generateRandomNumber(){
    var random = Random();
    hiddenNumber = random.nextInt( widget.limit ); 
  }

  void getSoundAndVibrations(){
    soundOn = widget.sharedPref.getBool("soundOn") ?? true;
    vibrationOn = widget.sharedPref.getBool("vibrationOn") ?? true;
  }

  void backButtonFunction () {
    FocusScope.of(context).unfocus();
    if( soundOn ){
      widget.player.play(AssetSource('sounds/Click.mp3'));
    }
    Timer(Duration(milliseconds: 700) , (){
      Navigator.of(context).pop();
    });
  }
}