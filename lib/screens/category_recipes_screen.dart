import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shiwu_app/providers/category_recipes_provider.dart';
import 'package:shiwu_app/widgets/search_card.dart';

class CategoryRecipesScreen extends ConsumerWidget {
  final String categoryName;

  const CategoryRecipesScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(categoryRecipesProvider(categoryName));

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: recipesAsync.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },

        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('An error occurred while loading recipes.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(categoryRecipesProvider(categoryName));
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },

        data: (recipes) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MealSearchCard(
                  imageUrl: recipe.imageUrl,
                  mealName: recipe.name,
                  onTap: () {
                    // Handle recipe tap
                    context.push('/details/${recipe.id}');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
