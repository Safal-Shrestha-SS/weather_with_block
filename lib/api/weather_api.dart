import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:open_settings/open_settings.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/model/weather.dart';
import 'package:geolocator/geolocator.dart';

class WeatherAPI {
  final dio = Dio();
  Future<Weather> getWeather(double lat, double long) async {
    try {
      final weather = await dio.get(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&units=metric&appid=bcdf3cc9e06b6bd2f50a0712ed96e440');
      final weatherModel = Weather.fromJson(weather.data);
      return weatherModel;
    } on Exception {
      throw Exception('Network Error');
    }
  }
}

class GeoLocationService {
  Future<void> checkPermissions() async {
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus.isEnabled;
    if (!isGpsOn) {
      throw Exception(
          'Turn on location services before requesting permission.');
    }

    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      return;
    } else if (status == PermissionStatus.denied) {
      throw Exception('Permission denied.');
    } else if (status == PermissionStatus.permanentlyDenied) {
      throw Exception();
      await openAppSettings();
    }
    return;
  }

  Future<void> connectionStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return;
    } else if (connectivityResult == ConnectivityResult.none) {
      await OpenSettings.openWIFISetting()
          .timeout(const Duration(milliseconds: 10000), onTimeout: () async {
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.wifi) {
          return;
        }
        throw Exception("You didn't turn on your network.Try again");
      });
      return;
    }
  }

  Future<Position> getLocation() async {
    await connectionStatus();
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
