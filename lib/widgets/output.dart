import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_forecast/api/api_caller.dart';
import 'package:weather_forecast/model/weather.dart';
import 'package:weather_forecast/riverpod/cityname_provider.dart';
import 'package:weather_forecast/riverpod/loading_provider.dart';
import 'package:weather_forecast/riverpod/weather_provider.dart';
import 'package:weather_forecast/util/data_transfer.dart';
import 'package:weather_forecast/widgets/base_weather_card.dart';
import 'package:weather_forecast/widgets/large_weather_card.dart';
import 'package:weather_forecast/widgets/small_weather_card.dart';

class Output extends ConsumerStatefulWidget {
  const Output({super.key});
  @override
  ConsumerState<Output> createState() => _OutputState();
}

class _OutputState extends ConsumerState<Output> {
  final ScrollController _scrollController = ScrollController();
  var numberOfItems = 6;
  String currentCityName = "";
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          loadMore();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void loadMore() async {
    bool isLoading = ref.watch(loadingProvider);
    if (!isLoading && mounted) {
      ref.read(loadingProvider.notifier).changeState();
      currentCityName = ref.read(cityNameProvider);
      numberOfItems++;
      var response = await ApiCaller.getWeather(
          cityName: currentCityName, day: numberOfItems);
      if (response != null) {
        ref
            .read(weatherNotifierProvider.notifier)
            .changeCityWeather(DataTransfer.transferWeatherJson(response));
      }
      ref.read(loadingProvider.notifier).changeState();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(cityNameProvider, (previous, next) {
      numberOfItems = 6;
    });
    List<Weather> weathers = ref.watch(weatherNotifierProvider);
    bool isLoading = ref.watch(loadingProvider);
    return Expanded(
      flex: 7,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseWeatherCard(
                    child: LargeWeatherCard(
                        weather: weathers.isNotEmpty ? weathers[0] : null),
                  ),
                  Text(
                    "${weathers.length - 1}-Day Forecast",
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 24),
                  ),
                  weathers.isNotEmpty
                      ? SizedBox(
                          height: 280,
                          child: ListView.builder(
                            controller: _scrollController,
                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.only(right: 24),
                              child: BaseWeatherCard(
                                  color: Colors.grey,
                                  child: SmallWeatherCard(
                                    weather: weathers[i + 1],
                                  )),
                            ),
                            itemCount: weathers.length - 1,
                            scrollDirection: Axis.horizontal,
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
    );
  }
}
