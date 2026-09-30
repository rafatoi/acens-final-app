import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiwu_app/widgets/search_icon.dart';

import '../widgets/custom_appbar.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Categories',
        actionWidget: SearchIconButton(
          onPressed: () => context.push('/search'),
        ),
      ),
      body: const SafeArea(
        child: Center(
          child: Text('Categories', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
