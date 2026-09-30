import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shiwu_app/app/router.dart';
import 'package:shiwu_app/app/theme.dart';
import 'package:shiwu_app/models/meal_summary.dart';
import 'package:shiwu_app/providers/theme_provider.dart';
import 'package:shiwu_app/services/meal_api_services.dart';
import 'package:shiwu_app/widgets/theme_toggle.dart';

import 'widgets/button.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkModeProvider);

    return MaterialApp.router(
      title: 'Shiwu App',
      theme: AppTheme(isDarkMode: isDarkMode).getTheme(),
      routerConfig: router,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<MealSummary> mealSummaryFuture;

  @override
  void initState() {
    super.initState();
    mealSummaryFuture = MealService().getRandomMeal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PrimaryButton(
              text: 'Let\'s Begin',
              onPressed: () => context.go('/home'),
            ),
            ThemeToggle(),
          ],
        ),
      ),
    );
  }
}
