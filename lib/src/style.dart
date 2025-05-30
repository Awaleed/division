import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'model.dart';
import 'function/angleToRadians.dart';

enum AngleFormat { degree, radians, cycles }

abstract class CoreStyle {
  CoreStyle({this.angleFormat = AngleFormat.cycles}) {
    _addListeners();
  }

  @mustCallSuper
  _addListeners() {
    alignment
      ..addListener(() => _styleModel.alignment = alignment.getAlignment);
    alignmentContent
      ..addListener(
          () => _styleModel.alignmentContent = alignmentContent.getAlignment);
    background
      ..addListener(() => _styleModel
        ..backgroundColor = background.exportBackgroundColor
        ..backgroundBlur = background.exportBackgroundBlur
        ..backgroundImage = background.exportBackgroundImage
        ..backgroundBlendMode = background.exportBackgroundBlendMode);
    overflow
      ..addListener(() => _styleModel
        ..overflow = overflow.getOverflow
        ..overflowDirection = overflow.getDirection);
  }

  final AngleFormat angleFormat;

  final StyleModel _styleModel = StyleModel();

  /// Alignment relative to its surroundings
  final AlignmentModel alignment = AlignmentModel();

  /// Alignment of the child
  final AlignmentModel alignmentContent = AlignmentModel();

  /// Widget background styling
  final BackgroundModel background = BackgroundModel();

  /// Change child overflow behaviour.
  /// ```dart
  /// ..overflow.visible(Axis.vertical) // overflows outside its parent
  /// ..overflow.hidden() // CLips to parent shape
  /// ..overflow.scrollable(Axis.vertical) // scrollable if bigger than parent
  /// ```
  final OverflowModel overflow = OverflowModel();

  /// Empty space to inscribe inside the [decoration]. The [child], if any, is placed inside this padding.
  ///
  /// All properties work together
  /// ```dart
  /// ..padding(all: 10, bottom: 20) // gives a different padding at the bottom
  /// ```
  void padding(
      {double? all,
      double? horizontal,
      double? vertical,
      double? top,
      double? bottom,
      double? left,
      double? right}) {
    _styleModel.padding = EdgeInsets.only(
        top: top ?? vertical ?? all ?? 0.0,
        bottom: bottom ?? vertical ?? all ?? 0.0,
        left: left ?? horizontal ?? all ?? 0.0,
        right: right ?? horizontal ?? all ?? 0.0);
  }

  /// Empty space to surround the [decoration] and [child].
  ///
  /// All properties work together
  /// ```dart
  /// ..margin(all: 10, bottom: 20) // gives a different margin at the bottom
  /// ```
  void margin(
      {double? all,
      double? horizontal,
      double? vertical,
      double? top,
      double? bottom,
      double? left,
      double? right}) {
    _styleModel.margin = EdgeInsets.only(
        top: top ?? vertical ?? all ?? 0.0,
        bottom: bottom ?? vertical ?? all ?? 0.0,
        left: left ?? horizontal ?? all ?? 0.0,
        right: right ?? horizontal ?? all ?? 0.0);
  }

  /// Creates a linear gradient.
  ///
  /// The [colors] argument must not be null. If [stops] is non-null, it must have the same length as [colors].
  void linearGradient(
      {AlignmentGeometry begin = Alignment.centerLeft,
      AlignmentGeometry end = Alignment.centerRight,
      required List<Color> colors,
      TileMode tileMode = TileMode.clamp,
      List<double>? stops}) {
    _styleModel.gradient = LinearGradient(
        begin: begin,
        end: end,
        colors: colors,
        tileMode: tileMode,
        stops: stops);
  }

  /// Creates a radial gradient.
  ///
  /// The [colors] argument must not be null. If [stops] is non-null, it must have the same length as [colors].
  void radialGradient(
      {AlignmentGeometry center = Alignment.center,
      required double radius,
      required List<Color> colors,
      TileMode tileMode = TileMode.clamp,
      List<double>? stops}) {
    _styleModel.gradient = RadialGradient(
      center: center,
      radius: radius,
      colors: colors,
      tileMode: tileMode,
      stops: stops,
    );
  }

