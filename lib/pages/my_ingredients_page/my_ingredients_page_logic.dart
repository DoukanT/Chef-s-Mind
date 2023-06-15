import 'package:flutter/material.dart';
import 'package:chefs_mind/services/storage_service/shared_preferences_storage.dart';

import '../../services/service_locator.dart';

class MyIngredientsLogic extends ChangeNotifier {
  ValueNotifier<List<String>> myIngredientsList = ValueNotifier([]);
  final storageService = locator.get<SharedPreferencesStorage>();

  Future<void> loadIngredientsList() async {
    final value = await storageService.getIngredientsList();
    myIngredientsList.value = value ?? [];
    notifyListeners();
  }

  Future<void> removeIngredient(String id) async {
    final value = await storageService.removeIngredient(id);
    myIngredientsList.value = value;
    notifyListeners();
  }
}
