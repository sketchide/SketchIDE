import 'package:flutter/material.dart';
import '../../models/flutter_widget_bean.dart';
import '../../controllers/mobile_frame_touch_controller.dart';
import '../../services/selection_service.dart';
import '../../services/child_widget_service.dart';
import '../../services/layout_property_service.dart';

/// FrameRow - Mobile frame version of Row widget (matches Sketchware Pro's ItemLinearLayout)
/// Enhanced touch handling, selection visual feedback, and drag capabilities
class FrameRow extends StatefulWidget {
  final FlutterWidgetBean widgetBean;
  final double scale;
  final MobileFrameTouchController? touchController;
  final SelectionService? selectionService;
  final Function(FlutterWidgetBean)? onWidgetSelected;
  final Function(FlutterWidgetBean, Offset)? onWidgetDragStart;
  final Function(FlutterWidgetBean, Offset)? onWidgetDragUpdate;
  final Function(FlutterWidgetBean, Offset)? onWidgetDragEnd;
  final List<FlutterWidgetBean> allWidgets;

  const FrameRow({
    super.key,
    required this.widgetBean,
    this.scale = 1.0,
    this.touchController,
    this.selectionService,
    this.onWidgetSelected,
    this.onWidgetDragStart,
    this.onWidgetDragUpdate,
    this.onWidgetDragEnd,
    required this.allWidgets,
  });

  @override
  State<FrameRow> createState() => _FrameRowState();
}

class _FrameRowState extends State<FrameRow> {
  final GlobalKey _widgetKey = GlobalKey();
  bool _isPressed = false;
  late LayoutPropertyService _layoutPropertyService;

  @override
  void initState() {
    super.initState();
    _layoutPropertyService = LayoutPropertyService();
    _setupTouchController();
  }

  /// SKETCHWARE PRO STYLE: Setup touch controller callbacks
  void _setupTouchController() {
    widget.touchController?.setCallbacks(
      onWidgetSelected: widget.onWidgetSelected,
      onWidgetDragStart: widget.onWidgetDragStart,
      onWidgetDragUpdate: widget.onWidgetDragUpdate,
      onWidgetDragEnd: widget.onWidgetDragEnd,
      onWidgetLongPress: (widget) {
        print('🎯 FRAME ROW LONG PRESS: ${widget.id}');
        // Handle long press feedback
      },
      onDragStateChanged: (isDragging) {
        print('🎯 FRAME ROW DRAG STATE: ${widget.widgetBean.id} - $isDragging');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSelected =
        widget.selectionService?.isWidgetSelected(widget.widgetBean) ?? false;

    // SKETCHWARE PRO STYLE: Get exact position and size like ItemLinearLayout
    final position = widget.widgetBean.position;
    final layout = widget.widgetBean.layout;

    // SKETCHWARE PRO STYLE: Convert dp to pixels like wB.a(context, value)
    final density = MediaQuery.of(context).devicePixelRatio;

    // SKETCHWARE PRO STYLE: Handle width/height like ViewPane.updateLayout()
    double width = position.width * widget.scale;
    double height = position.height * widget.scale;

    // SKETCHWARE PRO STYLE: If width/height are positive, convert dp to pixels
    if (layout.width > 0) {
      width = layout.width * density * widget.scale;
    }
    if (layout.height > 0) {
      height = layout.height * density * widget.scale;
    }

    return GestureDetector(
      onTapDown: (details) {
        setState(() => _isPressed = true);
        _handleTouchStart(details.globalPosition);
      },
      onTapUp: (details) {
        setState(() => _isPressed = false);
        _handleTouchEnd(details.globalPosition);
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _handleTouchCancel();
      },
      onPanStart: (details) {
        _handleTouchStart(details.globalPosition);
      },
      onPanUpdate: (details) {
        _handleTouchMove(details.globalPosition);
      },
      onPanEnd: (details) {
        _handleTouchEnd(details.globalPosition);
      },
      child: CustomPaint(
        painter: _SelectionPainter(isSelected),
        child: Container(
          key: _widgetKey,
          // SKETCHWARE PRO STYLE: Use exact width/height like ItemLinearLayout
          width: width > 0 ? width : null,
          height: height > 0 ? height : null,
          // SKETCHWARE PRO STYLE: Minimum size like ItemLinearLayout (32dp)
          constraints: BoxConstraints(
            minWidth: 32 * density * widget.scale,
            minHeight: 32 * density * widget.scale,
          ),
          child: _buildRowContent(),
        ),
      ),
    );
  }

  /// SKETCHWARE PRO STYLE: Build row content with properties
  Widget _buildRowContent() {
    final backgroundColor = _getBackgroundColor();
    final mainAxisAlignment = _getMainAxisAlignment();
    final crossAxisAlignment = _getCrossAxisAlignment();
    final childWidgets = _buildChildWidgets();

    // SKETCHWARE PRO STYLE: Convert dp to pixels like Android
    final density = MediaQuery.of(context).devicePixelRatio;
    final scaledFontSize = 12 * density * widget.scale;

    return Container(
      // SKETCHWARE PRO STYLE: Minimum size like ItemLinearLayout
      constraints: BoxConstraints(
        minWidth: 32 * density * widget.scale,
        minHeight: 32 * density * widget.scale,
      ),
      // SKETCHWARE PRO STYLE: Background color handling like ItemLinearLayout
      color: backgroundColor,
      child: childWidgets.isNotEmpty
          ? Row(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              children: childWidgets,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20 * density * widget.scale,
                  height: 20 * density * widget.scale,
                  color: Colors.grey[300],
                  margin: EdgeInsets.all(4 * density * widget.scale),
                ),
                Container(
                  width: 20 * density * widget.scale,
                  height: 20 * density * widget.scale,
                  color: Colors.grey[300],
                  margin: EdgeInsets.all(4 * density * widget.scale),
                ),
                Container(
                  width: 20 * density * widget.scale,
                  height: 20 * density * widget.scale,
                  color: Colors.grey[300],
                  margin: EdgeInsets.all(4 * density * widget.scale),
                ),
              ],
            ),
    );
  }

