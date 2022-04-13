<p align="center">
<img src='https://i.imgur.com/i3rb7YT.gif'>
</p>
<p align="center">
 <img src="https://img.shields.io/pub/v/load_switch?color=637d0d&style=for-the-badge" alt="Version" /> <img src="https://img.shields.io/github/languages/code-size/esentis/load_switch?color=637d0d&style=for-the-badge&label=size" alt="Version" />
</br>
</p>

## Minimal code

```dart
bool value = false;

Future<bool> _getFuture() async {
    await Future.delayed(const Duration(seconds: 2));
    return !value;
}

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

## Issues / Features

Found a bug or want a new feature? Open an issue in the [Github repository](https://github.com/esentis/load_switch/issues/new/choose) of the project.
