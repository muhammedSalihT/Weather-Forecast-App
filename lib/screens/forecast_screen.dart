import 'package:flutter/material.dart';
import 'package:whether_forecast/constents/app_colors.dart';
import 'package:whether_forecast/helpers/helper_methods.dart';
import 'package:whether_forecast/models/forecast_model.dart';
import 'package:whether_forecast/widgets/heading_text.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key, required this.forecastModel});

  final ForecastModel forecastModel;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
        title: const HeadingText(
          text: 'Forecast',
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            "assets/images/burj_khaleefa.jpg",
            fit: BoxFit.cover,
            height: h,
          ),
          Container(
            height: h,
            color: const Color.fromARGB(80, 0, 0, 0),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1.5),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(1),
                    },
                    border: TableBorder(
                      borderRadius: BorderRadius.circular(20),
                      horizontalInside: BorderSide(color: AppColors.appWhite),
                    ),
                    children: [
                      TableRow(
                        children: List.generate(
                          5,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: HeadingText(
                              text: [
                                'Date',
                                'Day',
                                'Weather',
                                'Max.ºC',
                                'Min.ºC'
                              ][index],
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      for (int i = 0; i < forecastModel.data!.length; i++)
                        TableRow(
                          children: List.generate(
                            5,
                            (index) {
                              final data = forecastModel.data?[i];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: index == 2
                                    ? ColoredBox(
                                        color: AppColors.scaffoldGrey,
                                        child: Column(
                                          children: [
                                            showNetWorkImage(
                                                height: 40,
                                                width: 40,
                                                image:
                                                    'https://www.weatherbit.io/static/img/icons/${data?.weather?.icon}.png'),
                                            HeadingText(
                                                fontSize: 10,
                                                text:
                                                    '${data?.weather?.description}')
                                          ],
                                        ),
                                      )
                                    : HeadingText(
                                        text: [
                                          (returnDate(
                                              data!.datetime.toString())),
                                          (returnDay(data.datetime.toString())
                                              .substring(0, 3)),
                                          '',
                                          '${data.maxTemp}',
                                          '${data.minTemp}',
                                        ][index],
                                        fontSize: 15,
                                      ),
                              );
                            },
                          ),
                        ),
                    ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
