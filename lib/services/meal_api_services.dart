import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shiwu_app/models/category.dart';
import 'package:shiwu_app/models/meal_summary.dart';

class MealService {
  final String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<MealSummary> getRandomMeal() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/random.php'));

      if (response.statusCode != 200) {
        throw Exception('HTTP error: ${response.statusCode}');
      }

      final rawData = jsonDecode(response.body);

      final mealJson = rawData['meals'][0];

      // Create a MealSummary object from the JSON data
      return MealSummary.fromJson(mealJson);
    } catch (e) {
      throw Exception('Failed to obtain meal: $e');
    }
  }

  Future<List<MealSummary>> searchMeals(String text) async {
    final url = Uri.parse(
      'https://www.themealdb.com/api/json/v1/1/search.php?s=$text',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Error al obtener las recetas');
    }

    final Map<String, dynamic> json = jsonDecode(response.body);

    final List<dynamic> meals = json['meals'] ?? [];

    return meals.map((meal) => MealSummary.fromJson(meal)).toList();
  }

  Future<List<Category>> getCategories() async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load categories');
    }

    final data = jsonDecode(response.body);

    final List categories = data['categories'];

    return categories.map((category) => Category.fromMap(category)).toList();
  }

  Future<List<MealSummary>> getMealsByCategory(String categoryName) async {
    final response = await http.get(
      Uri.parse('$baseUrl/filter.php?c=$categoryName'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load recipes');
    }

    final rawData = jsonDecode(response.body);

    final List meals = rawData['meals'];

    return meals.map((meal) {
      return MealSummary(
        id: meal['idMeal'],
        name: meal['strMeal'],
        category: categoryName,
        imageUrl: meal['strMealThumb'],
        country: meal['strCountry'] ?? '',
      );
    }).toList();
  }
}
