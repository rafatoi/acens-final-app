import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shiwu_app/widgets/custom_appbar.dart';
import 'package:shiwu_app/widgets/theme_toggle.dart';

import '../providers/recommendation_provider.dart';
import '../widgets/recipe_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationState = ref.watch(recommendationProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home',
        actionWidget: ThemeToggle(),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: recommendationState.when(
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
                          .read(recommendationProvider.notifier)
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
                  //Fake search bar
                  Padding(padding: EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 42, 
                      child: Material(
                        elevation: 2,
                        shadowColor: Colors.black26,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(30),
                        child: InkWell(
                          onTap: () => context.push(  '/search'),
                          borderRadius: BorderRadius.circular(30),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                                const SizedBox(width: 12),
                                
                                Expanded(
                                  child: Text(
                                    'Search for any recipe!',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 0),
                    child: Text(
                      'Welcome to Shiwu App!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Discover delicious meals and recipes.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(padding: EdgeInsets.only(left: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Recommended recipe:',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                      context.push('/details/${meal.id}');
                    },
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