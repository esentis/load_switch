import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:load_switch/src/load_switch_controller.dart';
import 'package:load_switch/src/load_switch_types.dart';
import 'package:load_switch/src/spin_styles.dart';
import 'package:load_switch/src/spinner.dart';

enum _LoadSwitchMode { managed, controlled }

@immutable
class LoadSwitch extends StatefulWidget {
  const LoadSwitch.managed({
    required this.value,
    required this.onToggle,
    required this.onChanged,
    this.onTap,
    this.style = SpinStyle.material,
    this.onError,
    this.width = 95,
    this.height = 50,
    this.spinColor,
    this.spinStrokeWidth = 2,
    this.thumbSizeRatio = 1,
    this.switchAnimationDuration = const Duration(milliseconds: 250),
    this.spinnerAnimationDuration = const Duration(milliseconds: 1200),
    this.thumbDecoration,
    this.switchDecoration,
    this.curveIn,
    this.curveOut,
    this.isLoading,
    this.isActive = true,
    super.key,
  })  : _mode = _LoadSwitchMode.managed,
        controller = null,
        assert(width >= height, "Width can't be less than the height."),
        assert(
          thumbSizeRatio > 0 && thumbSizeRatio <= 1,
          'Thumb size ratio must be between 0 and 1.',
        );

  const LoadSwitch.controlled({
    required this.controller,
    this.onToggle,
    this.onChanged,
    this.onTap,
    this.style = SpinStyle.material,
    this.onError,
    this.width = 95,
    this.height = 50,
    this.spinColor,
    this.spinStrokeWidth = 2,
    this.thumbSizeRatio = 1,
    this.switchAnimationDuration = const Duration(milliseconds: 250),
    this.spinnerAnimationDuration = const Duration(milliseconds: 1200),
    this.thumbDecoration,
    this.switchDecoration,
    this.curveIn,
    this.curveOut,
    super.key,
  })  : _mode = _LoadSwitchMode.controlled,
        value = null,
        isLoading = null,
        isActive = null,
        assert(width >= height, "Width can't be less than the height."),
        assert(
          thumbSizeRatio > 0 && thumbSizeRatio <= 1,
          'Thumb size ratio must be between 0 and 1.',
        );

  final _LoadSwitchMode _mode;

  /// Controller to manage the switch state programmatically.
  ///
  /// This is required for [LoadSwitch.controlled] and unused for
  /// [LoadSwitch.managed].
  final LoadSwitchController? controller;

  /// Current value of the switch in managed mode.
  final bool? value;

  /// The async action triggered when the switch is toggled.
  ///
  /// If null in controlled mode, tapping the widget toggles the controller
  /// immediately without entering a loading state.
  final LoadSwitchToggleCallback? onToggle;

  /// Called after the switch value changes.
  final ValueChanged<bool>? onChanged;

  /// Tap callback which returns the current value of the switch before toggling.
  final ValueChanged<bool>? onTap;

  /// The width of the switch. Must be greater than or equal to height.
  final double width;

  /// The height of the switch. Must be less than or equal to width.
  final double height;

  /// The width of the loading spinner stroke.
  final double spinStrokeWidth;

  /// The color of the loading spinner.
  final Color Function(bool value)? spinColor;

  /// The duration of the switch animation.
  final Duration switchAnimationDuration;

  /// The duration of the spinner animation.
  final Duration spinnerAnimationDuration;

  /// The curve of the switch animation when going into the loading state.
  final Curve? curveIn;

  /// The curve of the switch animation when going out of the loading state.
  final Curve? curveOut;

  /// The decoration of the switch.
  final Decoration Function(bool value, bool isActive)? switchDecoration;

  /// The decoration of the thumb.
  final Decoration Function(bool value, bool isActive)? thumbDecoration;

  /// Manually change the loading state of the switch in managed mode.
  final bool? isLoading;

  /// Whether the toggle is active in managed mode.
  final bool? isActive;

  /// The ratio of the thumb size to the switch size.
  final double thumbSizeRatio;

  /// The callback when an error occurs during the toggle execution.
  final LoadSwitchErrorCallback? onError;

  /// The style of the loading spinner.
  final SpinStyle style;

  @override
  State<LoadSwitch> createState() => _LoadSwitchState();
}

