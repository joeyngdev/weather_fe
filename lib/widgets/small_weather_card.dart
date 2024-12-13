import 'package:flutter/material.dart';
import 'package:weather_forecast/model/weather.dart';

class SmallWeatherCard extends StatelessWidget {
  const SmallWeatherCard({super.key, this.weather});
  final Weather? weather;
  final TextStyle _style = const TextStyle(
    color: Colors.white,
    fontSize: 14,
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("(${weather?.date})",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          const SizedBox(
            height: 12,
          ),
          Image.network(
            weather?.conditionImgUrl != null
                ? weather!.conditionImgUrl
                : "//cdn.weatherapi.com/weather/64x64/day/113.png",
            width: 50,
            fit: BoxFit.cover,
            height: 50,
          ),
          const SizedBox(
            height: 12,
          ),
          Text("Temperate: ${weather?.avgTemp}°C", style: _style),
          const SizedBox(
            height: 12,
          ),
          Text("Wind: ${weather?.windSpeed} M/S", style: _style),
          const SizedBox(
            height: 12,
          ),
          Text("Humidity: ${weather?.humidity}%", style: _style),
        ],
      ),
    );
  }
}
