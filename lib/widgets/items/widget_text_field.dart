import 'package:flutter/material.dart';
import '../../models/flutter_widget_bean.dart';

/// WidgetTextField - Flutter TextField widget with Sketchware Pro-style selection
/// Text input field
class WidgetTextField extends StatelessWidget {
  final FlutterWidgetBean widgetBean;
  final bool isSelected;
  final double scale;
  final VoidCallback? onTap;

  const WidgetTextField({
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
              : Border.all(
                  color: Colors.grey.withOpacity(0.3), width: 1 * scale),
          color: isSelected
              ? const Color(0x9599d5d0).withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Padding(
          padding: EdgeInsets.all(4 * scale),
          child: TextField(
            controller: TextEditingController(text: _getText()),
            enabled: false, // Read-only in preview
            style: _getTextStyle(),
            decoration: _getInputDecoration(),
            maxLines: _getMaxLines(),
            obscureText: _getObscureText(),
            textAlign: _getTextAlign(),
            keyboardType: _getKeyboardType(),
            textCapitalization: _getTextCapitalization(),
          ),
        ),
      ),
    );
  }

  String _getText() {
    return widgetBean.properties['text'] ?? '';
  }

  TextStyle _getTextStyle() {
    final fontSize = (widgetBean.properties['fontSize'] ?? 14.0) * scale;
    final fontWeight = _getFontWeight();
    final color = _parseColor(widgetBean.properties['textColor'] ?? '#000000');

    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  FontWeight _getFontWeight() {
    final weight = widgetBean.properties['fontWeight'] ?? 'normal';
    switch (weight) {
      case 'bold':
        return FontWeight.bold;
      case 'w500':
        return FontWeight.w500;
      case 'w600':
        return FontWeight.w600;
      default:
        return FontWeight.normal;
    }
  }

  InputDecoration _getInputDecoration() {
    final hint = widgetBean.properties['hint'] ?? 'Enter text';
    final label = widgetBean.properties['label'];
    final prefixIcon = widgetBean.properties['prefixIcon'];
    final suffixIcon = widgetBean.properties['suffixIcon'];
    final borderType = widgetBean.properties['borderType'] ?? 'outline';
    final borderColor =
        _parseColor(widgetBean.properties['borderColor'] ?? '#CCCCCC');
    final focusedBorderColor =
        _parseColor(widgetBean.properties['focusedBorderColor'] ?? '#2196F3');
    final borderRadius = (widgetBean.properties['borderRadius'] ?? 4.0) * scale;

    return InputDecoration(
      hintText: hint,
      labelText: label,
      prefixIcon:
          prefixIcon != null ? Icon(Icons.edit, size: 16 * scale) : null,
      suffixIcon:
          suffixIcon != null ? Icon(Icons.clear, size: 16 * scale) : null,
      border: _getBorder(borderType, borderColor, borderRadius),
      enabledBorder: _getBorder(borderType, borderColor, borderRadius),
      focusedBorder: _getBorder(borderType, focusedBorderColor, borderRadius),
      filled: widgetBean.properties['filled'] ?? false,
      fillColor: _parseColor(widgetBean.properties['fillColor'] ?? '#F5F5F5'),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12 * scale,
        vertical: 8 * scale,
      ),
    );
  }

  OutlineInputBorder _getBorder(String type, Color color, double radius) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(
        color: color,
        width: type == 'none' ? 0 : 1 * scale,
      ),
    );
  }

  int? _getMaxLines() {
    final lines = widgetBean.properties['maxLines'];
    return lines != null ? (lines as num).toInt() : 1;
  }

  bool _getObscureText() {
    return widgetBean.properties['obscureText'] ?? false;
  }

  TextAlign _getTextAlign() {
    final align = widgetBean.properties['textAlign'] ?? 'left';
    switch (align) {
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      case 'center':
        return TextAlign.center;
      case 'justify':
        return TextAlign.justify;
      case 'start':
        return TextAlign.start;
      case 'end':
        return TextAlign.end;
      default:
        return TextAlign.left;
    }
  }

  TextInputType _getKeyboardType() {
    final type = widgetBean.properties['keyboardType'] ?? 'text';
    switch (type) {
      case 'text':
        return TextInputType.text;
      case 'number':
        return TextInputType.number;
      case 'email':
        return TextInputType.emailAddress;
      case 'phone':
        return TextInputType.phone;
      case 'url':
        return TextInputType.url;
      case 'multiline':
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  TextCapitalization _getTextCapitalization() {
    final capitalization =
        widgetBean.properties['textCapitalization'] ?? 'sentences';
    switch (capitalization) {
      case 'words':
        return TextCapitalization.words;
      case 'sentences':
        return TextCapitalization.sentences;
      case 'characters':
        return TextCapitalization.characters;
      case 'none':
        return TextCapitalization.none;
      default:
        return TextCapitalization.sentences;
    }
  }

  Color _parseColor(String colorString) {
    try {
      if (colorString.startsWith('#')) {
        return Color(
            int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
      }
      return Colors.grey;
    } catch (e) {
      return Colors.grey;
    }
  }

  /// Create a FlutterWidgetBean for TextField
  static FlutterWidgetBean createBean({
    String? id,
    Map<String, dynamic>? properties,
  }) {
    return FlutterWidgetBean(
      id: id ?? FlutterWidgetBean.generateId(),
      type: 'TextField',
      properties: {
        'text': '',
        'hint': 'Enter text',
        'label': null,
        'fontSize': 14.0,
        'fontWeight': 'normal',
        'textColor': '#000000',
        'borderType': 'outline',
        'borderColor': '#CCCCCC',
        'focusedBorderColor': '#2196F3',
        'borderRadius': 4.0,
        'filled': false,
        'fillColor': '#F5F5F5',
        'maxLines': 1,
        'obscureText': false,
        'textAlign': 'left',
        'keyboardType': 'text',
        'textCapitalization': 'sentences',
        'prefixIcon': null,
        'suffixIcon': null,
        ...?properties,
      },
      children: [],
      position: PositionBean(
        x: 0,
        y: 0,
        width: 200,
        height: 50,
      ),
      events: {},
      layout: LayoutBean(
        width: -1, // MATCH_PARENT
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
