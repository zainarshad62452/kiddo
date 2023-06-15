import 'package:flutter/material.dart';
import 'package:kiddo/constants.dart';
// import 'package:kiddo/models/model_letters.dart';
import 'package:kiddo/models/model_sentences.dart';

class SentencesScreen extends StatefulWidget {
  @override
  _LettersScreenState createState() => _LettersScreenState();
}

class _LettersScreenState extends State<SentencesScreen> {
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
      body: Center(
        child: buildModels(),
      ),
    );
  }

  Widget buildModels() {
    return ListView.builder(
      itemCount: lettersList.length,
      itemBuilder: (context, index) {
        return ModelStyle(
          cardModel: new CustomCardModel2(
              title: lettersList[index]['name'].toString(),
              subImage: lettersList[index]['subImage'].toString(),
              image: lettersList[index]['imagePath'].toString()),
        );
      },
    );
  }
}
