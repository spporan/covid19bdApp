import 'package:covid19bd/api_service.dart';
import 'package:covid19bd/bloc/bloc.dart';
import 'package:covid19bd/bloc/event.dart';
import 'package:covid19bd/bloc/state.dart';
import 'package:covid19bd/constants.dart';
import 'package:covid19bd/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
       primaryColorDark: primaryColorDark,
          accentColor: colorAccent
      ),

      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

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
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text("Covid19 BD"),
      ),
      body:  BlocProvider<CovidBloc>(
        create: (BuildContext context) =>  CovidBloc(repository: Repository())..add(CovidBdDataEvent(param:"countries/bangladesh",paramAll: "all")),
          child:SingleChildScrollView(
            child:  Column(
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
                                      alignment: Alignment.topCenter,
                                      child: getChart(dataMap,[confirmedColor,recoveredColor,deathColor])
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      _getItem(state.covidBdData.todayCases, "Today Confirmed"),
                                      _getItem(state.covidBdData.todayDeaths, "Today Deaths"),
                                      _getItem(state.covidBdData.deaths+state.covidBdData.recovered+state.covidBdData.cases,"Reported cases"),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      _getItem(state.covidBdData.active, "Active Cases"),
                                      _getItem(state.covidBdData.critical, "Critical Cases"),
                                      _getItem(state.covidBdData.casesPerOneMillion,"Cases Per Million"),
                                    ],
                                  )

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
                        return Padding(padding: EdgeInsets.all(10),
                          child: Card(
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
                                      _getItem(state.allData.deaths+state.allData.recovered+state.allData.cases,"Total Cases"),
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
                )

              ],
            ),
          )
      ),

    );
  }
  _getItem(final data,String level){
    return   Column(
      children: <Widget>[
        Text("$data",style: TextStyle(fontSize: 18),),
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
      chartRadius: MediaQuery.of(context).size.width / 2.7,
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
String formatTimestamp(int timestamp) {
  var format = new DateFormat("MMM d, yyyy");
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
  return format.format(date);
}

}
