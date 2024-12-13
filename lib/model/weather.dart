class Weather {
  const Weather(
      {required this.maxTemp,
      required this.avgTemp,
      required this.chanceOfRain,
      required this.chanceOfSnow,
      required this.conditionImgUrl,
      required this.conditionText,
      required this.humidity,
      required this.minTemp,
      required this.cityName,
      required this.date,
      required this.windSpeed});

  final double maxTemp, minTemp, avgTemp, windSpeed;
  final int humidity, chanceOfRain, chanceOfSnow;
  final String conditionText, conditionImgUrl, cityName, date;

  factory Weather.fromJson(
      Map<String, dynamic> location, Map<String, dynamic> forecast) {
    return Weather(
      cityName: location['name'] as String,
      date: forecast['date'] as String,
      maxTemp: forecast['day']['maxtemp_c'] as double,
      avgTemp: forecast['day']['avgtemp_c'] as double,
      chanceOfRain: forecast['day']['daily_chance_of_rain'] as int,
      chanceOfSnow: forecast['day']['daily_chance_of_snow'] as int,
      conditionImgUrl: forecast['day']['condition']['icon'] as String,
      conditionText: forecast['day']['condition']['text'] as String,
      humidity: forecast['day']['avghumidity'] as int,
      minTemp: forecast['day']['mintemp_c'] as double,
      windSpeed: forecast['day']['maxwind_mph'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'date': date,
      'day': {
        'maxtemp_c': maxTemp,
        'avgtemp_c': avgTemp,
        'daily_chance_of_rain': chanceOfRain,
        'daily_chance_of_snow': chanceOfSnow,
        'condition': {'icon': conditionImgUrl, 'text': conditionText},
        'avghumidity': humidity,
        'mintemp_c': minTemp,
        'maxwind_mph': windSpeed
      }
    };
  }

  @override
  String toString() {
    return '''
    City name: $cityName
    Date: $date
    Temperature: $avgTemp - Himidity: $humidity - Wind speed: $windSpeed
    Condition: $conditionText - Change of rain: $chanceOfRain - Change of snow: $chanceOfSnow

    ''';
  }
}
