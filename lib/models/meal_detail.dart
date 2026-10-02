class MealDetail {
  final String id;
  final String name;
  final String category;
  final String country;
  final String imageUrl;
  final String? youtubeUrl;
  final List<Ingredient> ingredients;
  final String instructions;

  const MealDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.country,
    required this.imageUrl,
    required this.youtubeUrl,
    required this.ingredients,
    required this.instructions,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final ingredients = <Ingredient>[];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null &&
          ingredient.toString().trim().isNotEmpty) {
        ingredients.add(
          Ingredient(
            name: ingredient.toString().trim(),
            measure: measure?.toString().trim() ?? '',
          ),
        );
      }
    }

    return MealDetail(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? '',
      category: json['strCategory']?.toString() ?? '',
      country: json['strArea']?.toString() ?? '',
      imageUrl: json['strMealThumb']?.toString() ?? '',
      youtubeUrl: _parseYoutubeUrl(json['strYoutube']),
      ingredients: ingredients,
      instructions: json['strInstructions']?.toString() ?? '',
    );
  }

  static String? _parseYoutubeUrl(dynamic value) {
    if (value == null) {
      return null;
    }

    final url = value.toString().trim();

    if (url.isEmpty) {
      return null;
    }

    return url;
  }
}

class Ingredient {
  final String name;
  final String measure;

  const Ingredient({
    required this.name,
    required this.measure,
  });
}