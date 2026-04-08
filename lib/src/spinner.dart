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
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Colors.blue;
    late final Widget spinner;
    switch (style) {
      case SpinStyle.material:
        spinner = CircularProgressIndicator(
          strokeWidth: width,
          valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
        );
        break;
      case SpinStyle.cupertino:
        spinner = CupertinoActivityIndicator(radius: size * 0.24);
        break;
      case SpinStyle.chasingDots:
        spinner = SpinKitChasingDots(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        );
        break;
      case SpinStyle.circle:
        spinner = SpinKitCircle(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        );
        break;
      case SpinStyle.cubeGrid:
        spinner = SpinKitCubeGrid(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        );
        break;
      case SpinStyle.dancingSquare:
        spinner = SpinKitDancingSquare(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        );
        break;
      case SpinStyle.doubleBounce:
        spinner = SpinKitDoubleBounce(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        );
        break;
      case SpinStyle.dualRing:
        spinner = SpinKitDualRing(
          color: effectiveColor,
          lineWidth: width,
          duration: animationDuration,
          size: size,
        );
        break;
      case SpinStyle.fadingCircle:
        spinner = SpinKitFadingCircle(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        );
        break;
      case SpinStyle.fadingCube:
        spinner = SpinKitFadingCube(
          color: effectiveColor,
          duration: animationDuration,
          size: size,
        );
        break;
      case SpinStyle.fadingFour:
        spinner = SpinKitFadingFour(
          color: effectiveColor,
          duration: animationDuration,
          size: size,
        );
        break;
      case SpinStyle.fadingGrid:
        spinner = SpinKitFadingGrid(
          color: effectiveColor,
          duration: animationDuration,
          size: size,
        );
        break;
      case SpinStyle.foldingCube:
        spinner = SpinKitFoldingCube(
          color: effectiveColor,
          duration: animationDuration,
          size: size,
        );
        break;
      case SpinStyle.hourGlass:
        spinner = SpinKitHourGlass(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        );
        break;
      case SpinStyle.pianoWave:
        spinner = SpinKitPianoWave(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        );
        break;
      case SpinStyle.pouringHourGlass:
        spinner = SpinKitPouringHourGlass(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        );
        break;
      case SpinStyle.pulse:
        spinner = SpinKitPulse(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        );
        break;
      case SpinStyle.pulsingGrid:
        spinner = SpinKitPulsingGrid(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        );
        break;
      case SpinStyle.pumpingHeart:
        spinner = SpinKitPumpingHeart(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        );
        break;
      case SpinStyle.ring:
        spinner = SpinKitRing(
          color: effectiveColor,
          size: size,
          lineWidth: width,
          duration: animationDuration,
        );
        break;
      case SpinStyle.ripple:
        spinner = SpinKitRipple(
          color: effectiveColor,
          borderWidth: width,
          size: size,
          duration: animationDuration,
        );
        break;
      case SpinStyle.rotatingCircle:
        spinner = SpinKitRotatingCircle(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        );
        break;
      case SpinStyle.rotatingPlain:
        spinner = SpinKitRotatingPlain(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        );
        break;
      case SpinStyle.spinningCircle:
        spinner = SpinKitSpinningCircle(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        );
        break;
      case SpinStyle.spinningLines:
        spinner = SpinKitSpinningLines(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        );
        break;
      case SpinStyle.squareCircle:
        spinner = SpinKitSquareCircle(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        );
        break;
      case SpinStyle.threeBounce:
        spinner = SpinKitThreeBounce(
          color: effectiveColor,
          size: size * 0.5,
          duration: animationDuration,
        );
        break;
      case SpinStyle.threeInOut:
        spinner = SpinKitThreeInOut(
          color: effectiveColor,
          size: size * 0.5,
          duration: animationDuration,
        );
        break;
      case SpinStyle.wanderingCubes:
        spinner = SpinKitWanderingCubes(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        );
        break;
      case SpinStyle.waveStart:
        spinner = SpinKitWave(
          color: effectiveColor,
          size: size,
          type: SpinKitWaveType.start,
          duration: animationDuration,
        );
        break;
      case SpinStyle.waveCenter:
        spinner = SpinKitWave(
          color: effectiveColor,
          size: size,
          type: SpinKitWaveType.center,
          duration: animationDuration,
        );
        break;
      case SpinStyle.waveEnd:
        spinner = SpinKitWave(
          color: effectiveColor,
          size: size,
          type: SpinKitWaveType.end,
          duration: animationDuration,
        );
        break;
      case SpinStyle.waveSpinner:
        spinner = SpinKitWave(
          color: effectiveColor,
          size: size,
          duration: animationDuration,
        );
        break;
    }

    return SizedBox.square(
      dimension: size,
      child: Center(child: spinner),
    );
  }
}
