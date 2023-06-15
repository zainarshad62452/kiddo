class ScoreModel{

  String? name;
  int? age;
  double? puzzle,fruits,animals,shapes,puzzle2;

  ScoreModel({this.name,this.age,this.puzzle,this.fruits,this.animals,this.shapes,this.puzzle2});




  factory ScoreModel.fromJson(Map<String, dynamic> map) => ScoreModel(
  name: map['name'],
    age: map['age'],
  puzzle:  map['puzzle'],
  puzzle2:  map['puzzle2'],
  fruits:  map['fruits'],
  animals:  map['animals'],
  shapes:  map['shapes'],
  );

  Map<String,dynamic> get json => {
    'name' : name,
    'age' : age,
    'puzzle' : puzzle,
    'puzzle2' : puzzle2,
    'fruits' : fruits,
    'animals' : animals,
    'shapes' : shapes
  };
}