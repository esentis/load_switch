import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:load_switch/load_switch.dart';

void main() {
  testWidgets('LoadSwitch changes value when tapped',
      (WidgetTester tester) async {
    bool value = false;

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoadSwitch(
            value: value,
            future: () async {
              await Future.delayed(const Duration(seconds: 1));
              return !value;
            },
            onChange: (newValue) {
              value = newValue;
            },
            onTap: (currentValue) {},
          ),
        ),
      ),
    );

    // Verify that our switch starts off in the off position.
    expect(value, false);

    // Tap the switch and trigger a frame.
    await tester.tap(find.byType(LoadSwitch));
    await tester.pumpAndSettle();

    // Verify that our switch has toggled.
    expect(value, true);
  });

  testWidgets('LoadSwitch does not change value when inactive',
      (WidgetTester tester) async {
    bool value = false;

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoadSwitch(
            value: value,
            future: () async {
              await Future.delayed(const Duration(seconds: 1));
              return !value;
            },
            onChange: (newValue) {
              value = newValue;
            },
            onTap: (currentValue) {},
            isActive: false,
          ),
        ),
      ),
    );

    // Verify that our switch starts off in the off position.
    expect(value, false);

    // Tap the switch and trigger a frame.
    await tester.tap(find.byType(LoadSwitch));
    await tester.pumpAndSettle();

    // Verify that our switch has not toggled.
    expect(value, false);
  });
}
