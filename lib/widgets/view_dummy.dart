import 'package:flutter/material.dart';
import '../models/flutter_widget_bean.dart';

/// Simplified ViewDummy - Matches Sketchware Pro's lightweight approach
/// Provides visual feedback during drag operations without complex animations
class ViewDummy extends StatelessWidget {
  final bool isVisible;
  final bool isAllowed;
  final Offset position;
  final FlutterWidgetBean? widgetBean;
  final bool isCustomWidget;

  const ViewDummy({
    super.key,
    this.isVisible = false,
    this.isAllowed = false,
    this.position = Offset.zero,
    this.widgetBean,
    this.isCustomWidget = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: _buildDummyContent(),
    );
  }

  Widget _buildDummyContent() {
    return Container(
      decoration: BoxDecoration(
        color: _getHighlightColor(),
        borderRadius: BorderRadius.circular(2), // Sketchware Pro style
        border: Border.all(
          color: _getBorderColor(),
          width: 1,
        ),
      ),
      child: _buildWidgetPreview(),
    );
  }

  Color _getHighlightColor() {
    if (!isAllowed) {
      return const Color(0xffff5955); // Sketchware Pro red for invalid
    }
    return const Color(
        0x82ff5955); // Sketchware Pro semi-transparent red for valid
  }

  Color _getBorderColor() {
    if (!isAllowed) {
      return const Color(0xffff5955); // Sketchware Pro red
    }
    return const Color(0xffff5955); // Sketchware Pro red
  }

  Widget _buildWidgetPreview() {
    if (widgetBean == null) {
      return Container(
        width: 100,
        height: 50,
        padding: const EdgeInsets.all(4),
        child: const Icon(
          Icons.widgets,
          color: Colors.white,
          size: 20,
        ),
      );
    }

    // Create a simple preview based on widget type
    return Container(
      width: widgetBean!.position.width,
      height: widgetBean!.position.height,
      padding: const EdgeInsets.all(4),
      child: _buildWidgetTypePreview(),
    );
  }

  Widget _buildWidgetTypePreview() {
    final type = widgetBean!.type;
    final properties = widgetBean!.properties;

    switch (type) {
      case 'TextView':
        return Center(
          child: Text(
            properties['text'] ?? 'Text',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        );
      case 'Button':
        return Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              properties['text'] ?? 'Button',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      case 'ImageView':
        return const Center(
          child: Icon(
            Icons.image,
            size: 24,
            color: Colors.white,
          ),
        );
      case 'EditText':
        return Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            properties['hint'] ?? 'Edit Text',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        );
      default:
        return Center(
          child: Text(
            type,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        );
    }
  }
}
