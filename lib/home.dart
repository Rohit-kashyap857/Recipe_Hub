// lib/home.dart
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model.dart';
import 'recipe_detail.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  List<RecipeModel> recipeList = [];
  TextEditingController searchController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  final List<String> categories = [
    'chicken',
    'breakfast',
    'lunch',
    'dinner',
    'dessert',
    'snack',
    'vegetarian',
    'vegan',
    'seafood',
    'drinks',
  ];

  String selectedCategory = 'chicken'; // default category

  @override
  void initState() {
    super.initState();
    getRecipe(selectedCategory);
  }

  Future<void> getRecipe(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final String url =
        "https://api.edamam.com/api/recipes/v2?type=public&q=${Uri.encodeComponent(query)}&app_id=ebb6041c&app_key=3c33ad913ab23b8554082bfb5fdd78b5";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        recipeList.clear();

        if (data['hits'] != null && data['hits'] is List) {
          for (final element in data['hits']) {
            try {
              final recipeJson = element['recipe'];
              if (recipeJson is Map<String, dynamic>) {
                final recipeModel = RecipeModel.fromMap(recipeJson);
                recipeList.add(recipeModel);
              }
            } catch (e) {
              log('Skipping a hit due to parse error: $e');
            }
          }

          if (recipeList.isEmpty) {
            errorMessage = 'No recipes found for "$query"';
          }
        } else {
          errorMessage = 'No results';
        }
      } else {
        errorMessage = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage = 'Failed to load recipes: $e';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final selected = cat == selectedCategory;
          return ChoiceChip(
            label: Text(cat[0].toUpperCase() + cat.substring(1)),
            selected: selected,
            onSelected: (on) {
              if (!selected) {
                setState(() {
                  selectedCategory = cat;
                  searchController.clear();
                });
                getRecipe(cat);
              }
            },
            selectedColor: Colors.blueAccent,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600),
          );
        },
      ),
    );
  }

  Widget _buildRecipeCard(int index) {
    final recipe = recipeList[index];

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetail(recipe: recipe),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: recipe.appimageurl.isNotEmpty
                  ? Image.network(
                      recipe.appimageurl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          height: 200,
                          child: Icon(Icons.broken_image, size: 64),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[300],
                      height: 200,
                      child: Icon(Icons.image_not_supported, size: 64),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.applabel,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ...recipe.mealType.map((t) => Chip(
                            label: Text(t),
                            visualDensity: VisualDensity.compact,
                          )),
                      ...recipe.dishType.map((t) => Chip(
                            label: Text(t),
                            visualDensity: VisualDensity.compact,
                          )),
                      ...recipe.cuisineType.map((t) => Chip(
                            label: Text(t),
                            visualDensity: VisualDensity.compact,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null && recipeList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    }

    if (recipeList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Text(
            'No recipes found',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: recipeList.length,
      itemBuilder: (context, index) => _buildRecipeCard(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff213A50), Color(0xff071938)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // search bar
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.search, color: Colors.blue),
                            onPressed: () {
                              final q = searchController.text.trim();
                              if (q.isNotEmpty) {
                                setState(() {
                                  selectedCategory = '';
                                });
                                getRecipe(q);
                              }
                            },
                          ),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: 'Search your favourite food',
                                border: InputBorder.none,
                              ),
                              onSubmitted: (value) {
                                final q = value.trim();
                                if (q.isNotEmpty) {
                                  setState(() {
                                    selectedCategory = '';
                                  });
                                  getRecipe(q);
                                }
                              },
                            ),
                          ),
                          if (searchController.text.isNotEmpty)
                            IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                searchController.clear();
                                final q = selectedCategory.isNotEmpty
                                    ? selectedCategory
                                    : 'chicken';
                                getRecipe(q);
                              },
                            )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 8),
                  _buildCategoryChips(),
                  SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        Text(
                          'Choose your food?',
                          style: TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        Text('Let\'s search tasty food',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9))),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: _buildBody(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
