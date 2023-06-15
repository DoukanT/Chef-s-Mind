import 'package:flutter/material.dart';
import 'package:chefs_mind/services/service_locator.dart';
import 'package:chefs_mind/services/storage_service/shared_preferences_storage.dart';
import 'package:chefs_mind/main.dart';

class RecipePageLogic {
  final storageService = locator.get<SharedPreferencesStorage>();

  Widget buildRecipeDetails(Map<String, dynamic> recipeInfo) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            recipeInfo["image"],
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
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
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 5.0, 0.0),
          child: Container(
            width: 70.0,
            height: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 2, color: Colors.red),
              color: Colors.red,
            ),
            child: Center(
              child: Text(
                '${recipeInfo["readyInMinutes"].toString()}\nmin',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildInfos(Map<String, dynamic> recipeInfo) {
    return Container(
      color: Colors.teal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(8),
              // width: MediaQuery.of(context).size.width * 0.25,
              color: Colors.teal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dish Types',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: recipeInfo['dishTypes'].length,
                      itemBuilder: (context, index) {
                        return Text(
                          recipeInfo['dishTypes'][index]
                              .toString()
                              .toLowerCase()
                              .toTitleCase(),
                          style: const TextStyle(fontSize: 18),
                        );
                      }),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              // width: MediaQuery.of(context).size.width * 0.75,
              color: Colors.orange,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Short info about ${recipeInfo["title"]}',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 2,
                    ),
                    Text(
                      htmlString(recipeInfo['summary']),
                      style: const TextStyle(fontSize: 16, letterSpacing: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildInstructions(List instructions, Map<String, dynamic> recipeInfo) {
    return Container(
      color: Colors.redAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Instructions',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(
              color: Colors.black,
              thickness: 2,
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: instructions[0]['steps'].length,
              itemBuilder: (context, index) {
                return RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        letterSpacing: 1.5, fontSize: 18, color: Colors.black),
                    children: [
                      TextSpan(
                        text: '${instructions[0]['steps'][index]['number']}-',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            '${instructions[0]['steps'][index]['step'].toString().toLowerCase().toTitleCase()}\n',
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIngredients(List instructions, Function onTapIngredient,
      Map<String, dynamic> recipeInfo) {
    return Container(
      color: Colors.deepPurple,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Ingredients',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(
              color: Colors.black,
              thickness: 2,
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: recipeInfo['extendedIngredients'].length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onTapIngredient(index),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder(
                              future: storageService.checkIfIsInTheList(
                                  recipeInfo['extendedIngredients'][index]['id']
                                      .toString()),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    recipeInfo['extendedIngredients'][index]
                                            ['name']
                                        .toString()
                                        .toLowerCase()
                                        .toTitleCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: snapshot.data!
                                          ? Colors.greenAccent
                                          : Colors.redAccent,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    recipeInfo['extendedIngredients'][index]
                                            ['name']
                                        .toString()
                                        .toLowerCase()
                                        .toTitleCase(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.redAccent,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

String htmlString(String htmlText) {
  String html = htmlText;
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  String parsedString = html.replaceAll(exp, '');
  return parsedString;
}
