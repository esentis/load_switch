library load_switch;

import 'package:flutter/material.dart';

class LoadSwitch extends StatefulWidget {
  const LoadSwitch({
    required this.value,
    required this.future,
    required this.onChange,
    required this.onTap,
    this.width = 95,
    this.height = 50,
    this.spinColor,
    this.spinStrokeWidth = 2,
    this.animationDuration,
    this.thumbDecoration,
    this.switchDecoration,
    this.curveIn,
    this.curveOut,
    Key? key,
  })  : assert(width >= height, "Width can't be less than the height."),
        super(key: key);

  /// The width of the switch. Must be greater or equal to height. Defaults to 95.
  final double width;

  /// The height of the switch. Must be less or equal to width. Defaults to 50.
  final double height;

  /// The main [Future] with [bool] return type, which triggers when tapping the switch.
  ///
  /// The returned value represents the new state of the switch.
  final Future<bool> Function() future;

  /// The width of the loading spinner.
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
  final Decoration Function(bool value)? switchDecoration;

  /// The decoration of the thumb.
  final Decoration Function(bool value)? thumbDecoration;

  @override
  State<LoadSwitch> createState() => _LoadSwitchState();
}

class _LoadSwitchState extends State<LoadSwitch> {
  bool _loading = false;
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  Future<void> _handleToggle() async {
    setState(() {
      _loading = true;
    });

    _value = await widget.future.call();

    setState(() {
      _loading = false;
    });

    widget.onTap(_value);
  }

  @override
  Widget build(BuildContext context) {
    final switchSize = widget.height;
    final collapsedWidth = switchSize;
    final expandedWidth = widget.width;
    final curve = _loading
        ? widget.curveIn ?? Curves.easeIn
        : widget.curveOut ?? Curves.easeInOut;

    return GestureDetector(
      onTap: _loading ? null : _handleToggle,
      child: AnimatedContainer(
        width: _loading ? collapsedWidth : expandedWidth,
        height: switchSize,
        duration: widget.animationDuration ?? const Duration(milliseconds: 250),
        curve: curve,
        decoration: widget.switchDecoration != null
            ? widget.switchDecoration!(_value)
            : BoxDecoration(
                color: _value ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(switchSize / 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: _loading
                  ? Alignment.center
                  : _value
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
              duration:
                  widget.animationDuration ?? const Duration(milliseconds: 250),
              curve: curve,
              child: Container(
                width: switchSize,
                height: switchSize,
                decoration: widget.thumbDecoration != null
                    ? widget.thumbDecoration!(_value)
                    : BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                child: _loading
                    ? CircularProgressIndicator(
                        strokeWidth: widget.spinStrokeWidth,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.spinColor != null
                              ? widget.spinColor!(_value)
                              : Colors.blue,
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
