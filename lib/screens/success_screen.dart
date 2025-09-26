import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Image.asset(
                    'assets/logo.jpg',
                    height: 32,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 140), // было 100 — увеличено для визуального центра
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Stay Powered Anytime',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'To return your power bank\nand keep enjoying our\nservice for free, simply\ndownload the app!',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.6,
                    color: Colors.black,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFBFFAB8),
                      Color(0xFFA1ED59),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () async {
                      final url = Uri.parse(
                        'https://apps.apple.com/kz/app/recharge-city/id1594160460',
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: const Center(
                      child: Text(
                        'Download App',
                        style: TextStyle(
                          color: Color(0xFF0B0B0B),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  // TODO: переход на поддержку
                },
                child: const Text(
                  'Nothing happened? Contact support',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 82, 82, 82),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}