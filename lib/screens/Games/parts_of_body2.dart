import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiddo/constants.dart';
import 'package:kiddo/models/scoreModel.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';
import '../../jigsaw.dart';
import '../../models/DB.dart';

class BodyPartsPuzzle2 extends StatefulWidget {
  _BodyPartsPuzzleState createState() => _BodyPartsPuzzleState();
}

class _BodyPartsPuzzleState extends State<BodyPartsPuzzle2> {
  final player = AudioPlayer();
  var score = 0.obs;
  final puzzleKey = GlobalKey<JigsawWidgetState>();
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
                  starting = false;
                  dateTime.value = Duration();
                  puzzleKey.currentState!.reset();
                });
              },
            ),
          ],
          centerTitle: true,
          title: Obx(() => PrimaryText(
            text: 'Scores: ${score} / 25',
            size: 25,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          )),
          elevation: 0,
          backgroundColor: AppColors.sage),
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    color: Colors.black45,
                    onPressed: () async {
                      starting = true;
                      dateTime.value = Duration();
                      score.value =0;
                      await puzzleKey.currentState!.generate();
                      date = DateTime.now();
                      start();
                    },
                    child: const Text('Play',style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
              JigsawPuzzle(
                level: 'level2',
                gridSize: 3,
                image: const AssetImage('assets/body2.jpg'),
                onTap: (){
                  player.play(AssetSource("voices/correct.mp3"));
                },
                onFinished: () {
                  player.play(AssetSource("voices/winner.mp3"));
                  starting = false;
                  if(_scoreModel.puzzle2!=null){
                    if(_scoreModel.puzzle2!>dateTime.value.inMilliseconds/1000){
                      print(_scoreModel.puzzle2);
                      _scoreModel.puzzle2 = dateTime.value.inMilliseconds/1000;
                      update(_scoreModel);
                    }
                  }else{
                    ScoreModel scoreModel = ScoreModel();
                    scoreModel = _scoreModel;
                    scoreModel.puzzle2 = dateTime.value.inMilliseconds/1000;
                    update(scoreModel);
                  }
                  print('finished!');
                },
                // ignore: avoid_redundant_argument_values
                snapSensitivity: .5, // Between 0 and 1
                puzzleKey: puzzleKey,
                onBlockSuccess: () {
                  player.play(AssetSource("voices/correct.mp3"));
                  score.value++;
                  print('block success!');
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void update(ScoreModel scoreModel) async {
    await DB.instance.update(scoreModel);
    if(!mounted) return;
  }
}
