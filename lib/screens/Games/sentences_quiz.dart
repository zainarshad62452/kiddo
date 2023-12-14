import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kiddo/constants.dart';
import 'package:kiddo/models/model_sentences.dart';

class SentencesQuizScreen extends StatefulWidget {
  @override
  _LettersScreenState createState() => _LettersScreenState();
}

class _LettersScreenState extends State<SentencesQuizScreen> {
  final FlutterTts flutterTts = FlutterTts();
  bool flag= false;
  String selectedOption = "";
  int test = 0;
  int score = 0;
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
      body:Column(
        children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Container(
                child: Text("${test +1}). "+quizModel[test].title,style: TextStyle(color: Colors.white,fontSize: 30),),
              ),
              IconButton(icon: Icon(Icons.volume_up,color: Colors.white,),onPressed: (){
                flutterTts.speak(quizModel[test].title);
                flutterTts.setPitch(1);
                flutterTts.setVolume(1);
                flutterTts.setSpeechRate(0.2);
                setState(() => flag = true);
                Future.delayed(Duration(milliseconds: 650), () {
                  setState(() => flag = false);
                });

              },)
            ],
          ),
        ) ,
          Expanded(
            flex: 2,
            child: Container(
              child: GridView.count(
                crossAxisCount: 2,
                children: quizModel[test].isImage?[
                  buildGridTile(quizModel[test].choice1),
                  buildGridTile(quizModel[test].choice2),
                  buildGridTile(quizModel[test].choice3),
                  buildGridTile(quizModel[test].choice4),
                ]:quizModel[test].image?[
                  buildGridTextTile(quizModel[test].choice1),
                  buildGridTextTile(quizModel[test].choice2),
                  buildGridTextTile(quizModel[test].choice3),
                  buildGridTextTile(quizModel[test].choice4),
                ]:[
                  buildGridColorTile(quizModel[test].choice1),
                  buildGridColorTile(quizModel[test].choice2),
                  buildGridColorTile(quizModel[test].choice3),
                  buildGridColorTile(quizModel[test].choice4),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
               child: Center(
                 child: MaterialButton(
                   color: Colors.blue,
                   onPressed: (){
                     setState(() {
                       if(selectedOption == quizModel[test].rightOption){
                         score++;
                         print(score);
                       }
                       if(test<9){
                         test++;
                       }else{
                         showDialog(context: context, builder: (ctx)=>AlertDialog(title: Text("Your Score"),content: Column(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             Text("Nice! You have Got",style: TextStyle(fontSize: 20),),
                             SizedBox(height: 20,),
                             Text("$score Scores",style: TextStyle(fontSize: 50),),
                           ],
                         ),actions: [
                           TextButton(onPressed: (){
                             Get.back();
                             Get.back();
                             Get.to(SentencesQuizScreen());
                           }, child: Text("Retry")),
                           TextButton(onPressed: (){
                             Get.back();
                             Get.back();
                           }, child: Text("Go Back")),
                         ],));
                         setState(() {

                         });
                       }

                     });
                 },child: Text(test<9?"Next":"Save",style: TextStyle(color: Colors.white),),),
               ),
            ),
          ) ,
        ],
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
  Widget buildGridTile(String optionText) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Radio(
              value: optionText,
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value!;
                });
              },
            ),
            Image.asset(optionText,width: 100,height: 100,),
          ],
        ),
      ),
    );
  }
  Widget buildGridTextTile(String optionText) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Radio(
              value: optionText,
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value!;
                });
              },
            ),
            Text(optionText,style: TextStyle(color: Colors.black,fontSize: 50),),
          ],
        ),
      ),
    );
  }
  Widget buildGridColorTile(String optionText) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Radio(
              value: optionText,
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value!;
                });
              },
            ),
            Expanded(
              child: Container(
                color: optionText=="Blue"?Colors.blue:optionText=="Red"?Colors.red:optionText=="Green"?Colors.green:Colors.yellow,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
