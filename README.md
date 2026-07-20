<p align="center">
<img src='https://i.imgur.com/i3rb7YT.gif'>
</p>
<p align="center">
 <img src="https://img.shields.io/pub/v/load_switch?color=637d0d&style=for-the-badge&logo=flutter" alt="Version" /> <img src="https://img.shields.io/github/languages/code-size/esentis/load_switch?color=637d0d&style=for-the-badge&label=size" alt="Version" /></br><img src="https://github.com/esentis/load_switch/actions/workflows/publish.yml/badge.svg" alt="Publish to Pub.dev" />
</br>
</p>

<p align="center">
Show some love by dropping a ⭐ at GitHub </br>
<a href="https://github.com/esentis/load_switch/stargazers"><img src="https://img.shields.io/github/stars/esentis/load_switch?style=for-the-badge&logo=github&color=637d0d" alt="HTML tutorial"></a>

## Managed mode

Use `LoadSwitch.managed` when your widget tree owns the current value and the
switch should manage its own loading lifecycle around an async toggle.

```dart
bool value = false;

Future<bool> _toggle() async {
  await Future.delayed(const Duration(seconds: 2));
  return !value;
}

LoadSwitch.managed(
  value: value,
  onToggle: _toggle,
  onChanged: (nextValue) {
    setState(() {
      value = nextValue;
    });
  },
  onTap: (currentValue) {
    debugPrint('Tapped while value was $currentValue');
  },
)
```

## Controlled mode

Use `LoadSwitch.controlled` when an external `LoadSwitchController` owns the
widget state.

```dart
final controller = LoadSwitchController(initialValue: false);

LoadSwitch.controlled(
  controller: controller,
  onToggle: () async {
    await Future.delayed(const Duration(seconds: 1));
    return !controller.value;
  },
  onChanged: (nextValue) {
    debugPrint('Controller updated to $nextValue');
  },
  onError: (error, stackTrace) {
    debugPrint('Toggle failed: $error');
  },
)
```

## Styling

```dart
LoadSwitch.managed(
  value: value,
  onToggle: _toggle,
  onChanged: (nextValue) => setState(() => value = nextValue),
  curveIn: Curves.easeInBack,
  curveOut: Curves.easeOutBack,
  switchAnimationDuration: const Duration(milliseconds: 500),
  spinnerAnimationDuration: const Duration(milliseconds: 900),
  switchDecoration: (value, isActive) => BoxDecoration(
    color: isActive
        ? value
            ? Colors.green[100]
            : Colors.red[100]
        : Colors.grey[300],
    borderRadius: BorderRadius.circular(30),
  ),
  thumbDecoration: (value, isActive) => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(
        color: isActive
            ? value
                ? Colors.green.withValues(alpha: 0.2)
                : Colors.red.withValues(alpha: 0.2)
            : Colors.grey,
        blurRadius: 7,
        offset: const Offset(0, 3),
      ),
    ],
  ),
  spinColor: (value) => value
      ? const Color.fromARGB(255, 41, 232, 31)
      : const Color.fromARGB(255, 255, 77, 77),
)
```

## Accessibility

The switch ships with switch-style semantics, keyboard activation (Enter and
Space) and a focus indicator. Inactive switches stay reachable by keyboard so
`onTap` can explain why they cannot be toggled, exactly as it does for taps.

```dart
LoadSwitch.managed(
  value: value,
  isActive: hasAccount,
  onToggle: _toggle,
  onChanged: (nextValue) => setState(() => value = nextValue),
  onTap: (_) => _showReason(),
  focusNode: _focusNode,
  autofocus: true,
  focusColor: Colors.indigo,
  semanticLabel: 'Notifications',
  loadingSemanticHint: 'Saving your preference',
  disabledSemanticHint: 'Sign in to change this',
)
```

The thumb is aligned directionally, so the switch mirrors itself automatically
in right-to-left locales.

## Controller features

You can use the `LoadSwitchController` to control and listen to the switch's state.

