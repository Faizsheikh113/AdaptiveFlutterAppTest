// import 'package:cupertino_material3_mix/core/platforms/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveApp extends StatelessWidget {
  const AdaptiveApp({
    Key? key,
    required this.child,
    required this.debugShowCheckedModeBanner,
    // required this.isIOS,
  }) : super(key: key);
  final Widget child;
  final bool debugShowCheckedModeBanner;
  // final bool isIOS;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return isIOS
        ? CupertinoApp(
          debugShowCheckedModeBanner: debugShowCheckedModeBanner,
          theme: const CupertinoThemeData(),
          home: child,
        )
        : MaterialApp(
          debugShowCheckedModeBanner: debugShowCheckedModeBanner,
          theme: ThemeData.light(useMaterial3: true),
          home: child,
        );
  }
}