class _LoadSwitchState extends State<LoadSwitch> {
  static const Map<ShortcutActivator, Intent> _activationShortcuts =
      <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
    SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
  };

  late LoadSwitchController _controller;
  int _toggleOperationId = 0;
  bool _isManagedToggleInProgress = false;

  @override
  void initState() {
    super.initState();
    _controller = _resolveController();
    _syncManagedController();
  }

  LoadSwitchController _resolveController() {
    if (widget._mode == _LoadSwitchMode.controlled) {
      return widget.controller!;
    }
    return LoadSwitchController(
      initialValue: widget.value!,
      isLoading: widget.isLoading ?? false,
      isActive: widget.isActive ?? true,
    );
  }

  void _syncManagedController() {
    if (widget._mode != _LoadSwitchMode.managed) {
      return;
    }

    if (_controller.value != widget.value) {
      _controller.value = widget.value!;
    }

    final isLoading = widget.isLoading;
    if (isLoading != null && _controller.isLoading != isLoading) {
      _controller.isLoading = isLoading;
    }

    if (_controller.isActive != widget.isActive) {
      _controller.isActive = widget.isActive!;
    }
  }

  @override
  void didUpdateWidget(LoadSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    final controllerChanged = widget._mode != oldWidget._mode ||
        (widget._mode == _LoadSwitchMode.controlled &&
            !identical(widget.controller, oldWidget.controller));

    if (controllerChanged) {
      final previousController = _controller;
      _controller = _resolveController();
      _toggleOperationId++;
      _isManagedToggleInProgress = false;

      if (oldWidget._mode == _LoadSwitchMode.managed) {
        previousController.dispose();
      }
    }

    _syncManagedController();
  }

  Future<void> _handleToggle() async {
    final controller = _controller;
    if (_isLoading(controller) || !controller.isActive) {
      return;
    }

    widget.onTap?.call(controller.value);

    final onToggle = widget.onToggle;
    if (onToggle == null) {
      final previousValue = controller.value;
      controller.toggle();
      if (controller.value != previousValue) {
        widget.onChanged?.call(controller.value);
      }
      return;
    }

    final operationId = ++_toggleOperationId;
    if (widget._mode == _LoadSwitchMode.managed) {
      setState(() {
        _isManagedToggleInProgress = true;
      });
    } else {
      controller.isLoading = true;
    }

    try {
      final nextValue = await onToggle();
      if (!_isCurrentOperation(controller, operationId)) {
        return;
      }
      controller.value = nextValue;
      widget.onChanged?.call(nextValue);
    } catch (error, stackTrace) {
      if (_isCurrentOperation(controller, operationId)) {
        widget.onError?.call(error, stackTrace);
      }
    } finally {
      if (_isCurrentOperation(controller, operationId)) {
        if (widget._mode == _LoadSwitchMode.managed) {
          setState(() {
            _isManagedToggleInProgress = false;
          });
        } else {
          controller.isLoading = false;
        }
      }
    }
  }

  bool _isLoading(LoadSwitchController controller) {
    return controller.isLoading || _isManagedToggleInProgress;
  }

  bool _isCurrentOperation(LoadSwitchController controller, int operationId) {
    return mounted &&
        identical(_controller, controller) &&
        _toggleOperationId == operationId;
  }

  @override
  void dispose() {
    _toggleOperationId++;
    _isManagedToggleInProgress = false;
    if (widget._mode == _LoadSwitchMode.managed) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final switchSize = widget.height;
    final collapsedWidth = switchSize;
    final expandedWidth = widget.width;
    final thumbSize = switchSize * widget.thumbSizeRatio;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final value = _controller.value;
        final loading = _isLoading(_controller);
        final isActive = _controller.isActive;
        final isEnabled = !loading && isActive;

        return Semantics(
          container: true,
          toggled: value,
          enabled: isEnabled,
          focusable: true,
          onTap: isEnabled ? _handleToggle : null,
          child: FocusableActionDetector(
            enabled: isEnabled,
            mouseCursor:
                isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
            shortcuts: _activationShortcuts,
            actions: <Type, Action<Intent>>{
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (intent) {
                  _handleToggle();
                  return null;
                },
              ),
            },
            child: GestureDetector(
              excludeFromSemantics: true,
              behavior: HitTestBehavior.opaque,
              onTap: isEnabled ? _handleToggle : null,
              child: AnimatedContainer(
                width: loading ? collapsedWidth : expandedWidth,
                height: switchSize,
                duration: widget.switchAnimationDuration,
                curve: loading
                    ? widget.curveIn ?? Curves.easeIn
                    : widget.curveOut ?? Curves.easeInOut,
                decoration: widget.switchDecoration?.call(value, isActive) ??
                    _defaultSwitchDecoration(
                      value,
                      isActive,
                      switchSize,
                    ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      alignment: loading
                          ? Alignment.center
                          : value
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                      duration: widget.switchAnimationDuration,
                      curve: loading
                          ? widget.curveIn ?? Curves.easeIn
                          : widget.curveOut ?? Curves.easeInOut,
                      child: Padding(
                        padding: EdgeInsets.all((switchSize - thumbSize) / 2),
                        child: _buildThumb(
                          loading: loading,
                          value: value,
                          isActive: isActive,
                          size: thumbSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _defaultSwitchDecoration(
    bool value,
    bool isActive,
    double switchSize,
  ) {
    return BoxDecoration(
      color: isActive
          ? value
              ? Colors.green
              : Colors.red
          : Colors.grey[300],
      borderRadius: BorderRadius.circular(switchSize / 2),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.2),
          blurRadius: 5,
          spreadRadius: 1,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }

  Widget _buildThumb({
    required bool loading,
    required bool value,
    required bool isActive,
    required double size,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: widget.thumbDecoration?.call(value, isActive) ??
          BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                blurRadius: 5,
                spreadRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
      child: loading
          ? Center(
              child: SpinnerWidget(
                style: widget.style,
                size: size,
                width: widget.spinStrokeWidth,
                color: widget.spinColor?.call(value),
                animationDuration: widget.spinnerAnimationDuration,
              ),
            )
          : null,
    );
  }
}
