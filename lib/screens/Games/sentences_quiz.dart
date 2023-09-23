import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kiddo/constants.dart';
import 'package:kiddo/models/model_sentences.dart';

class SentencesQuizScreen extends StatefulWidget {
  @override
  _LettersScreenState createState() => _LettersScreenState();
}

class _LettersScreenState extends State<SentencesQuizScreen> {

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
          child: Container(
            child: Text("${test +1}). "+quizModel[test].title,style: TextStyle(color: Colors.white,fontSize: 30),),
          ),
        ) ,
          Expanded(
            flex: 2,
            child: Container(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  buildGridTile(quizModel[test].choice1),
                  buildGridTile(quizModel[test].choice2),
                  buildGridTile(quizModel[test].choice3),
                  buildGridTile(quizModel[test].choice4),
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
                       if(test<9){
                         if(selectedOption == quizModel[test].rightOption){
                           score++;
                         }
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
            Text(
              optionText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

}
