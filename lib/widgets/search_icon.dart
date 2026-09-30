import 'package:flutter/material.dart';

class SearchIconButton extends StatelessWidget {
  final VoidCallback onPressed; // El callback que se ejecutará siempre

  const SearchIconButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: Icon(Icons.search_rounded));
  }
}
