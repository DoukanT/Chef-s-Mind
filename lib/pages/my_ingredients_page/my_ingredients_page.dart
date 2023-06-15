import 'package:chefs_mind/main.dart';
import 'package:flutter/material.dart';

import '../recipes_list_page/recipes_list_page.dart';
import 'my_ingredients_page_logic.dart';

class MyIngredientsPage extends StatelessWidget {
  const MyIngredientsPage({Key? key}) : super(key: key);
  static final MyIngredientsLogic _logic = MyIngredientsLogic();

  @override
  Widget build(BuildContext context) {
    _logic.loadIngredientsList();
    return ValueListenableBuilder(
      valueListenable: _logic.myIngredientsList,
      builder: (context, value, child) {
        return Scaffold(
          floatingActionButton: Align(
            alignment: const Alignment(1.08, 1.02),
            child: FloatingActionButton.extended(
              onPressed: () {
                if (_logic.myIngredientsList.value.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text("First, please add item(s) to list."),
                    action: SnackBarAction(
                      label: "OK",
                      textColor: Colors.redAccent,
                      onPressed: () =>
                          ScaffoldMessenger.of(context).clearSnackBars(),
                    ),
                  ));
                  return;
                }
                List<String> s = [];
                for (var element in _logic.myIngredientsList.value) {
                  s.add(element.split("|")[1]);
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeListScreen(myIngredients: s),
                  ),
                );
              },
              label: const Text("What can I make?"),
              backgroundColor: Colors.redAccent,
              icon: const Icon(Icons.dining),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            color: Colors.yellow[300],
            child: Column(
              children: [
                const Text(
                  "Your Ingredients",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Divider(
                  thickness: 4,
                  color: Colors.black,
                  height: 32,
                ),
                Expanded(child: IngredientsList(logic: _logic,)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class IngredientsList extends StatelessWidget {
  const IngredientsList({Key? key, required this.logic}) : super(key: key);
  final MyIngredientsLogic logic;

  @override
  Widget build(BuildContext context) {
    return logic.myIngredientsList.value.isEmpty
        ? const Center(
            child: Text(
              "You have no ingredient(s) at the moment.\nYou can simply add ingredient to this list using ingredients tab.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black45,
                height: 1.75,
              ),
            ),
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: logic.myIngredientsList.value.length,
            itemBuilder: (context, index) {
              List<String> splittedList =
                  logic.myIngredientsList.value[index].split("|");
              return buildListItem(
                  context, splittedList[0], splittedList[1], splittedList[2]);
            },
          );
  }

  Widget buildListItem(
      BuildContext context, String id, String name, String image) {
    return Column(
      children: [
        Card(
          color: Colors.white,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Padding(
                  padding: image.endsWith(".png")
                      ? const EdgeInsets.only(
                          top: 8, bottom: 8, left: 12, right: 0)
                      : const EdgeInsets.all(0),
                  child: Image.network(
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
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Text(
                    name.toTitleCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () => logic.removeIngredient(id),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
              ],
            ),
          ),
        ),
        const Divider(
          thickness: 1,
          color: Colors.black,
        ),
      ],
    );
  }
}
