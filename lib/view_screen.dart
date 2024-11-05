import 'package:flutter/material.dart';

class ViewScreen extends StatelessWidget {
  const ViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Background color
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0), // Add top and bottom margins
            child: CustomPaint(
              size: Size(350, 700), // Adjusted size for a realistic mobile frame
              painter: MobileFramePainter(),
            ),
          ),
        ),
      ),
    );
  }
}

class MobileFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Define the paint for the mobile frame
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    // Draw rounded rectangle for the mobile frame
    final borderRadius = Radius.circular(30);
    final Rect mobileRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect roundedRect = RRect.fromRectAndRadius(mobileRect, borderRadius);

    // Draw the frame
    canvas.drawRRect(roundedRect, paint);

    // Draw the screen area (inner rectangle)
    final screenRect = Rect.fromLTWH(10, 10, size.width - 20, size.height - 20);
    final RRect screenRoundedRect = RRect.fromRectAndRadius(screenRect, Radius.circular(20));
    
    // Fill the screen area with a light gray color to simulate a screen
    paint.color = Colors.grey.shade300;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(screenRoundedRect, paint);
    
    // Draw the bezel
    paint.color = Colors.blue;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3.0;
    canvas.drawRRect(roundedRect, paint); // Draw bezel again to make it prominent

    // Optional: Draw a notch at the top
    final notchPath = Path()
      ..moveTo(size.width / 2 - 30, 0)
      ..lineTo(size.width / 2 + 30, 0)
      ..lineTo(size.width / 2 + 15, 20)
      ..lineTo(size.width / 2 - 15, 20)
      ..close();

    paint.color = Colors.white; // Notch color
    canvas.drawPath(notchPath, paint);
    
    // Optionally, add camera cutout at the top center
    final cameraCutout = Rect.fromCircle(center: Offset(size.width / 2, 15), radius: 5);
    paint.color = Colors.black; // Camera cutout color
    canvas.drawArc(cameraCutout, 0, 2 * 3.14, true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
