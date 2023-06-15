import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiddo/constants.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';
import '../../models/DB.dart';
import '../../models/scoreModel.dart';

class Memory extends StatefulWidget {
  @override
  _MemoryState createState() => _MemoryState();
}

class _MemoryState extends State<Memory> {
  final player = AudioPlayer();
  GameLogic _gameLogic = GameLogic();
  int tries = 0;
  int score = 0;
  bool str = false;
  var dateTime = Duration().obs;
  String latestTime = "";
  var date;
  ScoreModel _scoreModel = ScoreModel();
  bool starting = false;
  void start(){
    if(starting){
      run();
    }else{
      latestTime = dateTime.value.toString();
      print(latestTime);
    }
  }
  void run(){
    if(starting)
      Timer(Duration(milliseconds: 120), () {
        dateTime.value = DateTime.now().difference(date);
        run();
      },);
  }
  @override
  void initState() {
    super.initState();
    _gameLogic.initGame();
    _loadScoreModel();
  }

  void _loadScoreModel() async {
    ScoreModel scoreModel = await DB.instance.future;
    setState(() {
      _scoreModel = scoreModel;
      print(_scoreModel);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Lpink,
      appBar: AppBar(
          foregroundColor: AppColors.black,
          actions: [
            FloatingActionButton(
              elevation: 0,
              backgroundColor: AppColors.Lpink,
              mini: true,
              child: Icon(Icons.refresh, color: AppColors.black),
              onPressed: () {
                setState(() {
                  _gameLogic.initGame();
                  tries = 0;
                  score = 0;
                });
              },
            ),
          ],
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.Lpink),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                scoreBoard("Highest Scores", "${_scoreModel.shapes}"),
                Obx(() => scoreBoard("Time", "${dateTime.value}")),
              ],
            ),
            SizedBox(height: 45),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                scoreBoard("Tries", "$tries"),
                scoreBoard("Scores", "$score"),
              ],
            ),
            SizedBox(
              height: ScreenSize(context).height * 0.6,
              width: ScreenSize(context).width,
              child: GridView.builder(
                  itemCount: _gameLogic.gameImg.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                  ),
                  padding: EdgeInsets.all(15),
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.crimson,
                          image: DecorationImage(
                              image: AssetImage(_gameLogic.gameImg[index]),
                              fit: BoxFit.contain),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.crimson,
                              blurRadius: 2,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        if(!str) {
                          dateTime.value = Duration();
                          date = DateTime.now();
                          str = true;
                          starting = true;
                          start();
                        }
                        setState(() {
                          tries++;
                          _gameLogic.gameImg[index] = _gameLogic.cardsList[index];
                          _gameLogic.matchCheck
                              .add({index: _gameLogic.cardsList[index]});
                          print(_gameLogic.matchCheck);
                        });
                        if (_gameLogic.matchCheck.length == 2) {
                          if (_gameLogic.matchCheck[0].values.first ==
                                  _gameLogic.matchCheck[1].values.first &&
                              _gameLogic.matchCheck[0].keys.first !=
                                  _gameLogic.matchCheck[1].keys.first) {
                            score += 100;
                            player.play(AssetSource("voices/correct.mp3"));
                            _gameLogic.matchCheck.clear();
                          } else {
                            player.play(AssetSource("voices/wrong.mp3"));
                            Future.delayed(Duration(milliseconds: 500), () {
                              setState(() {
                                _gameLogic.gameImg[_gameLogic.matchCheck[0].keys
                                    .first] = _gameLogic.hiddenCardPath;
                                _gameLogic.gameImg[_gameLogic.matchCheck[1].keys
                                    .first] = _gameLogic.hiddenCardPath;
                                _gameLogic.matchCheck.clear();
                                Vibration.vibrate(duration: 300);
                              });
                            });
                          }

                          if (!_gameLogic.gameImg
                                  .contains("assets/games/memo/hidden.png") &&
                              score >= 400) {
                            str = false;
                            starting = false;
                            start();
                            player.play(AssetSource("voices/winner.mp3"));
                            if(_scoreModel.shapes!=null){
                              if(_scoreModel.shapes!>dateTime.value.inMilliseconds/1000){
                                print(_scoreModel.shapes);
                                _scoreModel.shapes = dateTime.value.inMilliseconds/1000;
                                update(_scoreModel);
                              }
                            }else{
                              ScoreModel scoreModel = ScoreModel();
                              scoreModel = _scoreModel;
                              scoreModel.shapes = dateTime.value.inMilliseconds/1000;
                              update(scoreModel);
                            }
                            Future.delayed(
                              Duration(seconds: 4),
                              () {
                                dateTime.value = Duration();
                                date = DateTime.now();
                                setState(() => score = 0);
                                setState(() => tries = 0);
                                setState(() => _gameLogic.initGame());
                              },
                            );
                          }
                        }
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
  void update(ScoreModel scoreModel) async {
    await DB.instance.update(scoreModel);
    if(!mounted) return;
  }
}

Widget scoreBoard(String title, String info) {
  return Expanded(
    child: Container(
      margin: EdgeInsets.all(25.0),
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(6.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PrimaryText(text: title, fontWeight: FontWeight.w800, size: 22),
          SizedBox(height: 10),
          PrimaryText(text: info, fontWeight: FontWeight.w800, size: 22),
        ],
      ),
    ),
  );
}

class GameLogic {
  final String hiddenCardPath = 'assets/games/memo/hidden.png';
  late List<String> gameImg;
  final cardCount = 8;

  final List<String> cardList1 = [
    "assets/games/memo/circle.png",
    "assets/games/memo/triangle.png",
    "assets/games/memo/heart.png",
    "assets/games/memo/star.png",
  ];

  final List<String> cardList2 = [
    "assets/games/memo/circle.png",
    "assets/games/memo/triangle.png",
    "assets/games/memo/heart.png",
    "assets/games/memo/star.png",
  ];
  List<String> cardsList = [];

  List<Map<int, String>> matchCheck = [];

  void fillList() {
    cardsList = [];
    cardsList += shuffle(cardList1) + shuffle(cardList2);
  }

  void initGame() {
    gameImg = List.generate(cardCount, (index) => hiddenCardPath);
    fillList();
  }
}

List<String> shuffle(List<String> items) {
  var random = new Random();

  for (var i = items.length - 1; i > 0; i--) {
    var n = random.nextInt(i + 1);
    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }
  return items;
}
