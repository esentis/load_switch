import 'package:flutter/foundation.dart';
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
  bool thumbStatus = true;
  Future<bool> _getFuture() async {
    if (kDebugMode) {
      print('Calling futute...');
    }
    await Future.delayed(const Duration(seconds: 2));
    if (kDebugMode) {
      print('Future returned.');
    }
    value = !value;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Load Switch Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadSwitch(
            value: value,
            isActive: thumbStatus,
            future: _getFuture,
            curveIn: Curves.easeInBack,
            curveOut: Curves.easeOutBack,
            animationDuration: const Duration(milliseconds: 500),
            switchDecoration: (value, isActive) => BoxDecoration(
              color: isActive
                  ? value
                      ? Colors.green[100]
                      : Colors.red[100]
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(30),
              shape: BoxShape.rectangle,
              boxShadow: [
                BoxShadow(
                  color: isActive
                      ? value
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2)
                      : Colors.grey,
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            spinColor: (value) => value
                ? const Color.fromARGB(255, 41, 232, 31)
                : const Color.fromARGB(255, 255, 77, 77),
            spinStrokeWidth: 3,
            thumbDecoration: (value, isActive) => BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              shape: BoxShape.rectangle,
              boxShadow: [
                BoxShadow(
                  color: isActive
                      ? value
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2)
                      : Colors.grey,
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            onChange: (v) {
              value = v;
              if (kDebugMode) {
                print('Value changed to $v');
              }
              setState(() {});
            },
            onTap: (v) {
              if (kDebugMode) {
                debugPrint('Tapping while value is $v');
              }
            },
          ),
          const SizedBox(height: 20),
          TextButton(
              onPressed: () {
                setState(() {
                  thumbStatus = !thumbStatus;
                });
              },
              child:
                  Text(thumbStatus ? 'Deactivate toggle' : 'Activate toggle')),
        ],
      ),
    );
  }
}