| Feature                        | Description                                                    |
| ------------------------------ | -------------------------------------------------------------- |
| `toggle()`                     | Toggle the switch value programmatically                       |
| `executeWithLoading(onToggle)` | Run an async operation with automatic loading state management |
| `value` (get/set)              | Get or set the current switch value                            |
| `isLoading` (get/set)          | Get or set the loading state                                   |
| `isActive` (get/set)           | Get or set whether the switch is active                        |
| `addListener(listener)`        | Listen to state changes in the controller                      |
| `clearLoadingAfterFrame()`     | Clear loading from widget teardown, notifying after the frame  |
| `dispose()`                    | Clean up resources when no longer needed                       |

## Spin styles

The library extends [flutter_spinkit](https://pub.dev/packages/flutter_spinkit) internally adding some fancy spin animations. Keep in mind you can also edit the `thumbDecoration` & `switchDecoration` for different color & shapes. The examples have the default circular thumb with white color. The default style is `SpinStyle.material`.

`SpinStyle.material` and `SpinStyle.cupertino` render the platform's own
indicators, which animate at a fixed rate, so `spinnerAnimationDuration` only
affects the remaining SpinKit backed styles.

| material                                                | cupertino                                                 | chasingDots                                                   |
| ------------------------------------------------------- | --------------------------------------------------------- | ------------------------------------------------------------- |
| ![material](https://i.imgur.com/i80tb2n.gif "material") | ![cupertino](https://i.imgur.com/ciOjjIx.gif "cupertino") | ![chasingDots](https://i.imgur.com/VnVZ7yW.gif "chasingDots") |

| circle                                              | cubeGrid                                                | dancingSquare                                                     |
| --------------------------------------------------- | ------------------------------------------------------- | ----------------------------------------------------------------- |
| ![circle](https://i.imgur.com/ePBR9xB.gif "circle") | ![cubeGrid](https://i.imgur.com/HhoyjuA.gif "cubeGrid") | ![dancingSquare](https://i.imgur.com/huQGF7f.gif "dancingSquare") |

| doubleBounce                                                    | dualRing                                                | fadingCircle                                                    |
| --------------------------------------------------------------- | ------------------------------------------------------- | --------------------------------------------------------------- |
| ![doubleBounce](https://i.imgur.com/XoNKCUb.gif "doubleBounce") | ![dualRing](https://i.imgur.com/YODTtaw.gif "dualRing") | ![fadingCircle](https://i.imgur.com/xMFMI6F.gif "fadingCircle") |

| fadingCube                                                  | fadingFour                                                  | fadingGrid                                                  |
| ----------------------------------------------------------- | ----------------------------------------------------------- | ----------------------------------------------------------- |
| ![fadingCube](https://i.imgur.com/s6jqcBy.gif "fadingCube") | ![fadingFour](https://i.imgur.com/1gL9G70.gif "fadingFour") | ![fadingGrid](https://i.imgur.com/HLHTVRw.gif "fadingGrid") |

| foldingCube                                                   | hourGlass                                                 | pianoWave                                                 |
| ------------------------------------------------------------- | --------------------------------------------------------- | --------------------------------------------------------- |
| ![foldingCube](https://i.imgur.com/OfOx9Ta.gif "foldingCube") | ![hourGlass](https://i.imgur.com/XuOZMuo.gif "hourGlass") | ![pianoWave](https://i.imgur.com/4omcY6m.gif "pianoWave") |

| pouringHourGlass                                                        | pulse                                             | pulsingGrid                                                   |
| ----------------------------------------------------------------------- | ------------------------------------------------- | ------------------------------------------------------------- |
| ![pouringHourGlass](https://i.imgur.com/qaDYkEk.gif "pouringHourGlass") | ![pulse](https://i.imgur.com/XviSAH5.gif "pulse") | ![pulsingGrid](https://i.imgur.com/XkvLuSm.gif "pulsingGrid") |

| pumpingHeart                                                    | ring                                            | ripple                                              |
| --------------------------------------------------------------- | ----------------------------------------------- | --------------------------------------------------- |
| ![pumpingHeart](https://i.imgur.com/J6jG4pT.gif "pumpingHeart") | ![ring](https://i.imgur.com/nDKRcu9.gif "ring") | ![ripple](https://i.imgur.com/Cdz31l9.gif "ripple") |

| rotatingCircle                                                      | rotatingPlain                                                     | spinningCircle                                                      |
| ------------------------------------------------------------------- | ----------------------------------------------------------------- | ------------------------------------------------------------------- |
| ![rotatingCircle](https://i.imgur.com/HFmZVvd.gif "rotatingCircle") | ![rotatingPlain](https://i.imgur.com/ZRw7ZAk.gif "rotatingPlain") | ![spinningCircle](https://i.imgur.com/7EvBfP4.gif "spinningCircle") |

| spinningLines                                                     | squareCircle                                                    | threeBounce                                                   |
| ----------------------------------------------------------------- | --------------------------------------------------------------- | ------------------------------------------------------------- |
| ![spinningLines](https://i.imgur.com/bZdiHNM.gif "spinningLines") | ![squareCircle](https://i.imgur.com/OBJsoEO.gif "squareCircle") | ![threeBounce](https://i.imgur.com/suMlo79.gif "threeBounce") |

| threeInOut                                                  | wanderingCubes                                                      | waveStart                                                 |
| ----------------------------------------------------------- | ------------------------------------------------------------------- | --------------------------------------------------------- |
| ![threeInOut](https://i.imgur.com/Vz4QCWh.gif "threeInOut") | ![wanderingCubes](https://i.imgur.com/S7W2jHT.gif "wanderingCubes") | ![waveStart](https://i.imgur.com/Tnlsbdo.gif "waveStart") |

| waveCenter                                                  | waveEnd                                               | waveSpinner                                                   |
| ----------------------------------------------------------- | ----------------------------------------------------- | ------------------------------------------------------------- |
| ![waveCenter](https://i.imgur.com/MX7SHbN.gif "waveCenter") | ![waveEnd](https://i.imgur.com/BMLUprM.gif "waveEnd") | ![waveSpinner](https://i.imgur.com/9geWUc6.gif "waveSpinner") |

## Issues / Features

Found a bug or want a new feature? Open an issue in the [Github repository](https://github.com/esentis/load_switch/issues/new/choose) of the project.

## Migration guide

`3.0.0` includes breaking API changes. Use the mapping below to migrate from
`2.x`.

### 1. Pick the right constructor

Old:

```dart
LoadSwitch(
  value: value,
  future: _toggle,
  onChange: (nextValue) {
    setState(() {
      value = nextValue;
    });
  },
)
```

New managed mode:

```dart
LoadSwitch.managed(
  value: value,
  onToggle: _toggle,
  onChanged: (nextValue) {
    setState(() {
      value = nextValue;
    });
  },
)
```

New controlled mode:

```dart
final controller = LoadSwitchController(initialValue: false);

LoadSwitch.controlled(
  controller: controller,
  onToggle: () async => !controller.value,
  onChanged: (nextValue) {
    debugPrint('Updated to $nextValue');
  },
)
```

### 2. Rename the changed parameters

| `2.x`               | `3.0.0`                   |
| ------------------- | ------------------------- |
| `future`            | `onToggle`                |
| `onChange`          | `onChanged`               |
| `animationDuration` | `switchAnimationDuration` |

If you were relying on spinner speed customization, use
`spinnerAnimationDuration`.

### 3. Update `onError`

Old:

```dart
onError: (error) {
  debugPrint(error.toString());
},
```

New:

```dart
onError: (error, stackTrace) {
  debugPrint(error.toString());
},
```

### 4. Decoration callbacks keep the two-argument signature

Use:

```dart
switchDecoration: (value, isActive) => ...,
thumbDecoration: (value, isActive) => ...,
```

If your older code only used `value`, add the unused `isActive` parameter.

### 5. Minimum supported SDKs changed

`3.0.0` now requires:

- Dart `>=3.6.0 <4.0.0`
- Flutter `>=3.27.0`

### 6. Controller API note

`LoadSwitchController.executeWithLoading(...)` now uses the same naming as the
widget API:

```dart
controller.executeWithLoading(
  () async => true,
  onChanged: (value) {},
  onError: (error, stackTrace) {},
);
```
