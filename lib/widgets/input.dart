import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_forecast/api/api_caller.dart';
import 'package:weather_forecast/model/weather.dart';
import 'package:weather_forecast/riverpod/cityname_provider.dart';
import 'package:weather_forecast/riverpod/loading_provider.dart';
import 'package:weather_forecast/riverpod/weather_provider.dart';
import 'package:weather_forecast/util/data_transfer.dart';
import 'package:weather_forecast/util/location_finder.dart';
import 'package:weather_forecast/util/overlay_handler.dart';
import 'package:weather_forecast/util/temporary_saver.dart';
import 'package:weather_forecast/widgets/Button.dart';
import 'package:weather_forecast/widgets/content_divider.dart';
import 'package:weather_forecast/widgets/history_overlay.dart';
import 'package:weather_forecast/widgets/register_daily_forecast.dart';

class Input extends ConsumerStatefulWidget {
  const Input({super.key});

  @override
  ConsumerState<Input> createState() => _InputState();
}

class _InputState extends ConsumerState<Input> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _texteditingcontroller;
  var cityName = "";

  Future<void> withLoading(Future<void> Function() action) async {
    ref.read(loadingProvider.notifier).changeState();
    try {
      await action();
    } finally {
      ref.read(loadingProvider.notifier).changeState();
    }
  }

  void search() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref.read(cityNameProvider.notifier).state = cityName;
      withLoading(() async {
        var response = await ApiCaller.getWeather(cityName: cityName);
        if (response != null) {
          List<Weather> weathers = DataTransfer.transferWeatherJson(response);
          TemporarySaver.saveWeathers(weathers[0]);
          ref
              .read(weatherNotifierProvider.notifier)
              .changeCityWeather(weathers);
        }
      });
    }
  }

  void searchCurrentLocation({required String location}) async {
    withLoading(() async {
      var response = await ApiCaller.getWeather(cityName: location);
      if (response != null) {
        List<Weather> weathers = DataTransfer.transferWeatherJson(response);
        ref.read(cityNameProvider.notifier).state = weathers[0].cityName;
        TemporarySaver.saveWeathers(weathers[0]);
        ref.read(weatherNotifierProvider.notifier).changeCityWeather(weathers);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _texteditingcontroller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(cityNameProvider, (previous, next) {
      _texteditingcontroller.text = next;
    });
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Enter a City Name",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      IconButton(
                        iconSize: 30,
                        onPressed: () {
                          OverlayHandler()
                              .show(context, const HistoryOverlay());
                        },
                        icon: Icon(
                          Icons.history,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _texteditingcontroller,
                    validator: (value) {
                      return value != null && value.trim().isEmpty
                          ? "Enter a city name to search"
                          : null;
                    },
                    onSaved: (newValue) => cityName = newValue!,
                    style: TextStyle(
                        fontSize:
                            14 * MediaQuery.textScalerOf(context).scale(1)),
                    decoration: InputDecoration(
                      hintText: "Eg: New York, Tokyo, Seoul...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      contentPadding: const EdgeInsets.all(14),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]!),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 43, 243, 226),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Button(
                    title: "Search",
                    onPress: search,
                  ),
                  const SizedBox(height: 15),
                  const ContentDivider(title: "or"),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            Column(
              children: [
                Button(
                  onPress: () async {
                    searchCurrentLocation(
                        location: await LocationFinder.getLocation());
                  },
                  title: "Use current location",
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 15),
                const ContentDivider(
                    title: "Subscribe to daily weather forecast"),
                const SizedBox(height: 15),
                const RegisterDailyForecast(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
