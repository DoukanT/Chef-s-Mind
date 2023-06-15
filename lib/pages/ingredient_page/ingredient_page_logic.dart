import 'package:chefs_mind/services/api_service.dart';
import 'package:chefs_mind/services/service_locator.dart';
import 'package:chefs_mind/services/storage_service/shared_preferences_storage.dart';
import 'package:flutter/material.dart';

class IngredientPageLogic extends ChangeNotifier {
  ValueNotifier<bool> isInList = ValueNotifier(false);

  final apiService = locator.get<ApiService>();
  final storageService = locator.get<SharedPreferencesStorage>();

  void checkIfIsInList(String ingredientId) {
    storageService.checkIfIsInTheList(ingredientId).then((value) {
      isInList.value = value;
      notifyListeners();
    });
  }

  void toggleIngredient(
      String ingredientId, String ingredientName, String ingredientImage) {
    storageService.checkIfIsInTheList(ingredientId).then((value) {
      if (value) {
        storageService.removeIngredient(ingredientId).then((value) {
          isInList.value = !isInList.value;
          notifyListeners();
        });
      } else {
        storageService
            .addIngredient(ingredientId, ingredientName, ingredientImage)
            .then((value) {
          isInList.value = !isInList.value;
          notifyListeners();
        });
      }
    });
  }

  Future<List> getRecipesByIngredient(String ingredientName) {
    return apiService.getRecipeByIngredient(ingredientName);
  }
}
