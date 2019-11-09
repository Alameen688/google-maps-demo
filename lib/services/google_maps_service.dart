import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' show Client, Response;
import 'dart:convert';

const apiKey = 'YOUR_API_KEY';

class GoogleMapsService {
  static const BASE_URL = 'https://maps.googleapis.com/maps/api';
  String placesSessionToken = '324354342'; //use random string
  final Client apiClient = Client();

  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String url =
        '$BASE_URL/directions&origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey';
    Response response = await apiClient.get(url);
    Map values = jsonDecode(response.body);
    return values['routes'][0]['overview_polyline']['points'];
  }

  Future<List> autocomplete(input) async {
    String url =
        '$BASE_URL/place/autocomplete/json?input=$input&sessiontoken=$placesSessionToken&key=$apiKey';
    List result = [];
    try {
      Response response = await apiClient.get(url);
      Map values = jsonDecode(response.body);
      // print(values);
      result = values['predictions'];
    } catch (e) {
      print(e);
    }
    return result;
  }
}
