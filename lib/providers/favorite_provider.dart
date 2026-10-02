import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../services/favorites_service.dart';

class FavoriteRecipeNotifier extends AsyncNotifier<String?> {
  final FavoritesService _favoritesService = FavoritesService();

  @override
  Future<String?> build() async {
    return _favoritesService.getFavorite();
  }

  Future<bool> setFavorite(String recipeId) async {
    try {
      await _favoritesService.saveFavorite(recipeId);

      state = AsyncData(recipeId);

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> removeFavorite() async {
    try {
      await _favoritesService.removeFavorite();

      state = const AsyncData(null);

      return true;
    } catch (_) {
      return false;
    }
  }
}

final favoriteRecipeProvider =
    AsyncNotifierProvider<FavoriteRecipeNotifier, String?>(
  FavoriteRecipeNotifier.new,
);

final favoriteActionProvider = StateProvider<String?>(
  (ref) => null,
);