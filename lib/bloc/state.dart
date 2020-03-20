
import 'package:covid19bd/model/all_data.dart';
import 'package:covid19bd/model/covid_bd_model.dart';

class CovidState {}
class CovidInitailState extends CovidState{}

class CovidLoadingState extends CovidState{}
class CovidBdState extends CovidState{
  CovidBdData covidBdData;
  AllData allData;
  CovidBdState({this.covidBdData,this.allData});
}
class CovidAllState extends CovidState{}

class CovidErrorState extends CovidState{
  final error;
  CovidErrorState({this.error});

}