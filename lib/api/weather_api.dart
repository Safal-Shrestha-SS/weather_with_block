import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../data/model/weather.dart';

class WeatherAPI {
  final dio = Dio();
  Future<Weather> getWeather(double lat, double long) async {
    final weather = await dio.get(
        'https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139.5&appid=bcdf3cc9e06b6bd2f50a0712ed96e440');
    // final jsonResponse = jsonDecode(weather.data);
    // print(jsonResponse);
    final weatherModel = Weather.fromJson(weather.data);
    // final m = jsonResponse.map<Weather>((json) => Weather.fromJson(json));
    return weatherModel;
  }
}
