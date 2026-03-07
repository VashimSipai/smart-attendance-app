import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../data/repositories/session_repository.dart';
import '../auth/auth_controller.dart';

class StudentQrScannerScreen extends ConsumerStatefulWidget {
  final String sessionId;
  const StudentQrScannerScreen({super.key, required this.sessionId});

  @override
  ConsumerState<StudentQrScannerScreen> createState() =>
      _StudentQrScannerScreenState();
}

class _StudentQrScannerScreenState
    extends ConsumerState<StudentQrScannerScreen> {
  MobileScannerController? _controller;
  bool _isProcessing = false;
  bool? _success;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing || _success != null) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    setState(() => _isProcessing = true);
    await _controller?.stop();

    final scannedToken = barcode!.rawValue!;
    final authState = ref.read(authControllerProvider);
    final studentUid = authState.user?.uid ?? '';
    final collegeId = authState.user?.collegeId ?? '';

    final error = await ref
        .read(sessionRepositoryProvider)
        .markAttendance(
          collegeId: collegeId,
          sessionId: widget.sessionId,
          studentUid: studentUid,
          scannedToken: scannedToken,
        );

    if (mounted) {
      setState(() {
        _isProcessing = false;
        if (error == null) {
          _success = true;
          _message = 'Attendance recorded! ✅';
        } else {
          _success = false;
          _message = error;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/student-dashboard'),
        ),
        title: Text(
          'Scan QR Code',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _success != null
          ? _buildResultView()
          : Stack(
              alignment: Alignment.center,
              children: [
                MobileScanner(controller: _controller!, onDetect: _onDetect),
                // Overlay
                CustomPaint(
                  painter: _ScannerOverlayPainter(),
                  child: const SizedBox.expand(),
                ),
                if (_isProcessing)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            color: Color(0xFF10B981),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Verifying attendance...',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Hint text at bottom
                Positioned(
                  bottom: 80,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Point at the QR code on your faculty\'s screen',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildResultView() {
    final isSuccess = _success == true;
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 360),
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: (isSuccess ? const Color(0xFF10B981) : Colors.red)
                    .withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSuccess ? Icons.check_circle : Icons.cancel,
                size: 64,
                color: isSuccess ? const Color(0xFF10B981) : Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isSuccess ? 'Attendance Marked!' : 'Failed',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 15),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/student-dashboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSuccess
                      ? const Color(0xFF10B981)
                      : const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Back to Dashboard',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            if (!isSuccess) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => setState(() {
                  _success = null;
                  _message = '';
                  _controller?.start();
                }),
                child: Text(
                  'Try Again',
                  style: GoogleFonts.inter(color: const Color(0xFF1E3A8A)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;
    final cutoutSize = size.width * 0.7;
    final cutoutRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.45),
      width: cutoutSize,
      height: cutoutSize,
    );

    // Draw dark overlay with transparent center
    canvas.save();
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRRect(
          RRect.fromRectAndRadius(cutoutRect, const Radius.circular(12)),
        ),
      ),
      paint,
    );
    canvas.restore();

    // Draw corners
    final cornerPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    const cornerLength = 24.0;
    final r = const Radius.circular(4);

    // Top-left
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          cutoutRect.left,
          cutoutRect.top,
          cornerLength,
          cornerLength,
        ),
        r,
      ),
      cornerPaint,
    );
    // Top-right
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          cutoutRect.right - cornerLength,
          cutoutRect.top,
          cornerLength,
          cornerLength,
        ),
        r,
      ),
      cornerPaint,
    );
    // Bottom-left
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          cutoutRect.left,
          cutoutRect.bottom - cornerLength,
          cornerLength,
          cornerLength,
        ),
        r,
      ),
      cornerPaint,
    );
    // Bottom-right
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          cutoutRect.right - cornerLength,
          cutoutRect.bottom - cornerLength,
          cornerLength,
          cornerLength,
        ),
        r,
      ),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
