import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:temphumidity/loading.dart';
import 'package:temphumidity/model/Humidity.dart';
import 'package:temphumidity/model/Info.dart';
import 'package:temphumidity/utils/service.dart';

import 'model/Temperature.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Temperature> chartDataTemp = [];
  late List<Humidity> chartDataHum = [];

  late ChartSeriesController _chartSeriesController;
  late ChartSeriesController _chartSeriesController2;

  @override
  void initState() {
    //chartData = [Temperature(0, 3.0)];
    Timer.periodic(const Duration(seconds: 5), updateDataSource);
    super.initState();
    //  init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(widget.title)),
          backgroundColor: Colors.grey[800],
        ),
        body: Container(
          color: Colors.blueGrey[900],
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<Object>(
                    future: Services().getCurrentInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Info res = snapshot.data as Info;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 160,
                                padding: const EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                    border: Border.all(), color: Colors.grey),
                                child: Center(
                                  child: Text(
                                    "Température: ${res.t.value}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 160,
                                padding: const EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                    border: Border.all(), color: Colors.grey),
                                child: Center(
                                  child: Text(
                                    "Humidité: ${res.h.value}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }
                      return Loading();
                    }),
                const Divider(
                  color: Colors.white,
                  thickness: 5,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Evolution du temperature:",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                FutureBuilder(
                    future: Services().getTemperatureListValue(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        chartDataTemp = snapshot.data as List<Temperature>;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SfCartesianChart(
                              series: <LineSeries<Temperature, int>>[
                                LineSeries<Temperature, int>(
                                  onRendererCreated:
                                      (ChartSeriesController controller) {
                                    _chartSeriesController = controller;
                                  },
                                  dataSource: chartDataTemp,
                                  color: const Color.fromRGBO(192, 108, 132, 1),
                                  xValueMapper: (Temperature sales, _) =>
                                      sales.dateTemp,
                                  yValueMapper: (Temperature sales, _) =>
                                      sales.value,
                                )
                              ],
                              primaryXAxis: NumericAxis(
                                  majorGridLines:
                                      const MajorGridLines(width: 0),
                                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                                  interval: 3,
                                  title: AxisTitle(
                                      text: 'Time (seconds)',
                                      textStyle: const TextStyle(
                                          color: Colors.white))),
                              primaryYAxis: NumericAxis(
                                  axisLine: const AxisLine(width: 0),
                                  majorTickLines: const MajorTickLines(size: 0),
                                  title: AxisTitle(
                                      text: 'temp (C°)',
                                      textStyle: const TextStyle(
                                          color: Colors.white)))),
                        );
                      }
                      return Loading();
                    }),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Evolution de l'humidité:",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                FutureBuilder<Object>(
                    future: Services().getHumidityListValue(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        chartDataHum = snapshot.data as List<Humidity>;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SfCartesianChart(
                              series: <LineSeries<Humidity, int>>[
                                LineSeries<Humidity, int>(
                                  onRendererCreated:
                                      (ChartSeriesController controller) {
                                    _chartSeriesController2 = controller;
                                  },
                                  dataSource: chartDataHum,
                                  color: const Color.fromRGBO(192, 108, 132, 1),
                                  xValueMapper: (Humidity sales, _) =>
                                      sales.dateHum,
                                  yValueMapper: (Humidity sales, _) =>
                                      sales.value,
                                )
                              ],
                              primaryXAxis: NumericAxis(
                                  majorGridLines:
                                      const MajorGridLines(width: 0),
                                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                                  interval: 3,
                                  title: AxisTitle(
                                      text: 'Time (seconds)',
                                      textStyle: const TextStyle(
                                          color: Colors.white))),
                              primaryYAxis: NumericAxis(
                                  axisLine: const AxisLine(width: 0),
                                  majorTickLines: const MajorTickLines(size: 0),
                                  title: AxisTitle(
                                      text: 'hum (%)',
                                      textStyle: const TextStyle(
                                          color: Colors.white)))),
                        );
                      }
                      return Loading();
                    }),
              ],
            ),
          ),
        ));
  }

  void updateDataSource(Timer timer) {
    setState(() {});
  }
}
