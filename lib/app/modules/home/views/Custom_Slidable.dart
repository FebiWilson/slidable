import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
const int _kFlex = 1;
const Color _kBackgroundColor = Colors.white;
const bool _kAutoClose = true;
class AASlidableAction extends StatelessWidget {
  const AASlidableAction({
    Key? key,
    this.flex = _kFlex,
    this.backgroundColor = _kBackgroundColor,
    this.foregroundColor,
    this.autoClose = _kAutoClose,
    this.borderRadius = BorderRadius.zero,
    this.padding,
    required this.onPressed,
    required this.icon, 
    this.label,
  })  : assert(flex > 0),
        super(key: key);
  final int flex;
  final Color backgroundColor;
  final Color? foregroundColor;
  final bool autoClose;
  final SlidableActionCallback? onPressed;
  final BorderRadius borderRadius;
  final EdgeInsets? padding;
  final Icon? icon;
  final String? label;
  final double spacing = 4;

  @override
  Widget build(BuildContext context) {
    final effectiveForegroundColor = foregroundColor ??
        (ThemeData.estimateBrightnessForColor(backgroundColor) ==
                Brightness.light
            ? Colors.black
            : Colors.white);

    return Expanded(
      flex: flex,
      child: SizedBox.expand(
        child: OutlinedButton(
          onPressed: () => _handleTap(context),
          style: OutlinedButton.styleFrom(
            padding: padding,
            backgroundColor: backgroundColor,
            primary: effectiveForegroundColor,
            onSurface: effectiveForegroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
            ),
            side: BorderSide.none,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(icon!=null)
              icon!,
              if(label != null)
              SizedBox(height: spacing,),
              if(label != null)
              Text(
                label!,
                style: TextStyle(fontSize: 10),
                overflow: TextOverflow.ellipsis,
              ),
              ],
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    onPressed?.call(context);
    if (autoClose) {
      Slidable.of(context)?.close();
    }
  }
}
