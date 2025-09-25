import 'package:flutter/material.dart';

class WeatherProvider extends ChangeNotifier {
  Future<void> getWeatherCurrent () async {
    print('getWeatherCurrent');
  }
}