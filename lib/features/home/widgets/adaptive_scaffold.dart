// import 'package:cupertino_material3_mix/features/home/screens/adaptiveFormPage.dart';
// import 'package:cupertino_material3_mix/features/home/widgets/adaptive_appbar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class AdaptiveScaffold extends StatelessWidget {
//   const AdaptiveScaffold({
//     Key.key,
//     required this.child,
//     this.appBar,
//   }):super({key:key});

//   final Widget child;
//   final PreferredSizeWidget? appBar;

//   @override
//   Widget build(BuildContext context) {
//     final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

//     return isIOS
//         ? CupertinoPageScaffold(
//             // navigationBar: appBar is AdaptiveAppBar ? appBar as AdaptiveAppBar : null,
//             navigationBar: appBar,
//             child: SafeArea(child: child),
//           )
//         : Scaffold(
//             appBar: appBar,
//             body: SafeArea(child: child),
//             floatingActionButton: FloatingActionButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const AdaptiveFormScreen()),
//                 );
//               },
//               child: const Icon(Icons.add),
//             ),
//           );
//   }
// }

// import 'package:cupertino_material3_mix/core/platforms/platform_widget.dart';
import 'package:cupertino_material3_mix/features/home/widgets/adaptive_appbar.dart';
// import 'package:cupertino_material3_mix/features/home/widgets/fabButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    Key? key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
  }) : super(key: key);

  final Widget child;
  final AdaptiveAppBar? appBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: child,
          )
        : Scaffold(
            appBar: appBar,
            body: child,
            floatingActionButton: floatingActionButton,
          );
  }
}

