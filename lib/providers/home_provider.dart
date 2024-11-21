import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:whether_forecast/api/weather_apis.dart';
import 'package:whether_forecast/constents/app_text.dart';
import 'package:whether_forecast/helpers/enum.dart';
import 'package:whether_forecast/models/forecast_model.dart';
import 'package:whether_forecast/models/weather_model_map.dart';
import 'package:whether_forecast/services/location_service.dart';

class HomeProvider extends ChangeNotifier {
  Position? position;
  WhetherModel? weatherModelMap;
  ForecastModel? forecastModel;
  ApiResponceType homePageResponce = ApiResponceType.loading;
  TextEditingController searchCtr = TextEditingController();
  bool firstTap = false;

  getHomeData({bool isSearching = false}) async {
    try {
      if (homePageResponce != ApiResponceType.data || isSearching) {
        homePageResponce = ApiResponceType.loading;
        notifyListeners();
      }
      if (position == null) {
        position = await LocationService.determinePosition();
        notifyListeners();
      }

      if (position != null || searchCtr.text.isNotEmpty) {
        await getWheatherUpdate(location: searchCtr.text);
        await getForecastUpdate(location: searchCtr.text);
      }
    } catch (e) {
      homePageResponce = ApiResponceType.internalException;
      notifyListeners();
    }
  }

  Future<void> getWheatherUpdate({String? location}) async {
    final response = await WeatherApis.getWheatherApi(
        position: position, location: location);
    homePageResponce = response.type;
    if (homePageResponce == ApiResponceType.data) {
      weatherModelMap = WhetherModel.fromJson(response.data!);
      searchCtr.text = weatherModelMap?.location?.name ?? 'Unknown';
    }
    notifyListeners();
  }

  Future<void> getForecastUpdate({String? location}) async {

    final response =
        await WeatherApis.getFiveDaysForecastDataApi(location: location);
    if (response.type == ApiResponceType.data) {
      forecastModel = ForecastModel.fromJson(response.data!);
    }
    notifyListeners();
  }

// for alert the user when the unexpected poping from app
  Future<bool> ctrUserBackScreen() async {
    if (firstTap) {
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
      return true;
    } else {
      firstTap = true;

      Fluttertoast.showToast(msg: AppText.exit);
      Timer(
        const Duration(seconds: 2),
        () {
          firstTap = false;
        },
      );
      notifyListeners();
    }
    return false;
  }
}
