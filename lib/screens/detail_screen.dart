import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shiwu_app/models/meal_detail.dart';
import 'package:shiwu_app/providers/favorite_provider.dart';
import 'package:shiwu_app/providers/meal_detail_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final String mealId;

  const DetailScreen({
    super.key,
    required this.mealId,
  });

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  bool _showIngredients = true;

  int _servings = 1;

  Future<bool> _showRemoveFavoriteDialog(
    BuildContext context,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove favorite'),
          content: const Text(
            'Do you want to remove this recipe from your favorites?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<bool> _showChangeFavoriteDialog(
    BuildContext context,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change favorite'),
          content: const Text(
            'You already have a favorite recipe. '
            'Do you want to replace it with this recipe?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Replace'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _openTutorial(String url) async {
    final shouldOpen = await showDialog<bool>(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return AlertDialog(
          title: const Text('Watch tutorial?'),
          content: const Text(
            'You are about to leave the app and open this recipe tutorial on YouTube.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );

    if (shouldOpen != true) {
      return;
    }

    final uri = Uri.parse(url);

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the tutorial.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mealAsync = ref.watch(
      mealDetailProvider(widget.mealId),
    );

    final favoriteState = ref.watch(
      favoriteRecipeProvider,
    );

    return mealAsync.when(
      loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, stackTrace) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Recipe'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      ref.invalidate(
                        mealDetailProvider(widget.mealId),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      data: (meal) {
        return _buildContent(
          context,
          ref,
          meal,
          favoriteState,
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    MealDetail meal,
    AsyncValue<String?> favoriteState,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Imagen + botones
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Image.network(
                      meal.imageUrl,
                      width: double.infinity,
                      height: 280,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Container(
                          width: double.infinity,
                          height: 280,
                          color: colorScheme.surfaceContainerHighest,
                          child: const Icon(
                            Icons.broken_image_outlined,
                            size: 48,
                          ),
                        );
                      },
                    ),
                  ),

                  // Back
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.primary,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),

                  // Favorite
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: favoriteState.when(
                      loading: () {
                        return const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        );
                      },

                      error: (error, stackTrace) {
                        return IconButton(
                          onPressed: null,
                          icon: const Icon(
                            Icons.favorite_border,
                          ),
                        );
                      },

                      data: (favoriteId) {
                        final isFavorite =
                            favoriteId == widget.mealId;

                        return IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withAlpha(200),
                          ),
                          onPressed: () async {
                            // -------------------------------------------------------
                            // CASO 1: la receta actual ya es favorita
                            // -------------------------------------------------------

                            if (favoriteId == widget.mealId) {
                              final confirmed =
                                  await _showRemoveFavoriteDialog(context);

                              if (!confirmed) {
                                return;
                              }

                              final success = await ref
                                  .read(favoriteRecipeProvider.notifier)
                                  .removeFavorite();

                              if (!success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Could not remove favorite recipe.',
                                    ),
                                  ),
                                );
                              }

                              return;
                            }

                            // -------------------------------------------------------
                            // CASO 2: no existe ninguna favorita
                            // -------------------------------------------------------

                            if (favoriteId == null) {
                              final success = await ref
                                  .read(favoriteRecipeProvider.notifier)
                                  .setFavorite(widget.mealId);

                              if (!success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Could not save favorite recipe.',
                                    ),
                                  ),
                                );
                              }

                              return;
                            }

                            // -------------------------------------------------------
                            // CASO 3: existe otra favorita
                            // -------------------------------------------------------

                            final confirmed =
                                await _showChangeFavoriteDialog(context);

                            if (!confirmed) {
                              return;
                            }

                            final success = await ref
                                .read(favoriteRecipeProvider.notifier)
                                .setFavorite(widget.mealId);

                            if (!success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Could not change favorite recipe.',
                                  ),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 32,
                          ),
                          color: isFavorite
                              ? Colors.red
                              : Colors.white,
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Nombre
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text(
                  meal.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),

              const SizedBox(height: 16),

              // Tags
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    _InfoTag(
                      icon: Icons.location_on_outlined,
                      label: meal.country,
                    ),

                    _InfoTag(
                      icon: Icons.list_alt,
                      label: meal.category,
                    ),

                    if (meal.youtubeUrl != null)
                      _InfoTag(
                        icon: Icons.play_circle_outlined,
                        label: 'Tutorial',
                        onTap: () {
                          _openTutorial(
                            meal.youtubeUrl!,
                          );
                        },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Selector
              _SectionSelector(
                showIngredients: _showIngredients,
                onIngredientsPressed: () {
                  setState(() {
                    _showIngredients = true;
                  });
                },
                onInstructionsPressed: () {
                  setState(() {
                    _showIngredients = false;
                  });
                },
              ),

              const SizedBox(height: 16),

              if (_showIngredients) ...[
                _ServingsCounter(
                  servings: _servings,
                  onDecrease: () {
                    if (_servings > 1) {
                      setState(() {
                        _servings--;
                      });
                    }
                  },
                  onIncrease: () {
                    setState(() {
                      _servings++;
                    });
                  },
                ),

                const SizedBox(height: 20),
              ],

              // Contenido
              if (_showIngredients)
                _IngredientsSection(
                  ingredients: meal.ingredients,
                  servings: _servings,
                )
              else
                _InstructionsSection(
                  instructions: meal.instructions,
                ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionSelector extends StatelessWidget {
  final bool showIngredients;
  final VoidCallback onIngredientsPressed;
  final VoidCallback onInstructionsPressed;

  const _SectionSelector({
    required this.showIngredients,
    required this.onIngredientsPressed,
    required this.onInstructionsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SectionButton(
            label: 'Ingredients',
            selected: showIngredients,
            onTap: onIngredientsPressed,
          ),
          _SectionButton(
            label: 'Instructions',
            selected: !showIngredients,
            onTap: onInstructionsPressed,
          ),
        ],
      ),
    );
  }
}

