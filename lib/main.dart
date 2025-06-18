import 'package:flutter/material.dart';
import 'package:world_weather_app/pages/cityselection.dart';
import 'package:world_weather_app/pages/home.dart';

void main() {
  runApp(MaterialApp(
    initialRoute:'/home' ,
    routes: {
    "/home":(context) => Home(),
    '/cityselection':(context) => CitySelection()
    }
  ));
}

