import 'package:flutter/material.dart';
import 'package:load_switch/load_switch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool value = false;

  Future<bool> _getFuture() async {
    await Future.delayed(const Duration(seconds: 2));
    return !value;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Load Switch Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoadSwitch(
        value: value,
        future: _getFuture,
        onChange: (v) {
          value = v;
          print('Value changed to $v');
          setState(() {});
        },
        onTap: (v) {
          print('Tapping while value is $v');
        },
      ),
    );
  }
}
