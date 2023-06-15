import 'dart:convert';

import 'package:kiddo/models/scoreModel.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DB{

  DB._();

  static DB get instance => DB._();

  final String key = "child";

  SharedPreferences? _prefs;

  reset() async {
    _prefs = await SharedPreferences.getInstance();

  }

  Future<ScoreModel> get future async {
    await reset();

    if (_prefs?.getString(key) == null) {
      await _prefs?.setString(key, jsonEncode({}));
      await reset();
    }

    String? source = _prefs?.getString(key);

    Map<String, dynamic> map = jsonDecode(source ?? '{}');
    return ScoreModel.fromJson(map);
  }

  _updateAll(ScoreModel notes) async{
    await reset();
    await _prefs?.setString(key, jsonEncode(notes.json));
  }

  insert(ScoreModel note) async{
    var notes = await future;
    notes = note;
    await _updateAll(notes);
  }

  update(ScoreModel note) async{
    var notes = await future;
      notes= note;
      await _updateAll(notes);
  }
}