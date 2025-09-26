class GooglePayService {
  static String? extractToken(Map<String, dynamic> result) {
    try {
      final paymentMethodData = result['paymentMethodData'];
      final tokenizationData = paymentMethodData['tokenizationData'];
      return tokenizationData['token'];
    } catch (_) {
      return null;
    }
  }
}