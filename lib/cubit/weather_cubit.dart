// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:weather/data/weather_repository.dart';

import '../data/model/weather.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository _weatherRepository;
  WeatherCubit(this._weatherRepository) : super(const WeatherInitial());
  Future<void> getWeather() async {
   
    try {
      emit(const WeatherLoading());
      try{
         await _weatherRepository.checkPermission();
      }on Exception catch(e){
        emit(PermissionError())}
      await _weatherRepository.checkPermission();
      final weather = await _weatherRepository.fetchWeather();
      emit(WeatherLoaded(weather));
    } on Exception catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
}
