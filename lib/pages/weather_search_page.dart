import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Center(
      child: CityInputField(),
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildColumnWithData(Weather weather) {
    return const Center(
      child: Text('Good job'),
    );
  }
  // Column buildColumnWithData(Weather weather) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: <Widget>[
  //       Text(
  //         weather.cityName,
  //         style: const TextStyle(
  //           fontSize: 40,
  //           fontWeight: FontWeight.w700,
  //         ),
  //       ),
  //       Text(
  //         // Display the temperature with 1 decimal place
  //         "${weather.temperatureCelsius.toStringAsFixed(1)} °C",
  //         style: const TextStyle(fontSize: 80),
  //       ),
  //       const CityInputField(),
  //     ],
  //   );
  // }
}

class CityInputField extends StatelessWidget {
  CityInputField({Key? key}) : super(key: key);
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            controller: myController1,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: "Enter a latitude",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: myController2,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: "Enter a longitude",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red, // background
              onPrimary: Colors.white, // foreground
            ),
            onPressed: () {
              submitCityName(context, double.parse(myController1.text),
                  double.parse(myController2.text));
            },
            child: const Text('Get'),
          )
        ],
      ),
    );
  }

  void submitCityName(BuildContext context, double lat, double long) {
    final weatherCubit = context.read<WeatherCubit>();
    weatherCubit.getWeather(lat, long);
  }
}
