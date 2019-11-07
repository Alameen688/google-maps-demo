import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // 2 ways to set controller
  // I prefer the non setstate way
  Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController _mapController2;
  static final CameraPosition _initialPosition =
      CameraPosition(target: LatLng(7.444132, 3.893878), zoom: 14.5);

  static final CameraPosition _newPosition = CameraPosition(
      // use location of a 3d kinda object, e.g Shoreline Lake, Mountain View, CA, USA to bring out bearing effect
      // target: LatLng(7.443008, 3.894733),
      target: LatLng(7.437252, 3.909374),
      bearing: 192.8334901395799,
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: _initialPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: true,
            onMapCreated: _onMapCreated2,
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
                  ),
                  SearchInput(
                    initialText: 'Destination',
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
}

class SearchInput extends StatelessWidget {
  final String initialText;

  const SearchInput({Key key, @required this.initialText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 50,
            margin: const EdgeInsets.fromLTRB(12, 8, 8, 0),
            padding: EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Color.fromRGBO(13, 51, 32, 0.1),
                  offset: Offset(0.0, 6.0),
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: TextField(
              cursorColor: Color(0xFF5B616F),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText: initialText),
            ),
          ),
        )
      ],
    );
  }
}
