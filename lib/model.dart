// lib/model.dart
class RecipeModel {
  final String applabel;
  final String appimageurl;
  final String appurl;
  final double appcalories;
  final List<String> ingredients;
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
      appcalories: (map['calories'] != null)
          ? (map['calories'] as num).toDouble()
          : 0.0,
      ingredients: map['ingredientLines'] != null
          ? List<String>.from(map['ingredientLines'])
          : [],
      dietLabels: map['dietLabels'] != null
          ? List<String>.from(map['dietLabels'])
          : [],
      healthLabels: map['healthLabels'] != null
          ? List<String>.from(map['healthLabels'])
          : [],
      mealType: map['mealType'] != null
          ? List<String>.from(map['mealType'])
          : [],
      dishType: map['dishType'] != null
          ? List<String>.from(map['dishType'])
          : [],
      cuisineType: map['cuisineType'] != null
          ? List<String>.from(map['cuisineType'])
          : [],
    );
  }
}

