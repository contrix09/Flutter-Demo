import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/pages/main_page.dart';

void main() => runApp(App());

class App extends StatelessWidget{

@override
  Widget build(BuildContext context) {
     return MaterialApp(
       debugShowCheckedModeBanner: false,
       title: "Places",
       home: MainPage(),
       theme: ThemeData(
         fontFamily: "Oxygen",
         primarySwatch: Colors.deepOrange
       ),
    );
  }
}