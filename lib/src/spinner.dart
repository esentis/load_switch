import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:load_switch/src/load_switch.dart';

Widget buildSpinner({
  required SpinStyle style,
  required TickerProvider vsync,
  required bool value,
  required double size,
  required double width,
  required Color? color,
  required Duration? animationDuration,
}) {
  switch (style) {
    case SpinStyle.material:
      return CircularProgressIndicator(
        strokeWidth: width,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Colors.blue,
        ),
      );
    case SpinStyle.cupertino:
      return CupertinoActivityIndicator(
        radius: width * 0.3,
      );
    case SpinStyle.chasingDots:
      return SpinKitChasingDots(
        color: color ?? Colors.blue,
        size: size,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
    case SpinStyle.circle:
      return SpinKitCircle(
        color: color ?? Colors.blue,
        size: size,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
        controller: AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 1200),
        ),
      );
    case SpinStyle.cubeGrid:
      return SpinKitCubeGrid(
        color: color ?? Colors.blue,
        size: size,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
        controller: AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 1200),
        ),
      );
    case SpinStyle.dancingSquare:
      return SpinKitDancingSquare(
        color: color ?? Colors.blue,
        size: size,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
        controller: AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 1200),
        ),
      );
    case SpinStyle.doubleBounce:
      return SpinKitDoubleBounce(
        color: color ?? Colors.blue,
        size: size,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
        controller: AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 1200),
        ),
      );
    case SpinStyle.dualRing:
      return SpinKitDualRing(
        color: color ?? Colors.blue,
        lineWidth: width,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
        size: size,
      );
    case SpinStyle.fadingCircle:
      return SpinKitFadingCircle(
        color: color ?? Colors.blue,
        size: size,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
        controller: AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 1200),
        ),
      );
    case SpinStyle.fadingCube:
      return SpinKitFadingCube(
        color: color ?? Colors.blue,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
        size: size,
      );
    case SpinStyle.fadingFour:
      return SpinKitFadingFour(
        color: color ?? Colors.blue,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
        size: size,
      );
    case SpinStyle.fadingGrid:
      return SpinKitFadingGrid(
        color: color ?? Colors.blue,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
        size: size,
      );
    case SpinStyle.foldingCube:
      return SpinKitFoldingCube(
        color: color ?? Colors.blue,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
        size: size,
      );
    case SpinStyle.hourGlass:
      return SpinKitHourGlass(
        color: color ?? Colors.blue,
        size: size,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
    case SpinStyle.pianoWave:
      return SpinKitPianoWave(
        color: color ?? Colors.blue,
        size: size,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
    case SpinStyle.pouringHourGlass:
      return SpinKitPouringHourGlass(
        color: color ?? Colors.blue,
        size: size,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
    case SpinStyle.pulse:
      return SpinKitPulse(
        color: color ?? Colors.blue,
        size: size,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
    case SpinStyle.pulsingGrid:
      return SpinKitPulsingGrid(
        color: color ?? Colors.blue,
        size: size,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
    case SpinStyle.pumpingHeart:
      return SpinKitPumpingHeart(
        color: color ?? Colors.blue,
        size: size,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
    case SpinStyle.ring:
      return SpinKitRing(
        color: color ?? Colors.blue,
        size: size,
        lineWidth: width,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
    case SpinStyle.ripple:
      return SpinKitRipple(
        color: color ?? Colors.blue,
        borderWidth: width,
        size: size,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
    case SpinStyle.rotatingCircle:
      return SpinKitRotatingCircle(
        color: color ?? Colors.blue,
        size: size,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
    case SpinStyle.rotatingPlain:
      return SpinKitRotatingPlain(
        color: color ?? Colors.blue,
        size: size,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
    case SpinStyle.spinningCircle:
      return SpinKitSpinningCircle(
        color: color ?? Colors.blue,
        size: size,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
    case SpinStyle.spinningLines:
      return SpinKitSpinningLines(
        color: color ?? Colors.blue,
        size: size,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
    case SpinStyle.squareCircle:
      return SpinKitSquareCircle(
        color: color ?? Colors.blue,
        size: size,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
    case SpinStyle.threeBounce:
      return SpinKitThreeBounce(
        color: color ?? Colors.blue,
        size: size * 0.5,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
    case SpinStyle.threeInOut:
      return SpinKitThreeInOut(
        color: color ?? Colors.blue,
        size: size * 0.5,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
    case SpinStyle.wanderingCubes:
      return SpinKitWanderingCubes(
        color: color ?? Colors.blue,
        size: size,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
    case SpinStyle.waveStart:
      return SpinKitWave(
        color: color ?? Colors.blue,
        size: size,
        type: SpinKitWaveType.start,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
    case SpinStyle.waveCenter:
      return SpinKitWave(
        color: color ?? Colors.blue,
        size: size,
        type: SpinKitWaveType.center,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
    case SpinStyle.waveEnd:
      return SpinKitWave(
        color: color ?? Colors.blue,
        size: size,
        type: SpinKitWaveType.end,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
    case SpinStyle.waveSpinner:
      return SpinKitWave(
        color: color ?? Colors.blue,
        size: size,
        duration: animationDuration ?? const Duration(milliseconds: 1200),
      );
  }
}
