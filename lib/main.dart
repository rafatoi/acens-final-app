import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shiwu_app/app/router.dart';
import 'package:shiwu_app/app/theme.dart';
import 'package:shiwu_app/models/meal_summary.dart';
import 'package:shiwu_app/services/meal_api_services.dart';

import 'widgets/button.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: AppTheme(isDarkMode: true).getTheme(),
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
          mainAxisAlignment: .center,
          children: [
            PrimaryButton(
              text: 'Let\'s Begin',
              onPressed: () => context.go('/home'),
            ),
          ],
        ),
      ),
    );
  }
}
