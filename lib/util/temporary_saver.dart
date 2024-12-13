import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_forecast/model/weather.dart';

class TemporarySaver {
  TemporarySaver._();
  static Future<void> saveWeathers(Weather weather) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(weather.toJson());
    List<Weather> transformWeather = await transformWeathers();
    if (!transformWeather.any((w) => w.cityName == weather.cityName)) {
      List<String> loadweathers = await loadWeathers();
      await prefs.setStringList('weathers', [...loadweathers, jsonString]);
    }
  }

  static Future<List<Weather>> transformWeathers() async {
    List<String> jsonStringList = await loadWeathers();
    List<Weather> weathers = [];
    for (final item in jsonStringList) {
      Map<String, dynamic> json = jsonDecode(item);
      weathers.add(Weather.fromJson(json, json));
    }
    return weathers;
  }

  static Future<List<String>> loadWeathers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonStringList = prefs.getStringList('weathers');

    if (jsonStringList == null) return [];
    return jsonStringList;
  }
}
