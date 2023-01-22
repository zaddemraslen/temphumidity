import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:temphumidity/model/Humidity.dart';

import '../model/Info.dart';
import '../model/Temperature.dart';

class Services {
  final db = FirebaseFirestore.instance;

  Future<List<Humidity>> getHumidityListValue() async {
    List<Humidity> listHum = [];

    await db.collection("Weathers").get().then((value) {
      for (var element in value.docs) {
        var a = element.data() as Map<String, dynamic>;
        double x = double.parse(a["humidity"].toString());
        int y = int.parse(a["date"]);
        Humidity b = Humidity(y, x);
        listHum.add(b);
      }
    });
    listHum.sort((a, b) => a.dateHum.compareTo(b.dateHum));
    List<Humidity> result =
        listHum.sublist(max(listHum.length - 10, 0), listHum.length);

    return result;
  }

  Future<List<Temperature>> getTemperatureListValue() async {
    List<Temperature> listTemp = [];
    await db.collection("Weathers").get().then((value) {
      value.docs.forEach((element) {
        var a = element.data() as Map<String, dynamic>;
        double x = double.parse(a["temp"].toString());
        int y = int.parse(a["date"]);

        listTemp.add(Temperature(y, x));
      });
    });
    listTemp.sort((a, b) => a.dateTemp.compareTo(b.dateTemp));

    List<Temperature> result =
        listTemp.sublist(max(listTemp.length - 10, 0), listTemp.length);
    return result;
  }

  Future<Info> getCurrentInfo() async {
    //Info f = Info();
    List<Info> listInfo = [];
    await db.collection("Weathers").get().then((value) {
      value.docs.forEach((element) {
        Info f = Info();
        var a = element.data() as Map<String, dynamic>;

        double x = double.parse(a["temp"].toString());
        double z = double.parse(a["humidity"].toString());

        int y = int.parse(a["date"]);
        f.t = Temperature(y, x);
        f.h = Humidity(y, z);
        listInfo.add(f);
      });
    });

    listInfo.sort((a, b) => a.t.dateTemp.compareTo(b.t.dateTemp));
    return listInfo.last;
  }
}
