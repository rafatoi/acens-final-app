import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shiwu_app/models/meal_summary.dart';
import 'package:shiwu_app/services/meal_api_services.dart';

class RecommendationNotifier extends AsyncNotifier<MealSummary> {
  final MealService _mealService = MealService();

  @override
  Future<MealSummary> build() async {
    return _mealService.getRandomMeal();
  }
  
  Future<void> getRandomMeal() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => _mealService.getRandomMeal(),
    );
  }
}

final recommendationProvider =
    AsyncNotifierProvider<RecommendationNotifier, MealSummary>(
  RecommendationNotifier.new,
);