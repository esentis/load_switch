import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:load_switch/load_switch.dart';

class LoadSwitchControllerExample extends StatefulWidget {
  const LoadSwitchControllerExample({Key? key}) : super(key: key);

  @override
  State<LoadSwitchControllerExample> createState() =>
      _LoadSwitchControllerExampleState();
}

class _LoadSwitchControllerExampleState
    extends State<LoadSwitchControllerExample> {
  // Create a controller to manage the switch state
  late LoadSwitchController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with default values
    _controller = LoadSwitchController(
      initialValue: false,
      isLoading: false,
      isActive: true,
    );

    // Listen to changes in the switch value
    _controller.addListener(_handleControllerChange);
  }

  void _handleControllerChange() {
    // React to controller changes if needed
    log('Switch value: ${_controller.value}');
    log('Loading state: ${_controller.isLoading}');
    log('Active state: ${_controller.isActive}');
  }

  // Simulate an async operation
  Future<bool> _mockOperation() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    // Return a new value (in a real app, this would come from an API)
    return !_controller.value;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _controller.removeListener(_handleControllerChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoadSwitch Controller Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use the switch with a controller
            LoadSwitch(
              controller: _controller,
              future: _mockOperation,
              onTap: (value) => log('Tapped: $value'),
              onChange: (value) => log('Changed to: $value'),
              onError: (error) => log('Error: $error'),
              style: SpinStyle.circle,
              spinColor: (value) => value ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 40),

            // External controls for the switch
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _controller.toggle(),
                  child: const Text('Toggle'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    _controller.executeWithLoading(
                      _mockOperation,
                      onChange: (value) => log('Changed to: $value'),
                    );
                  },
                  child: const Text('Execute with Loading'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _controller.isActive = !_controller.isActive;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(_controller.isActive
                              ? 'Switch activated'
                              : 'Switch deactivated')),
                    );
                  },
                  child: const Text('Toggle Active State'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Force loading state manually
                    _controller.isLoading = true;
                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) {
                        _controller.isLoading = false;
                      }
                    });
                  },
                  child: const Text('Manual Loading'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
