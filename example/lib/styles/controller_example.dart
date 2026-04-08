import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:load_switch/load_switch.dart';

class LoadSwitchControllerExample extends StatefulWidget {
  const LoadSwitchControllerExample({super.key});

  @override
  State<LoadSwitchControllerExample> createState() =>
      _LoadSwitchControllerExampleState();
}

class _LoadSwitchControllerExampleState
    extends State<LoadSwitchControllerExample> {
  late LoadSwitchController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoadSwitchController(
      initialValue: false,
    );
    _controller.addListener(_onControllerChange);
  }

  void _onControllerChange() {
    log('Controller changed - Value: ${_controller.value}, Loading: ${_controller.isLoading}');
    setState(() {}); // Rebuild UI when controller changes
  }

  Future<bool> _simulateAsyncOperation() async {
    log('Starting async operation... current value: ${_controller.value}');
    await Future.delayed(const Duration(seconds: 1));
    final newValue = !_controller.value;
    log('Async operation completed, returning: $newValue');
    return newValue;
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controller Example'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Current Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Current Status',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Value: ${_controller.value}'),
                        Text('Loading: ${_controller.isLoading}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Active: ${_controller.isActive}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // The LoadSwitch
            LoadSwitch.controlled(
              controller: _controller,
              onToggle: _simulateAsyncOperation,
              onChanged: (value) {
                log('LoadSwitch onChange callback: $value');
              },
              onError: (error, stackTrace) {
                log('LoadSwitch onError callback: $error');
              },
              style: SpinStyle.material,
            ),
            const SizedBox(height: 32),

            // Control Buttons
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _controller.toggle(),
                  child: const Text('Toggle'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller.isActive = !_controller.isActive;
                  },
                  child: Text(_controller.isActive ? 'Deactivate' : 'Activate'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Info
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'This example shows how to use LoadSwitchController to '
                  'programmatically control the switch state and optionally '
                  'run async toggles with built-in loading management.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
