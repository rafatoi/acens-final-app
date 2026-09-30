import 'package:flutter/material.dart';
import 'package:shiwu_app/screens/categories_screen.dart';
import 'package:shiwu_app/screens/favorite_screen.dart';
import 'package:shiwu_app/screens/home_screen.dart';
import 'package:shiwu_app/screens/random_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final pages = const [
    HomeScreen(),
    CategoriesScreen(),
    RandomScreen(),
    FavoriteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(1000),
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.list),
                label: 'Categories',
              ),
              NavigationDestination(
                icon: Icon(Icons.shuffle),
                label: 'Random',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite),
                label: 'Favorite',
              ),
            ],
          ),
        )
      )
    );
  }
}