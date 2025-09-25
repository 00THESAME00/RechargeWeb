import 'dart:math';

/// Используется в QRScannerScreen для проверки QR-кода
class ApiService {
  static Future<bool> rentPowerbank(String qrCode, String token) async {
    // Имитация вероятности: 75% успеха
    final roll = Random().nextInt(100); // 0–99
    final success = roll < 75;

    print('[ApiService] QR=$qrCode, Token=$token → roll=$roll → ${success ? 'успех' : 'неуспех'}');
    return success;
  }
}