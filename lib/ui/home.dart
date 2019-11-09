import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_devfest/services/google_maps_service.dart';
import 'package:maps_devfest/ui/common/search_input.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // 2 ways to set controller
  // I prefer the non setstate way (for no particular reason)
  Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController _mapController2;
  LatLng _startPosition;
  LatLng _finalDestination;
  
  static final CameraPosition _initialCameraPosition =
      CameraPosition(target: LatLng(7.444132, 3.893878), zoom: 14.5);

  static final CameraPosition _newPosition = CameraPosition(
      // use location of a 3d kinda object, e.g Shoreline Lake, Mountain View, CA, USA to bring out bearing effect
      // target: LatLng(7.443008, 3.894733),
      target: LatLng(7.437252, 3.909374),
      bearing: 192.8334901395799,
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  TextEditingController pickupTextEditingController = TextEditingController();
  TextEditingController destTextEditingController = TextEditingController();

  // TODO: Use DI to provide lazy singleton instance of GeoLocator anywhere needed
  Geolocator geoLocator = Geolocator();
  GoogleMapsService _mapsService = GoogleMapsService();

  final Set<Polyline> _polyLines = Set();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: true,
            onMapCreated: _onMapCreated2,
            polylines: _polyLines,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  SearchInput(
                    initialText: 'Pick up',
                    textController: pickupTextEditingController,
                  ),
                  SearchInput(
                    initialText: 'Destination',
                    textController: destTextEditingController,
                    onSubmitted: getDirections,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _moveToLake,
        child: Icon(
          Icons.directions_boat,
          semanticLabel: 'To the lake',
        ),
      ),
    );
  }

  _onMapCreated(GoogleMapController mapController) {
    _mapController.complete(mapController);
  }

  _onMapCreated2(GoogleMapController mapController) {
    setState(() {
      _mapController2 = mapController;
    });
  }

  void _moveToLake() async {
    // GoogleMapController controller = await _mapController.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(_newPosition));
    _mapController2.animateCamera(CameraUpdate.newCameraPosition(_newPosition));
  }

  _getCurrentLocation() async {
    Position currentPosition = await geoLocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark =
        await geoLocator.placemarkFromPosition(currentPosition);
    pickupTextEditingController.text = placemark[0].name;
    debugPrint(placemark[0].toJson().toString());
    debugPrint(placemark[0].name);
    debugPrint(currentPosition.toJson().toString());
    List<Placemark> finalPlacemark =
        await geoLocator.placemarkFromCoordinates(7.444023, 3.868124);
    destTextEditingController.text = finalPlacemark[0].name;
    setState(() {
      _startPosition =
          LatLng(currentPosition.latitude, currentPosition.longitude);
      _finalDestination = LatLng(7.444023, 3.868124);
    });
  }

  getDirections(String destination) async {
    List<Placemark> placemark =
        await geoLocator.placemarkFromAddress(destination);
    debugPrint("Called get directions");
    final latitude = placemark[0].position.latitude;
    final longitude = placemark[0].position.longitude;
    LatLng destinationCoord = LatLng(latitude, longitude);
    String route = await _mapsService.getRouteCoordinates(
        _startPosition, destinationCoord);
    createRoute(route, destinationCoord);
  }

  createRoute(String encondedPolyLines, destinationCoord) {
    final polyline = Polyline(
        polylineId: PolylineId(destinationCoord.toString()),
        width: 10,
        points: _convertToLatLng(_decodePoly(encondedPolyLines)),
        color: Colors.black);
    setState(() {
      _polyLines.add(polyline);
    });
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  @override
  void dispose() {
    pickupTextEditingController.dispose();
    destTextEditingController.dispose();
    super.dispose();
  }
}
