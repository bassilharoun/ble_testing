import 'package:ble_test/data/models/position_response.dart';
import 'package:ble_test/presentation/home_page/widgets/map_position.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultScreen extends StatelessWidget {
  PositionResponse responseTm;
  PositionResponse responseLs5;
  PositionResponse responseLsAll;
  List<String> nearby3BeaconsStrings;
  ResultScreen(this.responseTm,this.responseLs5,this.responseLsAll, this.nearby3BeaconsStrings);

  @override
  Widget build(BuildContext context) {
    String contentTm =
        'Building ID: ${responseTm.buildingId}, Level ID: ${responseTm.levelId} \nX: ${responseTm.x} \nY: ${responseTm.y}';

    String contentLs5 =
        'Building ID: ${responseLs5.buildingId}, Level ID: ${responseLs5.levelId} \nX: ${responseLs5.x} \nY: ${responseLs5.y}';

    String contentLsAll =
        'Building ID: ${responseLsAll.buildingId}, Level ID: ${responseLsAll.levelId} \nX: ${responseLsAll.x} \nY: ${responseLsAll.y}';

    return Scaffold(
      appBar: AppBar(
        title: Text("Position Response"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(child: Column(
              children: [
                Text("T Method", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                Text(contentTm, style: TextStyle(color: Colors.blue),),
              ],
            )),
            Card(
              child: Column(
                children: [
                                  Text("LS-5 Method", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),

                  Text(contentLs5, style: TextStyle(color: Colors.red),),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                                  Text("LS-All Method", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),

                  Text(contentLsAll, style: TextStyle(color: Colors.green),),
                ],
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            // if ((response.x < 3 && response.x > 0))
            //   Stack(
            //     children: [
            //       MapScreen(3, response.y),
            //     ],
            //   ),
            // else if (response.x > 7.10 && response.x < 10.1)
            //   MapScreen(7.10, response.y)
            // else if (response.y < 3 && response.y > 0)
            //   MapScreen(response.x, 3)
            // else if (response.y > 4.15 && response.y < 7.15)
            //   MapScreen(response.x, 4.15)
            // else
            MapScreen(responseTm.x, responseTm.y, responseLs5.x, responseLs5.y, responseLsAll.x, responseLsAll.y),
            SizedBox(height: 15,),
            Card(child: Column(
              children: [
                                Text("nearby 3 Beacons", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),

                Text("${nearby3BeaconsStrings}"),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
