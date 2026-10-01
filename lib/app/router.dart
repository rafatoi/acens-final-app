import 'package:go_router/go_router.dart';
import 'package:shiwu_app/main.dart';
import 'package:shiwu_app/screens/categories_screen.dart';
import 'package:shiwu_app/screens/category_recipes_screen.dart';
import 'package:shiwu_app/screens/detail_screen.dart';
import 'package:shiwu_app/screens/home_page.dart';
import 'package:shiwu_app/screens/search_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MyHomePage()),

    GoRoute(path: '/home', builder: (context, state) => const HomePage()),

    GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),

    GoRoute(
      path: '/categories',
      builder: (context, state) => const CategoriesScreen(),
    ),

    GoRoute(
      path: '/categories/:categoryName',
      builder: (context, state) {
        final categoryName = state.pathParameters['categoryName']!;

        return CategoryRecipesScreen(categoryName: categoryName);
      },
    ),

    GoRoute(
      path: '/details/:mealId',
      builder: (context, state) {
        final mealId = state.pathParameters['mealId']!;

        return DetailScreen(mealId: mealId);
      },
    ),
  ],
);
