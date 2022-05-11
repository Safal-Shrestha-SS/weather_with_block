import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_settings/open_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/cubit/weather_cubit.dart';

import '../data/model/weather.dart';

class WeatherSearchPage extends StatefulWidget {
  const WeatherSearchPage({Key? key}) : super(key: key);

  @override
  _WeatherSearchPageState createState() => _WeatherSearchPageState();
}

class _WeatherSearchPageState extends State<WeatherSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Search"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: BlocConsumer<WeatherCubit, WeatherState>(
            listener: (context, state) {
          if (state is WeatherError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errorMessage),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {},
              ),
            ));
          } else if (state is PermissionError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Go to App Permission'),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () async {
                  await openAppSettings();
                },
              ),
            ));
          } else if (state is LocationError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Go to location'),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () async {
                  await OpenSettings.openLocationSourceSetting();
                },
              ),
            ));
          } else if (state is NetworkError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('No network detected'),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () async {
                  await OpenSettings.openWIFISetting();
                },
              ),
            ));
          }
        }, builder: (context, state) {
          if (state is WeatherInitial) {
            return buildInitialInput();
          } else if (state is WeatherLoading) {
            return buildLoading();
          } else if (state is WeatherLoaded) {
            return buildColumnWithData(state.weather);
          } else {
            return buildInitialInput();
          }
        }),
      ),
    );
  }

  Widget buildInitialInput() {
    return const Center(
      child: CityInputField(),
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Column buildColumnWithData(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          weather.condition,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          // Display the temperature with 1 decimal place
          "${weather.temperatureCelcius.toStringAsFixed(1)} °C",
          style: const TextStyle(fontSize: 80),
        ),
        const CityInputField(),
      ],
    );
  }
}

class CityInputField extends StatelessWidget {
  const CityInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red, // background
          onPrimary: Colors.white, // foreground
        ),
        onPressed: () {
          submitCityName(context);
        },
        child: const Text('Get'),
      ),
    );
  }

  void submitCityName(BuildContext context) {
    final weatherCubit = context.read<WeatherCubit>();

    weatherCubit.getWeather();
  }
}
