import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget showNetWorkImage({
  required String image,
  double? height,
  double? width,
}) {
  return SizedBox(
    height: height,
    width: width,
    child: CachedNetworkImage(
      imageUrl: image,
      fit: BoxFit.contain,
      errorWidget: (context, url, error) {
        return const Center(
          child: Icon(
            Icons.sunny,
            color: Colors.grey,
          ),
        );
      },
    ),
  );
}

showSnackBar(BuildContext context, String message,
    {Color? color,
    Duration? duration,
    double margin = 10,
    SnackBarAction? action}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    action: action,
    margin: EdgeInsets.only(bottom: margin),
    elevation: 5.0,
    behavior: SnackBarBehavior.floating,
    duration: duration ?? const Duration(seconds: 1),
    content: Text(message),
    backgroundColor: color ?? Colors.blue,
  ));
}

String returnFormatedDate(String date) {
  return DateFormat('MMM d - hh:mm a ').format(DateTime.parse(date));
}

String returnDate(String date) {
  return DateFormat('MM/dd').format(DateTime.parse(date));
}

String returnDay(String date) {
  return DateFormat.EEEE().format(DateTime.parse(date));
}
