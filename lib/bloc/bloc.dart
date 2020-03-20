

import 'package:covid19bd/bloc/event.dart';
import 'package:covid19bd/bloc/state.dart';
import 'package:covid19bd/model/all_data.dart';
import 'package:covid19bd/model/covid_bd_model.dart';
import 'package:covid19bd/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CovidBloc extends Bloc<CovidEvent,CovidState>{
  Repository repository;
  CovidBloc({this.repository});

  @override
  CovidState get initialState => CovidInitailState();

  @override
  Stream<CovidState> mapEventToState(CovidEvent event) async*{
    if(event is CovidBdDataEvent){
      yield CovidLoadingState();

      try{
        final result1=repository.getCovidAllData(event.paramAll);
       final result=  repository.getCovidBdData(event.param);
        var results = await Future.wait([result1,result]);
        print("size response :${results.length}");
        if(results[0].statusCode !=200) throw Exception();
        AllData allData=allDataFromJson(results[0].body);
        if(results[1].statusCode !=200) throw Exception();
        CovidBdData covidBdData=covidBdDataFromJson(results[1].body);
        yield CovidBdState(covidBdData:covidBdData,allData: allData);

      }catch(e){
        yield CovidErrorState(error: e.toString());

      }

    }
  }
}