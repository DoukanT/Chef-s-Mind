import 'package:chefs_mind/main.dart';
import 'package:chefs_mind/pages/ingredient_page/ingredient_page.dart';
import 'package:chefs_mind/services/api_service.dart';
import 'package:flutter/material.dart';

class IngredientsListPage extends StatefulWidget {
  const IngredientsListPage({super.key});

  @override
  State<IngredientsListPage> createState() => _IngredientsListPageState();
}

class _IngredientsListPageState extends State<IngredientsListPage> {
  var searchedIngredient = "";
  var textFieldInput = "";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SearchBar(
            hintText: "Ingredient Name",
            hintStyle: const MaterialStatePropertyAll(TextStyle(
              color: Colors.black45,
            )),
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
          const SizedBox(height: 16,),
          Expanded(
            child: searchedIngredient != "" ? FutureBuilder(
              future: getIngredients(searchedIngredient),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 10),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!["results"].length,
                    itemBuilder: (context, index) {
                      return buildCard(snapshot.data!["results"][index]["id"].toString(), snapshot.data!["results"][index]["name"], snapshot.data!["results"][index]["image"]);
                    },
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator(color: Colors.redAccent,));
              },
            ) : 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.black45,
                    height: 2
                  ),
                  children: [
                    TextSpan(
                      text: "Nothing to show right now.\nPlease enter a ingredient name into search bar and press ",
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

  Widget buildCard(String id, String name, String image) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => IngredientPage(ingredientId: id, ingredientName: name, ingredientImage: image,),));
      },
      child: Card(
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
          ]
        ),
      ),
    );
  }
}