  /// Creates a sweep gradient.
  ///
  /// The [colors] argument must not be null. If [stops] is non-null, it must have the same length as [colors].
  ///
  /// Choose to calculate angles with radians or not through [useRadians] parameter.
  /// [end] default to 1.0 if [useRadians] is false and 2 * pi if [useRadians] is true,
  void sweepGradient(
      {AlignmentGeometry center = Alignment.center,
      double startAngle = 0.0,
      required double endAngle,
      required List<Color> colors,
      TileMode tileMode = TileMode.clamp,
      List<double>? stops}) {
    _styleModel.gradient = SweepGradient(
      center: center,
      startAngle: angleToRadians(startAngle, angleFormat),
      endAngle: angleToRadians(endAngle, angleFormat),
      colors: colors,
      stops: stops,
      tileMode: tileMode,
    );
  }

  /// Border for the widget
  /// ```dart
  /// ..border(all: 3.0, color: hex('#55ffff'), style: BorderStyle.solid)
  /// ```
  /// Choose between `all`, `left`, `right`, `top` and `bottom`. `all` works together with the other properties.
  void border(
      {double? all,
      double? left,
      double? right,
      double? top,
      double? bottom,
      Color color = const Color(0xFF000000),
      BorderStyle style = BorderStyle.solid}) {
    _styleModel.border = Border(
      left: (left ?? all) == null
          ? BorderSide.none
          : BorderSide(color: color, width: left ?? all!, style: style),
      right: (right ?? all) == null
          ? BorderSide.none
          : BorderSide(color: color, width: right ?? all!, style: style),
      top: (top ?? all) == null
          ? BorderSide.none
          : BorderSide(color: color, width: top ?? all!, style: style),
      bottom: (bottom ?? all) == null
          ? BorderSide.none
          : BorderSide(color: color, width: bottom ?? all!, style: style),
    );
  }

  /// It is valid to use `all` together with single sided properties. Single sided properties will trump over the `all` property.
  void borderRadius(
      {double? all,
      double? topLeft,
      double? topRight,
      double? bottomLeft,
      double? bottomRight}) {
    _styleModel.borderRadius = BorderRadius.only(
      topLeft: Radius.circular(topLeft ?? all ?? 0.0),
      topRight: Radius.circular(topRight ?? all ?? 0.0),
      bottomLeft: Radius.circular(bottomLeft ?? all ?? 0.0),
      bottomRight: Radius.circular(bottomRight ?? all ?? 0.0),
    );
  }

  void circle([enable = true]) =>
      enable ? _styleModel.boxShape = BoxShape.circle : null;

  // TODO: add posibility to append box shadow instead of replacing. bool append = true
  /// If defined while the elevation method is defined, the last one defined will be the one applied.
  void boxShadow(
          {Color color = const Color(0x33000000),
          double blur = 0.0,
          Offset offset = Offset.zero,
          double spread = 0.0}) =>
      _styleModel.boxShadow = [
        BoxShadow(
          color: color,
          blurRadius: blur,
          spreadRadius: spread,
          offset: offset,
        ),
      ];

  /// Elevates the widget with a boxShadow.
  /// [angle] format depends on what is specified in the style widget`s constructor.
  /// ```dart
  /// ..elevation(30.0, color: Colors.grey, angle: 0.0)
  /// ```
  void elevation(double elevation,
      {double angle = 0.0,
      Color color = const Color(0x33000000),
      double opacity = 1.0}) {
    if (elevation == 0) return;

    angle = angleToRadians(angle, angleFormat);
    final double offsetX = sin(angle) * elevation;
    final double offsetY = cos(angle) * elevation;

    // custom curve defining the opacity
    double calculatedOpacity = (0.5 - (sqrt(elevation) / 19)) * opacity;
    if (calculatedOpacity < 0.0) calculatedOpacity = 0.0;

    final Color colorWithOpacity = color.withOpacity(calculatedOpacity);

    _styleModel.boxShadow = [
      BoxShadow(
          color: colorWithOpacity,
          blurRadius: elevation,
          spreadRadius: 0.0,
          offset: Offset(offsetX, offsetY))
    ];
  }

  void width(double width) => _styleModel.width = width;

  void minWidth(double minWidth) => _styleModel.minWidth = minWidth;

  void maxWidth(double maxWidth) => _styleModel.maxWidth = maxWidth;

  void height(double height) => _styleModel.height = height;

  void minHeight(double minHeight) => _styleModel.minHeight = minHeight;

  void maxHeight(double maxHeight) => _styleModel.maxHeight = maxHeight;

  /// Sets the aspect ratio of the widget. For example, 16/9 would constrain
  /// the widget to a 16:9 aspect ratio.
  void aspectRatio(double ratio) => _styleModel.aspectRatio = ratio;

  void scale(double ratio) => _styleModel.scale = ratio;

