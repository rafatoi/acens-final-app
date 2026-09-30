import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/searching_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchMealProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(searchMealProvider.notifier).clearSearch();
            context.pop();
          },
        ),
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search any recipe...',
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
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

            ref.read(searchMealProvider.notifier).searchMeals(value.trim());
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
                Text('Loading...'),
              ],
            ),
          );
        },

        data: (meals) {
          if (meals.isEmpty) {
            return const Center(child: Text('No recipes found!'));
          }

          return ListView.builder(
            itemCount: meals.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(meals[index].name));
            },
          );
        },

        error: (error, stackTrace) {
          return const Center(child: Text('Error'));
        },
      ),
    );
  }
}
