import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';

class WeatherService {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  //get permission from user
  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

  //fetch the current location
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);


  //convert the location into a list of placemark objects
  List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);


  //extract city name from first placemark
  String? city = placemarks[0].locality;

  return city ?? "";
  }
}
