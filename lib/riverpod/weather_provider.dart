import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_forecast/model/weather.dart';

class WeatherNotifier extends StateNotifier<List<Weather>> {
  WeatherNotifier() : super([]);

  void changeCityWeather(List<Weather> weathers) {
    state = weathers;
  }
}

final weatherNotifierProvider =
    StateNotifierProvider<WeatherNotifier, List<Weather>>(
        (ref) => WeatherNotifier());
