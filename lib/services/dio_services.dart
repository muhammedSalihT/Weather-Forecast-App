import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whether_forecast/constents/api_urls.dart';
import 'package:whether_forecast/constents/app_text.dart';
import 'package:whether_forecast/helpers/enum.dart';

class ApiResponce {
  final ApiResponceType type;
  final Map<String, dynamic>? data;

  ApiResponce(this.type, this.data);
}

class ApiService {
  static Map<String, dynamic> errorResponse = {};
  static Dio dio = Dio();

  ///api method set up

  static Future<ApiResponce> callApi(
      {required ApiMethod method,
      required String url,
      var data,
      var queryParameters,
      Function(int, int)? onSendProgress,
      Function(int, int)? onRecieveProgress,
      Options? options}) async {
    dio.options.baseUrl = ApiUrls.baseUrl;
    dio.options.connectTimeout = const Duration(minutes: 1);
    dio.options.receiveTimeout = const Duration(minutes: 1);
    try {
      Response? response;
      switch (method) {
        case ApiMethod.get:
          if (data != null) {
            response = await dio.get(
              url,
              queryParameters: data,
              options: options ?? Options(),
            );
          } else {
            response = await dio.get(url,
                options: options ?? Options(),
                onReceiveProgress: onRecieveProgress);
          }
          break;
        case ApiMethod.post:
          response = await dio.post(url,
              data: data,
              queryParameters: queryParameters,
              onSendProgress: onSendProgress,
              onReceiveProgress: onRecieveProgress);
          break;
        case ApiMethod.delete:
          response = await dio.delete(url,
              data: data, queryParameters: queryParameters);
          break;
        case ApiMethod.update:
          response = await dio.put(url,
              data: data,
              queryParameters: queryParameters,
              onSendProgress: onSendProgress,
              onReceiveProgress: onRecieveProgress);
          break;
      }
      return ApiResponce(ApiResponceType.data, response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        Fluttertoast.showToast(msg: e.response?.data['error']['message']);
        return ApiResponce(ApiResponceType.dataEmpty, e.response?.data);
      } else if (e.response?.statusCode == 401) {
        errorResponse["status"] = "401";
        errorResponse["message"] = "Authorization error";

        print(errorResponse);
      } else if (e.response?.statusCode == 404) {
        // SnackBarWidget.getSnackBar(
        //     showText: "Server Unreachable, try later");
      } else if (e.response?.statusCode == 500) {
        Fluttertoast.showToast(msg: AppText.wentWrong);
        return ApiResponce(ApiResponceType.serverException, e.response?.data);
      } else if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout) {
        Fluttertoast.showToast(msg: AppText.connectionSpeed);
        return ApiResponce(ApiResponceType.internetException, e.response?.data);
      } else if (e.type == DioExceptionType.connectionError) {
        Fluttertoast.showToast(msg: AppText.noInternet);
        return ApiResponce(ApiResponceType.internetException, e.response?.data);
      } else if (e.error is SocketException) {
        errorResponse["status"] = "101";
        errorResponse["message"] = "internet error";
        if (errorResponse["status"] == "101") {
          Fluttertoast.showToast(msg: AppText.noInternet);
          return ApiResponce(ApiResponceType.internetException, errorResponse);
        }
      }

      return ApiResponce(ApiResponceType.serverException, e.response?.data);
    } catch (e) {
      return ApiResponce(ApiResponceType.serverException, errorResponse);
    }
  }
}
