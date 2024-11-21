import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whether_forecast/constents/app_colors.dart';
import 'package:whether_forecast/helpers/api_responce_helper.dart';
import 'package:whether_forecast/helpers/enum.dart';
import 'package:whether_forecast/helpers/helper_methods.dart';
import 'package:whether_forecast/helpers/navigation_helper.dart';
import 'package:whether_forecast/providers/home_provider.dart';
import 'package:whether_forecast/screens/forecast_screen.dart';
import 'package:whether_forecast/widgets/heading_text.dart';
import 'package:whether_forecast/widgets/svg_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final homePro = Provider.of<HomeProvider>(context, listen: false);
      homePro.getHomeData();
    });
  }

  @override
  void dispose() {
    final homePro = Provider.of<HomeProvider>(context, listen: false);
    homePro.searchCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Consumer<HomeProvider>(builder: (context, homePro, _) {
      final data = homePro.weatherModelMap;
      return PopScope(
        canPop: false,
        onPopInvoked: (
          didPop,
        ) =>
            homePro.ctrUserBackScreen(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: ApiResponceHelper(
            type: homePro.homePageResponce,
            reCallFunction: () async => await homePro.getHomeData(),
            child: Stack(
              children: [
                Image.asset(
                  "assets/images/burj_khaleefa.jpg",
                  fit: BoxFit.cover,
                  height: h,
                ),
                Container(
                  height: h,
                  color: AppColors.scaffoldGrey,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on_sharp,
                                  size: 25,
                                  color: AppColors.appWhite,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 150,
                                  child: SearchBar(
                                    //used for deactivate keyboard when user scroll or somthing
                                    onTapOutside: (event) => FocusManager
                                        .instance.primaryFocus
                                        ?.unfocus(),

                                    controller: homePro.searchCtr,
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppColors.appWhite),
                                    // hintText: data?.location?.name ?? 'Unknown',
                                    // hintStyle: WidgetStatePropertyAll(TextStyle(
                                    //   color: AppColors.appBlack,
                                    //   fontSize: 20,
                                    // )),
                                    trailing: [
                                      InkWell(
                                        onTap: () => homePro.getHomeData(
                                            isSearching: true),
                                        child: HeadingText(
                                          text: 'Search',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: AppColors.appPrimery,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (homePro.homePageResponce ==
                                ApiResponceType.dataEmpty)
                              const HeadingText(
                                  text: 'No matching location found.')
                            else
                              Column(
                                children: [
                                  HeadingText(
                                    text: returnDay(data?.location?.localtime ??
                                        DateTime.now().toString()),
                                    fontSize: 40,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  HeadingText(
                                    text:
                                        "Updated as of ${returnFormatedDate(data?.location?.localtime ?? DateTime.now().toString())}",
                                    fontSize: 15,
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      HeadingText(
                                        text: data?.current?.condition?.text ??
                                            '',
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      showNetWorkImage(
                                          height: 50,
                                          width: 50,
                                          image:
                                              'https:${data?.current?.condition?.icon}'),
                                    ],
                                  ),
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: HeadingText(
                                          text:
                                              data?.current?.tempC.toString() ??
                                                  '',
                                          fontSize: 80,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: HeadingText(
                                          text: "ºC",
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                      3,
                                      (index) => Column(
                                        children: [
                                          SvgWidget(
                                            path: [
                                              "Icon Humidity",
                                              "Icon Wind",
                                              "Icon Feels Like"
                                            ][index],
                                            size: 40,
                                          ),
                                          HeadingText(
                                            text: [
                                              "HUMIDITY",
                                              "WIND",
                                              "FEELS LIKE"
                                            ][index],
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          HeadingText(
                                            text: [
                                              "${data?.current?.humidity}%",
                                              "${data?.current?.windKph} km/h",
                                              "${data?.current?.feelslikeC}ºC"
                                            ][index],
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  if (homePro.forecastModel != null)
                                    TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  AppColors.appGrey)),
                                      onPressed: () {
                                        push(
                                            context,
                                            ForecastScreen(
                                              forecastModel:
                                                  homePro.forecastModel!,
                                            ));
                                      },
                                      child: const HeadingText(
                                        text: 'Show More Forecast',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                ],
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