  void offset(double dx, double dy) => _styleModel.offset = Offset(dx, dy);

  ///
  /// ```dart
  /// StyleClass(angleFormat: AngleFormat.cycles)
  ///   ..rotate(0.75);
  ///
  /// StyleClass(angleFormat: AngleFormat.radians)
  ///   ..rotate(0.75 * pi * 2)
  /// ```
  void rotate(double angle) =>
      _styleModel.rotate = angleToRadians(angle, angleFormat);

  void opacity(double opacity) => _styleModel.opacity = opacity;

  /// Material ripple effect
  void ripple(bool enable, {Color? splashColor, Color? highlightColor}) {
    _styleModel.ripple = RippleModel(
      enable: enable,
      splashColor: splashColor,
      highlightColor: highlightColor,
    );
  }

  /// `Duration` is given in milliseconds.
  ///
  /// ```dart
  /// ..animate(400, Curves.easeInOut);
  /// ```
  ///
  /// **Adding a delay to your animation**
  /// ```
  /// .onTapDown((details) {
  ///   // change styling without a delay
  ///   thisStyle..backgroundColor(rgb(255,255,0));
  ///
  ///   // Trigger the setState with a delay
  ///   Future.delayed(Duration(milliseconds: 500)).then((_) => setState(() {}));
  /// })
  /// ```
  void animate([int duration = 500, Curve curve = Curves.linear]) => _styleModel
    ..duration = Duration(milliseconds: duration)
    ..curve = curve;

  // void add<T extends CoreStyle>(T style, {bool override = false}) =>
  //   _styleModel?.inject(style?._styleModel, override);

  // export raw styledata
  StyleModel get exportStyle => _styleModel;
}

class ParentStyle extends CoreStyle {
  ParentStyle({this.angleFormat = AngleFormat.cycles})
      : super(angleFormat: angleFormat);

  final AngleFormat angleFormat;

  // TODO: implement
  // static ThemeDataModel<ParentStyle> themeData = ThemeDataModel<ParentStyle>();

  /// Combines style from another style instance
  /// ```dart
  /// ..add(ParentStyle()..width(100));
  /// ```
  void add(ParentStyle parentStyle, {bool override = false}) =>
      _styleModel.inject(parentStyle._styleModel, override);

  /// Clone object
  /// ```dart
  /// Parent(
  ///   'some text',
  ///   style: myStyle.clone()
  ///     ..width(100)
  ///     // etc..
  /// )
  /// ```
  ParentStyle clone() => ParentStyle(angleFormat: angleFormat)..add(this);
}

class TxtStyle extends CoreStyle {
  TxtStyle({AngleFormat angleFormat = AngleFormat.cycles})
      : super(angleFormat: angleFormat);

  @override
  void _addListeners() {
    super._addListeners();
    textAlign
      ..addListener(() {
        _textModel.textAlign = textAlign.exportTextAlign;
      });
  }

  // TODO: implemet
  // static ThemeDataModel<TxtStyle> themeData = ThemeDataModel<TxtStyle>();

  final TextModel _textModel = TextModel();

  final TextAlignModel textAlign = TextAlignModel();

  void bold([bool enable = true]) {
    if (enable == true) _textModel.fontWeight = FontWeight.bold;
  }

  void italic([bool enable = true]) {
    if (enable == true) _textModel.fontStyle = FontStyle.italic;
  }

  void fontWeight(FontWeight weight) => _textModel.fontWeight = weight;

  void fontSize(double fontSize) => _textModel.fontSize = fontSize;

  void fontFamily(String font, {List<String>? fontFamilyFallback}) {
    _textModel.fontFamily = font;
    _textModel.fontFamilyFallback = fontFamilyFallback;
  }

  void textColor(Color textColor) => _textModel.textColor = textColor;

  void maxLines(int maxLines) => _textModel.maxLines = maxLines;

  void letterSpacing(double space) => _textModel.letterSpacing = space;

  void wordSpacing(double space) => _textModel.wordSpacing = space;

  void textDecoration(TextDecoration decoration) =>
      _textModel.textDecoration = decoration;

  void textDirection(TextDirection textDirection) =>
      _textModel.textDirection = textDirection;

  void textOverflow(TextOverflow textOverflow) =>
      _textModel.textOverflow = textOverflow;

  void textShadow(
      {Color color = const Color(0x33000000),
      double blur = 0.0,
      Offset offset = Offset.zero}) {
    _textModel.textShadow = [
      Shadow(
        color: color,
        blurRadius: blur,
        offset: offset,
      ),
    ];
  }

