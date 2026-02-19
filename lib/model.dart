// lib/model.dart

class IngredientModel {
  final double quantity;
  final String measure;
  final String food;

  IngredientModel({
    required this.quantity,
    required this.measure,
    required this.food,
  });

  factory IngredientModel.fromMap(Map<String, dynamic> map) {
    return IngredientModel(
      quantity: (map['quantity'] as num?)?.toDouble() ?? 0.0,
      measure: map['measure'] ?? '',
      food: map['food'] ?? '',
    );
  }
}

class RecipeModel {
  final String applabel;
  final String appimageurl;
  final String appurl;
  final double appcalories;
  final double appyield;
  final List<IngredientModel> ingredients;

  final List<String> dietLabels;
  final List<String> healthLabels;
  final List<String> mealType;
  final List<String> dishType;
  final List<String> cuisineType;

  RecipeModel({
    required this.applabel,
    required this.appimageurl,
    required this.appurl,
    required this.appcalories,
    required this.appyield,
    required this.ingredients,
    required this.dietLabels,
    required this.healthLabels,
    required this.mealType,
    required this.dishType,
    required this.cuisineType,
  });

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      applabel: map['label'] ?? '',
      appimageurl: map['image'] ?? '',
      appurl: map['url'] ?? '',
      appcalories: (map['calories'] as num?)?.toDouble() ?? 0.0,
      appyield: (map['yield'] as num?)?.toDouble() ?? 1.0,

      ingredients: map['ingredients'] != null
          ? List<Map<String, dynamic>>.from(map['ingredients'])
          .map((e) => IngredientModel.fromMap(e))
          .toList()
          : [],

      dietLabels: List<String>.from(map['dietLabels'] ?? []),
      healthLabels: List<String>.from(map['healthLabels'] ?? []),
      mealType: List<String>.from(map['mealType'] ?? []),
      dishType: List<String>.from(map['dishType'] ?? []),
      cuisineType: List<String>.from(map['cuisineType'] ?? []),
    );
  }
}
