import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:load_switch/load_switch.dart';

class DefaultStyleExample extends StatefulWidget {
  const DefaultStyleExample({Key? key}) : super(key: key);

  @override
  State<DefaultStyleExample> createState() => _DefaultStyleExampleState();
}

class _DefaultStyleExampleState extends State<DefaultStyleExample> {
  bool value = false;
  bool thumbStatus = true;
  bool isLoading = false;

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
              style: SpinStyle.spinningLines,
              isLoading: isLoading,
              onError: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error.toString()),
                  ),
                );
              },
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
            const SizedBox(height: 50),
            TextButton(
              onPressed: () {
                setState(() {
                  isLoading = !isLoading;
                });
                Future.delayed(const Duration(seconds: 2), () {
                  setState(() {
                    isLoading = !isLoading;
                    value = !value;
                  });
                });
              },
              child: const Text('Start loading'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  thumbStatus = !thumbStatus;
                });
              },
              child:
                  Text(thumbStatus ? 'Deactivate toggle' : 'Activate toggle'),
            ),
          ],
        ),
      ),
    );
  }
}