  /// SKETCHWARE PRO STYLE: Build child widgets using enhanced service
  List<Widget> _buildChildWidgets() {
    return ChildWidgetService().buildChildWidgets(
      widget.widgetBean,
      widget.allWidgets,
      widget.scale,
      widget.touchController,
      widget.selectionService,
    );
  }

  /// SKETCHWARE PRO STYLE: Build sample items for preview
  List<Widget> _buildSampleItems() {
    return [
      _buildSampleItem('Item 1'),
      _buildSampleItem('Item 2'),
      _buildSampleItem('Item 3'),
    ];
  }

  /// SKETCHWARE PRO STYLE: Build sample item
  Widget _buildSampleItem(String text) {
    return Container(
      margin: EdgeInsets.all(4 * widget.scale),
      padding: EdgeInsets.all(8 * widget.scale),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(4 * widget.scale),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10 * widget.scale,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  /// SKETCHWARE PRO STYLE: Get main axis alignment using LayoutPropertyService
  MainAxisAlignment _getMainAxisAlignment() {
    final alignment = widget.widgetBean.properties['mainAxisAlignment'];
    return _layoutPropertyService.parseMainAxisAlignment(alignment);
  }

  /// SKETCHWARE PRO STYLE: Get cross axis alignment using LayoutPropertyService
  CrossAxisAlignment _getCrossAxisAlignment() {
    final alignment = widget.widgetBean.properties['crossAxisAlignment'];
    return _layoutPropertyService.parseCrossAxisAlignment(alignment);
  }

  /// SKETCHWARE PRO STYLE: Get main axis size using LayoutPropertyService
  MainAxisSize _getMainAxisSize() {
    final size = widget.widgetBean.properties['mainAxisSize'];
    return _layoutPropertyService.parseMainAxisSize(size);
  }

  /// SKETCHWARE PRO STYLE: Get background color (matches ItemLinearLayout)
  Color _getBackgroundColor() {
    final color = widget.widgetBean.properties['backgroundColor'];
    if (color != null) {
      if (color is int) {
        // SKETCHWARE PRO STYLE: Handle 0xffffff as transparent
        if (color == 0xffffff) {
          return Colors.transparent;
        }
        return Color(color);
      } else if (color is String && color.startsWith('#')) {
        try {
          final colorInt =
              int.parse(color.substring(1), radix: 16) + 0xFF000000;
          // SKETCHWARE PRO STYLE: Handle #FFFFFF as transparent
          if (colorInt == 0xFFFFFFFF) {
            return Colors.transparent;
          }
          return Color(colorInt);
        } catch (e) {
          return Colors.transparent;
        }
      }
    }
    return Colors.transparent;
  }

  /// SKETCHWARE PRO STYLE: Handle touch start
  void _handleTouchStart(Offset position) {
    print('🎯 FRAME ROW TOUCH START: ${widget.widgetBean.id}');
    widget.touchController
        ?.handleTouchStart(widget.widgetBean, position, _widgetKey);
  }

  /// SKETCHWARE PRO STYLE: Handle touch move
  void _handleTouchMove(Offset position) {
    widget.touchController?.handleTouchMove(position);
  }

  /// SKETCHWARE PRO STYLE: Handle touch end
  void _handleTouchEnd(Offset position) {
    print('🎯 FRAME ROW TOUCH END: ${widget.widgetBean.id}');
    widget.touchController?.handleTouchEnd(position);
  }

  /// SKETCHWARE PRO STYLE: Handle touch cancel
  void _handleTouchCancel() {
    print('🎯 FRAME ROW TOUCH CANCEL: ${widget.widgetBean.id}');
    widget.touchController?.handleTouchCancel();
  }
}

/// SKETCHWARE PRO STYLE: Custom painter for selection visual feedback (matches ItemLinearLayout.onDraw)
class _SelectionPainter extends CustomPainter {
  final bool isSelected;

  _SelectionPainter(this.isSelected);

  @override
  void paint(Canvas canvas, Size size) {
    if (isSelected) {
      // SKETCHWARE PRO STYLE: Use exact same color as ItemLinearLayout (0x9599d5d0)
      final paint = Paint()
        ..color = const Color(0x9599d5d0)
        ..style = PaintingStyle.fill;

      // Draw selection rectangle (matches ItemLinearLayout.onDraw)
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _SelectionPainter &&
        oldDelegate.isSelected != isSelected;
  }
}
