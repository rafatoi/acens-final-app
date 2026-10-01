import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shiwu_app/providers/category_provider.dart';
import 'package:shiwu_app/widgets/category_card.dart';
import 'package:shiwu_app/widgets/search_icon.dart';

import '../widgets/custom_appbar.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Categories',
        actionWidget: SearchIconButton(
          onPressed: () => context.push('/search'),
        ),
      ),
      body: categoriesAsync.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },

        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'An error occurred while loading categories.',
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(categoriesProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },

        data: (categories) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];

              return CategoryCard(
                category: category.name,
                imageUrl: category.imageUrl,
                onTap: () => {}
              );
            },
          );
        },
      ),
    );
  }
}