  /// Elevates the text with a shadow.
  /// [angle] format depends on what is specified in the style widget`s constructor.
  /// ```dart
  /// ..textElevation(30.0, color: Colors.grey, angle: 0.0)
  /// ```
  void textElevation(double elevation,
      {double angle = 0.0,
      Color color = const Color(0x33000000),
      double opacity = 1.0}) {
    if (elevation == 0) return;

    angle = angleToRadians(angle, angleFormat);
    final double offsetX = sin(angle) * elevation;
    final double offsetY = cos(angle) * elevation;

    // custom curve defining the opacity
    double calculatedOpacity = (0.5 - (sqrt(elevation) / 19)) * opacity;
    if (calculatedOpacity < 0.0) calculatedOpacity = 0.0;

    final Color colorWithOpacity = color.withOpacity(calculatedOpacity);

    _textModel.textShadow = [
      Shadow(
          color: colorWithOpacity,
          blurRadius: elevation,
          offset: Offset(offsetX, offsetY))
    ];
  }

  /// Make the widget editable just like a TextField.
  ///
  /// If `focusNode` isnt spesified an internal `focusNode` will be initiated.
  void editable(
      {bool enable = true,
      TextInputType? keyboardType,
      String? placeholder,
      bool obscureText = false,
      bool autoFocus = false,
      int? maxLines,
      void Function(String)? onChange,
      void Function(bool? focus)? onFocusChange,
      void Function(TextSelection, SelectionChangedCause?)? onSelectionChanged,
      void Function()? onEditingComplete,
      FocusNode? focusNode}) {
    if (enable == true)
      _textModel
        ..editable = true
        ..keyboardType = keyboardType
        ..placeholder = placeholder
        ..obscureText = obscureText
        ..autoFocus = autoFocus
        ..maxLines = maxLines
        ..onChange = onChange
        ..onFocusChange = onFocusChange
        ..onSelectionChanged = onSelectionChanged
        ..onEditingComplete = onEditingComplete
        ..focusNode = focusNode;
  }

  /// Combines style from another style instance
  /// ```dart
  /// ..add(TxtStyle()..width(100));
  /// ```
  void add(TxtStyle? txtStyle, {bool override = false}) {
    if (txtStyle != null) {
      _styleModel.inject(txtStyle._styleModel, override);
      _textModel.inject(txtStyle._textModel, override);
    }
  }

  /// Clone object
  /// ```dart
  /// Txt(
  ///   'some text',
  ///   style: myStyle.clone()
  ///     ..width(100)
  ///     // etc..
  /// )
  /// ```
  TxtStyle clone() => TxtStyle(angleFormat: angleFormat)..add(this);

  TextModel get exportTextStyle => _textModel;
}

class Gestures {
  /// Apply gestures to a Division widgets
  /// ```dart
  /// Parent(
  ///   gesture: Gestures()
  ///     ..onTap(() => print('Widget pressed!'))
  ///     ..onLongPress(() => print('Widget longpress)),
  ///   child: Text('Some text'),
  /// )
  /// ```
  Gestures(
      {this.behavior,
      this.excludeFromSemantics = false,
      this.dragStartBehavior = DragStartBehavior.start})
      : this.gestureModel = GestureModel(
            behavior: behavior,
            excludeFromSemantics: excludeFromSemantics,
            dragStartBehavior: dragStartBehavior);

  /// How this gesture detector should behave during hit testing.
  ///
  /// This defaults to [HitTestBehavior.deferToChild] if [child] is not null and
  /// [HitTestBehavior.translucent] if child is null.
  final HitTestBehavior? behavior;

