import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:audioplayers/audioplayers.dart';

//RESPONSIVE SCREENS
class ScreenSize {
  BuildContext context;

  ScreenSize(this.context) : assert(true);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
}

// //USED COLORS
class AppColors {
  static const white = Color(0xffEEEEEE);
  static const black = Color(0xff1e212d);
  static const backGround = Color(0xff87C7F1);
  static const yellow = Color(0xff8FDDE7);
  //  static const secondary = Color(0xff8eecf5);
  static const crimson = Color(0xffEACFFF);
  static const secondary = Color(0xffdaf2dc);
  static const orange = Color(0xffffab4c);
  static const Lpink = Color(0xffffcce7);
  static const sage = Color(0xffdaf2dc);
  static const tale = Color(0xffdaf2dc);
}

//USED COLORS
// class AppColors {
//   static const white = Color(0xffEEEEEE);
//   static const black = Color(0xff1e212d);
//   static const backGround = Color(0xffaf8aff);
//   static const secondary = Color(0xff5fffe0);
//   static const crimson = Color(0xffff5f7e);
//   static const yellow = Color(0xfffbe698);
//   static const orange = Color(0xffff884b);
//   static const Lpink = Color(0xffffcce7);
//   static const sage = Color(0xffdaf2dc);
//   static const pale = Color(0xffeacfff);
//   static const tale = Color(0xffdaf2dc);
// }

//FONT STYLING
class PrimaryText extends StatelessWidget {
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final double height;

