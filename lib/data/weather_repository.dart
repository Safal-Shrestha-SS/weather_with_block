import 'package:weather/api/weather_api.dart';

import 'model/weather.dart';

abstract class WeatherRepository {
  Future<Weather> fetchWeather(double lat, double long);
}

class RealWeatherRepository implements WeatherRepository {
  final WeatherAPI w = WeatherAPI();
  @override
  Future<Weather> fetchWeather(double latitude, double longitude) async {
    final val = await w.getWeather(latitude, longitude);
    return val;
  }
}
