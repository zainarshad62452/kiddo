import 'package:flutter/material.dart';
import 'package:kiddo/models/scoreModel.dart';

import '../constants.dart';
import '../models/DB.dart';

class HighScoreScreen extends StatefulWidget {
  @override
  _HighScoreScreenState createState() => _HighScoreScreenState();
}

class _HighScoreScreenState extends State<HighScoreScreen> {
  ScoreModel _scoreModel = ScoreModel();

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
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: AppColors.backGround),
        ),
        title:
        Image.asset('assets/images/Logo_color.png', width: 65, height: 65),
      ),
      backgroundColor: AppColors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Name: ${_scoreModel.name!.toUpperCase()}',
                  style: TextStyle(fontSize: 20.0,color: Colors.white),
                ),
                Text(
                  'Age: ${_scoreModel.age}',
                  style: TextStyle(fontSize: 20.0,color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                _buildHighScoreTile('Parts Of Body', _scoreModel.puzzle.toString()),
                _buildHighScoreTile('Parts Of Body2', _scoreModel.puzzle2.toString()),
                _buildHighScoreTile('Fruits', _scoreModel.fruits.toString()),
                _buildHighScoreTile('Animals', _scoreModel.animals.toString()),
                _buildHighScoreTile('Memory', _scoreModel.shapes.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighScoreTile(String gameName, String highScore) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        tileColor: Colors.white,
        title: Text(gameName),
        subtitle: Text('High Score: ${highScore=="null"?"0":highScore} sec'),
      ),
    );
  }
}
