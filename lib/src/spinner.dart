import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:load_switch/src/spin_styles.dart';

/// A stateless widget that displays various spinner styles for the LoadSwitch.
///
/// This widget provides better performance compared to the function-based approach
/// by allowing Flutter to cache and reuse the widget instances.
class SpinnerWidget extends StatelessWidget {
  const SpinnerWidget({
    super.key,
    required this.style,
    required this.size,
    required this.width,
    this.color,
    required this.animationDuration,
  });

  final SpinStyle style;
  final double size;
  final double width;
  final Color? color;

  /// Drives the spin animation of every [SpinKit] based style.
  ///
  /// [SpinStyle.material] and [SpinStyle.cupertino] render the platform's own
  /// indicators, which animate at a fixed rate, so this duration has no effect
  /// on them.
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Colors.blue;

    final Widget spinner = switch (style) {
      SpinStyle.material => CircularProgressIndicator(
          strokeWidth: width,
          color: effectiveColor,
        ),
      SpinStyle.cupertino => CupertinoActivityIndicator(
          radius: size * 0.24,
          color: effectiveColor,
        ),
      SpinStyle.chasingDots => SpinKitChasingDots(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.circle => SpinKitCircle(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.cubeGrid => SpinKitCubeGrid(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.dancingSquare => SpinKitDancingSquare(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.doubleBounce => SpinKitDoubleBounce(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.dualRing => SpinKitDualRing(
          color: effectiveColor,
          lineWidth: width,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.fadingCircle => SpinKitFadingCircle(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.fadingCube => SpinKitFadingCube(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.fadingFour => SpinKitFadingFour(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.fadingGrid => SpinKitFadingGrid(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.foldingCube => SpinKitFoldingCube(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.hourGlass => SpinKitHourGlass(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.pianoWave => SpinKitPianoWave(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.pouringHourGlass => SpinKitPouringHourGlass(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.pulse => SpinKitPulse(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.pulsingGrid => SpinKitPulsingGrid(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.pumpingHeart => SpinKitPumpingHeart(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.ring => SpinKitRing(
          color: effectiveColor,
          size: size,
          lineWidth: width,
          duration: animationDuration,
        ),
      SpinStyle.ripple => SpinKitRipple(
          color: effectiveColor,
          borderWidth: width,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.rotatingCircle => SpinKitRotatingCircle(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.rotatingPlain => SpinKitRotatingPlain(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.spinningCircle => SpinKitSpinningCircle(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.spinningLines => SpinKitSpinningLines(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.squareCircle => SpinKitSquareCircle(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.threeBounce => SpinKitThreeBounce(
          color: effectiveColor,
          size: size * 0.5,
          duration: animationDuration,
        ),
      SpinStyle.threeInOut => SpinKitThreeInOut(
          color: effectiveColor,
          size: size * 0.5,
          duration: animationDuration,
        ),
      SpinStyle.wanderingCubes => SpinKitWanderingCubes(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
      SpinStyle.waveStart => SpinKitWave(
          color: effectiveColor,
          size: size,
          type: SpinKitWaveType.start,
          duration: animationDuration,
        ),
      SpinStyle.waveCenter => SpinKitWave(
          color: effectiveColor,
          size: size,
          type: SpinKitWaveType.center,
          duration: animationDuration,
        ),
      SpinStyle.waveEnd => SpinKitWave(
          color: effectiveColor,
          size: size,
          type: SpinKitWaveType.end,
          duration: animationDuration,
        ),
      SpinStyle.waveSpinner => SpinKitWaveSpinner(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        ),
    };

    return SizedBox.square(
      dimension: size,
      child: Center(child: spinner),
    );
  }
}
