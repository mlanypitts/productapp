import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class WeatherInfo extends StatefulWidget {
  const WeatherInfo({Key? key}) : super(key: key);

  @override
  State<WeatherInfo> createState() => _WeatherInfoState();
}

class _WeatherInfoState extends State<WeatherInfo> {
  List<dynamic> weatherData = [];
  int weatherCode = 0;
  bool isLoaded = false;

  Future<void> getWeather() async {
    String request = 'https://api.open-meteo.com/v1/forecast?latitude=-20.23&longitude=57.49&daily=weathercode&forecast_days=1&timezone=auto';
    Response res = await get(
      Uri.parse(request),
    );
    if (res.statusCode == 200) {
      weatherCode = (jsonDecode(res.body)['daily']['weathercode'][0]);
    } else {
      throw Exception("Failed to load data");
    }
    return;
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(_afterLayoutInit);
  }

  Future<void> _afterLayoutInit(_) async {
    if (mounted) {
      await getWeather();
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    int time = int.parse(today.toString().substring(11, 13));
    return SizedBox(
        height: 50,
        width: 50,//To change
        child: isLoaded
          ? weatherCode <= 3
            ? time < 17
              ? Image.asset("assets/images/weather/sun.png")
              : Image.asset("assets/images/weather/clear.png")
            : weatherCode <= 48
              ? Image.asset("assets/images/weather/cloudy.png")
              : (weatherCode <= 67 || (weatherCode >= 80 && weatherCode <= 82))
                ? Image.asset("assets/images/weather/rain.png")
                : (weatherCode <= 77 || (weatherCode == 85 || weatherCode == 86))
                  ? Image.asset("assets/images/weather/snow.png")
                  : Image.asset("assets/images/weather/thunderstorm.png")
          : const CircularProgressIndicator()
    );
  }
}
