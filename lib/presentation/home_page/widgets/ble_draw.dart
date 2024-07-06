import 'package:ble_test/presentation/home_page/widgets/map_position.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BleDraw extends StatelessWidget {
  dynamic x;
  dynamic y;
  int index;
  BleDraw(this.x, this.y, this.index);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: mapXCoordinate(x),
      top: mapYCoordinate(y),
      child: Container(
          child: Text(
        "B$index",
        style: TextStyle(color: Colors.red[900], fontSize: 10.sp),
      )),
    );
  }
}
