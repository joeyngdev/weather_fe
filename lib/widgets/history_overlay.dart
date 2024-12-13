import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_forecast/api/api_caller.dart';
import 'package:weather_forecast/model/weather.dart';
import 'package:weather_forecast/riverpod/cityname_provider.dart';
import 'package:weather_forecast/riverpod/loading_provider.dart';
import 'package:weather_forecast/riverpod/weather_provider.dart';
import 'package:weather_forecast/util/data_transfer.dart';
import 'package:weather_forecast/util/overlay_handler.dart';
import 'package:weather_forecast/util/temporary_saver.dart';
import 'package:weather_forecast/widgets/backdrop.dart';
import 'package:weather_forecast/widgets/base_weather_card.dart';
import 'package:weather_forecast/widgets/large_weather_card.dart';

class HistoryOverlay extends ConsumerStatefulWidget {
  const HistoryOverlay({super.key});

  @override
  ConsumerState<HistoryOverlay> createState() => _HistoryOverlayState();
}

class _HistoryOverlayState extends ConsumerState<HistoryOverlay> {
  List<Weather> temporaryWeathers = [];
  bool visibility = true;
  @override
  void initState() {
    super.initState();
    getTemporaryData();
  }

  void getTemporaryData() async {
    var data = await TemporarySaver.transformWeathers();
    setState(() {
      temporaryWeathers = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Backdrop(
      isVisibility: visibility,
      child: temporaryWeathers.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      "Recent search history",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, i) => BaseWeatherCard(
                          onPress: () async {
                            setState(() {
                              visibility = false;
                            });
                            ref.read(cityNameProvider.notifier).state =
                                temporaryWeathers[i].cityName;
                            ref.read(loadingProvider.notifier).changeState();
                            var response = await ApiCaller.getWeather(
                                cityName: temporaryWeathers[i].cityName);
                            if (response != null) {
                              List<Weather> weathers =
                                  DataTransfer.transferWeatherJson(response);
                              ref
                                  .read(weatherNotifierProvider.notifier)
                                  .changeCityWeather(weathers);
                            }
                            ref.read(loadingProvider.notifier).changeState();
                            OverlayHandler().hide();
                          },
                          child:
                              LargeWeatherCard(weather: temporaryWeathers[i])),
                      itemCount: temporaryWeathers.length,
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: Text(
                "Looks like you haven't searched yet. Let's start searching first",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            ),
    );
  }
}
