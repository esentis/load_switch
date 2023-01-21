import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:load_switch/load_switch.dart';

void main() {
  testWidgets('A simple test case to ensure functionality',
      (WidgetTester tester) async {
    bool switchValue = false;
    bool onChangeCalled = false;
    bool onTapCalled = false;

    await tester.pumpWidget(MaterialApp(
      home: LoadSwitch(
        value: switchValue,
        future: () async =>
            Future.delayed(const Duration(seconds: 3), () => switchValue),
        onChange: (newValue) {
          switchValue = newValue;
          onChangeCalled = true;
        },
        onTap: (currentValue) {
          switchValue = !switchValue;
          onTapCalled = true;
        },
      ),
    ));

    // Check if the switch is in the correct initial state
    expect(switchValue, false);
    expect(onChangeCalled, false);
    expect(onTapCalled, false);

    // Tap the switch and check if the future function is called
    await tester.tap(find.byType(LoadSwitch));
    await tester.pump();
    expect(onTapCalled, true);
    expect(onChangeCalled, false);

    // Wait for the future to complete and check if the switch state is updated
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(switchValue, true);
    expect(onChangeCalled, true);
  });
}
