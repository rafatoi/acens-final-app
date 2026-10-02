import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shiwu_app/providers/favorite_provider.dart';
import 'package:shiwu_app/widgets/button.dart';
import 'package:shiwu_app/widgets/custom_appbar.dart';
import 'package:shiwu_app/widgets/search_icon.dart';
import '../providers/meal_summary_provider.dart';
import '../widgets/recipe_card.dart';
import 'detail_screen.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteState = ref.watch(
      favoriteRecipeProvider,
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Favorite Recipe',
        actionWidget: SearchIconButton(
          onPressed: () => context.push('/search'),
        ),
      ),
      body: favoriteState.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },

        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Could not load favorite recipe.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      ref.invalidate(
                        favoriteRecipeProvider,
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },

        data: (favoriteId) {
          if (favoriteId == null) {
            return _buildEmptyState(context);
          }

          return _FavoriteRecipe(
            favoriteId: favoriteId,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'No favorite recipe',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'You have not selected a favorite recipe yet.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteRecipe extends ConsumerWidget {
  final String favoriteId;

  const _FavoriteRecipe({
    required this.favoriteId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealState = ref.watch(
      mealSummaryByIdProvider(favoriteId),
    );

    return mealState.when(
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },

      error: (error, stackTrace) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Could not load favorite recipe.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    ref.invalidate(
                      mealSummaryByIdProvider(favoriteId),
                    );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },

      data: (meal) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 16,
          ),
          child: Column(
            children: [
              Text(
                'Your preferred meal',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 24),

              RecipeCard(
                recipeName: meal.name,
                imageUrl: meal.imageUrl,
                category: meal.category,
                country: meal.country,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return DetailScreen(
                          mealId: meal.id,
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              PrimaryButton(
                text: 'Remove favorite',
                icon: Icons.delete_outline,
                fontSize: 18,
                onPressed: () async {
                  final confirmed = await _showRemoveFavoriteDialog(
                    context,
                  );

                  if (!confirmed) {
                    return;
                  }

                  final success = await ref
                      .read(
                        favoriteRecipeProvider.notifier,
                      )
                      .removeFavorite();

                  if (!success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Could not remove favorite recipe.',
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _showRemoveFavoriteDialog(
    BuildContext context,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Remove favorite',
          ),
          content: const Text(
            'Do you want to remove this recipe from your favorites?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                'Remove',
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}