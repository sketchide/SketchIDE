import 'package:flutter/material.dart';
import '../../models/flutter_widget_bean.dart';
import '../../controllers/mobile_frame_touch_controller.dart';
import '../../services/selection_service.dart';
import 'base_frame_item.dart';

/// SKETCHWARE PRO STYLE: Frame Button Widget that matches ItemButton exactly
/// Implements the same interface pattern as Sketchware Pro's ItemButton
class FrameButton extends BaseFrameItem {
  const FrameButton({
    super.key,
    required super.widgetBean,
    super.touchController,
    super.selectionService,
    super.scale,
  });

  @override
  Widget buildContent(BuildContext context) {
    return _FrameButtonContent(
      widgetBean: widgetBean,
      touchController: touchController,
      selectionService: selectionService,
      scale: scale,
    );
  }
}

/// SKETCHWARE PRO STYLE: Frame Button Content Widget
class _FrameButtonContent extends StatelessWidget {
  final FlutterWidgetBean widgetBean;
  final MobileFrameTouchController? touchController;
  final SelectionService? selectionService;
  final double scale;

  const _FrameButtonContent({
    required this.widgetBean,
    this.touchController,
    this.selectionService,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final widgetKey = GlobalKey();

    /// SKETCHWARE PRO STYLE: Get exact position and size like ItemButton
    final position = widgetBean.position;
    final layout = widgetBean.layout;

    // SKETCHWARE PRO STYLE: Convert dp to pixels like wB.a(context, value)
    final density = MediaQuery.of(context).devicePixelRatio;

    // SKETCHWARE PRO STYLE: Handle width/height like ViewPane.updateLayout()
    double width = position.width * scale;
    double height = position.height * scale;

    // SKETCHWARE PRO STYLE: If width/height are positive, convert dp to pixels
    if (layout.width > 0) {
      width = layout.width * density * scale;
    }
    if (layout.height > 0) {
      height = layout.height * density * scale;
    }

    return GestureDetector(
      onTapDown: (details) {
        // Handle tap down
      },
      onLongPressStart: (details) {
        // Handle long press start
      },
      onLongPressMoveUpdate: (details) {
        // Handle long press move update
      },
      onLongPressEnd: (details) {
        // Handle long press end
      },
      onPanStart: (details) {
        // Handle pan start
      },
      onPanUpdate: (details) {
        // Handle pan update
      },
      onPanEnd: (details) {
        // Handle pan end
      },
      child: Container(
        key: widgetKey,
        // SKETCHWARE PRO STYLE: Use exact width/height like ItemButton
        width: width > 0 ? width : null,
        height: height > 0 ? height : null,
        // SKETCHWARE PRO STYLE: Minimum size like ItemButton (32dp)
        constraints: BoxConstraints(
          minWidth: 32 * density * scale,
          minHeight: 32 * density * scale,
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  /// SKETCHWARE PRO STYLE: Build button content (matches ItemButton)
  Widget _buildButtonContent(BuildContext context) {
    final backgroundColor = _getBackgroundColor();
    final cornerRadius = _getCornerRadius();

    // SKETCHWARE PRO STYLE: Convert dp to pixels like Android
    final density = MediaQuery.of(context).devicePixelRatio;
    final scaledCornerRadius = cornerRadius * density * scale;

    return Container(
      // SKETCHWARE PRO STYLE: Minimum size like ItemButton
      constraints: BoxConstraints(
        minWidth: 32 * density * scale,
        minHeight: 32 * density * scale,
      ),
      decoration: BoxDecoration(
        // SKETCHWARE PRO STYLE: Background color handling like ItemButton
        color: backgroundColor,
        borderRadius: BorderRadius.circular(scaledCornerRadius),
      ),
      child: Center(
        child: Text(
          _getText(),
          style: _getTextStyle(context),
        ),
      ),
    );
  }

  /// SKETCHWARE PRO STYLE: Get text content (matches ItemButton)
  String _getText() {
    final text = widgetBean.properties['text']?.toString() ?? '';

    // SKETCHWARE PRO STYLE: If text is empty, show default content like ItemButton
    if (text.isEmpty) {
      return 'Button'; // SKETCHWARE PRO STYLE: Default text like IconButton.getBean()
    }

    return text;
  }

  /// SKETCHWARE PRO STYLE: Get text style (matches ItemButton)
  TextStyle _getTextStyle(BuildContext context) {
    final fontSize = _parseDouble(widgetBean.properties['textSize']) ?? 14.0;
    final textColor =
        _parseColor(widgetBean.properties['textColor'] ?? '#FFFFFF');

    // SKETCHWARE PRO STYLE: Convert sp to pixels like Android
    final density = MediaQuery.of(context).devicePixelRatio;
    final scaledFontSize = fontSize * density * scale;

    return TextStyle(
      fontSize: scaledFontSize,
      color: textColor,
      fontWeight: FontWeight.w500,
    );
  }

  /// SKETCHWARE PRO STYLE: Get background color (matches ItemButton)
  Color _getBackgroundColor() {
    final backgroundColor =
        widgetBean.properties['backgroundColor']?.toString() ?? '#2196F3';

    // SKETCHWARE PRO STYLE: Handle white background like ItemButton
    if (backgroundColor == '#FFFFFF' || backgroundColor == '#ffffff') {
      return Colors
          .transparent; // SKETCHWARE PRO STYLE: Transparent for white background
    }

    return _parseColor(backgroundColor);
  }

  /// SKETCHWARE PRO STYLE: Get corner radius (matches ItemButton)
  double _getCornerRadius() {
    final radius = widgetBean.properties['cornerRadius'];
    if (radius is num) {
      return radius.toDouble();
    }
    return 0.0;
  }

  /// SKETCHWARE PRO STYLE: Parse double from various types
  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  /// SKETCHWARE PRO STYLE: Parse color from string
  Color _parseColor(String colorString) {
    if (colorString.startsWith('#')) {
      try {
        final colorInt =
            int.parse(colorString.substring(1), radix: 16) + 0xFF000000;
        return Color(colorInt);
      } catch (e) {
        return Colors.transparent;
      }
    }
    return Colors.transparent;
  }
}
