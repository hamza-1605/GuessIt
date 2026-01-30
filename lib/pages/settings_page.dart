import 'package:flutter/material.dart';
import 'package:guess_number/widgets/item_row.dart';
import 'package:guess_number/widgets/my_close_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.sharedPref});

  final SharedPreferences sharedPref; 

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool soundOn;
  late bool vibrationOn;

  @override
  void initState() {
    getSoundAndVibrations();
    super.initState();
  }
  
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
          spacing: 20.0,

          children: [
            ItemRow(
              label: "Sound",
              icondata: soundOn ? Icons.volume_up : Icons.volume_off,
              onTap: (){
                setState(() {
                  soundOn = !soundOn;
                  widget.sharedPref.setBool("soundOn", soundOn);
                });
              },
            ),
            ItemRow(
              label: "Vibration",
              icondata: vibrationOn ? Icons.vibration : Icons.mobile_off ,
              onTap: (){
                setState(() {
                  vibrationOn = !vibrationOn;
                  widget.sharedPref.setBool("vibrationOn", vibrationOn);
                });
              },
            ),

            MyCloseButton(),
          ],
        ),
      ),
    );
  }
  
  void getSoundAndVibrations() {
    soundOn = widget.sharedPref.getBool("soundOn") ?? true;
    vibrationOn = widget.sharedPref.getBool("vibrationOn") ?? true;
  }

 
}