import 'package:ble_test/presentation/home_page/widgets/map_position.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HollowCircle extends StatelessWidget {
  dynamic x;
  dynamic y;
  Color color;
  HollowCircle(this.x, this.y, this.color);
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(x, y), // Change as needed
      painter: CirclesPainter(color),
    );
  }
}

class CirclesPainter extends CustomPainter {
  Color color;
  CirclesPainter(this.color);
  var textPainter = TextPainter(text: TextSpan());
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color // Circle color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;


    // Outer circle
    // double outerRadius = size.width / 2 - paint.strokeWidth / 2;
    canvas.drawCircle(Offset(0, 0), mapXCoordinate(3) * 0.5, paint);

    // Middle circle
    // double middleRadius = outerRadius * 0.6;
    canvas.drawCircle(Offset(0, 0), mapXCoordinate(2) * 0.5, paint);

    // Inner circle
    // double innerRadius = middleRadius * 0.6;
    canvas.drawCircle(Offset(0, 0), mapXCoordinate(1) * 0.5, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
