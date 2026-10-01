import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../services/meal_api_services.dart';

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  return MealService().getCategories();
});