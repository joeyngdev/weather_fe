import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_forecast/firebase_options.dart';
import 'package:weather_forecast/riverpod/weather_provider.dart';
import 'package:weather_forecast/widgets/fallback.dart';
import 'package:weather_forecast/widgets/input.dart';
import 'package:weather_forecast/widgets/output.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Weather Dashboard'),
      scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown
      }),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          title,
          style: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.blue[50],
        width: double.infinity,
        child: Row(
          children: [
            const Input(),
            Consumer(builder: (context, ref, _) {
              var weatherItems = ref.watch(weatherNotifierProvider).length;
              return weatherItems == 0
                  ? const Expanded(
                      flex: 7,
                      child: Fallback(
                        title:
                            "Please enter the city name and click Search to show the weather forecast",
                      ))
                  : const Output();
            })
          ],
        ),
      ),
    );
  }
}
