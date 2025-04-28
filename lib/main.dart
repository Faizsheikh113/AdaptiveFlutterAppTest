import 'package:cupertino_material3_mix/features/home/screens/adaptiveHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_material3_mix/core/platforms/adaptive_app.dart';

void main() {
  runApp(const AdaptiveWidgetApp());
}

class AdaptiveWidgetApp extends StatelessWidget {
  const AdaptiveWidgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveApp(
      debugShowCheckedModeBanner: true,
      child: const AdaptiveHomeScreen(),
    );
  }
}
