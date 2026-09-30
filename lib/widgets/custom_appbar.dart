import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget actionWidget;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,

      leading: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/shiwu_logo.svg',
              width: 30,
              height: 30,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
            Text(
              'SHIWU',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: actionWidget,
        ),
      ],
    );
  }

  // Define standar size of appbar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
