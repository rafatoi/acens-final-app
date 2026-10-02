import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoriteRecipeKey = 'favorite_recipe_id';

  Future<void> saveFavorite(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _favoriteRecipeKey,
      recipeId,
    );
  }

  Future<String?> getFavorite() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(
      _favoriteRecipeKey,
    );
  }

  Future<void> removeFavorite() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(
      _favoriteRecipeKey,
    );
  }
}