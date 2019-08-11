import 'package:flutter/material.dart';
import 'package:zhiku/common/consts.dart';
import 'package:zhiku/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '知库',
      theme: ThemeData(
        primarySwatch: SWATCH_CONFIG,
      ),
      home: HomePage(),
    );
  }
}