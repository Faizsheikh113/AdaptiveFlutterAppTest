import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveAppBar extends StatelessWidget
    implements PreferredSizeWidget, ObstructingPreferredSizeWidget {
  const AdaptiveAppBar({
    super.key,
    this.title,
    this.shouldObstruct,
    this.leading,
    this.trailing,
  });

  final Widget? title;
  final bool? shouldObstruct;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return isIOS
        ? CupertinoNavigationBar(
            middle: title,
            leading: leading,
            trailing: trailing,
            transitionBetweenRoutes: true,
          )
        : AppBar(
            title: title,
            leading: leading,
          );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return shouldObstruct ?? true;
  }
}
