import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiddo/constants.dart';
import 'package:vibration/vibration.dart';
import 'dart:math';
import '../../models/DB.dart';
import '../../models/scoreModel.dart';

class ColorMatchAnimals extends StatefulWidget {
  _ColorMatchState createState() => _ColorMatchState();
}

class _ColorMatchState extends State<ColorMatchAnimals> {
  final player = AudioPlayer();
  ScoreModel _scoreModel = ScoreModel();
  final Map<String, bool> score = {};
  final Map choices = {
    '🦁': Colors.brown[400],
    '🐴': Colors.yellow[800],
    '🦆': Colors.teal,
    '🐸': Colors.green,
    '🐮': Colors.pink[100],
    '🐶': Colors.orange[300]
  };
  final Map choices1 = {
    '🦁': "Lion",
    '🐴': "Horse",
    '🦆': "Duck",
    '🐸': "Frog",
    '🐮': "Cow",
    '🐶': "Dog"
  };
  final Map voices = {
    '🦁': "voices/leo.mp3",
    '🐴': "voices/horse.mp3",
    '🦆': "voices/duck.mp3",
    '🐸': "voices/frog.mp3",
    '🐮': "voices/cow.mp3",
    '🐶': "voices/dog.mp3"
  };
  @override
  void initState() {
    super.initState();
    _loadScoreModel();
  }

  void _loadScoreModel() async {
    ScoreModel scoreModel = await DB.instance.future;
    setState(() {
      _scoreModel = scoreModel;
      print(_scoreModel);
    });
  }
  int seed = 0;
  bool str = false;
  var dateTime = Duration().obs;
  String latestTime = "";
  var date;
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sage,
      appBar: AppBar(
          foregroundColor: AppColors.black,
          actions: [
            Center(child: Obx(() => Text("${dateTime.value??""}"))),
            FloatingActionButton(
              elevation: 0,
              backgroundColor: AppColors.sage,
              mini: true,
              child: Icon(Icons.refresh, color: AppColors.black),
              onPressed: () {
                setState(() {
                  score.clear();
                  seed++;
                });
              },
            ),
          ],
          centerTitle: true,
          title: PrimaryText(
            text: 'Scores: ${score.length} / 6',
            size: 25,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
          elevation: 0,
          backgroundColor: AppColors.sage),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
            choices.keys.map((emoji) => _buildDragTarget(emoji)).toList()
              ..shuffle(Random(seed)),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: choices.keys.map((emoji) {
                return Draggable<String>(
                  data: emoji,
                  child: Emoji(emoji: score[emoji] == true ? '✅' : emoji),
                  feedback: Emoji(emoji: emoji),
                  childWhenDragging: Emoji(emoji: '🌱'),
                );
              }).toList())
        ],
      ),
    );
  }

  Widget _buildDragTarget(emoji) {
    return DragTarget<String>(
        builder: (BuildContext context, List<String?> incoming, List rejected) {
          if (score[emoji] == true) {
            return Container(
              child: PrimaryText(
                  text: "Nice", fontWeight: FontWeight.w800, size: 25),
              alignment: Alignment.center,
              height: 80,
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 2,
                    )
                  ]),
            );
          } else {
            return Container(
              height: 80,
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: choices[emoji],
                  boxShadow: [
                    BoxShadow(
                      color: choices[emoji],
                      blurRadius: 2,
                    )
                  ]),
              child: Center(child: Text(choices1[emoji],style: TextStyle(fontSize: 20),)),
            );
          }
        },
        onWillAccept: (data) => data == emoji,
        onAccept: (data) {
          setState(
                () {
              score[emoji] = true;
              player.play(voices[emoji]);
              if (score.length == 6) {
                str = false;
                starting = false;
                start();
                if(_scoreModel.animals!=null){
                  if(_scoreModel.animals!>dateTime.value.inMilliseconds/1000){
                    print(_scoreModel.animals);
                    _scoreModel.animals = dateTime.value.inMilliseconds/1000;
                    update(_scoreModel);
                  }
                }else{
                  ScoreModel scoreModel = ScoreModel();
                  scoreModel = _scoreModel;
                  scoreModel.animals = dateTime.value.inMilliseconds/1000;
                  update(scoreModel);
                }
                player.play(AssetSource("voices/winner.mp3"));
                Future.delayed(
                  Duration(seconds: 4),
                      () {
                    setState(() => score.clear());
                    dateTime.value = Duration();
                    date = DateTime.now();
                    setState(() => seed++);
                  },
                );
              }
            },
          );
        },
        onLeave: (data) {
          if(!str) {
            dateTime.value = Duration();
            date = DateTime.now();
            str = true;
            starting = true;
            start();
          }
          Vibration.vibrate(duration: 500);
        });
  }
  void update(ScoreModel scoreModel) async {
    await DB.instance.update(scoreModel);
    if(!mounted) return;
  }
}

class Emoji extends StatelessWidget {
  final String emoji;
  Emoji({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 80,
        padding: EdgeInsets.all(10),
        child: Text(
          emoji,
          style: TextStyle(color: AppColors.black, fontSize: 50),
        ),
      ),
    );
  }
}
