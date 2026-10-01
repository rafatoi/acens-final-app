import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String mealId;

  const DetailScreen({super.key, required this.mealId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _showIngredients = true;

  @override
  Widget build(BuildContext context) {
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
                      'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg',
                      width: double.infinity,
                      height: 280,
                      fit: BoxFit.cover,
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
                        border: Border.all(color: colorScheme.primary),
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
                    right: 12,
                    bottom: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                        border: Border.all(color: colorScheme.primary),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.favorite_border,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Nombre
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Falafel Pita Sandwich with Tahini Sauce',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 16),

              // Tags
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _InfoTag(
                      icon: Icons.location_on_outlined,
                      label: 'Country',
                    ),
                    const SizedBox(width: 10),
                    _InfoTag(icon: Icons.list_alt, label: 'Category'),
                    const SizedBox(width: 10),
                    _InfoTag(icon: Icons.link, label: 'Tutorial', onTap: () {}),
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

              const SizedBox(height: 20),

              // Contenido
              if (_showIngredients)
                const _IngredientsSection()
              else
                const _InstructionsSection(),

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
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline),
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
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primaryContainer : Colors.transparent,
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
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
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
  const _IngredientsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingredients',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          _IngredientRow(ingredient: 'soy sauce', quantity: '3/4 cup'),

          _IngredientRow(ingredient: 'soy sauce', quantity: '3/4 cup'),

          _IngredientRow(ingredient: 'soy sauce', quantity: '3/4 cup'),

          _IngredientRow(ingredient: 'soy sauce', quantity: '3/4 cup'),

          _IngredientRow(ingredient: 'soy sauce', quantity: '3/4 cup'),
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final String ingredient;
  final String quantity;

  const _IngredientRow({required this.ingredient, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              ingredient,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            quantity,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructionsSection extends StatelessWidget {
  const _InstructionsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Instructions',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          Text(
            'Preheat oven to 350° F. Spray a 9x13-inch '
            'baking pan with non-stick spray.\n\n'
            'Combine soy sauce, ½ cup water, brown '
            'sugar, ginger and garlic in a small saucepan '
            'and cover. Bring to a boil over medium heat. '
            'Remove lid and cook for one minute once boiling.\n\n'
            'Meanwhile, stir together the corn starch.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
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

  const _InfoTag({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 5),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
