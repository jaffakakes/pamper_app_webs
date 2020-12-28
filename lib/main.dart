import 'package:flutter/material.dart';
import 'Services/Route.dart';

void main() {
  Fluro.setupRouter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     onGenerateRoute: Fluro.router.generator
    );
  }
}

