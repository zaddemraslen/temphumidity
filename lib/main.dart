import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:temphumidity/MyHomePage.dart';
import 'package:temphumidity/utils/service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBQ2VONQu5Aln7svZsXru__rOCX7-rirXk",
          appId: "1:47392887755:android:e09d9fdcfa1cfddc94dc4e",
          messagingSenderId:
              "47392887755-9pvco0e374j5js8tlkutmv5rfgd34h6l.apps.googleusercontent.com",
          projectId: "test101-ac974"));
  // await Services().addDocToBase();
  // print(await Services().addDocToBase().then((value) => value));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Projet STM'),
    );
  }
}
