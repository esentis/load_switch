### [3.1.0] Lifecycle, accessibility and spinner fixes

#### Bug fixes

- Fixes a caller-owned `LoadSwitchController` being left loading forever when a
  `LoadSwitch.controlled` was disposed, changed mode, or had its controller
  swapped while an async toggle was still in flight. The widget now tracks the
  controller whose loading state it switched on and always hands it back
- Fixes a managed switch staying loading forever after being rebuilt from
  `isLoading: true` back to the default. An omitted `isLoading` now means "not
  loading" instead of "do not synchronize"; loading driven by the widget's own
  toggle is tracked separately and is unaffected
- `SpinStyle.cupertino` now honors `spinColor` instead of ignoring it
- `SpinStyle.waveSpinner` now renders `SpinKitWaveSpinner` instead of
  duplicating `SpinStyle.waveStart`

#### UI and accessibility

- The thumb now uses directional alignment, so the switch lays out correctly in
  right-to-left locales
- Inactive switches are reachable by keyboard, so keyboard users get the same
  `onTap` feedback pointer users already had
- Adds a keyboard focus indicator, plus `focusNode`, `autofocus` and
  `focusColor`
- Adds `semanticLabel`, `loadingSemanticHint` and `disabledSemanticHint` for
  configurable screen reader announcements

#### Quality

- Constructors now reject non-positive or non-finite `width`, `height` and
  `spinStrokeWidth`, and negative animation durations
- Documents that `spinnerAnimationDuration` does not affect the native Material
  and Cupertino indicators, which animate at a fixed rate
- Adds `LoadSwitchController.clearLoadingAfterFrame()`, used by the widget to
  release loading during teardown without notifying listeners while the widget
  tree is locked
- Test suite grown from 23 to 47 tests; core library is now at 100% line
  coverage

### [3.0.0] Major cleanup

#### Breaking API changes

- Replaces the overloaded `LoadSwitch` constructor with explicit
  `LoadSwitch.managed` and `LoadSwitch.controlled` modes
- Renames `future` to `onToggle` and `onChange` to `onChanged`
- Splits `animationDuration` into `switchAnimationDuration` and
  `spinnerAnimationDuration`
- Changes `onError` to include both `Object` and `StackTrace`
- Aligns `LoadSwitchController.executeWithLoading()` naming with the widget API

#### Bug fixes

- Fixes controller ownership bugs when swapping between managed and controlled
  modes
- Hardens async updates against dispose and stale controller writes
- Prevents managed switches from becoming tappable again after a parent rebuild
  while an async toggle is still in flight
- Fixes spinner sizing, including the Cupertino spinner radius

#### UI and accessibility

- Adds keyboard activation support
- Uses proper switch-style `toggled` semantics instead of checkbox-style
  semantics

#### Quality and tooling

- Expands tests to cover controller behavior, lifecycle, async regressions,
  semantics, and all spinner styles
- Raises the minimum supported SDKs to Dart 3.6 and Flutter 3.27

#### Docs and examples

- Updates the README and examples for the new API
- Migration guide for the breaking changes is available in the README

### [2.2.1] Bug fixes

- Removes redundant `AnimationControllers` from toggle styles
- Internal code cleanup and optimizations
- Improves examples

### [2.2.0] Controller Support

- Adds `LoadSwitchController` for programmatic control of the switch
- Switch now supports both controlled and uncontrolled modes
- Controller features:
  - Programmatic value toggling via `toggle()` method
  - Loading state management via `executeWithLoading()`
  - External observation of state changes via `addListener()`
  - Programmatic control of active state
- Example usage with controller pattern included

### [2.1.1] Refactor deprecated code

- Replace `withOpacity` with `withValues`

### [2.1.0] New spin styles

- New parameter `style`. The library extends [flutter_spinkit](https://pub.dev/packages/flutter_spinkit) internally adding some fancy spin animations. Keep in mind you can also edit the `thumbDecoration` & `switchDecoration` for different color & shapes. The examples have the default circular thumb with white color. The default style is `SpinStyle.material`.

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

### [2.0.9]

- `onError(error)` : Callback when the Future throws an error
- Internal code optimization and clean up

### [2.0.8] Bug fixes

- `onTap(bool)` : Will always trigger even if the toggle is not active

### [2.0.7] Bug fixes

- `onTap(bool)` will trigger before the future, the `bool` is the value of the switch when tapped
- `onChange(bool)` will trigger after the future, the `bool` is the response of the future

### [2.0.6] New features

- Adds new parameter `isActive` to choose whether the toggle is active and can be interacted
- Tweaks `switchDecoration` & `thumbDecoration` to also expose the activity status

### [2.0.5] Fixes screenshots

### [2.0.4] Adds screenshots & Allows higher than 3.0.0 SDK version

### [2.0.3] New features

- Adds `thumbSizeRatio` (0 - 1) to control the size of the thumb

Default:

<img src="https://i.imgur.com/LdHfQU4.png" width="350px"></img>

`thumbSizeRation = 0.8`

<img src="https://i.imgur.com/0FJ185A.png" width="350px"></img>

### [2.0.2] New features

- Adds `isLoading` flag to manually change the loading state when needed

### [2.0.1] Bug fixes

- Fixes switch not updating when `value` was changed

### [2.0.0] Breaking changes

- Simplifies API by removing redundant parameters.
- Fixes dimension issues when specifying height and width to the switch.
- Removes tests for now

Check the README for the examples.

### [1.2.0] Adds tests

### [1.1.1] Minor changes

- Updates flutter_lints dependency

### [1.1.0] Breaking change

- Removes unnecessary parent widgets (`Scaffold` & `Center`).

### [1.0.1]

- Removes forgotten print outputs.

### [1.0.0]

- Initial release
