import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:whether_forecast/constents/api_urls.dart';
import 'package:whether_forecast/constents/keys.dart';
import 'package:whether_forecast/helpers/enum.dart';
import 'package:whether_forecast/services/dio_services.dart';

class WeatherApis {
  static Future<ApiResponce> getWheatherApi(
      {Position? position, String? location}) async {
    final response = await ApiService.callApi(
        method: ApiMethod.post,
        url: ApiUrls.currentUrl,
        queryParameters: {
          "key": AppKeys.weatherApiKey,
          "q": location != ''
              ? location
              : "${position?.latitude},${position?.longitude}"
        });

    return response;
  }

  static Future<ApiResponce> getForecastApi(
      {required Position position}) async {
    final response = await ApiService.callApi(
        method: ApiMethod.post,
        url: ApiUrls.forecastUrl,
        queryParameters: {
          "key": AppKeys.weatherApiKey,
          "q": "${position.latitude},${position.longitude}",
          "days": '5'
        });

    log("forecast : ${response.data.toString()}");

    return response;
  }

  // free plan of weatherapi not gives more than 3 days forecast data,so we have to use below api for 5 days forecast data.
  static Future<ApiResponce> getFiveDaysForecastDataApi(
      {String? location}) async {
    final response = await ApiService.callApi(
        method: ApiMethod.post,
        url: ApiUrls.fiveDayForecastUrl,
        queryParameters: {
          "key": AppKeys.fiveDayForecastApiKey,
          'city': location,
          "days": '5'
        });

    return response;
  }
}
