
import 'package:covid19bd/api_service.dart';
import 'package:http/http.dart';

class Repository{

  ApiService _apiService;
  Repository(){
    this._apiService=ApiService();
  }

  Future<Response> getCovidBdData(String param){
    return _apiService.getCovidData(param);
  }
  Future<Response> getCovidAllData(String param){
    return _apiService.getCovidData(param);
  }
}