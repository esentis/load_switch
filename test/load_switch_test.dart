import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:load_switch/load_switch.dart';

void main() {
  group('LoadSwitchController', () {
    test('executeWithLoading updates the value and emits onChanged', () async {
      final controller = LoadSwitchController(initialValue: false);
      final events = <String>[];

      await controller.executeWithLoading(
        () async => true,
        onChanged: (value) {
          events.add('changed:$value');
        },
      );

      expect(controller.value, isTrue);
      expect(controller.isLoading, isFalse);
      expect(events, <String>['changed:true']);
    });

    test('executeWithLoading does nothing while inactive', () async {
      final controller = LoadSwitchController(
        initialValue: false,
        isActive: false,
      );
      var calls = 0;

      await controller.executeWithLoading(() async {
        calls++;
        return true;
      });

      expect(calls, 0);
      expect(controller.value, isFalse);
      expect(controller.isLoading, isFalse);
    });

    test('executeWithLoading reports errors and resets loading', () async {
      final controller = LoadSwitchController(initialValue: false);
      Object? capturedError;
      StackTrace? capturedStackTrace;

      await controller.executeWithLoading(
        () async => throw StateError('boom'),
        onError: (error, stackTrace) {
          capturedError = error;
          capturedStackTrace = stackTrace;
        },
      );

      expect(capturedError, isA<StateError>());
      expect(capturedStackTrace, isNotNull);
      expect(controller.isLoading, isFalse);
      expect(controller.value, isFalse);
    });

    test('toggle respects active and loading state', () {
      final controller = LoadSwitchController(initialValue: false);

      controller.toggle();
      expect(controller.value, isTrue);

      controller.isLoading = true;
      controller.toggle();
      expect(controller.value, isTrue);

      controller.isLoading = false;
      controller.isActive = false;
      controller.toggle();
      expect(controller.value, isTrue);
    });
  });

  group('LoadSwitch', () {
    testWidgets('managed switch changes value when tapped', (
      WidgetTester tester,
    ) async {
      bool value = false;

      await tester.pumpWidget(
        _wrapWithApp(
          StatefulBuilder(
            builder: (context, setState) {
              return LoadSwitch.managed(
                value: value,
                onToggle: () async => !value,
                onChanged: (nextValue) {
                  setState(() {
                    value = nextValue;
                  });
                },
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(LoadSwitch));
      await tester.pumpAndSettle();

      expect(value, isTrue);
    });

    testWidgets('inactive managed switch blocks interaction', (
      WidgetTester tester,
    ) async {
      var tapCount = 0;
      var toggleCount = 0;

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.managed(
            value: false,
            isActive: false,
            onTap: (_) => tapCount++,
            onToggle: () async {
              toggleCount++;
              return true;
            },
            onChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byType(LoadSwitch));
      await tester.pump();

      expect(tapCount, 0);
      expect(toggleCount, 0);
    });

    testWidgets('loading managed switch blocks interaction', (
      WidgetTester tester,
    ) async {
      var tapCount = 0;
      var toggleCount = 0;

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.managed(
            value: false,
            isLoading: true,
            onTap: (_) => tapCount++,
            onToggle: () async {
              toggleCount++;
              return true;
            },
            onChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byType(LoadSwitch));
      await tester.pump();

      expect(tapCount, 0);
      expect(toggleCount, 0);
    });

    testWidgets(
        'managed switch ignores taps after a parent rebuild while a toggle is in flight',
        (
      WidgetTester tester,
    ) async {
      final firstToggle = Completer<bool>();
      var toggleCount = 0;
      var rebuildTick = 0;

      await tester.pumpWidget(
        _wrapWithApp(
          StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('rebuild:$rebuildTick'),
                  LoadSwitch.managed(
                    value: false,
                    isLoading: false,
                    onToggle: () {
                      toggleCount++;
                      return firstToggle.future;
                    },
                    onChanged: (_) {},
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        rebuildTick++;
                      });
                    },
                    child: const Text('rebuild'),
                  ),
                ],
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(LoadSwitch));
      await tester.pump();

      await tester.tap(find.text('rebuild'));
      await tester.pump();

      await tester.tap(find.byType(LoadSwitch));
      await tester.pump();

      firstToggle.complete(true);
      await tester.pump();

      expect(toggleCount, 1);
    });

    testWidgets('callbacks fire in order for successful toggles', (
      WidgetTester tester,
    ) async {
      bool value = false;
      final events = <String>[];

      await tester.pumpWidget(
        _wrapWithApp(
          StatefulBuilder(
            builder: (context, setState) {
              return LoadSwitch.managed(
                value: value,
                onTap: (currentValue) {
                  events.add('tap:$currentValue');
                },
                onToggle: () async {
                  events.add('toggle:$value');
                  return !value;
                },
                onChanged: (nextValue) {
                  events.add('change:$nextValue');
                  setState(() {
                    value = nextValue;
                  });
                },
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(LoadSwitch));
      await tester.pumpAndSettle();

      expect(events, <String>['tap:false', 'toggle:false', 'change:true']);
    });

    testWidgets('controlled switch toggles immediately without onToggle', (
      WidgetTester tester,
    ) async {
      final controller = LoadSwitchController(initialValue: false);
      final changes = <bool>[];

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.controlled(
            controller: controller,
            onChanged: changes.add,
          ),
        ),
      );

      await tester.tap(find.byType(LoadSwitch));
      await tester.pump();

      expect(controller.value, isTrue);
      expect(changes, <bool>[true]);
    });

    testWidgets('onError receives stack trace and skips onChanged on failure', (
      WidgetTester tester,
    ) async {
      bool value = false;
      final events = <String>[];

      await tester.pumpWidget(
        _wrapWithApp(
          StatefulBuilder(
            builder: (context, setState) {
              return LoadSwitch.managed(
                value: value,
                onTap: (currentValue) {
                  events.add('tap:$currentValue');
                },
                onToggle: () async {
                  events.add('toggle');
                  throw StateError('boom');
                },
                onError: (error, stackTrace) {
                  events.add('error:${error is StateError}');
                  expect(stackTrace, isNot(StackTrace.empty));
                },
                onChanged: (nextValue) {
                  setState(() {
                    value = nextValue;
                  });
                },
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(LoadSwitch));
      await tester.pumpAndSettle();

      expect(value, isFalse);
      expect(events, <String>['tap:false', 'toggle', 'error:true']);
    });

    testWidgets(
        'managed to controlled transition does not dispose external controller',
        (
      WidgetTester tester,
    ) async {
      final externalController = LoadSwitchController(initialValue: false);

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.managed(
            value: false,
            onToggle: () async => true,
            onChanged: (_) {},
          ),
        ),
      );

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.controlled(controller: externalController),
        ),
      );

      await tester.pumpWidget(const SizedBox.shrink());

      expect(() => externalController.addListener(() {}), returnsNormally);
      externalController.toggle();
      expect(externalController.value, isTrue);
    });

    testWidgets(
        'controlled controller swap stops listening to the old controller', (
      WidgetTester tester,
    ) async {
      final firstController = LoadSwitchController(initialValue: false);
      final secondController = LoadSwitchController(initialValue: false);
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.controlled(controller: firstController),
        ),
      );

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.controlled(controller: secondController),
        ),
      );

      firstController.value = true;
      await tester.pump();

      expect(
        tester.getSemantics(find.byType(LoadSwitch)),
        matchesSemantics(
          hasToggledState: true,
          isToggled: false,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
        ),
      );

      secondController.value = true;
      await tester.pump();

      expect(
        tester.getSemantics(find.byType(LoadSwitch)),
        matchesSemantics(
          hasToggledState: true,
          isToggled: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
        ),
      );

      semantics.dispose();
    });

    testWidgets('disposing while a toggle future is in flight does not throw', (
      WidgetTester tester,
    ) async {
      final completer = Completer<bool>();

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.managed(
            value: false,
            onToggle: () => completer.future,
            onChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byType(LoadSwitch));
      await tester.pump();

      await tester.pumpWidget(const SizedBox.shrink());

      completer.complete(true);
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('late managed toggles do not mutate a replacement controller', (
      WidgetTester tester,
    ) async {
      final completer = Completer<bool>();
      final externalController = LoadSwitchController(initialValue: false);

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.managed(
            value: false,
            onToggle: () => completer.future,
            onChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byType(LoadSwitch));
      await tester.pump();

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.controlled(controller: externalController),
        ),
      );

      completer.complete(true);
      await tester.pump();

      expect(externalController.value, isFalse);
    });

    testWidgets('managed mode syncs value, activity and loading from rebuilds',
        (
      WidgetTester tester,
    ) async {
      var value = false;
      var isActive = true;
      var isLoading = false;
      late StateSetter setParentState;
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        _wrapWithApp(
          StatefulBuilder(
            builder: (context, setState) {
              setParentState = setState;
              return LoadSwitch.managed(
                value: value,
                isActive: isActive,
                isLoading: isLoading,
                onToggle: () async => !value,
                onChanged: (_) {},
              );
            },
          ),
        ),
      );

      setParentState(() {
        value = true;
        isActive = false;
        isLoading = true;
      });
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        tester.getSemantics(find.byType(LoadSwitch)),
        matchesSemantics(
          hasToggledState: true,
          isToggled: true,
          hasEnabledState: true,
          isEnabled: false,
          isFocusable: true,
        ),
      );

      semantics.dispose();
    });

    testWidgets('thumbSizeRatio constrains spinner size', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.managed(
            value: false,
            isLoading: true,
            style: SpinStyle.ring,
            height: 40,
            thumbSizeRatio: 0.5,
            onToggle: () async => true,
            onChanged: (_) {},
          ),
        ),
      );

      final spinnerSize = tester.getSize(find.byType(SpinKitRing));
      expect(spinnerSize.width, closeTo(20, 0.1));
      expect(spinnerSize.height, closeTo(20, 0.1));
    });

    testWidgets(
        'cupertino spinner uses the thumb size rather than stroke width', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.managed(
            value: false,
            isLoading: true,
            style: SpinStyle.cupertino,
            height: 50,
            onToggle: () async => true,
            onChanged: (_) {},
          ),
        ),
      );

      final spinnerSize =
          tester.getSize(find.byType(CupertinoActivityIndicator));
      expect(spinnerSize.width, greaterThan(10));
      expect(spinnerSize.height, greaterThan(10));
      expect(spinnerSize.width, lessThanOrEqualTo(50));
      expect(spinnerSize.height, lessThanOrEqualTo(50));
    });

    testWidgets('all spin styles build without throwing', (
      WidgetTester tester,
    ) async {
      for (final style in SpinStyle.values) {
        await tester.pumpWidget(
          _wrapWithApp(
            LoadSwitch.managed(
              value: false,
              isLoading: true,
              style: style,
              onToggle: () async => true,
              onChanged: (_) {},
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(LoadSwitch), findsOneWidget, reason: style.name);
        expect(tester.takeException(), isNull, reason: style.name);
      }
    });

    testWidgets('exposes toggled and enabled switch semantics', (
      WidgetTester tester,
    ) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.managed(
            value: false,
            onToggle: () async => true,
            onChanged: (_) {},
          ),
        ),
      );

      expect(
        tester.getSemantics(find.byType(LoadSwitch)),
        matchesSemantics(
          hasToggledState: true,
          isToggled: false,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
        ),
      );

      semantics.dispose();
    });

    testWidgets('keyboard activation toggles the switch', (
      WidgetTester tester,
    ) async {
      bool value = false;

      await tester.pumpWidget(
        _wrapWithApp(
          StatefulBuilder(
            builder: (context, setState) {
              return FocusTraversalGroup(
                child: LoadSwitch.managed(
                  value: value,
                  onToggle: () async => !value,
                  onChanged: (nextValue) {
                    setState(() {
                      value = nextValue;
                    });
                  },
                ),
              );
            },
          ),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();

      expect(value, isTrue);
    });
  });
}

Widget _wrapWithApp(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}
