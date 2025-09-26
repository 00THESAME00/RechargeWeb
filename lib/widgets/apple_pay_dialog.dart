import 'package:flutter/material.dart';
/// Модель информации о карте
class CardInfo {
  final String name;
  final String last4;
  final String address;

  CardInfo({
    required this.name,
    required this.last4,
    required this.address,
  });
}

/// Запускает диалог Apple Pay с анимацией снизу
Future<void> showApplePayDialog({
  required BuildContext context,
  required String amount,
  required Future<bool> Function() onConfirm,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, _, __) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(curved),
        child: ApplePayDialog(amount: amount, onConfirm: onConfirm),
      );
    },
  );
}

/// Диалог Apple Pay
class ApplePayDialog extends StatelessWidget {
  final String amount;
  final Future<bool> Function() onConfirm;

  const ApplePayDialog({
    Key? key,
    required this.amount,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final card = CardInfo(
      name: 'Apple Card',
      last4: '1234',
      address: '10880 Malibu Point Malibu Cal...',
    );
    final total = double.parse(amount.replaceAll('\$', ''));

    // Базовые локальные стили
    const sfRegular = TextStyle(
      fontFamily: 'SFProDisplay',
      fontSize: 16,
      color: Colors.black,
    );

    const sfBold = TextStyle(
      fontFamily: 'SFProDisplay',
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    const sfSmallGrey = TextStyle(
      fontFamily: 'SFProDisplay',
      fontSize: 13,
      color: Colors.grey,
    );

    // Pay Recharge стили
    const payTitleStyle = TextStyle(
      fontFamily: 'SFProDisplay',
      fontSize: 13.12,
      color: Color(0xFF88888C),
      fontWeight: FontWeight.w300,
      height: 1.0,
    );

    const payAmountStyle = TextStyle(
      fontFamily: 'SFProDisplay',
      fontSize: 28.27,
      color: Colors.black,
      fontWeight: FontWeight.w600,
      height: 1.0,
    );

    // Confirm-with-side-button стили — Regular 13.12
    const confirmTitleStyle = TextStyle(
      fontFamily: 'SFProDisplay',
      fontSize: 13.12,
      color: Color(0xFF3C3C43),
      fontWeight: FontWeight.w400,
      height: 1.1,
    );

    const dividerColor = Color(0xFFB2B2B5);

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF2F2F7),
              borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
            ),
            clipBehavior: Clip.hardEdge,
            child: SafeArea(
              top: false,
              bottom: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1) Логотип + крестик
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 1, 16, 0),
                    child: Row(
                      children: [
                        Image.asset('assets/apple_pay_logo_Pay.png', height: 55),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE3E3E8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 20, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),

                                   // 2) Блок карты
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 7),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('assets/apple_pay_logo_cards.png', width: 42, height: 42),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(card.name, style: sfRegular),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            card.address,
                                            style: sfSmallGrey,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const Icon(Icons.chevron_right, size: 30, color: Colors.grey),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '•••• ${card.last4}',
                                      style: sfSmallGrey.copyWith(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 3) Блок суммы
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 7),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Text('\$${total.toStringAsFixed(2)}', style: sfBold),
                      ),
                    ),
                  ),

                  // 4) Блок аккаунта
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Text('Account: username@icloud.com', style: sfSmallGrey),
                      ),
                    ),
                  ),

                  // ===== изменения ниже Account: расстояние уменьшено до 20px =====
                  const SizedBox(height: 20),

                  // Верхняя тонкая линия прилегает к Pay Recharge
                  Container(height: 0.5, color: dividerColor, width: double.infinity),

                  // Pay Recharge — сплошной слой
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 17, 16, 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pay Recharge', style: payTitleStyle),
                                const SizedBox(height: 2),
                                Text('\$${total.toStringAsFixed(2)}', style: payAmountStyle),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 28, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  // Нижняя тонкая линия прилегает к Pay Recharge — общая граница с Confirm блоком
                  Container(height: 0.5, color: dividerColor, width: double.infinity),

                  // Confirm-with-side-button блок — прилегает непосредственно к Pay Recharge через разделитель
                  GestureDetector(
                    onTap: () async {
                      // Выполняем переданную async-логику без показа LoadingDialog
                      await onConfirm();

                      // Закрываем сам ApplePayDialog
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: Padding(
                        // вертикальные padding внутри блока
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // иконка центрирована (увеличена ранее)
                            Center(child: Image.asset('assets/side_button.png', width: 42, height: 42)),
                            const SizedBox(height: 8),
                            // Confirm текст — Regular 13.12
                            Center(child: Text('Confirm with Side Button', style: confirmTitleStyle)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Нижняя тонкая линия под Confirm блоком — прикреплена
                  Container(height: 0.5, color: dividerColor, width: double.infinity),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}