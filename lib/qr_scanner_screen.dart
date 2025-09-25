// qr_scanner_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/api_service.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool isTorchOn = false;
  bool isProcessing = false;
  String cameraStatus = 'init';

  @override
  void initState() {
    super.initState();
    debugPrint('[Scanner] initState() called');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        debugPrint('[Scanner] starting controller...');
        await controller.start();
        debugPrint('[Scanner] controller.start() OK');
        setState(() => cameraStatus = 'running');
      } catch (e, st) {
        debugPrint('[Scanner] controller.start() ERROR: $e');
        debugPrint('[Scanner] controller.start() STACK: $st');
        setState(() => cameraStatus = 'error: $e');
      }
    });
  }

  void toggleTorch() {
    try {
      controller.toggleTorch();
      setState(() {
        isTorchOn = !isTorchOn;
      });
    } catch (e) {
      debugPrint('[Scanner] toggleTorch error: $e');
    }
  }

  Future<void> handleScan(String code) async {
    if (isProcessing) return;
    isProcessing = true;

    const token = 'mock-token';
    debugPrint('[Scanner] handleScan() → code=$code, token=$token');
    final success = await ApiService.rentPowerbank(code, token);

    if (!mounted) return;

    if (success) {
      debugPrint('[Scanner] Navigation → /payment');
      context.go('/payment?code=$code', extra: token);
    } else {
      debugPrint('[Scanner] Navigation → /error');
      context.go('/error');
    }
    isProcessing = false;
  }

  @override
  void dispose() {
    try {
      controller.dispose();
    } catch (e) {
      debugPrint('[Scanner] dispose error: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[Scanner] build() called; status=$cameraStatus; kIsWeb=$kIsWeb');

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            key: const ValueKey('mobile_scanner'),
            controller: controller,
            fit: BoxFit.cover,
            onDetect: (capture) {
              try {
                final barcode = capture.barcodes.first;
                final String? code = barcode.rawValue;
                debugPrint('[Scanner] QR detected: $code');
                if (code != null) {
                  handleScan(code);
                }
              } catch (e, st) {
                debugPrint('[Scanner] onDetect error: $e');
                debugPrint('[Scanner] onDetect stack: $st');
              }
            },
          ),

          Positioned.fill(child: CustomPaint(painter: HolePainter())),
          Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: CustomPaint(painter: QRFramePainter()),
            ),
          ),

          Positioned(
            top: 48,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Сканируй QR',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          Positioned(
            top: 32,
            right: 16,
            child: GestureDetector(
              onTap: toggleTorch,
              child: Icon(
                isTorchOn ? Icons.flashlight_on : Icons.flashlight_off,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Status: $cameraStatus',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Painters (оставлены без изменений)
class QRFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const cornerSize = 30.0;

    canvas.drawLine(Offset(0, 0), Offset(cornerSize, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, cornerSize), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerSize, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerSize), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerSize), paint);
    canvas.drawLine(Offset(0, size.height), Offset(cornerSize, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - cornerSize, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - cornerSize), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HolePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final holeSize = 250.0;
    final center = Offset(size.width / 2, size.height / 2);
    final holeRect = Rect.fromCenter(center: center, width: holeSize, height: holeSize);

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectXY(holeRect, 16, 16))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, overlayPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}