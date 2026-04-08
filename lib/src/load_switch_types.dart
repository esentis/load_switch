typedef LoadSwitchToggleCallback = Future<bool> Function();

typedef LoadSwitchErrorCallback = void Function(
  Object error,
  StackTrace stackTrace,
);
