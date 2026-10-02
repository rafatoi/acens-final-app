import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shiwu_app/models/meal_detail.dart';
import 'package:shiwu_app/services/meal_api_services.dart';

final mealServiceProvider = Provider<MealService>((ref) {
  return MealService();
});

final mealDetailProvider =
    FutureProvider.family<MealDetail, String>((ref, mealId) async {
  final mealService = ref.read(mealServiceProvider);

  return mealService.getMealDetail(mealId);
});