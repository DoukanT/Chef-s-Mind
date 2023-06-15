import 'package:chefs_mind/main.dart';
import 'package:chefs_mind/pages/recipe_page/recipe_page.dart';
import 'package:chefs_mind/pages/ingredient_page/ingredient_page_logic.dart';
import 'package:flutter/material.dart';

class IngredientPage extends StatefulWidget {
  const IngredientPage({
    Key? key,
    required this.ingredientId,
    required this.ingredientName,
    required this.ingredientImage,
  }) : super(key: key);

  final String ingredientName;
  final String ingredientImage;
  final String ingredientId;

  @override
  State<IngredientPage> createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {
  final _logic = IngredientPageLogic();

  @override
  void initState() {
    super.initState();
    _logic.checkIfIsInList(widget.ingredientId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.ingredientName.toTitleCase()),
        actions: [
          ValueListenableBuilder(
            valueListenable: _logic.isInList,
            builder: (context, value, child) {
              return IconButton(
                onPressed: () {
                  _logic.toggleIngredient(widget.ingredientId,
                      widget.ingredientName, widget.ingredientImage);
                },
                icon: _logic.isInList.value
                    ? const Icon(Icons.bookmark_remove)
                    : const Icon(Icons.bookmark_add),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 6,
              ),
              const Text(
                "Things you can do\nwith",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              Card(
                elevation: 12,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: widget.ingredientImage.endsWith(".png")
                      ? const EdgeInsets.all(12)
                      : const EdgeInsets.all(0),
                  child: Image.network(
                    "https://spoonacular.com/cdn/ingredients_250x250/${widget.ingredientImage}",
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                          child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.black45,
                      ));
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Divider(
                thickness: 4,
                color: Colors.redAccent,
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: FutureBuilder<List>(
                  future: _logic.getRecipesByIngredient(widget.ingredientName),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 0, bottom: 10),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return buildCard(snapshot.data![index]);
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipePage(recipeId: data["id"]),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    data["image"],
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                          child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.black45,
                      ));
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                    ),
                    child: Text(
                      data["title"].toString().toLowerCase().toTitleCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          const WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.thumb_up,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: "  ${data["likes"]}",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
