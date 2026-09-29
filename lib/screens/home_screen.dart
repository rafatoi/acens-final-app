import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shiwu_app/providers/random_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meal = ref.watch(mealProvider);

    return Scaffold(
      body: meal.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },

        data: (meal) {
          return Center(child: Text(meal.name));
        },

        error: (error, stackTrace) {
          return Center(child: Text('Error: $error'));
        },
      ),
    );
  }
}
