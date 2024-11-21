class ForecastModel {
  String? cityName;
  String? countryCode;
  List<ForcastData>? data;
  String? stateCode;
  String? timezone;

  ForecastModel({
    this.cityName,
    this.countryCode,
    this.data,
    this.stateCode,
    this.timezone,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) => ForecastModel(
        cityName: json["city_name"],
        countryCode: json["country_code"],
        data: json["data"] == null
            ? []
            : List<ForcastData>.from(
                json["data"]!.map((x) => ForcastData.fromJson(x))),
        stateCode: json["state_code"],
        timezone: json["timezone"],
      );
}

class ForcastData {
  double? appMaxTemp;
  double? appMinTemp;

  DateTime? datetime;
  double? dewpt;
  double? highTemp;
  double? lowTemp;
  dynamic maxDhi;
  double? maxTemp;
  double? minTemp;
  double? moonPhase;
  double? moonPhaseLunation;

  double? precip;

  double? temp;

  DateTime? validDate;
  double? vis;
  Weather? weather;
  String? windCdir;

  double? windGustSpd;

  ForcastData({
    this.appMaxTemp,
    this.appMinTemp,
    this.datetime,
    this.dewpt,
    this.highTemp,
    this.lowTemp,
    this.maxDhi,
    this.maxTemp,
    this.minTemp,
    this.moonPhase,
    this.moonPhaseLunation,
    this.precip,
    this.temp,
    this.validDate,
    this.vis,
    this.weather,
    this.windCdir,
    this.windGustSpd,
  });

  factory ForcastData.fromJson(Map<String, dynamic> json) => ForcastData(
        appMaxTemp: json["app_max_temp"]?.toDouble(),
        appMinTemp: json["app_min_temp"]?.toDouble(),
        datetime:
            json["datetime"] == null ? null : DateTime.parse(json["datetime"]),
        dewpt: json["dewpt"]?.toDouble(),
        highTemp: json["high_temp"]?.toDouble(),
        lowTemp: json["low_temp"]?.toDouble(),
        maxDhi: json["max_dhi"],
        maxTemp: json["max_temp"]?.toDouble(),
        minTemp: json["min_temp"]?.toDouble(),
        moonPhase: json["moon_phase"]?.toDouble(),
        moonPhaseLunation: json["moon_phase_lunation"]?.toDouble(),
        precip: json["precip"]?.toDouble(),
        temp: json["temp"]?.toDouble(),
        validDate: json["valid_date"] == null
            ? null
            : DateTime.parse(json["valid_date"]),
        vis: json["vis"]?.toDouble(),
        weather:
            json["weather"] == null ? null : Weather.fromJson(json["weather"]),
        windCdir: json["wind_cdir"],
        windGustSpd: json["wind_gust_spd"]?.toDouble(),
      );
}

class Weather {
  String? icon;
  String? description;
  int? code;

  Weather({
    this.icon,
    this.description,
    this.code,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        icon: json["icon"],
        description: json["description"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "description": description,
        "code": code,
      };
}