class _ServingsCounter extends StatelessWidget {
  final int servings;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _ServingsCounter({
    required this.servings,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Servings:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),

        const SizedBox(width: 12),

        // Menos
        _CounterButton(
          icon: Icons.remove,
          onPressed: onDecrease,
        ),

        const SizedBox(width: 12),

        // Número
        SizedBox(
          width: 24,
          child: Text(
            '$servings',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
          ),
        ),

        const SizedBox(width: 12),

        // Más
        _CounterButton(
          icon: Icons.add,
          onPressed: onIncrease,
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CounterButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          size: 18,
        ),
        style: IconButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(
            color: colorScheme.primary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class _SectionButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SectionButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
        ),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              Icon(
                Icons.check,
                size: 16,
                color: colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.w400,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IngredientsSection extends StatelessWidget {
  final List<Ingredient> ingredients;
  final int servings;

  const _IngredientsSection({
    required this.ingredients,
    required this.servings,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingredients',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 12),

          ...ingredients.map(
            (ingredient) {
              return _IngredientRow(
                ingredient: ingredient.name,
                quantity: scaleMeasure(
                  ingredient.measure,
                  servings,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

String scaleMeasure(
  String measure,
  int servings,
) {
  if (measure.trim().isEmpty) {
    return '';
  }

  final text = measure.trim();

  final match = RegExp(
    r'^(\d+(?:\.\d+)?(?:\s+\d+/\d+)?|\d+/\d+)(.*)$',
  ).firstMatch(text);

  // Si no comienza con una cantidad reconocible,
  // conservamos exactamente el texto original.
  if (match == null) {
    return text;
  }

  final numberText = match.group(1)!;
  final remainder = match.group(2)!;

  final quantity = _parseQuantity(numberText);

  if (quantity == null) {
    return text;
  }

  final scaledQuantity = quantity * servings;

  return '${_formatQuantity(scaledQuantity)}$remainder';
}

double? _parseQuantity(String value) {
  final text = value.trim();

  // Fracción simple: 1/2
  if (text.contains('/') && !text.contains(' ')) {
    final parts = text.split('/');

    if (parts.length != 2) {
      return null;
    }

    final numerator = double.tryParse(parts[0]);
    final denominator = double.tryParse(parts[1]);

    if (numerator == null ||
        denominator == null ||
        denominator == 0) {
      return null;
    }

    return numerator / denominator;
  }

  // Número mixto: 1 1/2
  if (text.contains(' ')) {
    final parts = text.split(RegExp(r'\s+'));

    if (parts.length != 2) {
      return null;
    }

    final whole = double.tryParse(parts[0]);

    if (whole == null) {
      return null;
    }

    final fractionParts = parts[1].split('/');

    if (fractionParts.length != 2) {
      return null;
    }

    final numerator = double.tryParse(fractionParts[0]);
    final denominator = double.tryParse(fractionParts[1]);

    if (numerator == null ||
        denominator == null ||
        denominator == 0) {
      return null;
    }

    return whole + (numerator / denominator);
  }

  // Número entero o decimal
  return double.tryParse(text);
}

String _formatQuantity(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }

  final whole = value.floor();
  final decimal = value - whole;

  Map<double, String> fractions = {
    0.25: '1/4',
    0.5: '1/2',
    0.75: '3/4',
    0.333: '1/3',
    0.667: '2/3',
  };

  String? fraction;

  for (final entry in fractions.entries) {
    if ((decimal - entry.key).abs() < 0.01) {
      fraction = entry.value;
      break;
    }
  }

  if (fraction != null) {
    if (whole == 0) {
      return fraction;
    }

    return '$whole $fraction';
  }

  return value
      .toStringAsFixed(2)
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}

class _IngredientRow extends StatelessWidget {
  final String ingredient;
  final String quantity;

  const _IngredientRow({
    required this.ingredient,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              ingredient,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),

          const SizedBox(width: 16),

          Text(
            quantity,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _InstructionsSection extends StatelessWidget {
  final String instructions;

  const _InstructionsSection({
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Instructions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 16),

          Text(
            instructions,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _InfoTag({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

