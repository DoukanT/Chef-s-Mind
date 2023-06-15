import 'package:chefs_mind/pages/ingredient_page/ingredient_page.dart';
import 'package:chefs_mind/pages/recipe_page/recipe_page_logic.dart';
import 'package:chefs_mind/services/service_locator.dart';
import 'package:chefs_mind/services/storage_service/shared_preferences_storage.dart';
import 'package:flutter/material.dart';
import 'package:chefs_mind/services/api_service.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key, required this.recipeId});

  final int recipeId;

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final apiService = locator.get<ApiService>();
  final storageService = locator.get<SharedPreferencesStorage>();
  Map<String, dynamic> recipeInfo = {};
  List instructions = [];

  @override
  void initState() {
    super.initState();
    apiService
        .getRecipeInformation(widget.recipeId)
        .then((value) => setState(() => recipeInfo = value));
    apiService
        .getInstructions(widget.recipeId)
        .then((value) => setState(() => instructions = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipe Details"),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: recipeInfo.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.black45,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      recipeInfo["title"],
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  RecipePageLogic().buildRecipeDetails(recipeInfo),
                  RecipePageLogic().buildInfos(recipeInfo),
                  RecipePageLogic().buildInstructions(instructions, recipeInfo),
                  RecipePageLogic().buildIngredients(
                      instructions, onTapIngredient, recipeInfo),
                ],
              ),
            ),
    );
  }

  void onTapIngredient(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IngredientPage(
          ingredientId:
              recipeInfo['extendedIngredients'][index]['id'].toString(),
          ingredientImage: recipeInfo['extendedIngredients'][index]['image'],
          ingredientName: recipeInfo['extendedIngredients'][index]['name'],
        ),
      ),
    );
  }
}