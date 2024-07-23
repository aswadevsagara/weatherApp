import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _controller = TextEditingController();
  String _weather = '';
  final String _apiKey = 'f839bd60d037ad77d299ac3f71552a5b'; 

  Future<void> _fetchWeather() async {
    final city = _controller.text;
    if (city.isEmpty) return;

    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _weather = 'Temperature: ${data['main']['temp']}°C\nDescription: ${data['weather'][0]['description']}';
      });
    } else {
      setState(() {
        _weather = 'No data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                decoration:const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter city',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchWeather,
                child: Text('Get Weather'),
              ),
              SizedBox(height: 16),
              Text(
                _weather,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