  const PrimaryText({
    required this.text,
    this.fontWeight = FontWeight.w400,
    this.color= AppColors.black,
    this.size= 20,
    this.height= 1.3,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.almarai(
        height: height,
        fontSize: size,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

//BACKGROUND MUSIC CONTROLLER
// class Music {
//   static AudioPlayer music = AudioPlayer();
//   static AudioCache player = AudioCache(fixedPlayer: music);
//   void play() {
//     player.loop("voices/music.mp3", volume: 0.85);
//   }
//   volDown() {
//     music.setVolume(0.25);
//   }
//   volUp() {
//     music.setVolume(0.85);
//   }
// }

//CATEGORIES
const CardsList = [
  {
    'imagePath': 'assets/nums.png',
    'name': 'Body Parts Puzzle',
  },
  {
    'imagePath': 'assets/letters.png',
    'name': 'Learn Color',
  },
  {
    'imagePath': 'assets/animals.png',
    'name': 'Animals',
  },
  {
    'imagePath': 'assets/family.png',
    'name': 'Family',
  },
  {
    'imagePath': 'assets/fruits.png',
    'name': 'Fruits',
  },
  {
    'imagePath': 'assets/vegetables.png',
    'name': 'Vegetables',
  },
];

//ROUTES
const routesList = [
  {
    'routePath': '/Nums',
  },
  {
    'routePath': '/Letters',
  },
  {
    'routePath': '/Animals',
  },
  {
    'routePath': '/Family',
  },
  {
    'routePath': '/Fruits',
  },
  {
    'routePath': '/Vegetables',
  },
];

const GamesList = [
  {'GameName': 'Body Parts', 'imagePath': 'assets/partsofbody.png'},
  {'GameName': 'Score Board', 'imagePath': 'assets/images/Logo_color.png'},
  {'GameName': 'Matching Game', 'imagePath': 'assets/fruits.png'},
  {'GameName': 'Learn First Word', 'imagePath': 'assets/games/letters.png'},
  {'GameName': 'Memory', 'imagePath': 'assets/games/memo.png'},

];

const gamesRoutes = [
  {'routePath': '/BodyPartsGameScreen'},
  // {'routePath': '/MatchingGameScreen'},
  // {'routePath': '/LearnFirstWord'},
  // {'routePath': '/Memory'},
  {'routePath': '/HighScoreScreen'},
];
const matchingGameList = [
  {'GameName': 'Fruits', 'imagePath': 'assets/fruits.png'},
  {'GameName': 'Animals', 'imagePath': 'assets/animals.png'},
];

const matchingGameRoutes = [
  {'routePath': '/Color'},
  {'routePath': '/Animal'},
];
const bodyPartsGameRoutes = [
  {'routePath': '/Jigsaw'},
  {'routePath': '/Jigsaw2'},
];
const bodyPartsGameList = [
  {'GameName': 'Level 1', 'imagePath': 'assets/body.png'},
  {'GameName': 'Level 2', 'imagePath': 'assets/body2.jpg'},
];
const learnGameList = [
  {'GameName': 'Letters', 'imagePath': 'assets/games/letters.png'},
  {'GameName': 'Sentences', 'imagePath': 'assets/games/letters.png'},
];

const learnGameRoutes = [
  {'routePath': '/Letters'},
  {'routePath': '/Sentences'},
];

//NUMS LIST
const numsList = [
  {
    'imagePath': 'assets/numbers/0.png',
    'counterPath': 'assets/counters/hands0.png',
    'name': 'Zero',
  },
  {
    'imagePath': 'assets/numbers/1.png',
    'counterPath': 'assets/counters/hands1.png',
    'name': 'One',
  },
  {
    'imagePath': 'assets/numbers/2.png',
    'counterPath': 'assets/counters/hands2.png',
    'name': 'Two',
  },
  {
    'imagePath': 'assets/numbers/3.png',
    'counterPath': 'assets/counters/hands3.png',
    'name': 'Three',
  },
  {
    'imagePath': 'assets/numbers/4.png',
    'counterPath': 'assets/counters/hands4.png',
    'name': 'Four',
  },
  {
    'imagePath': 'assets/numbers/5.png',
    'counterPath': 'assets/counters/hands5.png',
    'name': 'Five',
  },
  {
    'imagePath': 'assets/numbers/6.png',
    'counterPath': 'assets/counters/hands6.png',
    'name': 'Six',
  },
  {
    'imagePath': 'assets/numbers/7.png',
    'counterPath': 'assets/counters/hands7.png',
    'name': 'Seven',
  },
  {
    'imagePath': 'assets/numbers/8.png',
    'counterPath': 'assets/counters/hands8.png',
    'name': 'Eight',
  },
  {
    'imagePath': 'assets/numbers/9.png',
    'counterPath': 'assets/counters/hands9.png',
    'name': 'Nine',
  },
];

//ANIMALS LIST
const animalsList = [
  {
    'imagePath': 'assets/animals/leo.png',
    'voice': 'voices/leo.mp3',
    'name': 'Lion',
  },
  {
    'imagePath': 'assets/animals/duck.png',
    'voice': 'voices/duck.mp3',
    'name': 'Duck',
  },
  {
    'imagePath': 'assets/animals/chicken.png',
    'voice': 'voices/chicken.mp3',
    'name': 'Chicken',
  },
  {
    'imagePath': 'assets/animals/horse.png',
    'voice': 'voices/horse.mp3',
    'name': 'Horse',
  },
  {
    'imagePath': 'assets/animals/goat.png',
    'voice': 'voices/goat.mp3',
    'name': 'Goat',
  },
  {
    'imagePath': 'assets/animals/cat.png',
    'voice': 'voices/cat.mp3',
    'name': 'Cat',
  },
  {
    'imagePath': 'assets/animals/mouse.png',
    'voice': 'voices/mouse.mp3',
    'name': 'Mouse',
  },
  {
    'imagePath': 'assets/animals/frog.png',
    'voice': 'voices/frog.mp3',
    'name': 'Frog',
  },
  {
    'imagePath': 'assets/animals/dog.png',
    'voice': 'voices/dog.mp3',
    'name': 'Dog',
  },
  {
    'imagePath': 'assets/animals/cow.png',
    'voice': 'voices/cow.mp3',
    'name': 'Cow',
  },
];

//LETTERS LIST
const lettersList = [
  {
    'imagePath': 'assets/letters/alphabets/a.PNG',
    'subImage': 'assets/letters/avatars/apple.png',
    'name': 'A',
  },
  {
    'imagePath': 'assets/letters/alphabets/cc.PNG',
    'subImage': 'assets/letters/avatars/banana.png',
    'name': 'B',
  },
  {
    'imagePath': 'assets/letters/alphabets/c.PNG',
    'subImage': 'assets/letters/avatars/cow.png',
    'name': 'C',
  },
  {
    'imagePath': 'assets/letters/alphabets/d.PNG',
    'subImage': 'assets/letters/avatars/duck.png',
    'name': 'D',
  },
  {
    'imagePath': 'assets/letters/alphabets/e.PNG',
    'subImage': 'assets/letters/avatars/eagle.png',
    'name': 'E',
  },
  {
    'imagePath': 'assets/letters/alphabets/f.PNG',
    'subImage': 'assets/letters/avatars/football.png',
    'name': 'F',
  },
  {
    'imagePath': 'assets/letters/alphabets/g.PNG',
    'subImage': 'assets/letters/avatars/graffie.png',
    'name': 'G',
  },
  {
    'imagePath': 'assets/letters/alphabets/h.PNG',
    'subImage': 'assets/letters/avatars/horse.png',
    'name': 'H',
  },
  {
    'imagePath': 'assets/letters/alphabets/i.PNG',
    'subImage': 'assets/letters/avatars/ice.png',
    'name': 'I',
  },
  {
    'imagePath': 'assets/letters/alphabets/j.PNG',
    'subImage': 'assets/letters/avatars/jeep.png',
    'name': 'J',
  },
  {
    'imagePath': 'assets/letters/alphabets/k.PNG',
    'subImage': 'assets/letters/avatars/kite.png',
    'name': 'K',
  },
  {
    'imagePath': 'assets/letters/alphabets/l.PNG',
    'subImage': 'assets/letters/avatars/lion.png',
    'name': 'L',
  },
  {
    'imagePath': 'assets/letters/alphabets/m.PNG',
    'subImage': 'assets/letters/avatars/mail.png',
    'name': 'M',
  },
  {
    'imagePath': 'assets/letters/alphabets/n.PNG',
    'subImage': 'assets/letters/avatars/nose.png',
    'name': 'N',
  },
  {
    'imagePath': 'assets/letters/alphabets/o.PNG',
    'subImage': 'assets/letters/avatars/orange.png',
    'name': 'O',
  },
  {
    'imagePath': 'assets/letters/alphabets/p.PNG',
    'subImage': 'assets/letters/avatars/pencil.png',
    'name': 'P',
  },
  {
    'imagePath': 'assets/letters/alphabets/q.PNG',
    'subImage': 'assets/letters/avatars/queen.png',
    'name': 'Q',
  },
  {
    'imagePath': 'assets/letters/alphabets/r.PNG',
    'subImage': 'assets/letters/avatars/rat.png',
    'name': 'R',
  },
  {
    'imagePath': 'assets/letters/alphabets/s.PNG',
    'subImage': 'assets/letters/avatars/strawberry.png',
    'name': 'S',
  },
  {
    'imagePath': 'assets/letters/alphabets/t.PNG',
    'subImage': 'assets/letters/avatars/turtle.png',
    'name': 'T',
  },
  {
    'imagePath': 'assets/letters/alphabets/u.PNG',
    'subImage': 'assets/letters/avatars/umbrella.png',
    'name': 'U',
  },
  {
    'imagePath': 'assets/letters/alphabets/v.PNG',
    'subImage': 'assets/letters/avatars/van.png',
    'name': 'V',
  },
  {
    'imagePath': 'assets/letters/alphabets/w.PNG',
    'subImage': 'assets/letters/avatars/watch.png',
    'name': 'W',
  },
  {
    'imagePath': 'assets/letters/alphabets/x.PNG',
    'subImage': 'assets/letters/avatars/xray.png',
    'name': 'X',
  },
  {
    'imagePath': 'assets/letters/alphabets/y.PNG',
    'subImage': 'assets/letters/avatars/yoyo.png',
    'name': 'Y',
  },
  {
    'imagePath': 'assets/letters/alphabets/z.PNG',
    'subImage': 'assets/letters/avatars/zebra.png',
    'name': 'Z',
  },
];