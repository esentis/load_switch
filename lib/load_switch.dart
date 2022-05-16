library load_switch;

import 'package:flutter/material.dart';

class LoadSwitch extends StatefulWidget {
  const LoadSwitch({
    required this.value,
    required this.future,
    required this.onChange,
    required this.onTap,
    this.width = 85,
    this.height = 50,
    this.spinColor = Colors.blue,
    this.spinStrokeWidth = 8,
    this.falseColor = Colors.red,
    this.trueColor = Colors.green,
    this.neutralColor = Colors.grey,
    this.thumbColorLoading = Colors.white,
    this.thumbColorFalse = Colors.white,
    this.thumbColorTrue = Colors.white,
    this.thumbPadding = 2,
    this.thumbBorderColor = Colors.white,
    this.thumbBorderWidth = 1,
    this.borderColor = Colors.transparent,
    this.loadingBlurColor = Colors.grey,
    this.loadingHasBlur = false,
    this.loadingBlurRadius = 5,
    this.loadingSpreadRadius = 5,
    Key? key,
  })  : assert(width >= height, "Width can't be less than the height."),
        super(key: key);

  /// The width of the switch. Must be greater or equal to height.
  final double width;

  /// The height of the switch. Must be less or equal to width.
  final double height;

  /// The main [Future] with [bool] return type, which triggers when tapping the switch.
  ///
  /// The returned value represents the new state of the switch.
  final Future<bool> Function() future;

  /// The width of the loading spinner.
  final double spinStrokeWidth;

  /// The color of the loading spinner.
  final Color spinColor;

  /// The background color of the switch on true state.
  final Color trueColor;

  /// The background color of the switch on false state.
  final Color falseColor;

  /// The thumb color of the switch when loading.
  final Color thumbColorLoading;

  /// The thumb color of the switch when on true state.
  final Color thumbColorTrue;

  /// The thumb color of the switch when on false state.
  final Color thumbColorFalse;

  /// The border color of the thumb.
  final Color thumbBorderColor;

  /// The width of thumb's border if border is present.
  final double thumbBorderWidth;

  /// The vertical padding of the thumb on idle state (true or false).
  final double thumbPadding;

  /// The blur color when loading if [loadingHasBlur].
  final Color loadingBlurColor;

  /// The blur radius if [loadingHasBlur].
  final double loadingBlurRadius;

  /// The spread radius if [loadingHasBlur].
  final double loadingSpreadRadius;

  /// The border color of the switch.
  final Color borderColor;

  /// The neutral color showing when the switch is loading. Defaults to Colors.grey[400].
  final Color neutralColor;

  /// The callback when [future] has finished loading. Returns the response [bool] of the [future].
  final Function(bool) onChange;

  /// Tap callback which returns the current value of the switch.
  final Function(bool) onTap;

  /// Current value of the switch.
  final bool value;

  /// Whether to add a blur effect when loading.
  final bool loadingHasBlur;

  @override
  State<LoadSwitch> createState() => _LoadSwitchState();
}

class _LoadSwitchState extends State<LoadSwitch> {
  bool loading = false;
  late bool value;

  late double currentWidth;
  late double maxWidth;
  late double minHeight;
  @override
  void initState() {
    super.initState();
    value = widget.value;
    minHeight = widget.height;
    maxWidth = widget.width;
    currentWidth = loading ? minHeight : maxWidth;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading
          ? null
          : () async {
              widget.onTap(value);
              currentWidth = minHeight;
              loading = true;
              // Toggling loading.
              setState(() {});
              // Waiting for the user's future to complete.
              value = await widget.future.call();
              currentWidth = maxWidth;
              loading = false;
              widget.onChange(value);
              setState(() {});
            },
      child: AnimatedContainer(
        width: currentWidth,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutSine,
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: widget.height,
        ),
        decoration: BoxDecoration(
          color: loading
              ? widget.neutralColor
              : value
                  ? widget.trueColor
                  : widget.falseColor,
          borderRadius: BorderRadius.circular(360),
          border: Border.all(
            color: widget.borderColor,
          ),
          boxShadow: [
            if (widget.loadingHasBlur)
              BoxShadow(
                blurRadius: loading ? widget.loadingBlurRadius : 0,
                spreadRadius: loading ? widget.loadingSpreadRadius : 0,
                color: widget.loadingBlurColor,
                blurStyle: BlurStyle.normal,
              )
          ],
        ),
        child: Center(
          child: AnimatedAlign(
            duration: Duration(milliseconds: loading ? 450 : 150),
            curve: Curves.easeInOutSine,
            alignment: loading
                ? Alignment.center
                : value
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
            child: AnimatedPadding(
              duration: Duration(milliseconds: loading ? 450 : 150),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                vertical: loading ? 4 : widget.thumbPadding,
                horizontal: loading ? 4 : 0,
              ),
              child: SizedBox(
                width: widget.height,
                child: Stack(
                  children: [
                    if (loading)
                      Center(
                        child: SizedBox(
                          width: widget.height,
                          height: widget.height,
                          child: CircularProgressIndicator(
                            strokeWidth: widget.spinStrokeWidth,
                            color: widget.spinColor,
                          ),
                        ),
                      ),
                    Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 550),
                        curve: Curves.easeInOutSine,
                        width: widget.height,
                        height: widget.height,
                        decoration: BoxDecoration(
                          color: loading
                              ? widget.thumbColorLoading
                              : value
                                  ? widget.thumbColorTrue
                                  : widget.thumbColorFalse,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: widget.thumbBorderColor,
                            width: widget.thumbBorderWidth,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
