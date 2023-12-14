import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:kiddo/constants.dart';
import 'package:kiddo/screens/Games/5x5_puzzle.dart';
import 'package:kiddo/screens/Games/allPuzzleGames.dart';
import 'package:kiddo/screens/Games/bodyParts.dart';
import 'package:kiddo/screens/Games/body_parts_puzzle.dart';
import 'package:kiddo/screens/Games/body_parts_tabs.dart';
import 'package:kiddo/screens/Games/bosy_parts_tabs2.dart';
import 'package:kiddo/screens/Games/color_match_animals.dart';
import 'package:kiddo/screens/Games/learn_first_word.dart';
import 'package:kiddo/screens/Games/letters_screen.dart';
import 'package:kiddo/screens/Games/matching.dart';
import 'package:kiddo/screens/Games/memory.dart';
import 'package:kiddo/screens/Games/parts_of_body2.dart';
import 'package:kiddo/screens/Games/sentences_quiz.dart';
import 'package:kiddo/screens/Games/sentences_screen.dart';
import 'package:kiddo/screens/Games/tabsGames.dart';
import 'package:kiddo/screens/profile_screen.dart';
import 'package:kiddo/screens/score_screen.dart';
import 'package:kiddo/screens/splash_screen.dart';
import 'package:kiddo/screens/main_screen.dart';
import 'package:kiddo/screens/Games/color_match.dart';
import 'package:kiddo/screens/games_screen.dart';

import 'models/DB.dart';
void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  // WidgetsBinding.instance!.addObserver(new MusicHandler());
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersive,
  );

  // Music().play();.
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kiddo',
      theme: ThemeData(scaffoldBackgroundColor: AppColors.backGround),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SplashScreen(),
        '/Main': (context) => MainScreen(),
        '/Sentences': (context) => SentencesScreen(),
        '/LearnFirstWord': (context) => LearnFirstWord(),
        '/MatchingGameScreen': (context) => MatchingGameScreen(),
        '/BodyPartsGameScreen': (context) => BodyPartsGameScreen(),
        '/Games': (context) => GameScreen(),
        '/KidScreen': (context) => KidsScreen(),
        '/Color': (context) => ColorMatch(),
        '/Animal': (context) => ColorMatchAnimals(),
        '/Memory': (context) => Memory(),
        '/Letters': (context) => LettersScreen(),
        '/HighScoreScreen': (context) => HighScoreScreen(),
        '/Jigsaw': (context) => BodyPartsPuzzle(),
        '/Jigsaw2': (context) => BodyPartsPuzzle2(),
        '/5x5': (context) => Puzzle5x5(),
        '/tabsGames': (context) => TabsGames(),
        '/allPuzzleGames': (context) => AllPuzzleGames(),
        '/Tab': (context) => BodyPartsTabs(),
        '/Tab2': (context) => BodyPartsTabsScreen2(),
        '/Quiz': (context) => SentencesQuizScreen(),
      },
    );
  }
}

// class MusicHandler extends WidgetsBindingObserver {
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       Music.music.pause();
//     } else if (state == AppLifecycleState.resumed) {
//       Music.music.resume();
//     }
//   }
// }
