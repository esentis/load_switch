<p align="center">
<img src='https://i.imgur.com/i3rb7YT.gif'>
</p>
<p align="center">
 <img src="https://img.shields.io/pub/v/load_switch?color=637d0d&style=for-the-badge" alt="Version" /> <img src="https://img.shields.io/github/languages/code-size/esentis/load_switch?color=637d0d&style=for-the-badge&label=size" alt="Version" />
</br>
</p>

## Examples

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

## Issues / Features

Found a bug or want a new feature? Open an issue in the [Github repository](https://github.com/esentis/load_switch/issues/new/choose) of the project.
