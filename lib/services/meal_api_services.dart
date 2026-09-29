import 'dart:convert';

import 'package:http/http.dart' as http;
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
}
