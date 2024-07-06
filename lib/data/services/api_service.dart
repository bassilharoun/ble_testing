import 'dart:convert';

import 'package:ble_test/data/models/position_response.dart';
import 'package:dio/dio.dart';

class ApiService {
  Future<PositionResponse?> sendBeaconData(
      List<Map<String, dynamic>> beaconData,
      String endPoint
      ) async {
    String apiUrl =
        "http://epadp.visionvalley.net:802/api/$endPoint";

    final Dio dio = Dio();

    // List<Map<String, dynamic>> requestBody = [
    //   for (var i = 0; i < beaconData.length; i++)
    //     {"UUID": beaconData[i]["UUID"], "Rssi": beaconData[i]["RSSI"]}
    // ];

    // "beacon1Uuid": beacon1Uuid,
    // "beacon1Rssi": beacon1Rssi,
    // "beacon2Uuid": beacon2Uuid,
    // "beacon2Rssi": beacon2Rssi,
    // "beacon3Uuid": beacon3Uuid,
    // "beacon3Rssi": beacon3Rssi

    try {
      print('Sending request to $apiUrl with body: $beaconData');

      Response response = await dio.post(apiUrl, data: jsonEncode(beaconData));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Response received: ${response.data}');
        // Assuming the API response body contains the position response JSON
        return PositionResponse.fromJson(response.data);
      } else {
        print('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }

    // return null;
  }
}
