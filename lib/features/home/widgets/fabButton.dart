import 'dart:io' show Platform;
import 'package:cupertino_material3_mix/features/home/screens/adaptiveFormPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FABWidget extends StatelessWidget {
  const FABWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Positioned(
        bottom: 20,
        right: 20,
        child: CupertinoButton(
          color: CupertinoColors.activeBlue,
          padding: const EdgeInsets.all(16),
          child: const Icon(CupertinoIcons.add),
          onPressed: () {
            print("Floating action button pressed For IOS");
          },
        ),
      );
    } else {
      return FloatingActionButton(
        onPressed: () {
            MaterialPageRoute(builder: (_) => AdaptiveFormScreen());
        },
        child: const Icon(Icons.add),
      );
    }
  }
}