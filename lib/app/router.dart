import 'package:go_router/go_router.dart';
import 'package:shiwu_app/main.dart';
import 'package:shiwu_app/screens/home_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MyHomePage()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
  ],
);
