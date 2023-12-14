import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:screenshot/screenshot.dart';

import '../../constants.dart';

class BodyPartsTabs extends StatefulWidget {
  const BodyPartsTabs({super.key});

  @override
  State<BodyPartsTabs> createState() => _BodyPartsTabsState();
}

class _BodyPartsTabsState extends State<BodyPartsTabs> {
  final FlutterTts flutterTts = FlutterTts();
  bool flag = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.black,
        title: Text("Body Parts"),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap: (){
                            speak("Hand");
                          },
                          child: Image.asset("assets/tabs/1.jpg",)),
                      GestureDetector(
                          onTap: (){
                            speak("Mouth");
                          },
                          child: Image.asset("assets/tabs/4.jpg",)),
                      GestureDetector(
                          onTap: (){
                            speak("Ear");
                          },
                          child: Image.asset("assets/tabs/15.jpg",)),
                      GestureDetector(
                          onTap: (){
                            speak("Leg");
                          },
                          child: Image.asset("assets/tabs/7.jpg",)),
                    ],
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        child: GestureDetector(
                            onTap: (){
                              speak("Foot");
                            },
                            child: Image.asset("assets/tabs/2.jpg")),
                      ),
                      Container(
                        child: GestureDetector(
                            onTap: (){
                              speak("The body");
                            },
                            child: Image.asset("assets/tabs/5.jpg")),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10,),

                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap: (){
                            speak("Arm");
                          },
                          child: Image.asset("assets/tabs/3.jpg",)),
                      GestureDetector(
                          onTap: (){
                            speak("Nose");
                          },
                          child: Image.asset("assets/tabs/6.jpg",)),
                      GestureDetector(
                          onTap: (){
                            speak("Eye");
                          },
                          child: Image.asset("assets/tabs/16.jpg",)),
                      GestureDetector(
                          onTap: (){
                            speak("Face");
                          },
                          child: Image.asset("assets/tabs/17.jpg",)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void speak(text){
    flutterTts.stop();
    flutterTts.speak(text);
    flutterTts.setPitch(1);
    setState(() => flag = true);
  }
}
