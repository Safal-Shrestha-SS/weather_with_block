class Weather {
  final double lat;
  final double long, temperatureCelcius;
  final String condition;
  Weather(
      {required this.lat,
      required this.long,
      required this.temperatureCelcius,
      required this.condition});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        lat: double.parse((json['coord']['lat']).toString()),
        long: double.parse((json['coord']['lon']).toString()),
        temperatureCelcius: (json['main']['temp']),
        condition: json['weather'][0]['main']);
  }
}
