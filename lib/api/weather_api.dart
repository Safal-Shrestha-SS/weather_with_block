import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/model/weather.dart';
import 'package:geolocator/geolocator.dart';

class WeatherAPI {
  final dio = Dio();
  Future<Weather> getWeather(double lat, double long) async {
    try {
      final weather = await dio.get(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&units=metric&appid={api_key}');
      final weatherModel = Weather.fromJson(weather.data);
      return weatherModel;
    } on Exception {
      throw Exception('Network Error');
    }
  }
}

class GeoLocationService {
  Future<void> checkLocationService() async {
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus.isEnabled;
    if (!isGpsOn) {
      throw Exception(
          'Turn on location services before requesting permission.');
    }

    return;
  }

  Future<void> checkPermissions() async {
    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      return;
    } else if (status == PermissionStatus.denied) {
      throw Exception('Permission denied.');
    } else if (status == PermissionStatus.permanentlyDenied) {
      throw Exception();
      // await openAppSettings();
    }
  }

  Future<void> connectionStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return;
    } else if (connectivityResult == ConnectivityResult.none) {
      throw Exception("You didn't turn on your network.Try again");
    }
  }

  Future<Position> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.reduced,
      );
      return position;
    } on Exception {
      throw Exception("You aren't online");
    }
  }
}
