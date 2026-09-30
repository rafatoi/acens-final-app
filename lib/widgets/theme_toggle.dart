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
            //Circle container
            width: 60.0,
            height: 28.0,
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                //CIRCLE SIZE
                width: 24.0,
                height: 24.0,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    key: ValueKey<bool>(isDark),
                    color: colorScheme.onPrimary,
                    //ICON SIZE
                    size: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ),
        //Space between text and toggle
        const SizedBox(height: 2.0),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            isDark ? 'Dark Mode' : 'Light Mode',
            key: ValueKey<bool>(isDark),
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
