import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kiddo/constants.dart';

class BodyPartsTabsScreen2 extends StatefulWidget {
  const BodyPartsTabsScreen2({super.key});

  @override
  State<BodyPartsTabsScreen2> createState() => _BodyPartsTabsScreen2State();
}

class _BodyPartsTabsScreen2State extends State<BodyPartsTabsScreen2> {
  final FlutterTts flutterTts = FlutterTts();
  bool flag = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            color: Color(0xFFf5f5f4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap: (){
                            speak("Brain");
                          },
                          child: Image.asset("assets/tabs/9.jpg",height: 200,width: 200,)),
                      GestureDetector(
                          onTap: (){
                            speak("Heart");
                          },
                          child: Image.asset("assets/tabs/10.jpg",height: 200,width: 200,)),
                      GestureDetector(
                          onTap: (){
                            speak("Liver");
                          },
                          child: Image.asset("assets/tabs/11.jpg",height: 200,width: 200,)),
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
                              speak("Lungs");
                            },
                            child: Image.asset("assets/tabs/8.jpg")),
                      ),
                      GestureDetector(
                          onTap: (){
                            speak("Stomach");
                          },
                          child: Image.asset("assets/tabs/14.jpg",height: 200,width: 200,)),
                    ],
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap: (){
                            speak("Intestines");
                          },
                          child: Image.asset("assets/tabs/12.jpg",height: 200,width: 200,)),
                      GestureDetector(
                          onTap: (){
                            speak("Kidneys");
                          },
                          child: Image.asset("assets/tabs/13.jpg",height: 200,width: 200,)),
                    ],
                  ),
                )

              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.center,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Container(
          //         child: GestureDetector(
          //             onTap: (){
          //               speak("Lungs");
          //             },
          //             child: Image.asset("assets/tabs/8.jpg")),
          //       ),
          //     ],
          //   ),
          // ),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       GestureDetector(
          //           onTap: (){
          //             speak("Brain");
          //           },
          //           child: Image.asset("assets/tabs/9.jpg",height: 200,width: 200,)),
          //       GestureDetector(
          //           onTap: (){
          //             speak("Heart");
          //           },
          //           child: Image.asset("assets/tabs/10.jpg",height: 200,width: 200,)),
          //       GestureDetector(
          //           onTap: (){
          //             speak("Liver");
          //           },
          //           child: Image.asset("assets/tabs/11.jpg",height: 200,width: 200,)),
          //     ],
          //   ),
          // ),
          // Align(
          //   alignment: Alignment.topRight,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       GestureDetector(
          //           onTap: (){
          //             speak("Intestines");
          //           },
          //           child: Image.asset("assets/tabs/12.jpg",height: 200,width: 200,)),
          //       GestureDetector(
          //           onTap: (){
          //             speak("Kidneys");
          //           },
          //           child: Image.asset("assets/tabs/13.jpg",height: 200,width: 200,)),
          //       GestureDetector(
          //           onTap: (){
          //             speak("Stomach");
          //           },
          //           child: Image.asset("assets/tabs/14.jpg",height: 200,width: 200,)),
          //     ],
          //   ),
          // ),
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
