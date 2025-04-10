import 'package:flutter/foundation.dart';

/// Controller for managing the state of a [LoadSwitch] widget.
///
/// This controller allows for programmatic control of a [LoadSwitch] widget,
/// including changing the value, loading state, and active state.
class LoadSwitchController extends ChangeNotifier {
  /// Creates a new [LoadSwitchController] with the specified initial values.
  LoadSwitchController({
    bool initialValue = false,
    bool isLoading = false,
    bool isActive = true,
  })  : _value = initialValue,
        _isLoading = isLoading,
        _isActive = isActive;

  bool _value;
  bool _isLoading;
  bool _isActive;

  /// The current value of the switch (on/off).
  bool get value => _value;

  /// Whether the switch is currently in a loading state.
  bool get isLoading => _isLoading;

  /// Whether the switch is currently active and can be interacted with.
  bool get isActive => _isActive;

  /// Sets the value of the switch and notifies listeners.
  set value(bool newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }

  /// Sets the loading state of the switch and notifies listeners.
  set isLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// Sets the active state of the switch and notifies listeners.
  set isActive(bool active) {
    if (_isActive != active) {
      _isActive = active;
      notifyListeners();
    }
  }

  /// Toggles the value of the switch if it's not loading and is active.
  void toggle() {
    if (!_isLoading && _isActive) {
      value = !value;
    }
  }

  /// Executes a future with loading state management.
  ///
  /// Sets [isLoading] to true before executing the future, and to false after
  /// the future completes or throws an error. Updates the value of the switch
  /// based on the result of the future.
  ///
  /// If [onChange] is provided, it will be called with the new value.
  /// If [onError] is provided, it will be called with any error that occurs.
  Future<void> executeWithLoading(
    Future<bool> Function() future, {
    Function(bool)? onChange,
    Function(Object)? onError,
  }) async {
    if (_isLoading || !_isActive) return;

    isLoading = true;

    try {
      value = await future.call();
      onChange?.call(value);
    } catch (error) {
      onError?.call(error);
    } finally {
      isLoading = false;
    }
  }
}
