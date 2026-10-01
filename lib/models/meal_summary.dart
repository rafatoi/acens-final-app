class MealSummary {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final String country;

  const MealSummary({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.country,
  });

  factory MealSummary.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'idMeal': String id,
        'strMeal': String name,
        'strCategory': String category,
        'strMealThumb': String imageUrl,
        'strCountry': String country,
      } =>
        MealSummary(
          id: id,
          name: name,
          category: category,
          imageUrl: imageUrl,
          country: country,
        ),
      _ => throw ArgumentError('Invalid JSON for MealSummary'),
    };
  }
}
