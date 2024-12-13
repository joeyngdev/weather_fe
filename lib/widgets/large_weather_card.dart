import 'package:flutter/material.dart';
import 'package:weather_forecast/model/weather.dart';

class LargeWeatherCard extends StatelessWidget {
  const LargeWeatherCard({super.key, required this.weather});
  final Weather? weather;
  final TextStyle _style = const TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${weather?.cityName} (${weather?.date})",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600)),
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
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Image.network(
                weather?.conditionImgUrl != null
                    ? weather!.conditionImgUrl
                    : "//cdn.weatherapi.com/weather/64x64/day/113.png",
                width: 100,
                fit: BoxFit.cover,
                height: 60,
              ),
              Text(
                weather?.conditionText != null ? weather!.conditionText : "",
                style: _style,
              )
            ],
          ),
        ),
      ],
    );
  }
}
