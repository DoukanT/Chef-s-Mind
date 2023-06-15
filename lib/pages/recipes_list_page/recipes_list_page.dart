import 'package:chefs_mind/pages/recipe_page/recipe_page.dart';
import 'package:flutter/material.dart';
import 'package:chefs_mind/services/api_service.dart';
import 'package:chefs_mind/main.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key, this.myIngredients});

  final List<String>? myIngredients;

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  String textFieldInput = "";
  bool externalMode = false;
  List recipeSuggestions = [];
  
  @override
  void initState() {
    super.initState();
    if (widget.myIngredients != null) {
      getRecipeSuggestions(widget.myIngredients!).then((value) => setState(() => recipeSuggestions = value));
      externalMode = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: externalMode ? AppBar(
        backgroundColor: Colors.red,
        title: const Text("You can make all of this!"),
      ) : null,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(8),
            child: Column(children: [
              !externalMode ? SearchBar(
                hintText: "Recipe Name",
                hintStyle: const MaterialStatePropertyAll(TextStyle(
                  color: Colors.black45,
                )),
                trailing: [
                  IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(Icons.search, color: Colors.redAccent),
                  ),
                ],
                onChanged: (value) => textFieldInput = value,
              ) : Container(),
              !externalMode ? const SizedBox(
                height: 16,
              ) : Container(),
              externalMode && recipeSuggestions.isEmpty 
              ? const Center(child: CircularProgressIndicator(color: Colors.redAccent,))
              : Column(
                children: [
                  externalMode
                  ? Center(
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: recipeSuggestions.length,
                            itemBuilder: (context, index) {
                              return buildCard(recipeSuggestions[index]["id"], recipeSuggestions[index]["title"], recipeSuggestions[index]["image"]);
                            },
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16,
                            ),
                          ),
                        )
                  : FutureBuilder(
                    future: textFieldInput.isEmpty
                        ? getRecipes(null)
                        : getRecipes(textFieldInput),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Colors.black45,));
                      }
                      if (snapshot.hasData) {
                        return Center(
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: textFieldInput.isEmpty
                                ? snapshot.data!["recipes"].length
                                : snapshot.data!["results"].length,
                            itemBuilder: (context, index) {
                              return textFieldInput.isEmpty
                                  ? buildCard(
                                      snapshot.data!["recipes"][index]["id"],
                                      snapshot.data!["recipes"][index]["title"],
                                      snapshot.data!["recipes"][index]["image"])
                                  : buildCard(
                                      snapshot.data!["results"][index]["id"],
                                      snapshot.data!["results"][index]["title"],
                                      snapshot.data!["results"][index]["image"]);
                            },
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16,
                            ),
                          ),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  Widget buildCard(int id, String name, String image) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipePage(
                recipeId: id,
              ),
            ));
      },
      child: Card(
        elevation: 8,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Image.network(
            image,
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
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  name.toTitleCase(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}