import 'package:geolocator/geolocator.dart';
import 'package:weather/api/weather_api.dart';

import 'model/weather.dart';

abstract class WeatherRepository {
  Future<Weather> fetchWeather();
  Future<void> checkPermission();
  Future<void> checkLocationService();
  Future<void> checkNetwork();
}

class RealWeatherRepository implements WeatherRepository {
  final WeatherAPI w = WeatherAPI();
  final GeoLocationService geo = GeoLocationService();
  @override
  Future<Weather> fetchWeather() async {
    Position position = await geo.getLocation();
    final val = await w.getWeather(position.latitude, position.longitude);
    return val;
  }

  @override
  Future<void> checkPermission() async {
    await geo.checkPermissions();
  }

  @override
  Future<void> checkLocationService() async {
    await geo.checkLocationService();
  }

  @override
  Future<void> checkNetwork() async {
    await geo.connectionStatus();
  }
}
