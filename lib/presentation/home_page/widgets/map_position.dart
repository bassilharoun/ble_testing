import 'package:ble_test/presentation/home_page/widgets/ble_draw.dart';
import 'package:ble_test/presentation/home_page/widgets/hollow_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapScreen extends StatelessWidget {
  dynamic xTm; // Example X coordinate from API
  dynamic yTm; // Example Y coordinate from API
  dynamic xLs5; // Example Y coordinate from API
  dynamic yLs5; // Example Y coordinate from API
  dynamic xLsAll; // Example Y coordinate from API
  dynamic yLsAll; // Example Y coordinate from API
  MapScreen(this.xTm,this.yTm,this.xLs5, this.yLs5,this.xLsAll, this.yLsAll);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                // width: containerWidth,
                // height: containerHeight,
                child: Stack(
                  children: [
                    Container(
                      width: (11.10 * 20.w) + 15.w,
                      height: (7.40 * 20.w) + 10.w,
                      color: Colors.grey[400],
                      child: Image.asset(
                          "assets/images/background_saudi_office.png"),
                    ),
                    Positioned(
                      left: mapXCoordinate(xTm),
                      top: mapYCoordinate(yTm),
                      child: Container(
                        // width: 30.w,
                        // height: 30.h,

                        child: Stack(
                          children: [
                            HollowCircle(mapXCoordinate(3), mapYCoordinate(3), Colors.blue),
                            // HollowCircle(_mapXCoordinate(2), _mapYCoordinate(2)),
                            // HollowCircle(_mapXCoordinate(1), _mapYCoordinate(1)),
                          ],
                        ), // Ensure visibility
                      ),
                    ),
                    Positioned(
                      left: mapXCoordinate(xLs5),
                      top: mapYCoordinate(yLs5),
                      child: Container(
                        // width: 30.w,
                        // height: 30.h,

                        child: Stack(
                          children: [
                            HollowCircle(mapXCoordinate(3), mapYCoordinate(3), Colors.red),
                            // HollowCircle(_mapXCoordinate(2), _mapYCoordinate(2)),
                            // HollowCircle(_mapXCoordinate(1), _mapYCoordinate(1)),
                          ],
                        ), // Ensure visibility
                      ),
                    ),
                    Positioned(
                      left: mapXCoordinate(xLsAll),
                      top: mapYCoordinate(yLsAll),
                      child: Container(
                        // width: 30.w,
                        // height: 30.h,

                        child: Stack(
                          children: [
                            HollowCircle(mapXCoordinate(3), mapYCoordinate(3), Colors.green),
                            // HollowCircle(_mapXCoordinate(2), _mapYCoordinate(2)),
                            // HollowCircle(_mapXCoordinate(1), _mapYCoordinate(1)),
                          ],
                        ), // Ensure visibility
                      ),
                    ),
                  ],
                ),
              ),
              BleDraw(11, 0, 1),
              BleDraw(11, 3, 2),
              BleDraw(11, 7, 3),
              BleDraw(6, 7, 4),
              BleDraw(0, 7, 5),
              BleDraw(0, 3, 6),
              BleDraw(5, 0, 7),
              BleDraw(6, 3, 8),
            ],
          );
        },
      ),
    );
  }

  // Convert user coordinates to image coordinates
}

dynamic mapXCoordinate(dynamic x) {
  return x * 20.w;
}

dynamic mapYCoordinate(dynamic y) {
  return y * 20.w;
}
