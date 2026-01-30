import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuButton extends StatelessWidget {
  final String title;
  final VoidCallback function;
  final AudioPlayer player;
  final SharedPreferences sharedPref;
  const MenuButton({super.key, required this.title, required this.function, required this.player, required this.sharedPref});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        bool soundOn = sharedPref.getBool('soundOn') ?? true;
        if ( soundOn ){
          await player.play(AssetSource('sounds/Click.mp3'));
        }
        function();  
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.8 ,
        decoration: BoxDecoration(
          color: Colors.pink,
          border: BoxBorder.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10.0) 
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              title , style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w700
              ),
            ),
          )
        ),
      ),
    );
  }
}