  /// Whether to exclude these gestures from the semantics tree. For
  /// example, the long-press gesture for showing a tooltip is
  /// excluded because the tooltip itself is included in the semantics
  /// tree directly and so having a gesture to show it would result in
  /// duplication of information.
  final bool excludeFromSemantics;

  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], gesture drag behavior will
  /// begin upon the detection of a drag gesture. If set to
  /// [DragStartBehavior.down] it will begin when a down event is first detected.
  ///
  /// In general, setting this to [DragStartBehavior.start] will make drag
  /// animation smoother and setting it to [DragStartBehavior.down] will make
  /// drag behavior feel slightly more reactive.
  ///
  /// By default, the drag start behavior is [DragStartBehavior.start].
  ///
  /// Only the [onStart] callbacks for the [VerticalDragGestureRecognizer],
  /// [HorizontalDragGestureRecognizer] and [PanGestureRecognizer] are affected
  /// by this setting.
  ///
  /// See also:
  ///
  ///  * [DragGestureRecognizer.dragStartBehavior], which gives an example for the different behaviors.
  final DragStartBehavior dragStartBehavior;

  final GestureModel gestureModel;

  /// Called whenever the tap state on the widget changes.
  ///
  /// This changes this
  /// ```dart
  /// ..onTapDown((_) => setState(() => pressed = true))
  /// ..onTapUp((_) => setState(() => pressed = false))
  /// ..onTapCancel(() => setState(() => pressed = false))
  /// ```
  /// to this
  /// ```dart
  /// ..isTap((isTapped) => setState(() => pressed = isTapped))
  /// ```
  void isTap(void Function(bool) function) => gestureModel.isTap = function;

  void onTap(void Function() function) => gestureModel.onTap = function;

  void onTapUp(void Function(TapUpDetails) function) =>
      gestureModel.onTapUp = function;

  void onTapDown(void Function(TapDownDetails) function) =>
      gestureModel.onTapDown = function;

  void onTapCancel(void Function() function) =>
      gestureModel.onTapCancel = function;

  void onDoubleTap(void Function() function) =>
      gestureModel.onDoubleTap = function;

  void onLongPress(void Function() function) =>
      gestureModel.onLongPress = function;

  void onLongPressStart(void Function(LongPressStartDetails) function) =>
      gestureModel.onLongPressStart = function;

  void onLongPressEnd(void Function(LongPressEndDetails) function) =>
      gestureModel.onLongPressEnd = function;

  void onLongPressMoveUpdate(
          void Function(LongPressMoveUpdateDetails) function) =>
      gestureModel.onLongPressMoveUpdate = function;

  void onLongPressUp(void Function() function) =>
      gestureModel.onLongPressUp = function;

  void onVerticalDragStart(void Function(DragStartDetails) function) =>
      gestureModel.onVerticalDragStart = function;

  void onVerticalDragEnd(void Function(DragEndDetails) function) =>
      gestureModel.onVerticalDragEnd = function;

  void onVerticalDragDown(void Function(DragDownDetails) function) =>
      gestureModel.onVerticalDragDown = function;

  void onVerticalDragCancel(void Function() function) =>
      gestureModel.onVerticalDragCancel = function;

  void onVerticalDragUpdate(void Function(DragUpdateDetails) function) =>
      gestureModel.onVerticalDragUpdate = function;

  void onHorizontalDragStart(void Function(DragStartDetails) function) =>
      gestureModel.onHorizontalDragStart = function;

  void onHorizontalDragEnd(void Function(DragEndDetails) function) =>
      gestureModel.onHorizontalDragEnd = function;

  void onHorizontalDragDown(void Function(DragDownDetails) function) =>
      gestureModel.onHorizontalDragDown = function;

  void onHorizontalDragCancel(void Function() function) =>
      gestureModel.onHorizontalDragCancel = function;

  void onHorizontalDragUpdate(void Function(DragUpdateDetails) function) =>
      gestureModel.onHorizontalDragUpdate = function;

  void onForcePressStart(void Function(ForcePressDetails) function) =>
      gestureModel.onForcePressStart = function;

  void onForcePressEnd(void Function(ForcePressDetails) function) =>
      gestureModel.onForcePressEnd = function;

  void onForcePressPeak(void Function(ForcePressDetails) function) =>
      gestureModel.onForcePressPeak = function;

  void onForcePressUpdate(void Function(ForcePressDetails) function) =>
      gestureModel.onForcePressUpdate = function;

  void onPanStart(void Function(DragStartDetails) function) =>
      gestureModel.onPanStart = function;

  void onPanEnd(void Function(DragEndDetails) function) =>
      gestureModel.onPanEnd = function;

  void onPanCancel(void Function() function) =>
      gestureModel.onPanCancel = function;

  void onPanDown(void Function(DragDownDetails) function) =>
      gestureModel.onPanDown = function;

  void onPanUpdate(void Function(DragUpdateDetails) function) =>
      gestureModel.onPanUpdate = function;

  void onScaleStart(void Function(ScaleStartDetails) function) =>
      gestureModel.onScaleStart = function;

  void onScaleEnd(void Function(ScaleEndDetails) function) =>
      gestureModel.onScaleEnd = function;

  void onScaleUpdate(void Function(ScaleUpdateDetails) function) =>
      gestureModel.onScaleUpdate = function;

  GestureModel get exportGesture => gestureModel;
}
