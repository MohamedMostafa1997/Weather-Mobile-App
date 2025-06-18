import 'package:flutter/material.dart';
import 'package:world_weather_app/repo.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};

  WeatherData weatherData = WeatherData(city: 'Cairo');

  bool isLoading = true;
  String? errorMessage;

  void setupWeather() async {
    try {
      await weatherData.fetchWeatherData();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage =
            "Failed to load weather data. Please check your connection.";
      });
    }
  }

  @override
  void initState() {
    super.initState();

    setupWeather();
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map) {
        data = args;
      }
    }

    String date = DateFormat('EEEE, MMMM d').format(DateTime.now());
    String condition = weatherData.weatherCondition?.toLowerCase() ?? '';

    Color backgroundColor = Colors.blueGrey;

    if (condition.contains('cloud')) {
      backgroundColor = Colors.blueGrey.shade700;
    } else if (condition.contains('clear')) {
      backgroundColor = Colors.blue.shade400;
    } else if (condition.contains('rain')) {
      backgroundColor = Colors.indigo.shade900;
    } else if (condition.contains('snow')) {
      backgroundColor = Colors.lightBlue.shade100;
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.redAccent),
              SizedBox(height: 16),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });
                  setupWeather();
                },
                label: Text("Refresh"),
                icon: Icon(Icons.refresh),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [backgroundColor, Colors.black87],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      date,
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                    SizedBox(height: 4),
                    Text(
                      weatherData.city,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 32),
                    Icon(Icons.cloud, size: 100, color: Colors.white),
                    SizedBox(height: 8),
                    Text(
                      weatherData.weatherCondition!,
                      style: TextStyle(fontSize: 20, color: Colors.white70),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${weatherData.temperature?.round()}°',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 32),
                    Divider(color: Colors.white24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoWidget(
                          'Wind',
                          '${weatherData.windSpeed} m/s',
                        ),
                        _buildInfoWidget(
                          'Humidity',
                          '${weatherData.humidity} %',
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Divider(color: Colors.white24),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final results = await Navigator.pushNamed(
                          context,
                          '/cityselection',
                        );

                        if (results != null && results is Map) {
                          setState(() {
                            weatherData.city = results['city'];
                            weatherData.weatherCondition =
                                results['weatherCondition'];
                            weatherData.temperature = results['temperature'];
                            weatherData.humidity = results['humidity'];
                            weatherData.windSpeed = results['windSpeed'];
                          });
                        }
                      },
                      icon: Icon(Icons.edit_location),
                      label: Text("Change City"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

Widget _buildInfoWidget(String label, String value) {
  return Column(
    children: [
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
