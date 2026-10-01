import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shiwu_app/widgets/custom_appbar.dart';
import 'package:shiwu_app/widgets/search_icon.dart';

import '../providers/random_provider.dart';
import '../widgets/recipe_card.dart';

class RandomScreen extends ConsumerWidget {
  const RandomScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealState = ref.watch(mealProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Random Recipe',
        actionWidget: SearchIconButton(
          onPressed: () => context.push('/search'),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: mealState.when(
            loading: () {
              return const CircularProgressIndicator();
            },

            error: (error, stackTrace) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'An error occurred while loading the recipe.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(mealProvider.notifier)
                          .getRandomMeal();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              );
            },

            data: (meal) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Welcome to Shiwu App!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  RecipeCard(
                    recipeName: meal.name,
                    imageUrl: meal.imageUrl,
                    category: meal.category,
                    country: meal.country,
                    onTap: () {
                      // Handle recipe card tap
                    },
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                    ),
                    onPressed: () {
                      ref
                          .read(mealProvider.notifier)
                          .getRandomMeal();
                    },
                    child: const Text(
                      'Another Recipe',
                       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}