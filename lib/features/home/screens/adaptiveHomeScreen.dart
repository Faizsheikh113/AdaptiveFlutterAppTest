// import 'package:cupertino_material3_mix/core/platforms/platform_widget.dart';
// import 'package:cupertino_material3_mix/features/home/widgets/adaptive_appbar.dart';
// import 'package:cupertino_material3_mix/features/home/widgets/fabButton.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class AdaptiveHomeScreen extends StatelessWidget {
//   const AdaptiveHomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return PlatformWidget(
//       material: Scaffold(
//         appBar: const AdaptiveAppBar(),
//         body: const Center(child: Text('Hello Android!')),
//         floatingActionButton: const FABWidget(),
//       ),
//       cupertino: CupertinoPageScaffold(
//         navigationBar: AdaptiveAppBar(),
//         child: const Center(child: Text('Hello iOS!')),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_material3_mix/features/home/widgets/adaptive_appbar.dart';
import 'package:cupertino_material3_mix/features/home/widgets/adaptive_scaffold.dart';
import 'adaptiveFormPage.dart';

class AdaptiveHomeScreen extends StatelessWidget {
  const AdaptiveHomeScreen({super.key});

  void _navigateToForm(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    Navigator.push(
      context,
      isIOS
          ? CupertinoPageRoute(builder: (_) => const AdaptiveFormScreen())
          : MaterialPageRoute(builder: (_) => const AdaptiveFormScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: const Text("Adaptive Home"),
        trailing: isIOS
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.add),
                onPressed: () => _navigateToForm(context),
              )
            : null,
      ),
      floatingActionButton: isIOS
          ? null
          : FloatingActionButton(
              onPressed: () => _navigateToForm(context),
              child: const Icon(Icons.add),
            ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "Welcome to the Adaptive App!",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
