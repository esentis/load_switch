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

    test('executeWithLoading does not call onChanged when value is unchanged',
        () async {
      final controller = LoadSwitchController(initialValue: true);
      final events = <String>[];

      await controller.executeWithLoading(
        () async => true, // returns the same value as current
        onChanged: (value) {
          events.add('changed:$value');
        },
      );

      expect(controller.value, isTrue);
      expect(events, isEmpty,
          reason: 'onChanged must not fire when the value did not change');
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

    testWidgets(
        'inactive managed switch fires onTap but blocks toggle and onChanged', (
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

      // onTap fires so callers can show feedback (tooltip, snackbar, etc.)
      // explaining why the switch is disabled.
      expect(tapCount, 1);
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

    testWidgets(
        'onChanged is not called when onToggle returns the current value', (
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
                onToggle: () async => false, // returns same value as current
                onChanged: (nextValue) {
                  events.add('changed:$nextValue');
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
      expect(events, isEmpty,
          reason: 'onChanged must not fire when value did not change');
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

  group('LoadSwitch controlled loading ownership', () {
    testWidgets('successful controlled toggle clears loading', (
      WidgetTester tester,
    ) async {
      final controller = LoadSwitchController(initialValue: false);
      final completer = Completer<bool>();
      final changes = <bool>[];

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.controlled(
            controller: controller,
            onToggle: () => completer.future,
            onChanged: changes.add,
          ),
        ),
      );

      await tester.tap(find.byType(LoadSwitch));
      await tester.pump();
      expect(controller.isLoading, isTrue);

      completer.complete(true);
      await tester.pumpAndSettle();

      expect(controller.isLoading, isFalse);
      expect(controller.value, isTrue);
      expect(changes, <bool>[true]);
    });

    testWidgets('failed controlled toggle clears loading and reports error', (
      WidgetTester tester,
    ) async {
      final controller = LoadSwitchController(initialValue: false);
      Object? capturedError;

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.controlled(
            controller: controller,
            onToggle: () async => throw StateError('boom'),
            onError: (error, _) => capturedError = error,
          ),
        ),
      );

      await tester.tap(find.byType(LoadSwitch));
      await tester.pumpAndSettle();

      expect(capturedError, isA<StateError>());
      expect(controller.isLoading, isFalse);
      expect(controller.value, isFalse);
    });

    testWidgets('disposal during a controlled toggle releases the controller', (
      WidgetTester tester,
    ) async {
      final controller = LoadSwitchController(initialValue: false);
      final completer = Completer<bool>();

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.controlled(
            controller: controller,
            onToggle: () => completer.future,
          ),
        ),
      );

      await tester.tap(find.byType(LoadSwitch));
      await tester.pump();
      expect(controller.isLoading, isTrue);

      await tester.pumpWidget(const SizedBox.shrink());
      completer.complete(true);
      await tester.pump();

      expect(
        controller.isLoading,
        isFalse,
        reason: 'a caller-owned controller must not stay loading forever',
      );
      expect(
        controller.value,
        isFalse,
        reason: 'a stale toggle must not write to the controller',
      );
    });

    testWidgets('a controller outliving a mid-toggle unmount stays usable', (
      WidgetTester tester,
    ) async {
      final controller = LoadSwitchController(initialValue: false);
      final completer = Completer<bool>();

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.controlled(
            controller: controller,
            onToggle: () => completer.future,
          ),
        ),
      );

      await tester.tap(find.byType(LoadSwitch));
      await tester.pump();

      await tester.pumpWidget(const SizedBox.shrink());
      completer.complete(true);
      await tester.pump();

      // Remount with the same controller, as a caller returning to the screen.
      await tester.pumpWidget(
        _wrapWithApp(LoadSwitch.controlled(controller: controller)),
      );
      // Deliberately not pumpAndSettle: a stranded spinner animates forever, so
      // settling would time out instead of reporting the actual failure.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        controller.isLoading,
        isFalse,
        reason: 'a remounted switch must not inherit a stranded spinner',
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);

      controller.toggle();
      await tester.pump();
      expect(controller.value, isTrue);
    });

    testWidgets(
        'controller replacement during a controlled toggle releases the old one',
        (
      WidgetTester tester,
    ) async {
      final first = LoadSwitchController(initialValue: false);
      final second = LoadSwitchController(initialValue: false);
      final completer = Completer<bool>();

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.controlled(
            controller: first,
            onToggle: () => completer.future,
          ),
        ),
      );

      await tester.tap(find.byType(LoadSwitch));
      await tester.pump();
      expect(first.isLoading, isTrue);

      await tester.pumpWidget(
        _wrapWithApp(LoadSwitch.controlled(controller: second)),
      );

      expect(
        first.isLoading,
        isFalse,
        reason: 'the swapped-away controller is released immediately',
      );

      completer.complete(true);
      await tester.pump();

      expect(first.isLoading, isFalse);
      expect(first.value, isFalse);
      expect(second.isLoading, isFalse);
      expect(second.value, isFalse);
    });

    testWidgets('mode change from controlled to managed releases the controller',
        (
      WidgetTester tester,
    ) async {
      final controller = LoadSwitchController(initialValue: false);
      final completer = Completer<bool>();

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.controlled(
            controller: controller,
            onToggle: () => completer.future,
          ),
        ),
      );

      await tester.tap(find.byType(LoadSwitch));
      await tester.pump();
      expect(controller.isLoading, isTrue);

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.managed(
            value: false,
            onToggle: () async => true,
            onChanged: (_) {},
          ),
        ),
      );

      expect(controller.isLoading, isFalse);

      completer.complete(true);
      await tester.pump();

      expect(controller.isLoading, isFalse);
    });

    testWidgets('repeated taps while loading run the toggle once', (
      WidgetTester tester,
    ) async {
      final controller = LoadSwitchController(initialValue: false);
      final completer = Completer<bool>();
      var toggleCount = 0;

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.controlled(
            controller: controller,
            onToggle: () {
              toggleCount++;
              return completer.future;
            },
          ),
        ),
      );

      await tester.tap(find.byType(LoadSwitch));
      await tester.pump();
      await tester.tap(find.byType(LoadSwitch), warnIfMissed: false);
      await tester.pump();
      await tester.tap(find.byType(LoadSwitch), warnIfMissed: false);
      await tester.pump();

      expect(toggleCount, 1);

      completer.complete(true);
      await tester.pumpAndSettle();

      expect(toggleCount, 1);
      expect(controller.isLoading, isFalse);
      expect(controller.value, isTrue);
    });

    testWidgets('releasing on teardown tolerates listeners that call setState', (
      WidgetTester tester,
    ) async {
      final controller = LoadSwitchController(initialValue: false);
      final completer = Completer<bool>();
      var showSwitch = true;
      late StateSetter setOuterState;

      await tester.pumpWidget(
        _wrapWithApp(
          StatefulBuilder(
            builder: (context, setState) {
              setOuterState = setState;
              return showSwitch
                  ? LoadSwitch.controlled(
                      controller: controller,
                      onToggle: () => completer.future,
                    )
                  : const SizedBox.shrink();
            },
          ),
        ),
      );

      void listener() => setOuterState(() {});
      controller.addListener(listener);
      addTearDown(() => controller.removeListener(listener));

      await tester.tap(find.byType(LoadSwitch));
      await tester.pump();

      setOuterState(() {
        showSwitch = false;
      });
      await tester.pump();

      completer.complete(true);
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(controller.isLoading, isFalse);
    });
  });

  group('LoadSwitch managed loading sync', () {
    testWidgets('dropping isLoading back to null clears the loading state', (
      WidgetTester tester,
    ) async {
      bool? isLoading = true;
      late StateSetter setParentState;

      await tester.pumpWidget(
        _wrapWithApp(
          StatefulBuilder(
            builder: (context, setState) {
              setParentState = setState;
              return LoadSwitch.managed(
                value: false,
                isLoading: isLoading,
                onToggle: () async => true,
                onChanged: (_) {},
              );
            },
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      setParentState(() {
        isLoading = null;
      });
      // Deliberately not pumpAndSettle: a stranded spinner animates forever, so
      // settling would time out instead of reporting the actual failure.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.byType(CircularProgressIndicator),
        findsNothing,
        reason: 'an omitted isLoading must not strand the switch loading',
      );
    });

    testWidgets('an internal managed toggle survives a parent rebuild', (
      WidgetTester tester,
    ) async {
      final completer = Completer<bool>();
      var rebuildTick = 0;
      late StateSetter setParentState;

      await tester.pumpWidget(
        _wrapWithApp(
          StatefulBuilder(
            builder: (context, setState) {
              setParentState = setState;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('tick:$rebuildTick'),
                  LoadSwitch.managed(
                    value: false,
                    onToggle: () => completer.future,
                    onChanged: (_) {},
                  ),
                ],
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(LoadSwitch));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // A rebuild syncs isLoading to false, but the in-flight toggle must
      // still hold the spinner.
      setParentState(() {
        rebuildTick++;
      });
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(true);
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  group('LoadSwitch spinner styles', () {
    testWidgets('cupertino spinner honors spinColor', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.managed(
            value: false,
            isLoading: true,
            style: SpinStyle.cupertino,
            spinColor: (_) => const Color(0xFFFF9800),
            onToggle: () async => true,
            onChanged: (_) {},
          ),
        ),
      );

      final indicator = tester.widget<CupertinoActivityIndicator>(
        find.byType(CupertinoActivityIndicator),
      );
      expect(indicator.color, const Color(0xFFFF9800));
    });

    testWidgets('waveSpinner renders SpinKitWaveSpinner, not SpinKitWave', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.managed(
            value: false,
            isLoading: true,
            style: SpinStyle.waveSpinner,
            onToggle: () async => true,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(SpinKitWaveSpinner), findsOneWidget);
      expect(find.byType(SpinKitWave), findsNothing);
    });
  });

  group('LoadSwitch accessibility', () {
    testWidgets('thumb follows text direction', (WidgetTester tester) async {
      Future<double> thumbOffsetFor(TextDirection direction) async {
        await tester.pumpWidget(
          _wrapWithApp(
            LoadSwitch.managed(
              value: true,
              onToggle: () async => false,
              onChanged: (_) {},
            ),
            textDirection: direction,
          ),
        );
        await tester.pumpAndSettle();

        final switchCenter = tester.getCenter(find.byType(AnimatedContainer));
        final thumbCenter = tester.getCenter(_thumbFinder());
        return thumbCenter.dx - switchCenter.dx;
      }

      expect(
        await thumbOffsetFor(TextDirection.ltr),
        greaterThan(0),
        reason: 'an on switch puts the thumb at the trailing (right) edge',
      );

      expect(
        await thumbOffsetFor(TextDirection.rtl),
        lessThan(0),
        reason: 'in RTL the trailing edge is on the left',
      );
    });

    testWidgets('inactive switch is keyboard reachable and reports taps', (
      WidgetTester tester,
    ) async {
      var tapCount = 0;
      var toggleCount = 0;

      await tester.pumpWidget(
        _wrapWithApp(
          FocusTraversalGroup(
            child: LoadSwitch.managed(
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
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();

      expect(
        tapCount,
        1,
        reason: 'keyboard users get the same feedback as pointer users',
      );
      expect(toggleCount, 0);
    });

    testWidgets('a focus indicator is drawn while focused', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithApp(
          FocusTraversalGroup(
            child: LoadSwitch.managed(
              value: false,
              onToggle: () async => true,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(_focusRingFinder(), findsNothing);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      expect(_focusRingFinder(), findsOneWidget);
    });

    testWidgets('exposes configurable loading and disabled hints', (
      WidgetTester tester,
    ) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.managed(
            value: false,
            isActive: false,
            semanticLabel: 'Notifications',
            disabledSemanticHint: 'Sign in to change this',
            onToggle: () async => true,
            onChanged: (_) {},
          ),
        ),
      );

      final node = tester.getSemantics(find.byType(LoadSwitch));
      expect(node.label, 'Notifications');
      expect(node.hint, 'Sign in to change this');

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.managed(
            value: false,
            isLoading: true,
            semanticLabel: 'Notifications',
            loadingSemanticHint: 'Saving',
            onToggle: () async => true,
            onChanged: (_) {},
          ),
        ),
      );

      final loadingNode = tester.getSemantics(find.byType(LoadSwitch));
      expect(loadingNode.hint, 'Saving');

      semantics.dispose();
    });

    testWidgets('honors an externally supplied focus node with autofocus', (
      WidgetTester tester,
    ) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.managed(
            value: false,
            focusNode: focusNode,
            autofocus: true,
            onToggle: () async => true,
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, isTrue);
      // The ring tracks the focus *highlight*, which only turns on for keyboard
      // traversal, so autofocus alone must not paint one.
      expect(_focusRingFinder(), findsNothing);
    });
  });

  group('LoadSwitch constructor validation', () {
    LoadSwitch buildManaged({
      double width = 95,
      double height = 50,
      double spinStrokeWidth = 2,
      double thumbSizeRatio = 1,
    }) {
      return LoadSwitch.managed(
        value: false,
        width: width,
        height: height,
        spinStrokeWidth: spinStrokeWidth,
        thumbSizeRatio: thumbSizeRatio,
        onToggle: () async => true,
        onChanged: (_) {},
      );
    }

    test('rejects negative dimensions', () {
      expect(
        () => buildManaged(width: -10, height: -20),
        throwsA(isA<AssertionError>()),
      );
      expect(() => buildManaged(height: -20), throwsA(isA<AssertionError>()));
    });

    test('rejects zero dimensions', () {
      expect(
        () => buildManaged(width: 0, height: 0),
        throwsA(isA<AssertionError>()),
      );
    });

    test('rejects non-finite dimensions', () {
      expect(
        () => buildManaged(width: double.infinity),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => buildManaged(width: double.nan, height: double.nan),
        throwsA(isA<AssertionError>()),
      );
    });

    test('rejects a non-positive spinner stroke width', () {
      expect(
        () => buildManaged(spinStrokeWidth: 0),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => buildManaged(spinStrokeWidth: -1),
        throwsA(isA<AssertionError>()),
      );
    });

    test('still rejects a width smaller than the height', () {
      expect(
        () => buildManaged(width: 20, height: 50),
        throwsA(isA<AssertionError>()),
      );
    });

    test('still rejects an out-of-range thumb size ratio', () {
      expect(
        () => buildManaged(thumbSizeRatio: 0),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => buildManaged(thumbSizeRatio: 1.5),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('rejects negative animation durations', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithApp(
          LoadSwitch.managed(
            value: false,
            switchAnimationDuration: const Duration(milliseconds: -1),
            onToggle: () async => true,
            onChanged: (_) {},
          ),
        ),
      );

      expect(tester.takeException(), isA<AssertionError>());
    });
  });
}

Widget _wrapWithApp(Widget child, {TextDirection? textDirection}) {
  final body = Center(child: child);
  return MaterialApp(
    home: Scaffold(
      body: textDirection == null
          ? body
          : Directionality(textDirection: textDirection, child: body),
    ),
  );
}

/// The thumb is the only [Container] living underneath the [AnimatedAlign].
Finder _thumbFinder() => find.descendant(
      of: find.byType(AnimatedAlign),
      matching: find.byType(Container),
    );

Finder _focusRingFinder() => find.byWidgetPredicate(
      (widget) =>
          widget is DecoratedBox &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).border != null,
    );
