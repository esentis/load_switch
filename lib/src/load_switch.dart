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
    this.focusNode,
    this.autofocus = false,
    this.focusColor,
    this.semanticLabel,
    this.loadingSemanticHint,
    this.disabledSemanticHint,
    super.key,
  })  : _mode = _LoadSwitchMode.managed,
        controller = null,
        assert(
          width > 0 && width < double.infinity,
          'Width must be a positive, finite value.',
        ),
        assert(
          height > 0 && height < double.infinity,
          'Height must be a positive, finite value.',
        ),
        assert(width >= height, "Width can't be less than the height."),
        assert(
          spinStrokeWidth > 0 && spinStrokeWidth < double.infinity,
          'Spin stroke width must be a positive, finite value.',
        ),
        assert(
          thumbSizeRatio > 0 && thumbSizeRatio <= 1,
          'Thumb size ratio must be greater than 0 and at most 1.',
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
    this.focusNode,
    this.autofocus = false,
    this.focusColor,
    this.semanticLabel,
    this.loadingSemanticHint,
    this.disabledSemanticHint,
    super.key,
  })  : _mode = _LoadSwitchMode.controlled,
        value = null,
        isLoading = null,
        isActive = null,
        assert(
          width > 0 && width < double.infinity,
          'Width must be a positive, finite value.',
        ),
        assert(
          height > 0 && height < double.infinity,
          'Height must be a positive, finite value.',
        ),
        assert(width >= height, "Width can't be less than the height."),
        assert(
          spinStrokeWidth > 0 && spinStrokeWidth < double.infinity,
          'Spin stroke width must be a positive, finite value.',
        ),
        assert(
          thumbSizeRatio > 0 && thumbSizeRatio <= 1,
          'Thumb size ratio must be greater than 0 and at most 1.',
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

  /// Called with the new value once a toggle changes it.
  ///
  /// In managed mode the parent owns the value: the switch only shows the new
  /// value once it is rebuilt with it, so a parent that ignores this callback
  /// effectively rejects the change.
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
  ///
  /// [SpinStyle.material] and [SpinStyle.cupertino] use the platform's own
  /// indicators, which animate at a fixed rate. This duration only affects the
  /// remaining, SpinKit backed styles.
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
  ///
  /// Defaults to `false` when omitted, so a switch that was rebuilt with
  /// `isLoading: true` returns to its idle state once the flag is dropped.
  final bool? isLoading;

  /// Whether the toggle is active in managed mode.
  final bool? isActive;

  /// The ratio of the thumb size to the switch size.
  final double thumbSizeRatio;

  /// The callback when an error occurs during the toggle execution.
  final LoadSwitchErrorCallback? onError;

  /// The style of the loading spinner.
  final SpinStyle style;

  /// An optional focus node to control keyboard focus externally.
  final FocusNode? focusNode;

  /// Whether the switch should grab focus when it is first shown.
  final bool autofocus;

  /// The color of the focus indicator drawn while the switch has keyboard
  /// focus. Defaults to the ambient [ColorScheme.primary].
  final Color? focusColor;

  /// Semantic label announced by assistive technologies.
  final String? semanticLabel;

  /// Semantic hint announced while the switch is loading.
  final String? loadingSemanticHint;

  /// Semantic hint announced while the switch is inactive.
  ///
  /// Useful to explain why the switch cannot be toggled right now.
  final String? disabledSemanticHint;

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
  bool _showFocusHighlight = false;

  /// The controller whose loading flag this widget switched on.
  ///
  /// Controlled mode drives a caller-owned controller, so the widget has to
  /// remember what it turned on in order to turn it back off — even when the
  /// toggle outlives the widget or the controller is swapped mid-flight.
  LoadSwitchController? _loadingOwner;

  /// The toggle operation that switched [_loadingOwner] into loading.
  ///
  /// A stale toggle may finish after a newer one re-acquired the same
  /// controller, so ownership is matched per operation, not per controller.
  int? _loadingOperationId;

  late final Map<Type, Action<Intent>> _actions = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(
      onInvoke: (intent) {
        _handleToggle();
        return null;
      },
    ),
  };

  @override
  void initState() {
    super.initState();
    assert(
      !widget.switchAnimationDuration.isNegative,
      'switchAnimationDuration must not be negative.',
    );
    assert(
      !widget.spinnerAnimationDuration.isNegative,
      'spinnerAnimationDuration must not be negative.',
    );
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

    // An omitted `isLoading` means "not externally loading". Treating it as
    // "don't sync" would strand the switch in a loading state forever once the
    // caller stopped passing the flag. Loading driven by this widget's own
    // toggle lives in [_isManagedToggleInProgress], so it survives this write.
    final isLoading = widget.isLoading ?? false;
    if (_controller.isLoading != isLoading) {
      _controller.isLoading = isLoading;
    }

    if (_controller.isActive != widget.isActive) {
      _controller.isActive = widget.isActive!;
    }
  }

  /// Switches [controller] into its loading state and records the ownership so
  /// it can always be handed back.
  void _acquireLoading(LoadSwitchController controller, int operationId) {
    _loadingOwner = controller;
    _loadingOperationId = operationId;
    controller.isLoading = true;
  }

  bool _ownsLoading(int operationId) {
    return _loadingOwner != null && _loadingOperationId == operationId;
  }

  /// Clears a loading state previously switched on by this widget.
  ///
  /// Safe to call on a disposed controller: the setters are no-ops after
  /// disposal.
  void _releaseLoading() {
    final owner = _loadingOwner;
    if (owner == null) {
      return;
    }
    _loadingOwner = null;
    _loadingOperationId = null;
    owner.isLoading = false;
  }

  /// Same as [_releaseLoading], but for `dispose` and `didUpdateWidget`, which
  /// run while the widget tree is locked and cannot notify listeners inline.
  void _releaseLoadingOnTeardown() {
    final owner = _loadingOwner;
    if (owner == null) {
      return;
    }
    _loadingOwner = null;
    _loadingOperationId = null;
    owner.clearLoadingAfterFrame();
  }

  @override
  void didUpdateWidget(LoadSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    final controllerChanged = widget._mode != oldWidget._mode ||
        (widget._mode == _LoadSwitchMode.controlled &&
            !identical(widget.controller, oldWidget.controller));

    if (controllerChanged) {
      final previousController = _controller;
      // Hand the loading state back before letting go of the old controller,
      // otherwise a caller-owned one stays loading for the rest of its life.
      _releaseLoadingOnTeardown();
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

    // Loading is a transient lock — the spinner makes it visually obvious, so
    // every input, onTap included, is ignored while it lasts.
    if (_isLoading(controller)) {
      return;
    }

    // Fire onTap whenever the user physically taps the switch, even if it is
    // inactive. This allows callers to show feedback (e.g. a tooltip or snackbar)
    // explaining why the switch is disabled.
    widget.onTap?.call(controller.value);

    if (!controller.isActive) {
      return;
    }

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
      _acquireLoading(controller, operationId);
    }

    bool? changedValue;
    try {
      final nextValue = await onToggle();
      if (_isCurrentOperation(controller, operationId) &&
          nextValue != controller.value) {
        // In managed mode the parent owns the value and hands it back through
        // a rebuild. Writing it here would show a value the parent may reject.
        if (widget._mode == _LoadSwitchMode.controlled) {
          controller.value = nextValue;
        }
        changedValue = nextValue;
      }
    } catch (error, stackTrace) {
      if (_isCurrentOperation(controller, operationId)) {
        widget.onError?.call(error, stackTrace);
      }
    } finally {
      // Release by ownership rather than by liveness: the loading flag must come
      // back off even when this widget was disposed or re-pointed while the
      // toggle was still running. Teardown, or a newer toggle on the same
      // controller, may own it by now, in which case it is left alone.
      if (_ownsLoading(operationId)) {
        _releaseLoading();
      }
      if (_isManagedToggleInProgress &&
          _isCurrentOperation(controller, operationId)) {
        setState(() {
          _isManagedToggleInProgress = false;
        });
      }
    }

    // Outside the try, so a throwing onChanged is neither swallowed nor passed
    // to onError as if the toggle itself had failed.
    if (changedValue != null) {
      _notifyChanged(changedValue);
    }
  }

  void _notifyChanged(bool value) {
    try {
      widget.onChanged?.call(value);
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'load_switch',
          context: ErrorDescription('while calling LoadSwitch.onChanged'),
        ),
      );
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
    _releaseLoadingOnTeardown();
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
        // Only loading swallows input. Inactive switches still route to
        // _handleToggle so onTap can explain why they cannot be toggled, and
        // keyboard users get the same affordance as pointer users.
        final acceptsInput = !loading;

        return Semantics(
          container: true,
          toggled: value,
          enabled: isEnabled,
          focusable: true,
          focused: _showFocusHighlight,
          label: widget.semanticLabel,
          hint: loading
              ? widget.loadingSemanticHint
              : isActive
                  ? null
                  : widget.disabledSemanticHint,
          onTap: acceptsInput ? _handleToggle : null,
          // Always enabled: disabling it while loading would revoke
          // canRequestFocus and throw keyboard focus off the switch mid-toggle.
          // _handleToggle ignores activation while loading instead.
          child: FocusableActionDetector(
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            mouseCursor:
                isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
            shortcuts: _activationShortcuts,
            onShowFocusHighlight: _handleShowFocusHighlight,
            actions: _actions,
            child: GestureDetector(
              excludeFromSemantics: true,
              behavior: HitTestBehavior.opaque,
              onTap: acceptsInput ? _handleToggle : null,
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
                          ? AlignmentDirectional.center
                          : value
                              ? AlignmentDirectional.centerEnd
                              : AlignmentDirectional.centerStart,
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
                    if (_showFocusHighlight)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(switchSize / 2),
                              border: Border.all(
                                color: widget.focusColor ??
                                    Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
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

  void _handleShowFocusHighlight(bool showHighlight) {
    if (_showFocusHighlight == showHighlight) {
      return;
    }
    setState(() {
      _showFocusHighlight = showHighlight;
    });
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
