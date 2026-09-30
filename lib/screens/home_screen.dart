import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shiwu_app/widgets/custom_appbar.dart';
import 'package:shiwu_app/widgets/theme_toggle.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Let\'s begin', actionWidget: ThemeToggle()),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/shiwu_logo.svg',
                width: 200.0,
                height: 200.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
