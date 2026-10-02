import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiwu_app/app/router.dart';
import 'package:shiwu_app/app/theme.dart';
import 'package:shiwu_app/providers/theme_provider.dart';

import 'widgets/button.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _isThemeLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final preferences = await SharedPreferences.getInstance();

    final isDarkMode = preferences.getBool('isDarkMode') ?? false;

    ref.read(darkModeProvider.notifier).state = isDarkMode;

    setState(() {
      _isThemeLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isThemeLoaded) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/shiwu_logo.svg',
              width: 200,
              height: 200,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            Text(
              'SHIWU',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
            ),
            Text(
              'Discover | Prepare | Enjoy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 80),
            PrimaryButton(
              icon: Icons.chevron_right,
              text: 'Let\'s Start',
              fontSize: 24,
              onPressed: () {
                context.push('/home');
              },
            ),
          ],
        ),
      ),
    );
  }
}