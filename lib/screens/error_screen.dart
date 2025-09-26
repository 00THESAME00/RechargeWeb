import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ошибка')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Не удалось выдать повербанк',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => context.go('/scanner'),
              child: const Text('Попробовать снова'),
            ),
          ],
        ),
      ),
    );
  }
}