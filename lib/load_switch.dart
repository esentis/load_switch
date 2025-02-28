library load_switch;

import 'package:flutter/material.dart';
import 'package:load_switch/spinner.dart';

enum SpinStyle {
  material,
  cupertino,
  chasingDots,
  circle,
  cubeGrid,
  dancingSquare,
  doubleBounce,
  dualRing,
  fadingCircle,
  fadingCube,
  fadingFour,
  fadingGrid,
  foldingCube,
  hourGlass,
  pianoWave,
  pouringHourGlass,
  pulse,
  pulsingGrid,
  pumpingHeart,
  ring,
  ripple,
  rotatingCircle,
  rotatingPlain,
  spinningCircle,
  spinningLines,
  squareCircle,
  threeBounce,
  threeInOut,
  wanderingCubes,
  waveStart,
  waveCenter,
  waveEnd,
  waveSpinner,
}

class LoadSwitch extends StatefulWidget {
  const LoadSwitch({
    required this.value,
    required this.future,
    required this.onChange,
    required this.onTap,
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
    this.isActive = true,
    Key? key,
  })  : assert(width >= height, "Width can't be less than the height."),
        assert(thumbSizeRatio > 0 && thumbSizeRatio <= 1,
            "Thumb size ratio must be between 0 and 1."),
        super(key: key);

  /// The width of the switch. Must be greater or equal to height. Defaults to 95.
  final double width;

  /// The height of the switch. Must be less or equal to width. Defaults to 50.
  final double height;

  /// The main [Future] with [bool] return type, which triggers when tapping the switch.
  ///
  /// The returned value represents the new state of the switch.
  final Future<bool> Function() future;

  /// The width of the loading spinner. Defaults to 2.
  final double spinStrokeWidth;

  /// The color of the loading spinner.
  final Color Function(bool value)? spinColor;

  /// The callback when [future] has finished loading. Returns the response [bool] of the [future].
  final Function(bool) onChange;

  /// Tap callback which returns the current value of the switch.
  final Function(bool) onTap;

  /// Current value of the switch.
  final bool value;

  /// The duration of the switch animation. Defaults to 250ms.
  final Duration? animationDuration;

  /// The curve of the switch animation when going in loading state.
  final Curve? curveIn;

  /// The curve of the switch animation when going out loading state.
  final Curve? curveOut;

  /// The decoration of the thumb.
  final Decoration Function(bool value, bool isActive)? switchDecoration;

  /// The decoration of the thumb.
  final Decoration Function(bool value, bool isActive)? thumbDecoration;

  /// Manually change the loading state of the switch.
  final bool? isLoading;

  /// Whether the toggle is active or not. If null, the switch will be active.
  final bool isActive;

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
  late ValueNotifier<bool> _isLoading;
  late ValueNotifier<bool> _switchValue;

  @override
  void initState() {
    super.initState();
    _switchValue = ValueNotifier(widget.value);
    _isLoading = ValueNotifier(widget.isLoading ?? false);
  }

  @override
  void didUpdateWidget(LoadSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value ||
        oldWidget.isLoading != widget.isLoading) {
      _switchValue.value = widget.value;
      _isLoading.value = widget.isLoading ?? _isLoading.value;
    }
  }

  Future<void> _handleToggle() async {
    widget.onTap(_switchValue.value);

    if (_isLoading.value || !widget.isActive) {
      return;
    }

    _isLoading.value = true;

    try {
      _switchValue.value = await widget.future.call();
    } catch (error) {
      widget.onError?.call(error);
    } finally {
      _isLoading.value = false;
    }

    widget.onChange(_switchValue.value);
  }

  @override
  Widget build(BuildContext context) {
    final switchSize = widget.height;
    final collapsedWidth = switchSize;
    final expandedWidth = widget.width;

    return GestureDetector(
      onTap: _handleToggle,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isLoading,
        builder: (_, loading, __) {
          final curve = loading
              ? widget.curveIn ?? Curves.easeIn
              : widget.curveOut ?? Curves.easeInOut;
          return AnimatedContainer(
            width: loading ? collapsedWidth : expandedWidth,
            height: switchSize,
            duration:
                widget.animationDuration ?? const Duration(milliseconds: 250),
            curve: curve,
            decoration: widget.switchDecoration
                    ?.call(_switchValue.value, widget.isActive) ??
                _defaultSwitchDecoration(
                    _switchValue.value, widget.isActive, switchSize),
            child: ValueListenableBuilder<bool>(
              valueListenable: _switchValue,
              builder: (_, value, __) {
                final thumbSize = switchSize * widget.thumbSizeRatio;
                final thumbPadding = (switchSize - thumbSize) / 2;
                return Stack(
                  children: [
                    AnimatedAlign(
                      alignment: loading
                          ? Alignment.center
                          : value
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                      duration: widget.animationDuration ??
                          const Duration(milliseconds: 250),
                      curve: curve,
                      child: Padding(
                        padding: EdgeInsets.all(thumbPadding),
                        child: _buildThumb(loading, value, thumbSize, this),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
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

  Widget _buildThumb(
      bool loading, bool value, double size, TickerProvider vsync) {
    return Container(
      width: size,
      height: size,
      decoration: widget.thumbDecoration?.call(value, widget.isActive) ??
          BoxDecoration(
            color: loading ? Colors.white : Colors.white,
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
              vsync: vsync,
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
