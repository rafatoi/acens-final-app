import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/meal_summary.dart';
import '../services/meal_api_services.dart';

final categoryRecipesProvider =
    FutureProvider.family<List<MealSummary>, String>((ref, categoryName) async {
      return MealService().getMealsByCategory(categoryName);
    });
