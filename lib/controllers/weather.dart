import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/appstate.dart';
import '../configuration/configuration.dart';
import '../models/weather.dart';

class WeatherController with ChangeNotifier {
  var cityController = TextEditingController(text: '');
  AppState _state = AppState.Idle;
  AppState get state => _state;
  void setState(AppState appState) {
    _state = appState;
    notifyListeners();
  }

  Weather _weatherModel = new Weather();
  Weather get weather => _weatherModel;

  String getDay(int day) {
    String today = "";
    switch (day) {
      case 1:
        today = "Monday";
        break;
      case 2:
        today = "Tuesday";
        break;
      case 3:
        today = "Wednesday";
        break;
      case 4:
        today = "Thrusday";
        break;
      case 5:
        today = "Friday";
        break;
      case 6:
        today = "Saturday";
        break;
      case 7:
        today = "Sunday";
        break;

      default:
    }
    return today;
  }

  String getMonth(int month) {
    String today = "";
    switch (month) {
      case 1:
        today = "January";
        break;
      case 2:
        today = "February";
        break;
      case 3:
        today = "March";
        break;
      case 4:
        today = "April";
        break;
      case 5:
        today = "May";
        break;
      case 6:
        today = "June";
        break;
      case 7:
        today = "July";
        break;
      case 8:
        today = "August";
        break;
      case 9:
        today = "September";
        break;
      case 10:
        today = "October";
        break;
      case 11:
        today = "November";
        break;
      case 12:
        today = "December";
        break;

      default:
    }
    return today;
  }

  Future<Weather> getWeather({String city = "Kolkata"}) async {
    setState(AppState.Busy);
    try {
      _weatherModel = new Weather();
      var response = await http.get(Configuration.apiurl + "&query=$city");
      if (response.statusCode == 200) {
        _weatherModel = Weather.fromJson(json.decode(response.body));
        cityController.text = "";
      }
    } catch (e) {
      setState(AppState.Idle);
    }
    setState(AppState.Idle);
    return _weatherModel;
  }
}
