
import 'dart:convert';

import 'package:covid19bd/model/covid_bd_model.dart';

List<CovidBdData> dailyUpdateDataFromJson(String str) => List<CovidBdData>.from(json.decode(str).map((x) => CovidBdData.fromJson(x)));

String dailyUpdateDataToJson(List<CovidBdData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


