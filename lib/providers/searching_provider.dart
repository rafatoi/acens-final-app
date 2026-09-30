import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shiwu_app/models/meal_summary.dart';
import 'package:shiwu_app/services/meal_api_services.dart';

class SearchMealNotifier extends AsyncNotifier<List<MealSummary>> {
  @override
  Future<List<MealSummary>> build() async {
    return [];
  }

  Future<void> searchMeals(String text) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => MealService().searchMeals(text));
  }

  void clearSearch() {
    state = const AsyncData([]);
  }
}

final searchMealProvider =
    AsyncNotifierProvider<SearchMealNotifier, List<MealSummary>>(
      SearchMealNotifier.new,
    );
