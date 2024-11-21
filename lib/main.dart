import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whether_forecast/providers/home_provider.dart';
import 'package:whether_forecast/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Weather App",
        theme: ThemeData(fontFamily: "Roboto"),
        home: const HomeScreen(),
      ),
    );
  }
}
