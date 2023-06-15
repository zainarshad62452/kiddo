import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:async';
import 'package:kiddo/constants.dart';
import 'package:kiddo/models/scoreModel.dart';
import 'package:kiddo/screens/games_screen.dart';
import 'package:kiddo/screens/profile_screen.dart';

import '../models/DB.dart';
import '../models/DB.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () async {
      var score = await DB.instance.future;
      print(score.puzzle);
      score.name !=null?Get.offAll(()=>GameScreen()):Get.offAll(KidsScreen());
      // Get.offAll(()=>GameScreen());
    });

    return new Scaffold(
      backgroundColor: AppColors.black,
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/images/Logo_color.png',
              width: ScreenSize(context).width * 0.6,
              height: ScreenSize(context).height * 0.75,
            ),
            CircularProgressIndicator(color: AppColors.secondary)
          ],
        ),
      ),
    );
  }
}
