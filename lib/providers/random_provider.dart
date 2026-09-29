import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shiwu_app/models/meal_summary.dart';
import 'package:shiwu_app/services/meal_api_services.dart';

class MealNotifier extends AsyncNotifier<MealSummary> {
  @override
  Future<MealSummary> build() async {
    return MealService().getRandomMeal();
  }
}

final mealProvider = AsyncNotifierProvider<MealNotifier, MealSummary>(
  MealNotifier.new,
);
