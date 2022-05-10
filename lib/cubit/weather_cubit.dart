// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:weather/data/weather_repository.dart';

import '../data/model/weather.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository _weatherRepository;
  WeatherCubit(this._weatherRepository) : super(const WeatherInitial());
  Future<void> getWeather(double lat, double long) async {
    try {
      emit(const WeatherLoading());

      final weather = await _weatherRepository.fetchWeather(lat, long);
      emit(WeatherLoaded(weather));
    } on Exception {
      emit(const WeatherError('Network Error'));
    }
  }
}
