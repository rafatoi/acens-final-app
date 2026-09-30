import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiwu_app/widgets/custom_appbar.dart';
import 'package:shiwu_app/widgets/search_icon.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Favorite Recipe',
        actionWidget: SearchIconButton(
          onPressed: () => context.push('/search'),
        ),
      ),
      body: SafeArea(
        child: Center(child: Text('Favorite', style: TextStyle(fontSize: 18))),
      ),
    );
  }
}
