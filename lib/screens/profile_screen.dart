import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kiddo/screens/games_screen.dart';

import '../constants.dart';
import '../models/DB.dart';

class KidsScreen extends StatefulWidget {
  @override
  _KidsScreenState createState() => _KidsScreenState();
}

class _KidsScreenState extends State<KidsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 20.0,
              ),
              Column(
                children: [
                  TextField(
                    controller: nameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                      border: OutlineInputBorder(),
                      label: Text('name'),
                      labelStyle: TextStyle(color: Colors.white),
                      // focusedBorder: UnderlineInputBorder(
                      //   borderSide: BorderSide(color: Colors.white),
                      // ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  SizedBox(height: 56.0),
                  TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('age'),
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  if(nameController.text.isNotEmpty){
                    var node = await DB.instance.future;
                    node.name = nameController.text;
                    node.age = int.parse(ageController.text);
                    await DB.instance.update(node);
                    Get.offAll(()=>GameScreen());
                  }else{
                    print("name");
                  }

                },
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                ),
              ),
            ],
          ),
      ),
    )
    );
  }
}
