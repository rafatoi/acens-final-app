import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/meal_summary.dart';
import '../services/meal_api_services.dart';

final mealServiceProvider = Provider<MealService>(
  (ref) => MealService(),
);

final mealSummaryByIdProvider =
    FutureProvider.family<MealSummary, String>(
  (ref, mealId) async {
    final mealService = ref.read(
      mealServiceProvider,
    );

    return mealService.getMealSummaryById(mealId);
  },
);