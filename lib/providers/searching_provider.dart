import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shiwu_app/models/meal_summary.dart';
import 'package:shiwu_app/services/meal_api_services.dart';

class MealNotifier extends AsyncNotifier<List<MealSummary>> {
  bool hasSearched = false;

  @override
  Future<List<MealSummary>> build() async {
    return [];
  }

  Future<void> searchMeals(String text) async {
    hasSearched = true;

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => MealService().searchMeals(text),
    );
  }

  void clearSearch() {
    hasSearched = false;
    state = const AsyncData([]);
  }
}

final searchingProvider =
    AsyncNotifierProvider<MealNotifier, List<MealSummary>>(
  MealNotifier.new,
);