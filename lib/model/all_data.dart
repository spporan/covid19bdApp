
import 'dart:convert';

AllData allDataFromJson(String str) => AllData.fromJson(json.decode(str));

String allDataToJson(AllData data) => json.encode(data.toJson());

class AllData {
  int cases;
  int deaths;
  int recovered;
  int updated;

  AllData({
    this.cases,
    this.deaths,
    this.recovered,
    this.updated,
  });

  factory AllData.fromJson(Map<String, dynamic> json) => AllData(
    cases: json["cases"],
    deaths: json["deaths"],
    recovered: json["recovered"],
    updated: json["updated"],
  );

  Map<String, dynamic> toJson() => {
    "cases": cases,
    "deaths": deaths,
    "recovered": recovered,
    "updated": updated,
  };
}
