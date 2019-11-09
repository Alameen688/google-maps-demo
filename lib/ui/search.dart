import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maps_devfest/services/google_maps_service.dart';
import 'package:maps_devfest/ui/common/search_input.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  GoogleMapsService _mapsService = GoogleMapsService();
  TextEditingController _destinationField;
  Timer _debounce;
  Duration _debounceTime = const Duration(milliseconds: 500);
  List _suggestions = [];

  @override
  void initState() {
    super.initState();
    _destinationField = TextEditingController()..addListener(_suggestPlaces);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              child: SearchInput(
                initialText: 'Destination',
                textController: _destinationField,
              ),
            ),
            Flexible(
                child: ListView.builder(
              itemCount: _suggestions.length,
              itemBuilder: (BuildContext context, int index) {
                final suggestedPlace = _suggestions[index];
                debugPrint(index.toString());
                debugPrint(suggestedPlace.toString());
                return ListTile(
                  title: Text('${suggestedPlace['structured_formatting']['main_text']}'),
                  subtitle: Text('${suggestedPlace['structured_formatting']['secondary_text']}'),
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  _suggestPlaces() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(_debounceTime, () async {
      if (_destinationField.text.isNotEmpty) {
        List autoCompleteResults =
            await _mapsService.autocomplete(_destinationField.text);
        setState(() {
          _suggestions = autoCompleteResults;
        });
      }
      ;
    });
  }

  @override
  void dispose() {
    _destinationField.removeListener(_suggestPlaces);
    _destinationField.dispose();
    super.dispose();
  }
}
