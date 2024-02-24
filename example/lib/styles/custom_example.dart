import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:load_switch/load_switch.dart';

class CustomStyleExample extends StatefulWidget {
  const CustomStyleExample({Key? key}) : super(key: key);

  @override
  State<CustomStyleExample> createState() => _CustomStyleExampleState();
}

class _CustomStyleExampleState extends State<CustomStyleExample> {
  bool value = false;
  bool thumbStatus = true;
  Future<bool> _getFuture() async {
    if (kDebugMode) {
      print('Calling futute...');
    }
    await Future.delayed(const Duration(seconds: 2));
    // If you want to test the onError callback, uncomment the following line.
    // throw Exception('Error');
    if (kDebugMode) {
      print('Future returned.');
    }
    value = !value;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadSwitch(
              value: value,
              isActive: thumbStatus,
              future: _getFuture,
              onError: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error.toString()),
                  ),
                );
              },
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
                child: Text(
                    thumbStatus ? 'Deactivate toggle' : 'Activate toggle')),
          ],
        ),
      ),
    );
  }
}
