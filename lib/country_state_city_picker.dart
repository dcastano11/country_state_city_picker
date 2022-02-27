library country_state_city_picker_nona;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
//import 'package:html_unescape/html_unescape_small.dart';

import 'model/select_status_model.dart' as StatusModel;
import 'package:http/http.dart' as http;

class SelectState extends StatefulWidget {
  final String baseUrl;
  final String api;
  final ValueChanged<String> onCountryChanged;
  final ValueChanged<String> onStateChanged;
  final ValueChanged<String> onCityChanged;
  final VoidCallback? onCountryTap;
  final VoidCallback? onStateTap;
  final VoidCallback? onCityTap;
  final TextStyle? style;
  final TextStyle? labelTextStyle;
  final double? titleSpacing;
  final Color? dropdownColor;
  final InputDecoration decoration;
  final double spacing;
  final bool withEmoji;
  final String accessToken;

  const SelectState(
      {Key? key,
      required this.onCountryChanged,
      required this.onStateChanged,
      required this.onCityChanged,
      this.decoration =
          const InputDecoration(contentPadding: EdgeInsets.all(0.0)),
      this.spacing = 0.0,
      this.style,
      this.dropdownColor,
      this.onCountryTap,
      this.onStateTap,
      this.onCityTap,
      this.labelTextStyle,
      this.titleSpacing,
      this.withEmoji = false,
      required this.baseUrl,
      required this.api,
      required this.accessToken})
      : super(key: key);

  @override
  _SelectStateState createState() => _SelectStateState();
}

class _SelectStateState extends State<SelectState> {
  List<String> _cities = ["Escoge una ciudad"];
  List<String> _country = ["Escoge un país"];
  String _selectedCity = "Escoge una ciudad";
  String _selectedCountry = "Escoge un país";
  String _selectedState = "Escoge una región";
  List<String> _states = ["Escoge una región"];
  var responses;

  @override
  void initState() {
    getCounty();
    super.initState();
  }

  Future getResponse() async {
    var res = await rootBundle.loadString(
        'packages/country_state_city_picker/lib/assets/country.json');
    return jsonDecode(res);
  }

  Future getResponse2(/* String baseUrl, String api */) async {
    var res = await getAll();
    return jsonDecode(res.body);
  }

  Future<http.Response> getAll() {
    String auth = "Bearer ${widget.accessToken}";

    var headers2 = {
      HttpHeaders.authorizationHeader: auth,
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    return http.get(Uri.https(widget.baseUrl, widget.api), headers: headers2);
  }

  Future getCounty() async {
    var countryres = await getResponse2() as List;
    countryres.forEach((data) {
      /*  var model = StatusModel.StatusModel();
      model.name = data['name'];
      model.emoji = data['emoji']; */
      if (!mounted) return;
      setState(() {
        var a = HtmlUnescape().convert(data["country"]!);
        //var a=parseFragment(data["country"]!).toString();
        _country
            .add(/* widget.withEmoji ? model.emoji ?? "" + "    " : "" +  */ a);
      });
    });

    return _country;
  }

  Future getState() async {
    var response = await getResponse2() as List;
    var takestate = response
        .map((map) => StatusModel.ModelAllLocation.fromJson(map))
        .where((item) =>
            (/* (widget.withEmoji ? item.emoji + "    " : "") + */ HtmlUnescape()
                    .convert(item.country) ==
                _selectedCountry))
        .map((item) => item.region)
        .toList();
    var states = takestate;
    states.forEach((f) {
      if (!mounted) return;
      setState(() {
        var name = f.map((item) => item.region).toList();
        for (var statename in name) {
          print(statename.toString());

          _states.add(HtmlUnescape().convert(statename.toString()));
        }
      });
    });

    return _states;
  }

  Future getCity() async {
    var response = await getResponse2() as List;
    var takestate = response
        .map((map) => StatusModel.ModelAllLocation.fromJson(map))
        .where((item) =>
            (/* (widget.withEmoji ? item.emoji + "    " : "") + */ HtmlUnescape()
                    .convert(item.country) ==
                _selectedCountry))
        .map((item) => item.region)
        .toList();
    var states = takestate;
    states.forEach((f) {
      var name = f.where(
          (item) => HtmlUnescape().convert(item.region) == _selectedState);
      var cityname = name.map((item) => item.city).toList();
      cityname.forEach((ci) {
        if (!mounted) return;
        setState(() {
          var citiesname = ci.map((item) => item.city).toList();
          for (var citynames in citiesname) {
            print(citynames.toString());

            _cities.add(HtmlUnescape().convert(citynames.toString()));
          }
        });
      });
    });
    return _cities;
  }

  void _onSelectedCountry(String value) {
    if (!mounted) return;
    setState(() {
      _selectedState = "Escoge una región";
      _states = ["Escoge una región"];
      _selectedCountry = value;
      this.widget.onCountryChanged(value);
      getState();
    });
  }

  void _onSelectedState(String value) {
    if (!mounted) return;
    setState(() {
      _selectedCity = "Escoge una ciudad";
      _cities = ["Escoge una ciudad"];
      _selectedState = value;
      this.widget.onStateChanged(value);
      getCity();
    });
  }

  void _onSelectedCity(String value) {
    if (!mounted) return;
    setState(() {
      _selectedCity = value;
      this.widget.onCityChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            Text(
              "País",
              style: widget.labelTextStyle,
            ),
          ],
        ),
        SizedBox(
          height: widget.titleSpacing,
        ),
        InputDecorator(
          decoration: widget.decoration,
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
            dropdownColor: widget.dropdownColor,
            isExpanded: true,
            items: _country.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        dropDownStringItem,
                        style: widget.style,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
            // onTap: ,
            onChanged: (value) => _onSelectedCountry(value!),
            onTap: widget.onCountryTap,
            // onChanged: (value) => _onSelectedCountry(value!),
            value: _selectedCountry,
          )),
        ),
        SizedBox(
          height: widget.spacing,
        ),
        Row(
          children: [
            Text(
              "Región",
              style: widget.labelTextStyle,
            ),
          ],
        ),
        SizedBox(
          height: widget.titleSpacing,
        ),
        InputDecorator(
          decoration: widget.decoration,
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
            dropdownColor: widget.dropdownColor,
            isExpanded: true,
            items: _states.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        dropDownStringItem,
                        style: widget.style,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) => _onSelectedState(value!),
            onTap: widget.onStateTap,
            value: _selectedState,
          )),
        ),
        SizedBox(
          height: widget.spacing,
        ),
        Row(
          children: [
            Text(
              "Ciudad",
              style: widget.labelTextStyle,
            ),
          ],
        ),
        SizedBox(
          height: widget.titleSpacing,
        ),
        InputDecorator(
          decoration: widget.decoration,
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
            dropdownColor: widget.dropdownColor,
            isExpanded: true,
            items: _cities.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        dropDownStringItem,
                        style: widget.style,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) => _onSelectedCity(value!),
            onTap: widget.onCityTap,
            value: _selectedCity,
          )),
        ),
      ],
    );
  }
}
