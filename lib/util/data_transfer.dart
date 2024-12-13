import 'dart:convert';

import 'package:weather_forecast/model/weather.dart';
import 'package:http/http.dart' as http;

class DataTransfer {
  DataTransfer._();
  static List<Weather> transferWeatherJson(http.Response response) {
    Map<String, dynamic> decodedData = json.decode(response.body);
    var location = decodedData['location'];
    List<dynamic> forecastDays = decodedData['forecast']['forecastday'];
    List<Weather> weathers = [];
    for (final day in forecastDays) {
      weathers.add(Weather.fromJson(location, day));
    }
    return weathers;
  }
}
