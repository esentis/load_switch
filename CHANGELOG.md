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
