import 'package:chefs_mind/main.dart';
import 'package:chefs_mind/services/api_service.dart';
import 'package:chefs_mind/services/service_locator.dart';
import 'package:flutter/material.dart';

class IngredientsListPageLogic {
  final apiService = locator.get<ApiService>();

  Future<dynamic> fetchIngredients(String searchedIngredient) {
    return apiService.getIngredients(searchedIngredient);
  }

  Widget buildCard(String id, String name, String image) {
    return Card(
      elevation: 8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.network(
            "https://spoonacular.com/cdn/ingredients_100x100/$image",
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  color: Colors.black45,
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              name.toTitleCase(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
