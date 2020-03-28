
import 'dart:convert';

CovidBdData covidBdDataFromJson(String str) => CovidBdData.fromJson(json.decode(str));

String covidBdDataToJson(CovidBdData data) => json.encode(data.toJson());

class CovidBdData {
  dynamic country;
  dynamic cases;
  dynamic todayCases;
  dynamic deaths;
  dynamic todayDeaths;
  dynamic recovered;
  dynamic active;
  dynamic critical;
  dynamic casesPerOneMillion;

  CovidBdData({
    this.country,
    this.cases,
    this.todayCases,
    this.deaths,
    this.todayDeaths,
    this.recovered,
    this.active,
    this.critical,
    this.casesPerOneMillion,
  });

  factory CovidBdData.fromJson(Map<String, dynamic> json) => CovidBdData(
    country: json["country"],
    cases: json["cases"],
    todayCases: json["todayCases"],
    deaths: json["deaths"],
    todayDeaths: json["todayDeaths"],
    recovered: json["recovered"],
    active: json["active"],
    critical: json["critical"],
    casesPerOneMillion: json["casesPerOneMillion"],
  );

  Map<String, dynamic> toJson() => {
    "country": country,
    "cases": cases,
    "todayCases": todayCases,
    "deaths": deaths,
    "todayDeaths": todayDeaths,
    "recovered": recovered,
    "active": active,
    "critical": critical,
    "casesPerOneMillion": casesPerOneMillion,
  };
}
