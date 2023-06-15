import 'package:chefs_mind/pages/ingredients_list_page/ingredients_list_page.dart';
import 'package:chefs_mind/pages/my_ingredients_page/my_ingredients_page.dart';
import 'package:chefs_mind/pages/recipes_list_page/recipes_list_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  final screens = const [
    MyIngredientsPage(),
    RecipeListScreen(),
    IngredientsListPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.montserrat().fontFamily
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Recipe App"),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.redAccent,
          currentIndex: currentIndex,
          onTap: (value) => setState(() {
            currentIndex = value;
          }),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: "My Ingredients",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dining),
              label: "Recipes",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fastfood),
              label: "Ingredients",
            ),
          ],
        ),
      )
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}