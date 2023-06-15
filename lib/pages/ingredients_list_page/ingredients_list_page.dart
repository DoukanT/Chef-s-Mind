import 'package:chefs_mind/pages/ingredient_page/ingredient_page.dart';
import 'package:flutter/material.dart';


import 'ingredients_list_page_logic.dart';

class IngredientsListPage extends StatefulWidget {
  const IngredientsListPage({Key? key}) : super(key: key);

  @override
  State<IngredientsListPage> createState() => _IngredientsListPageState();
}

class _IngredientsListPageState extends State<IngredientsListPage> {
  var searchedIngredient = "";
  var textFieldInput = "";

  final IngredientsListPageLogic logic = IngredientsListPageLogic();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SearchBar(
            hintText: "Ingredient Name",
            hintStyle: const MaterialStatePropertyAll<TextStyle>(
              TextStyle(
                color: Colors.black45,
              ),
            ),
            trailing: [
              IconButton(
                onPressed: () {
                  setState(() {
                    searchedIngredient = textFieldInput;
                  });
                },
                icon: const Icon(Icons.search, color: Colors.redAccent),
              ),
            ],
            onChanged: (value) => textFieldInput = value,
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: searchedIngredient != ""
                ? FutureBuilder(
                    future: logic.fetchIngredients(searchedIngredient),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return GridView.builder(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            top: 0,
                            bottom: 10,
                          ),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data!["results"].length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IngredientPage(
                                      ingredientId: snapshot.data!["results"][index]["id"].toString(),
                                      ingredientName: snapshot.data!["results"][index]["name"],
                                      ingredientImage: snapshot.data!["results"][index]["image"],
                                    ),
                                  ),
                                );
                              },
                              child: logic.buildCard(
                                snapshot.data!["results"][index]["id"].toString(),
                                snapshot.data!["results"][index]["name"],
                                snapshot.data!["results"][index]["image"],
                              ),
                            );
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.redAccent,
                        ),
                      );
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          color: Colors.black45,
                          height: 2,
                        ),
                        children: [
                          TextSpan(
                            text:
                                "Nothing to show right now.\nPlease enter an ingredient name into the search bar and press ",
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.search,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
