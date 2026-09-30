import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importa Riverpod
import 'package:shiwu_app/providers/theme_provider.dart'; // Tu archivo del proveedor

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    
    final isDark = ref.watch(darkModeProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            // Riverpod
            ref.read(darkModeProvider.notifier).state = !isDark;
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: 110.0,
            height: 54.0,
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.wb_sunny_rounded,
                    key: ValueKey<bool>(isDark),
                    color: colorScheme.onPrimary,
                    size: 24.0,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12.0),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            isDark ? 'Dark Mode' : 'Light Mode',
            key: ValueKey<bool>(isDark),
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
