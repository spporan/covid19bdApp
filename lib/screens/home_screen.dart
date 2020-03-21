import 'package:covid19bd/bloc/bloc.dart';
import 'package:covid19bd/bloc/event.dart';
import 'package:covid19bd/bloc/state.dart';
import 'package:covid19bd/model/covid_bd_model.dart';
import 'package:covid19bd/model/daily_update_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';
import '../api_service.dart';
import '../constants.dart';
import '../repository.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ApiService apiService;
  Map<String, double> dataMap = new Map();
  Map<String, double> dataMapAll = new Map();
  TextEditingController controller = new TextEditingController();
  List<CovidBdData>searchResult=List();
  List<CovidBdData>covidDailyData;
  FocusNode _focusNode = FocusNode();
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text("Covid19 BD"),
      ),
      body:  BlocProvider<CovidBloc>(
          create: (BuildContext context) =>  CovidBloc(repository: Repository())..add(CovidBdDataEvent(param:"countries/bangladesh",paramAll: "all",paramDailyUpdate: "countries")),
          child:SingleChildScrollView(
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                BlocBuilder<CovidBloc,CovidState>(
                  builder: (context,state){
                    if(state is CovidLoadingState){
                      return Align(
                        alignment: Alignment.center,
                        child:  Container(
                          color: primaryColorDark,
                          height: MediaQuery.of(context).size.height,
                          child:  Center(
                            child: CircularProgressIndicator(
                              backgroundColor:primaryColor ,
                            ),
                          ),
                        ),
                      );
                    }else if(state is CovidBdState){
                      if(state.covidBdData !=null){
                        dataMap.putIfAbsent("Confirmed", () => state.covidBdData.cases.toDouble());
                        dataMap.putIfAbsent("Recovered", () => state.covidBdData.recovered.toDouble());
                        dataMap.putIfAbsent("Deaths", () => state.covidBdData.deaths.toDouble());
                        return Padding(padding: EdgeInsets.all(10),
                          child: Card(
                            elevation: 0,
                            color: colorDarkGray,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Bangladesh Covid 19",style: TextStyle(fontSize: 18),),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child:getChart(dataMap,[confirmedColor,recoveredColor,deathColor])
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                     _getItem(state.covidBdData.deaths+state.covidBdData.recovered+state.covidBdData.cases,"Reported cases"),
                                    ],
                                  ),

//                                  Row(
//                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                    children: <Widget>[
//                                      _getItem(state.covidBdData.todayCases, "Today Confirmed"),
//                                      _getItem(state.covidBdData.todayDeaths, "Today Deaths"),
//                                      _getItem(state.covidBdData.deaths+state.covidBdData.recovered+state.covidBdData.cases,"Reported cases"),
//                                    ],
//                                  ),
//                                  SizedBox(height: 20,),
//                                  Row(
//                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                    children: <Widget>[
//                                      _getItem(state.covidBdData.active, "Active Cases"),
//                                      _getItem(state.covidBdData.critical, "Critical Cases"),
//                                      _getItem(state.covidBdData.casesPerOneMillion,"Cases Per Million"),
//                                    ],
//                                  )

                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    }

                    else if(state is CovidErrorState){
                      return Container();
                    }

                    return Container();

                  },
                ),
                BlocBuilder<CovidBloc,CovidState>(
                  builder: (context,state){
                    if(state is CovidBdState){
                      if(state.allData !=null){
                        print("CovidBdState ${state.allData}");
                        dataMapAll.putIfAbsent("Confirmed ", () => state.allData.cases.toDouble());
                        dataMapAll.putIfAbsent("Recovered", () => state.allData.recovered.toDouble());
                        dataMapAll.putIfAbsent("Deaths", () => state.allData.deaths.toDouble());
                        return Padding(padding: EdgeInsets.only(bottom: 10,right: 10,left: 10),
                          child: Card(
                            color: colorDarkGray,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("World Covid 19 ",style: TextStyle(fontSize: 18),),
                                      Column(
                                        children: <Widget>[
                                          Text("Updated on",style: TextStyle(fontSize: 12,color:Colors.blueGrey ),),
                                          SizedBox(height: 10,),
                                          Text(" ${formatTimestamp(state.allData.updated)}",),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  Align(
                                      alignment: Alignment.topCenter,
                                      child: getChart(dataMapAll,[confirmedColor,recoveredColor,deathColor])
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      _getItem(state.allData.deaths+state.allData.recovered+state.allData.cases,"Reported Cases"),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                        );
                      }

                    }
                    else if(state is CovidErrorState){
                      return Align(
                        alignment: Alignment.center,
                        child:  Container(
                          color: primaryColorDark,
                          height: MediaQuery.of(context).size.height,
                          child:  Center(
                            child: Text("Something went wrong!",style: TextStyle(color: Colors.white,fontSize: 18),),
                          ),
                        ),
                      );

                    }
                    return Container();

                  },
                ),
               Container(
                 alignment: Alignment.centerLeft,
                 margin: EdgeInsets.only(left: 20),
                 child: Text("Daily Update",style: TextStyle(color: recoveredColor,fontSize: 18),)
                 ,
               ),
                SizedBox(
                  height: 10,
                ),
               InkWell(
                 splashColor: Colors.transparent,
                 onTap: (){
                   FocusScope.of(context).requestFocus(FocusNode());
                 },
                 child: Padding(padding: EdgeInsets.only(
                     left: 20,
                     right: 20
                 ),
                   child: TextField(
                     controller: controller,
                     focusNode: _focusNode,
                     onChanged: onSearchTextChanged,
                     decoration: new InputDecoration(
                       border: new OutlineInputBorder(
                         borderRadius: const BorderRadius.all(
                           const Radius.circular(7.0),
                         ),
                       ),
                       filled: true,
                       hintStyle: new TextStyle(color: Colors.grey[800],),
                       hintText: "Type country...",
                       prefixIcon: Icon(Icons.search,color: Colors.blueGrey,),
                       fillColor: Colors.transparent,

                     ),
                   ),
                 ) ,
               ),
                SizedBox(
                  height: 10,
                ),
                BlocBuilder<CovidBloc,CovidState>(
                  builder: (context,state){
                    if(state is CovidBdState){
                      if(state.dailyUpdateList !=null||state.dailyUpdateList.length>0){
                       covidDailyData=state.dailyUpdateList;

                        if(covidDailyData[0].country.toLowerCase() !='bangladesh'){
                          covidDailyData.removeWhere((item) {
                            return item.country.toLowerCase() == 'bangladesh';
                          } );
                          if(state.covidBdData!=null){
                            covidDailyData.insert(0, state.covidBdData);
                          }else{
                            covidDailyData=state.dailyUpdateList;
                          }

                        }

                        covidDailyData.where((item) => item.country.toLowerCase().contains("ban")).toList();

                        return searchResult.length !=0||controller.text.length>2? ListView.builder(
                          itemCount: searchResult.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder:(context,index){
                              return getDailyUpdateItems(searchResult[index]) ;
                            }
                        ) : ListView.builder(
                            itemCount: covidDailyData.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder:(context,index){
                              return getDailyUpdateItems(covidDailyData[index]) ;
                            }
                        );
                      }
                    }
                    return Container();

                  },
                )

              ],
            ),
          )
      ),

    );
  }

  getDailyUpdateItems(CovidBdData data){
    return Padding(
      padding: EdgeInsets.only(left: 10,right: 10),
      child:  Card(
        elevation: 0,
        color: colorDarkGray,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7)
        ),
        child:Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("${data.country}",style: TextStyle(fontSize: 18,color: Colors.white),),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Critical : ${getFormattedNumber(number: data.critical)}",style: TextStyle(fontSize: 12,color:itemColor),overflow: TextOverflow.ellipsis,),
                  Text("Today Cases: ${getFormattedNumber(number: data.todayCases)}",style: TextStyle(fontSize: 12,color:itemColor),overflow: TextOverflow.ellipsis,),
                  Text("Confirmed : ${getFormattedNumber(number: data.cases)}",style: TextStyle(fontSize: 12,color:confirmedColor),overflow: TextOverflow.ellipsis,),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Active : ${getFormattedNumber(number: data.active)}",style: TextStyle(fontSize: 12,color:itemColor),overflow: TextOverflow.ellipsis,),
                  Text("Today Deaths: ${getFormattedNumber(number: data.todayDeaths)}",style: TextStyle(fontSize: 12,color:itemColor),overflow: TextOverflow.ellipsis,),
                  Text("Recovered : ${getFormattedNumber(number: data.recovered)}",style: TextStyle(fontSize: 12,color:recoveredColor),overflow: TextOverflow.ellipsis,),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("casesPerOneMillion : ${getFormattedNumber(number: data.casesPerOneMillion)}",style: TextStyle(fontSize: 12,color:itemColor),overflow: TextOverflow.ellipsis,),
                  Text("Death : ${getFormattedNumber(number: data.deaths)}",style: TextStyle(fontSize: 12,color:deathColor),overflow: TextOverflow.ellipsis,),

                ],
              ),

            ],
          ),
        ) ,
      ),
    );
  }

  _getItem(final data,String level){
    return   Column(
      children: <Widget>[
        Text("${getFormattedNumber(number: data)}",style: TextStyle(fontSize: 18),),
        SizedBox(height: 10,),
        Text("$level",style: TextStyle(color: Colors.blueGrey),)
      ],
    );
  }
  getChart(var  data,var color){
    return PieChart(
      dataMap: data,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 32.0,
      chartRadius: MediaQuery.of(context).size.width / 4,
      showChartValuesInPercentage: false,
      showChartValues: true,
      showChartValuesOutside: false,
      chartValueBackgroundColor: Colors.transparent,
      colorList: color,
      showLegends: true,
      legendPosition: LegendPosition.right,
      decimalPlaces: 0,
      showChartValueLabel: true,
      initialAngle: 0,
      chartValueStyle: defaultChartValueStyle.copyWith(
          color:Colors.white
      ),
      chartType: ChartType.ring,
    );
  }
  onSearchTextChanged(String text) async {
    searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
   if( covidDailyData!=null) {
     if(text.length>2){
       covidDailyData.forEach((item) {
         if (item.country.toLowerCase().contains(text.toLowerCase())){
           searchResult.add(item);
           FocusScope.of(context).requestFocus(FocusNode());
           setState(() {});
         }
       });

   }

  }
}

}