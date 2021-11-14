import 'package:flutter/material.dart';
import 'package:to_do_list/widgets/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreenWidget(),
    );
  }
}