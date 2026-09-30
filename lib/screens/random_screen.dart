import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shiwu_app/widgets/custom_appbar.dart';
import 'package:shiwu_app/widgets/search_icon.dart';

class RandomScreen extends StatelessWidget {
  const RandomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Random Recipe',
        actionWidget: SearchIconButton(
          onPressed: () => context.push('/search'),
        ),
      ),
      body: const SafeArea(
        child: Center(child: Text('Random', style: TextStyle(fontSize: 18))),
      ),
    );
  }
}
