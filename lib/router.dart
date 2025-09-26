import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/payment_screen.dart';
import 'screens/success_screen.dart';
import 'screens/error_screen.dart';
import 'qr_scanner_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/scanner',
  routes: [
    GoRoute(
      path: '/scanner',
      builder: (context, state) {
        debugPrint('[Router] /scanner route activated');
        return const QRScannerScreen();
      },
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) {
        final code = state.uri.queryParameters['code'] ?? '';
        final token = state.extra as String? ?? '';
        debugPrint('[Router] /payment route activated with code=$code, token=$token');
        return PaymentScreen(qrCode: code, token: token);
      },
    ),
    GoRoute(
      path: '/success',
      builder: (context, state) {
        debugPrint('[Router] /success route activated');
        return const SuccessScreen();
      },
    ),
    GoRoute(
      path: '/error',
      builder: (context, state) {
        debugPrint('[Router] /error route activated');
        return const ErrorScreen();
      },
    ),
  ],
);