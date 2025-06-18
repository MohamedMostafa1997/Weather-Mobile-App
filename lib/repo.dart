import 'package:http/http.dart';
import 'dart:convert';

class WeatherData {
  String city;
  double? temperature;
  String? weatherCondition;
  int? humidity;
  double? windSpeed;
  String? flag;

  WeatherData({required this.city, this.flag});

  Future<void> fetchWeatherData() async {
    try {
      Response response = await get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=a565be5616bb7fa5f5a09c47167f0a36&units=metric",
        ),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to load weather data: ${response.statusCode}");
      }

      Map data = jsonDecode(response.body);

      temperature = data['main']['temp'];
      weatherCondition = data['weather'][0]['main'];
      humidity = data['main']['humidity'];
      windSpeed = data['wind']['speed'];
    } on Exception catch (e) {
      throw Exception(" Network or Parsing Error : $e");
    }
  }
}
