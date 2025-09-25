import 'package:flutter/material.dart';
import 'router.dart';

void main() {
  debugPrint('[Main] runApp() called');
  runApp(const PowerbankApp());
}

class PowerbankApp extends StatelessWidget {
  const PowerbankApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('[Main] PowerbankApp.build() called');
    return MaterialApp.router(
      title: 'Powerbank Rental',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}