import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

const BASE_URL="https://disease.sh/v3/covid-19/";

class ApiService {
  Future<Response> getCovidData(String param)async{

    try{
      final result= http.get(BASE_URL+"$param");
      return result;
    }catch(e){
      print("Error :${e.toString()}");

      throw Exception();
    }

  }
}
