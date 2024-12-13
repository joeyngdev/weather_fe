import 'package:http/http.dart' as http;

class ApiCaller {
  ApiCaller._();
  static const String _apiKey = "c4468049dd0b47d5a6a54443241212",
      _endpoint = "https://api.weatherapi.com/v1";
  static Future<http.Response?> getWeather(
      {required String cityName, int day = 6}) async {
    var response = await http.get(
      Uri.parse("$_endpoint/forecast.json?key=$_apiKey&q=$cityName&days=$day"),
    );
    return response.statusCode == 200 ? response : null;
  }
}
