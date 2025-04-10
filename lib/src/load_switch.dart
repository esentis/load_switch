library load_switch;

import 'package:flutter/material.dart';
import 'package:load_switch/src/load_switch_controller.dart';
import 'package:load_switch/src/spin_styles.dart';
import 'package:load_switch/src/spinner.dart';

class LoadSwitch extends StatefulWidget {
  const LoadSwitch({
    this.value,
    this.future,
    this.onChange,
    this.onTap,
    this.controller,
    this.style = SpinStyle.material,
    this.onError,
    this.width = 95,
    this.height = 50,
    this.spinColor,
    this.spinStrokeWidth = 2,
    this.thumbSizeRatio = 1,
    this.animationDuration,
    this.thumbDecoration,
    this.switchDecoration,
    this.curveIn,
    this.curveOut,
    this.isLoading,
    this.isActive,
    Key? key,
  })  : assert(width >= height, "Width can't be less than the height."),
        assert(thumbSizeRatio > 0 && thumbSizeRatio <= 1,
            "Thumb size ratio must be between 0 and 1."),
        assert(
            (controller == null &&
                    value != null &&
                    future != null &&
                    onChange != null &&
                    onTap != null) ||
                (controller != null),
            "Either provide a controller or all of value, future, onChange, and onTap"),
        super(key: key);

  /// Controller to manage the switch state programmatically.
  ///
  /// If provided, this controller takes precedence over the other state-related properties.
  final LoadSwitchController? controller;

  /// The width of the switch. Must be greater or equal to height. Defaults to 95.
  final double width;

  /// The height of the switch. Must be less or equal to width. Defaults to 50.
  final double height;

  /// The main [Future] with [bool] return type, which triggers when tapping the switch.
  ///
  /// The returned value represents the new state of the switch.
  final Future<bool> Function()? future;

  /// The width of the loading spinner. Defaults to 2.
  final double spinStrokeWidth;

  /// The color of the loading spinner.
  final Color Function(bool value)? spinColor;

  /// The callback when [future] has finished loading. Returns the response [bool] of the [future].
  final Function(bool)? onChange;

  /// Tap callback which returns the current value of the switch.
  final Function(bool)? onTap;

  /// Current value of the switch.
  final bool? value;

  /// The duration of the switch animation. Defaults to 250ms.
  final Duration? animationDuration;

  /// The curve of the switch animation when going in loading state.
  final Curve? curveIn;

  /// The curve of the switch animation when going out loading state.
  final Curve? curveOut;

  /// The decoration of the switch.
  final Decoration Function(bool value, bool isActive)? switchDecoration;

  /// The decoration of the thumb.
  final Decoration Function(bool value, bool isActive)? thumbDecoration;

  /// Manually change the loading state of the switch.
  final bool? isLoading;

  /// Whether the toggle is active or not. If null, the switch will be active.
  final bool? isActive;

  /// The ratio of the thumb size to the switch size. Defaults to 1.
  final double thumbSizeRatio;

  /// The callback when an error occurs during the [future] execution.
  final Function(Object)? onError;

  /// The style of the loading spinner. Defaults to [SpinStyle.material].
  final SpinStyle style;

  @override
  State<LoadSwitch> createState() => _LoadSwitchState();
}

class _LoadSwitchState extends State<LoadSwitch> with TickerProviderStateMixin {
  late LoadSwitchController _controller;
  bool _internalController = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _internalController = true;
      _controller = LoadSwitchController(
        initialValue: widget.value!,
        isLoading: widget.isLoading ?? false,
        isActive: widget.isActive ?? true,
      );
    }
    _controller.addListener(_handleControllerChange);
  }

  void _handleControllerChange() {
    setState(() {
      // Update the UI when the controller values change
    });
  }

  @override
  void didUpdateWidget(LoadSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChange);
      _controller.removeListener(_handleControllerChange);

      if (_internalController) {
        _controller.dispose();
      }

      _initializeController();
    } else if (_internalController) {
      // Update internal controller values if they changed externally
      if (widget.value != null && _controller.value != widget.value) {
        _controller.value = widget.value!;
      }
      if (widget.isLoading != null &&
          _controller.isLoading != widget.isLoading) {
        _controller.isLoading = widget.isLoading!;
      }
      if (widget.isActive != null && _controller.isActive != widget.isActive) {
        _controller.isActive = widget.isActive!;
      }
    }
  }

  Future<void> _handleToggle() async {
    if (widget.onTap != null) {
      widget.onTap!(_controller.value);
    }

    if (!_controller.isLoading && _controller.isActive) {
      if (_internalController) {
        _controller.isLoading = true;

        try {
          _controller.value = await widget.future!();
          if (widget.onChange != null) {
            widget.onChange!(_controller.value);
          }
        } catch (error) {
          if (widget.onError != null) {
            widget.onError!(error);
          }
        } finally {
          _controller.isLoading = false;
        }
      } else {
        await _controller.executeWithLoading(
          widget.future ?? () async => !_controller.value,
          onChange: widget.onChange,
          onError: widget.onError,
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChange);
    if (_internalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final switchSize = widget.height;
    final collapsedWidth = switchSize;
    final expandedWidth = widget.width;

    final value = _controller.value;
    final loading = _controller.isLoading;
    final isActive = _controller.isActive;

    return GestureDetector(
      onTap: _handleToggle,
      child: AnimatedContainer(
        width: loading ? collapsedWidth : expandedWidth,
        height: switchSize,
        duration: widget.animationDuration ?? const Duration(milliseconds: 250),
        curve: loading
            ? widget.curveIn ?? Curves.easeIn
            : widget.curveOut ?? Curves.easeInOut,
        decoration: widget.switchDecoration?.call(value, isActive) ??
            _defaultSwitchDecoration(value, isActive, switchSize),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: loading
                  ? Alignment.center
                  : value
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
              duration:
                  widget.animationDuration ?? const Duration(milliseconds: 250),
              curve: loading
                  ? widget.curveIn ?? Curves.easeIn
                  : widget.curveOut ?? Curves.easeInOut,
              child: Padding(
                padding: EdgeInsets.all(
                    (switchSize - (switchSize * widget.thumbSizeRatio)) / 2),
                child: _buildThumb(
                    loading, value, switchSize * widget.thumbSizeRatio),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _defaultSwitchDecoration(
      bool value, bool isActive, double switchSize) {
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

  Widget _buildThumb(bool loading, bool value, double size) {
    return Container(
      width: size,
      height: size,
      decoration: widget.thumbDecoration?.call(value, _controller.isActive) ??
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
          ? buildSpinner(
              style: widget.style,
              vsync: this,
              value: value,
              size: widget.height,
              width: widget.spinStrokeWidth,
              color: widget.spinColor?.call(value),
              animationDuration: widget.animationDuration,
            )
          : null,
    );
  }
}
