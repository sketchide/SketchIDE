import 'package:flutter/material.dart';
import '../../models/flutter_widget_bean.dart';

/// WidgetText - Flutter Text widget with Sketchware Pro-style selection
/// Display text with styling
class WidgetText extends StatelessWidget {
  final FlutterWidgetBean widgetBean;
  final bool isSelected;
  final double scale;
  final VoidCallback? onTap;

  const WidgetText({
    super.key,
    required this.widgetBean,
    this.isSelected = false,
    this.scale = 1.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: isSelected 
            ? Border.all(color: const Color(0x9599d5d0), width: 2 * scale)
            : Border.all(color: Colors.grey.withOpacity(0.3), width: 1 * scale),
          color: isSelected 
            ? const Color(0x9599d5d0).withOpacity(0.1)
            : Colors.transparent,
        ),
        child: Padding(
          padding: EdgeInsets.all(4 * scale),
          child: Text(
            _getText(),
            style: _getTextStyle(),
            textAlign: _getTextAlign(),
            maxLines: _getMaxLines(),
            overflow: _getTextOverflow(),
            softWrap: _getSoftWrap(),
          ),
        ),
      ),
    );
  }

  String _getText() {
    return widgetBean.properties['text'] ?? 'Text Widget';
  }

  TextStyle _getTextStyle() {
    final fontSize = (widgetBean.properties['fontSize'] ?? 14.0) * scale;
    final fontWeight = _getFontWeight();
    final fontStyle = _getFontStyle();
    final color = _parseColor(widgetBean.properties['textColor'] ?? '#000000');
    final backgroundColor = _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');
    final decoration = _getTextDecoration();
    final decorationColor = _parseColor(widgetBean.properties['decorationColor'] ?? '#000000');
    final decorationThickness = (widgetBean.properties['decorationThickness'] ?? 1.0) * scale;

    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
      backgroundColor: backgroundColor,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
    );
  }

  FontWeight _getFontWeight() {
    final weight = widgetBean.properties['fontWeight'] ?? 'normal';
    switch (weight) {
      case 'bold': return FontWeight.bold;
      case 'w100': return FontWeight.w100;
      case 'w200': return FontWeight.w200;
      case 'w300': return FontWeight.w300;
      case 'w400': return FontWeight.w400;
      case 'w500': return FontWeight.w500;
      case 'w600': return FontWeight.w600;
      case 'w700': return FontWeight.w700;
      case 'w800': return FontWeight.w800;
      case 'w900': return FontWeight.w900;
      default: return FontWeight.normal;
    }
  }

  FontStyle _getFontStyle() {
    final style = widgetBean.properties['fontStyle'] ?? 'normal';
    switch (style) {
      case 'italic': return FontStyle.italic;
      default: return FontStyle.normal;
    }
  }

  TextDecoration _getTextDecoration() {
    final decoration = widgetBean.properties['textDecoration'] ?? 'none';
    switch (decoration) {
      case 'underline': return TextDecoration.underline;
      case 'overline': return TextDecoration.overline;
      case 'lineThrough': return TextDecoration.lineThrough;
      default: return TextDecoration.none;
    }
  }

  TextAlign _getTextAlign() {
    final align = widgetBean.properties['textAlign'] ?? 'left';
    switch (align) {
      case 'left': return TextAlign.left;
      case 'right': return TextAlign.right;
      case 'center': return TextAlign.center;
      case 'justify': return TextAlign.justify;
      case 'start': return TextAlign.start;
      case 'end': return TextAlign.end;
      default: return TextAlign.left;
    }
  }

  int? _getMaxLines() {
    final lines = widgetBean.properties['maxLines'];
    return lines != null ? (lines as num).toInt() : null;
  }

  TextOverflow _getTextOverflow() {
    final overflow = widgetBean.properties['textOverflow'] ?? 'ellipsis';
    switch (overflow) {
      case 'clip': return TextOverflow.clip;
      case 'fade': return TextOverflow.fade;
      case 'visible': return TextOverflow.visible;
      default: return TextOverflow.ellipsis;
    }
  }

  bool _getSoftWrap() {
    return widgetBean.properties['softWrap'] ?? true;
  }

  Color _parseColor(String colorString) {
    try {
      if (colorString.startsWith('#')) {
        return Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
      }
      return Colors.black;
    } catch (e) {
      return Colors.black;
    }
  }

  /// Create a FlutterWidgetBean for Text
  static FlutterWidgetBean createBean({
    String? id,
    Map<String, dynamic>? properties,
  }) {
    return FlutterWidgetBean(
      id: id ?? FlutterWidgetBean.generateId(),
      type: 'Text',
      properties: {
        'text': 'Text Widget',
        'fontSize': 14.0,
        'fontWeight': 'normal',
        'fontStyle': 'normal',
        'textColor': '#000000',
        'backgroundColor': '#FFFFFF',
        'textAlign': 'left',
        'maxLines': null,
        'textOverflow': 'ellipsis',
        'softWrap': true,
        'textDecoration': 'none',
        'decorationColor': '#000000',
        'decorationThickness': 1.0,
        ...?properties,
      },
      children: [],
      position: PositionBean(
        x: 0,
        y: 0,
        width: 120,
        height: 30,
      ),
      events: {},
      layout: LayoutBean(
        width: -2, // WRAP_CONTENT
        height: -2, // WRAP_CONTENT
        marginLeft: 0,
        marginTop: 0,
        marginRight: 0,
        marginBottom: 0,
        paddingLeft: 8,
        paddingTop: 4,
        paddingRight: 8,
        paddingBottom: 4,
      ),
    );
  }
} 