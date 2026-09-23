import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guess_number/models/difficulty_level.dart';
import 'package:guess_number/models/game_mode.dart';
import 'package:guess_number/pages/about_page.dart';
import 'package:guess_number/pages/cpu_guesses_game_page.dart';
import 'package:guess_number/pages/player_guesses_game_page.dart';
import 'package:guess_number/pages/instructions_page.dart';
import 'package:guess_number/pages/settings_page.dart';
import 'package:guess_number/widgets/game_text.dart';
import 'package:guess_number/widgets/menu_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:guess_number/game_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool play = false;
  final AudioPlayer player = AudioPlayer();
  late SharedPreferences sharedPref;
  bool prefsReady = false;
  GameMode? gameMode;
  DifficultyLevel? difficultyLevel;

  @override
  void initState(){
    super.initState();
    initShared();
  }

  @override
  Widget build(BuildContext context) {
    if( !prefsReady ){
      return const Scaffold(
        backgroundColor: Color.fromARGB(255, 26, 15, 46),
        body: Center(child: LinearProgressIndicator(backgroundColor: Colors.white, color: Colors.lightBlueAccent,)),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 15, 46),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              spacing: 30.0,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0),        
                Image.asset('assets/images/GuessIt.png' , width: MediaQuery.of(context).size.width),        
                Spacer(),

                // Opening Menu
                if(!play)
                  ...[
                    MenuButton(title: "Play", function: playGame, player: player, sharedPref: sharedPref),
                    MenuButton(title: "Instructions", function: instructionsPage, player: player, sharedPref: sharedPref),
                    MenuButton(title: "Settings", function: settingsPage, player: player, sharedPref: sharedPref),
                    MenuButton(title: "Exit", function: exitGame, player: player, sharedPref: sharedPref),
                  ]
                // Shows Game Modes
                else if(gameMode == null) 
                  ...[
                    GameText(text: "Select a Game Mode", fontSize: 18 , color: Colors.white,),
                    MenuButton(title: "Guess the Number", function: () => chooseMode(GameMode.playerGuesses), player: player, sharedPref: sharedPref, fontSize: 22,),
                    MenuButton(title: "CPU guesses your Number", function: () => chooseMode(GameMode.cpuGuesses), player: player, sharedPref: sharedPref, fontSize: 22,),
                    MenuButton(title: "Back", function: () => setState(() => play=false), player: player, sharedPref: sharedPref),
                  ]
                // Shows Difficulty Levels
                else ...[
                    MenuButton(title: "Easy", function: () => enterGameMode( DifficultyLevel.easy ), player: player, sharedPref: sharedPref),
                    MenuButton(title: "Medium", function: () => enterGameMode( DifficultyLevel.medium ), player: player, sharedPref: sharedPref),
                    MenuButton(title: "Hard", function: () => enterGameMode( DifficultyLevel.hard ), player: player, sharedPref: sharedPref),
                    MenuButton(title: "Back", function: () => setState(() => gameMode=null), player: player, sharedPref: sharedPref),
                  ],
                   
                SizedBox(height: 90.0),
              ],
            ),

            // Info/About button at the right-top
            Positioned(
              top: 10,
              right: 20,
              child: IconButton(
                onPressed: () => aboutPage(), 
                icon: Icon(Icons.info, color: Colors.lightBlueAccent, size: 30,)
              ), 
            )
          ],
        ),
      ),
    );
  }



  // Initialization of Shared Preferences => Handles Sound & Vibration on/off
  void initShared() async{
    sharedPref = await SharedPreferences.getInstance();

    sharedPref.setBool("soundOn", sharedPref.getBool("soundOn") ?? true);
    sharedPref.setBool("vibrationOn", sharedPref.getBool("vibrationOn") ?? true);

    setState(() {
      prefsReady = true;
    });
  }



  // On clicking play-button, the initial menu gets hidden and game modes menu appear
  void playGame(){
    setState(() => play=true);
  }

  // Opens the Instructions Page that shows what is game about and how to play it 
  void instructionsPage(){
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) {  
        return InstructionsPage();
      }
    );
  }

  // Opens the Settings page to control Sound & Vibration on/off
  void settingsPage() {
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) {  
        return SettingsPage(sharedPref: sharedPref) ;
      }
    );
  }

  // Opens the About page that shows information about latest update & version
  void aboutPage(){
    showDialog(
      context: context,
      builder: (context) {  
        return AboutPage();
      }
    );
  }

  // CLoses the game
  void exitGame(){
    SystemNavigator.pop();
  }

  
  // Sets the Game Mode
  void chooseMode(GameMode mode) {
    setState(() {
      gameMode = mode;
    });
  }

  // Navigates to the desired game mode screen
  void enterGameMode( DifficultyLevel difficulty ) {
    if(gameMode==null) return;

    Widget gamePage;

    int limit;
    if(gameMode == GameMode.playerGuesses) {
      if( difficulty == DifficultyLevel.easy )  limit = 10;
      else if( difficulty == DifficultyLevel.medium )  limit = 50;
      else   limit = 100;

      gamePage = PlayerGuessesGamePage(
        limit: limit, 
        player: player, 
        sharedPref: sharedPref
      );
    }
    else {
      if( difficulty == DifficultyLevel.easy )  limit = 100;
      else if( difficulty == DifficultyLevel.medium )  limit = 50;
      else   limit = 10;
      
      gamePage = CpuGuessesGamePage(
        difficultyLevel: difficulty,
        limit: limit,
        player: player,
        sharedPref: sharedPref,
      );
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, _,_) => gamePage ,
        transitionDuration: Duration(milliseconds: 500),
        reverseTransitionDuration: Duration(milliseconds: 300),

        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          final rotateTween = Tween<double>(begin: 0.5, end: 1);

          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.1, end: 1.0).animate(animation) ,
                child: RotationTransition(
                  turns: animation.drive(rotateTween),
                  child: child,
                ),
            ),
          );

        },
      )
    );
  }



}