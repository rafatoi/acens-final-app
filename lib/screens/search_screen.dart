import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shiwu_app/models/meal_summary.dart';

import '../providers/searching_provider.dart';
import '../widgets/search_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchingProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(searchingProvider.notifier).clearSearch();
            Navigator.pop(context);
          },
        ),
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search recipe...',
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();

                      ref.read(searchingProvider.notifier).clearSearch();

                      setState(() {});
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() {});
          },
          onSubmitted: (value) {
            if (value.trim().isEmpty) {
              return;
            }

            ref.read(searchingProvider.notifier).searchMeals(value.trim());
          },
        ),
      ),
      body: searchState.when(
        loading: () {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Searching recipes...'),
              ],
            ),
          );
        },
        data: (meals) {
          if (!ref.read(searchingProvider.notifier).hasSearched) {
            return const Center(child: Text('Search for a recipe'));
          }

          if (meals.isEmpty) {
            return const Center(child: Text('No recipes found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final MealSummary meal = meals[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: MealSearchCard(
                  imageUrl: meal.imageUrl,
                  mealName: meal.name,
                  onTap: () => {},
                ),
              );
            },
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'An error occurred while searching for recipes.',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final text = _searchController.text.trim();

                    if (text.isEmpty) {
                      return;
                    }

                    ref.read(searchingProvider.notifier).searchMeals(text);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
