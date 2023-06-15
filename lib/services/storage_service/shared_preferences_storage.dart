import 'package:shared_preferences/shared_preferences.dart';

Future<void> addIngredient(String id, String name, String image) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? currList = prefs.getStringList("my-list");
  if (currList != null) {
    currList.add("$id|$name|$image");
    prefs.setStringList("my-list", currList);
  }else {
    prefs.setStringList("my-list", ["$id|$name|$image"]);
  }
}

Future<List<String>> removeIngredient(String id) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? currList = prefs.getStringList("my-list");
  currList!.removeWhere((element) => element.split("|")[0] == id);
  prefs.setStringList("my-list", currList);
  return currList;
}

Future<List<String>?> getIngredientsList() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList("my-list");
}

Future<bool> checkIfIsInTheList(String id) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? currList = prefs.getStringList("my-list");
  if (currList != null) {
    int i = currList.indexWhere((element) => element.split("|")[0] == id);
    return i == -1 ? false : true;
  }else {
    return false;
  }
}