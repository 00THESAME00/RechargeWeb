import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/apple_pay_dialog.dart';
import '../services/api_service.dart';
import '../widgets/loading_dialog.dart';

class PaymentScreen extends StatefulWidget {
  final String qrCode;
  final String token;

  const PaymentScreen({
    required this.qrCode,
    required this.token,
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const _amount = '\$4.99';
  static const Color dividerColor = Color(0xFFB2B2B5);
  static const double dividerInset = 7.0;

  Future<void> _showApplePaySheet() async {
    // Используем наш wrapper вместо прямого showGeneralDialog
    await showApplePayDialog(
      context: context,
      amount: _amount,
      onConfirm: () async {
        // Здесь не показываем LoadingDialog — его показывает ApplePayDialog
        final success = await ApiService.rentPowerbank(widget.qrCode, widget.token);
        if (!mounted) return false;

        // Навигация по результату
        context.go(success ? '/success' : '/error');

        return success;
      },
    );
  }

  Future<void> _handleCardPayment() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const LoadingDialog(),
    );

    final success = await ApiService.rentPowerbank(widget.qrCode, widget.token);
    if (!mounted) return;
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    context.go(success ? '/success' : '/payment');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Image.asset('assets/logo.jpg', height: 40),
              const SizedBox(height: 32),
              const Text(
                'Monthly Subscription',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Text(
                    '\$4.99',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 12),
                  Text(
                    '\$9.99',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text('First month only', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: dividerInset),
                child: Container(height: 0.5, color: dividerColor, width: double.infinity),
              ),
              const SizedBox(height: 20),

              // — Apple Pay кнопка
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _showApplePaySheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/apple_pay_logo.png', height: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Pay',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: dividerInset),
                child: Container(height: 0.5, color: dividerColor, width: double.infinity),
              ),
              const SizedBox(height: 12),

              // — Оплата картой
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleCardPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.network(
                            'https://images.icon-icons.com/37/PNG/512/bankcards_theapplication_banco_3050.png',
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Debit or credit card',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: dividerInset),
                child: Container(height: 0.65, color: dividerColor, width: double.infinity),
              ),

              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Nothing happened? Contact support',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 82, 82, 82),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}