import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(
    MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: MyWeatherWidget(),
      ),
    ),
  );
}

class MyWeatherWidget extends StatefulWidget {
  const MyWeatherWidget({super.key});

  @override
  MyWeatherWidgetState createState() => MyWeatherWidgetState();
}

class MyWeatherWidgetState extends State<MyWeatherWidget> {
  final TextEditingController _cityController = TextEditingController();
  String _weatherDescription = 'Scattered Clouds';
  String _temperature = '20 °';
  String _cityName = 'Kathmandu';
  String _minTemp = '18 °';
  String _maxTemp = '25 °';
  String _errorMessage = '';

  Future<void> _fetchWeather() async {
    const apiKey = '317d2888896332e5bfb7591fff3bd6c6';
    final city = _cityController.text.trim();

    if (city.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a city name';
        _weatherDescription = '';
        _temperature = '';
        _cityName = '';
        _minTemp = '';
        _maxTemp = '';
      });
      return;
    }

    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _cityName = data['name'];
          _weatherDescription = data['weather'][0]['description'];
          _temperature = '${data['main']['temp'].round()} °';
          _minTemp = '${data['main']['temp_min'].round()} °';
          _maxTemp = '${data['main']['temp_max'].round()} °';
          _errorMessage = '';
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch weather data';
          _weatherDescription = '';
          _temperature = '';
          _cityName = '';
          _minTemp = '';
          _maxTemp = '';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _weatherDescription = '';
        _temperature = '';
        _cityName = '';
        _minTemp = '';
        _maxTemp = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4A90E2), Color(0xFF6A1B9A)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  hintText: 'Search city...',
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                onSubmitted: (_) => _fetchWeather(),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_errorMessage.isNotEmpty)
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    if (_cityName.isNotEmpty)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _cityName,
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          const Icon(Icons.cloud, size: 64, color: Colors.white),
                          Text(
                            _temperature,
                            style: const TextStyle(
                              fontSize: 64,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$_minTemp  $_maxTemp',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            _weatherDescription,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildForecastDay('Sun', '20/18', Icons.cloud),
                  _buildForecastDay('Mon', '22/16', Icons.cloud),
                  _buildForecastDay('Tue', '20/15', Icons.cloud),
                  _buildForecastDay('Wed', '21/17', Icons.cloud),
                  _buildForecastDay('Thu', '23/19', Icons.wb_sunny),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastDay(String day, String temp, IconData icon) {
    return Column(
      children: [
        Text(
          day,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8.0),
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8.0),
        Text(
          temp,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}