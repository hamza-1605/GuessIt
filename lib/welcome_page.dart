import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guess_number/pages/about_page.dart';
import 'package:guess_number/pages/game_page.dart';
import 'package:guess_number/pages/instructions_page.dart';
import 'package:guess_number/pages/settings_page.dart';
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
                const SizedBox(height: 30.0),        
                Image.asset('assets/images/GuessIt.png' , width: MediaQuery.of(context).size.width),        
                Spacer(),
            
                if(!play )
                  ...[
                    MenuButton(title: "Play", function: playGame, player: player, sharedPref: sharedPref),
                    MenuButton(title: "Instructions", function: instructionsPage, player: player, sharedPref: sharedPref),
                    MenuButton(title: "Settings", function: settingsPage, player: player, sharedPref: sharedPref),
                    MenuButton(title: "Exit", function: exitGame, player: player, sharedPref: sharedPref),
                  ]
                  else ...[
                    MenuButton(title: "Easy", function: () => enterGameMode(10), player: player, sharedPref: sharedPref),
                    MenuButton(title: "Medium", function: () => enterGameMode(50), player: player, sharedPref: sharedPref),
                    MenuButton(title: "Hard", function: () => enterGameMode(100), player: player, sharedPref: sharedPref),
                    MenuButton(title: "Back", function: () => setState(() => play=false), player: player, sharedPref: sharedPref),
                  ],
                   
                SizedBox(height: 90.0),
              ],
            ),

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


  void playGame(){
    setState(() => play=true);
  }
  
  void instructionsPage(){
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) {  
        return InstructionsPage();
      }
    );
  }

  void settingsPage() {
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) {  
        return SettingsPage(sharedPref: sharedPref) ;
      }
    );
  }

  void aboutPage(){
    showDialog(
      context: context,
      builder: (context) {  
        return AboutPage();
      }
    );
  }

  void exitGame(){
    SystemNavigator.pop();
  }



  void enterGameMode(int limit) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, _,_) => GamePage(limit: limit, player: player, sharedPref: sharedPref) ,
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


  void initShared() async{
    sharedPref = await SharedPreferences.getInstance();

    sharedPref.setBool("soundOn", sharedPref.getBool("soundOn") ?? true);
    sharedPref.setBool("vibrationOn", sharedPref.getBool("vibrationOn") ?? true);

    setState(() {
      prefsReady = true;
    });
  }


}