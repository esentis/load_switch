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

```dart
bool value = false;

Future<bool> _getFuture() async {
    await Future.delayed(const Duration(seconds: 2));
    return !value;
}
```

### Default

<img src="https://i.imgur.com/pD84Oea.gif" alt="Version" />

```dart
LoadSwitch(
    value: value,
    future: _getFuture,
    style: SpinStyle.material
    onChange: (v) {
        value = v;
        print('Value changed to $v');
        setState(() {});
    },
    onTap: (v) {
        print('Tapping while value is $v');
    },
)
```

### Custom

<img src="https://i.imgur.com/sSecDrP.gif" alt="Version" />

```dart
LoadSwitch(
value: value,
future: _getFuture,
style: SpinStyle.material
curveIn: Curves.easeInBack,
curveOut: Curves.easeOutBack,
animationDuration: const Duration(milliseconds: 500),
switchDecoration: (value) => BoxDecoration(
    color: value ? Colors.green[100] : Colors.red[100],
    borderRadius: BorderRadius.circular(30),
    shape: BoxShape.rectangle,
    boxShadow: [
    BoxShadow(
        color: value
            ? Colors.green.withOpacity(0.2)
            : Colors.red.withOpacity(0.2),
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
thumbDecoration: (value) => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
    shape: BoxShape.rectangle,
    boxShadow: [
    BoxShadow(
        color: value
            ? Colors.green.withOpacity(0.2)
            : Colors.red.withOpacity(0.2),
        spreadRadius: 5,
        blurRadius: 7,
        offset: const Offset(0, 3), // changes position of shadow
    ),
    ],
),
onChange: (v) {
    value = v;
    print('Value changed to $v');
    setState(() {});
},
onTap: (v) {
    print('Tapping while value is $v');
},
),
```

## Spin styles

The library extends [flutter_spinkit](https://pub.dev/packages/flutter_spinkit) internally adding some fancy spin animations. Keep in mind you can also edit the `thumbDecoration` & `switchDecoration` for different color & shapes. The examples have the default circular thumb with white color. The default style is `SpinStyle.material`.

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
