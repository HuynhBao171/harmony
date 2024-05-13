import 'dart:convert';

import 'package:harmony/main.dart';
import 'package:harmony/model/song.dart';
import 'package:shared_preferences/shared_preferences.dart';

final SharedPreferences prefs = getIt<SharedPreferences>();

Future<void> saveList(String key, List<dynamic> list) async {
  List<String> data = list.map((item) => jsonEncode(item.toJson())).toList();
  prefs.setStringList(key, data);
}

Future<List<Songs>> getList(String key) async {
  List<String> data = prefs.getStringList(key) ?? [];
  return data.map((item) => Songs.fromJson(jsonDecode(item))).toList();
}