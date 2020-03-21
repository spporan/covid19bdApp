
import 'package:covid19bd/model/all_data.dart';
import 'package:covid19bd/model/covid_bd_model.dart';
import 'package:covid19bd/model/daily_update_data.dart';

class CovidState {}
class CovidInitailState extends CovidState{}

class CovidLoadingState extends CovidState{}
class CovidBdState extends CovidState{
  CovidBdData covidBdData;
  AllData allData;
  List<CovidBdData>dailyUpdateList;
  CovidBdState({this.covidBdData,this.allData,this.dailyUpdateList});
}
class CovidAllState extends CovidState{}

class CovidErrorState extends CovidState{
  final error;
  CovidErrorState({this.error});

}