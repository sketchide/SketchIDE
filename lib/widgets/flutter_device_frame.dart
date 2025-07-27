import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/flutter_widget_bean.dart';
import '../models/view_info.dart';
import '../services/view_info_service.dart';
import 'enhanced_view_pane.dart';
import 'view_dummy.dart';

/// Flutter Device Frame (Center) - EXACTLY matches Sketchware Pro's ViewPane
///
/// SIMPLIFIED DESIGN:
/// - Pure white background (matches Sketchware Pro)
/// - Simple border (no device simulation)
/// - Red highlight colors (matches Sketchware Pro)
/// - Optional ViewDummy for enhanced feedback
/// - Maintains sophisticated ViewInfo system
///
/// FEATURES:
/// - Coordinate-based drop zone detection
/// - Scale-aware widget positioning
/// - Enhanced drag feedback (optional)
/// - Grid background for alignment
class FlutterDeviceFrame extends StatefulWidget {
  final List<FlutterWidgetBean> widgets;
  final FlutterWidgetBean? selectedWidget;
  final Function(FlutterWidgetBean) onWidgetSelected;
  final Function(FlutterWidgetBean) onWidgetMoved;
  final Function(FlutterWidgetBean) onWidgetAdded;

  const FlutterDeviceFrame({
    super.key,
    required this.widgets,
    this.selectedWidget,
    required this.onWidgetSelected,
    required this.onWidgetMoved,
    required this.onWidgetAdded,
  });

  @override
  State<FlutterDeviceFrame> createState() => _FlutterDeviceFrameState();
}

class _FlutterDeviceFrameState extends State<FlutterDeviceFrame> {
  late ViewInfoService _viewInfoService;
  double _scale = 1.0;
  bool _showEnhancedViewPane = true;
  bool _showViewDummy = true; // Optional ViewDummy toggle

  // Sketchware Pro style drop zone detection
  List<DropZoneInfo> _dropZones = [];
  DropZoneInfo? _currentDropZone;

  @override
  void initState() {
    super.initState();
    _viewInfoService = ViewInfoService();
  }

  @override
  void dispose() {
    _viewInfoService.dispose();
    super.dispose();
  }

  // Enhanced View Pane callbacks
  void _onDropTargetChanged(FlutterWidgetBean widget, ViewInfo? viewInfo) {
    _viewInfoService.highlightViewInfo(viewInfo);
    setState(() {
      // Update UI state based on drop target
    });
  }

  void _onDropZoneChanged(FlutterWidgetBean widget, dynamic dropZone) {
    if (dropZone is DropZoneInfo) {
      _viewInfoService.setCurrentDropZone(dropZone);
      _currentDropZone = dropZone;
    } else {
      _viewInfoService.setCurrentDropZone(null);
      _currentDropZone = null;
    }
    setState(() {
      // Update UI state based on drop zone
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Stack(
        children: [
          Column(
            children: [
              // Device Frame Header (like Sketchware Pro)
              _buildDeviceHeader(),

              // Device Frame Content with Phone Simulation
              Expanded(
                child: _buildPhoneSimulation(),
              ),
            ],
          ),

          // Delete Zone (overlay)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: const SizedBox.shrink(), // Removed DeleteZone
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceHeader() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.phone_android,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Sketchware Pro Style Preview',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // ViewDummy Toggle (optional enhanced feedback)
          IconButton(
            icon: Icon(
              _showViewDummy ? Icons.visibility : Icons.visibility_off,
              size: 18,
            ),
            onPressed: () => setState(() => _showViewDummy = !_showViewDummy),
            tooltip: 'Toggle Enhanced Drag Feedback',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
          // Zoom Controls
          IconButton(
            icon: const Icon(Icons.zoom_in, size: 18),
            onPressed: () =>
                setState(() => _scale = (_scale + 0.1).clamp(0.5, 2.0)),
            tooltip: 'Zoom In',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out, size: 18),
            onPressed: () =>
                setState(() => _scale = (_scale - 0.1).clamp(0.5, 2.0)),
            tooltip: 'Zoom Out',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneSimulation() {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate available space like Sketchware Pro
          final availableWidth = constraints.maxWidth - 40;
          final availableHeight = constraints.maxHeight - 40;

          // Calculate scale factors like Sketchware Pro
          final scaleX =
              availableWidth / 360.0; // 360dp is Sketchware Pro's base width
          final scaleY =
              availableHeight / 640.0; // 640dp is Sketchware Pro's base height

          // Use the smaller scale to maintain aspect ratio (like Sketchware Pro)
          final calculatedScale = _scale * (scaleX < scaleY ? scaleX : scaleY);

          // Calculate final content dimensions
          final contentWidth = 360 * calculatedScale;
          final contentHeight = 640 * calculatedScale;

          // SKETCHWARE PRO STYLE: Simple white container with border
          return Container(
            width: contentWidth,
            height: contentHeight,
            decoration: BoxDecoration(
              color: Colors.white, // Pure white like Sketchware Pro
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: _buildContentArea(calculatedScale),
          );
        },
      ),
    );
  }

  // Removed status bar and toolbar methods - simplified to match Sketchware Pro

  // SKETCHWARE PRO STYLE CONTENT AREA
  Widget _buildContentArea(double scale) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerSize = Size(constraints.maxWidth, constraints.maxHeight);

        return Container(
          color: Colors.white,
          child: Stack(
            children: [
              // Background grid (like Sketchware Pro)
              CustomPaint(
                painter: GridPainter(scale: scale),
                size: Size.infinite,
              ),

              // Enhanced View Pane (like Sketchware Pro's ViewPane)
              if (_showEnhancedViewPane)
                EnhancedViewPane(
                  widgets: widget.widgets,
                  onWidgetSelected: widget.onWidgetSelected,
                  onDropTargetChanged: _onDropTargetChanged,
                  onDropZoneChanged: _onDropZoneChanged,
                  viewInfoService: _viewInfoService,
                  containerSize:
                      Size(constraints.maxWidth, constraints.maxHeight),
                ),

              // SKETCHWARE PRO STYLE: Drag target for palette widgets
              _buildDragTargetOverlay(),

              // Optional ViewDummy for enhanced drag feedback
              if (_showViewDummy) _buildViewDummyOverlay(),
            ],
          ),
        );
      },
    );
  }

  // SKETCHWARE PRO STYLE: Drag target overlay for palette widgets
  Widget _buildDragTargetOverlay() {
    return Positioned.fill(
      child: DragTarget<FlutterWidgetBean>(
        // SKETCHWARE PRO STYLE: Accept all widgets
        onWillAccept: (data) {
          print('🎯 DRAG TARGET: Will accept ${data?.type}'); // Debug output
          return data != null;
        },

        // SKETCHWARE PRO STYLE: Handle widget drop
        onAccept: (widgetData) {
          print('🎯 WIDGET DROPPED: ${widgetData.type}'); // Debug output
          _handleWidgetDrop(widgetData);
        },

        // SKETCHWARE PRO STYLE: Visual feedback during drag
        onMove: (details) {
          print(
              '🎯 DRAG MOVE: ${details.data.type} at ${details.offset}'); // Debug output
        },

        // SKETCHWARE PRO STYLE: Build drag target with red highlight colors
        builder: (context, candidateData, rejectedData) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: candidateData.isNotEmpty
                    ? const Color(0xffff5955) // Sketchware Pro red
                    : Colors.transparent,
                width: candidateData.isNotEmpty ? 2 : 0,
              ),
              color: candidateData.isNotEmpty
                  ? const Color(
                      0x82ff5955) // Sketchware Pro semi-transparent red
                  : Colors.transparent,
            ),
            child: Center(
              child: candidateData.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xffff5955), // Sketchware Pro red
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Drop here',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : const Text(
                      'Drop widgets here',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  // SKETCHWARE PRO STYLE: Handle widget drop
  void _handleWidgetDrop(FlutterWidgetBean widgetData) {
    // Create a new widget with proper position
    final newWidget = FlutterWidgetBean(
      id: FlutterWidgetBean.generateId(),
      type: widgetData.type,
      properties: Map<String, dynamic>.from(widgetData.properties),
      children: [],
      position: PositionBean(
        x: 50, // Default position
        y: 50,
        width: 200,
        height: 50,
      ),
      events: {},
      layout: widgetData.layout,
    );

    // Add the widget to the list
    widget.onWidgetAdded(newWidget);

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${widgetData.type} widget'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // SKETCHWARE PRO STYLE WIDGET RENDERING
  Widget _buildSketchwareProWidgets(double scale) {
    // Build drop zones first (like Sketchware Pro's ViewInfo system)
    _buildDropZones(scale);

    return Stack(
      children: widget.widgets
          .map((widgetBean) => _buildSketchwareProWidget(widgetBean, scale))
          .toList(),
    );
  }

  // SKETCHWARE PRO STYLE WIDGET
  Widget _buildSketchwareProWidget(FlutterWidgetBean widgetBean, double scale) {
    final isSelected = widget.selectedWidget?.id == widgetBean.id;
    final widgetKey = GlobalKey();

    // Calculate position like Sketchware Pro
    final position = _calculateWidgetPosition(widgetBean, scale);

    return Positioned(
      left: position.left,
      top: position.top,
      child: GestureDetector(
        onTap: () => widget.onWidgetSelected(widgetBean),
        child: Listener(
          onPointerDown: (details) =>
              _startDragDetection(widgetBean, details, widgetKey),
          onPointerMove: (details) => _updateDragDetection(details),
          onPointerUp: (details) => _endDragDetection(),
          onPointerCancel: (details) => _cancelDragDetection(),
          child: RepaintBoundary(
            key: widgetKey,
            child: Container(
              width: position.width,
              height: position.height,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.withOpacity(0.3),
                  width: isSelected ? 2 : 1,
                ),
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Colors.transparent,
              ),
              child: _buildRealWidgetWithScale(widgetBean, scale),
            ),
          ),
        ),
      ),
    );
  }

  // SKETCHWARE PRO STYLE POSITION CALCULATION
  WidgetPosition _calculateWidgetPosition(
      FlutterWidgetBean widgetBean, double scale) {
    // Like Sketchware Pro's LayoutParams system
    double width = widgetBean.position.width * scale;
    double height = widgetBean.position.height * scale;

    // Handle MATCH_PARENT and WRAP_CONTENT like Sketchware Pro
    if (widgetBean.layout.width == LayoutBean.MATCH_PARENT) {
      width = 360 * scale; // Full width
    } else if (widgetBean.layout.width == LayoutBean.WRAP_CONTENT) {
      width = _calculateWrapContentWidth(widgetBean, scale);
    }

    if (widgetBean.layout.height == LayoutBean.MATCH_PARENT) {
      height = 640 * scale; // Full height
    } else if (widgetBean.layout.height == LayoutBean.WRAP_CONTENT) {
      height = _calculateWrapContentHeight(widgetBean, scale);
    }

    return WidgetPosition(
      left: widgetBean.position.x * scale,
      top: widgetBean.position.y * scale,
      width: width,
      height: height,
    );
  }

  double _calculateWrapContentWidth(
      FlutterWidgetBean widgetBean, double scale) {
    // Calculate based on content like Sketchware Pro
    switch (widgetBean.type) {
      case 'TextView':
        final text = widgetBean.properties['text'] ?? 'Text';
        final fontSize =
            double.tryParse(widgetBean.properties['fontSize'] ?? '14') ?? 14.0;
        return (text.length * fontSize * 0.6 + 16) *
            scale; // Approximate text width
      case 'Button':
        final text = widgetBean.properties['text'] ?? 'Button';
        final fontSize =
            double.tryParse(widgetBean.properties['fontSize'] ?? '14') ?? 14.0;
        return (text.length * fontSize * 0.6 + 32) * scale; // Button padding
      default:
        return widgetBean.position.width * scale;
    }
  }

  double _calculateWrapContentHeight(
      FlutterWidgetBean widgetBean, double scale) {
    // Calculate based on content like Sketchware Pro
    switch (widgetBean.type) {
      case 'TextView':
        final fontSize =
            double.tryParse(widgetBean.properties['fontSize'] ?? '14') ?? 14.0;
        return (fontSize + 8) * scale; // Text height + padding
      case 'Button':
        final fontSize =
            double.tryParse(widgetBean.properties['fontSize'] ?? '14') ?? 14.0;
        return (fontSize + 16) * scale; // Button height
      default:
        return widgetBean.position.height * scale;
    }
  }

  // SKETCHWARE PRO STYLE DROP ZONE DETECTION
  void _buildDropZones(double scale) {
    _dropZones.clear();

    // Add drop zones for each widget (like Sketchware Pro's ViewInfo system)
    for (int i = 0; i < widget.widgets.length; i++) {
      final widgetBean = widget.widgets[i];
      final position = _calculateWidgetPosition(widgetBean, scale);

      _dropZones.add(DropZoneInfo(
        bounds: Rect.fromLTWH(
            position.left, position.top, position.width, position.height),
        targetWidget: widgetBean,
        index: i,
        depth: i,
      ));
    }
  }

  // SKETCHWARE PRO STYLE DROP ZONE DETECTION
  DropZoneInfo? _getDropZoneAtPosition(Offset position) {
    DropZoneInfo? result;
    int highestPriority = -1;

    for (DropZoneInfo dropZone in _dropZones) {
      if (dropZone.bounds.contains(position) &&
          highestPriority < dropZone.depth) {
        highestPriority = dropZone.depth;
        result = dropZone;
      }
    }

    return result;
  }

  // Proper long-press detection like Sketchware Pro
  void _startDragDetection(FlutterWidgetBean widgetBean,
      PointerDownEvent details, GlobalKey widgetKey) {
    // Removed old drag controller logic
  }

  void _updateDragDetection(PointerMoveEvent details) {
    // Removed old drag controller logic

    // Update drop zone detection like Sketchware Pro
    final dropZone = _getDropZoneAtPosition(details.position);
    if (dropZone != _currentDropZone) {
      _currentDropZone = dropZone;
      // Update visual feedback
    }
  }

  void _endDragDetection() {
    // Removed old drag controller logic
    _currentDropZone = null;
  }

  void _cancelDragDetection() {
    // Removed old drag controller logic
    _currentDropZone = null;
  }

  Widget _buildDragOverlay() {
    // Removed old drag controller logic
    return const SizedBox.shrink();
  }

  // Build real widget with proper scale
  Widget _buildRealWidgetWithScale(FlutterWidgetBean widgetBean, double scale) {
    switch (widgetBean.type) {
      case 'TextView':
        return _buildTextViewWithScale(widgetBean, scale);
      case 'EditText':
        return _buildEditTextWithScale(widgetBean, scale);
      case 'Button':
        return _buildButtonWithScale(widgetBean, scale);
      case 'ImageView':
        return _buildImageViewWithScale(widgetBean, scale);
      case 'LinearLayout':
        return _buildLinearLayoutWithScale(widgetBean, scale);
      case 'RelativeLayout':
        return _buildRelativeLayoutWithScale(widgetBean, scale);
      case 'ScrollView':
        return _buildScrollViewWithScale(widgetBean, scale);
      case 'ListView':
        return _buildListViewWithScale(widgetBean, scale);
      case 'ProgressBar':
        return _buildProgressBarWithScale(widgetBean, scale);
      case 'SeekBar':
        return _buildSeekBarWithScale(widgetBean, scale);
      case 'Switch':
        return _buildSwitchWithScale(widgetBean, scale);
      case 'CheckBox':
        return _buildCheckBoxWithScale(widgetBean, scale);
      case 'RadioButton':
        return _buildRadioButtonWithScale(widgetBean, scale);
      case 'Spinner':
        return _buildSpinnerWithScale(widgetBean, scale);
      case 'CalendarView':
        return _buildCalendarViewWithScale(widgetBean, scale);
      case 'WebView':
        return _buildWebViewWithScale(widgetBean, scale);
      case 'MapView':
        return _buildMapViewWithScale(widgetBean, scale);
      case 'AdView':
        return _buildAdViewWithScale(widgetBean, scale);
      case 'FloatingActionButton':
        return _buildFloatingActionButtonWithScale(widgetBean, scale);
      default:
        return _buildUnknownWidgetWithScale(widgetBean, scale);
    }
  }

  Widget _buildTextViewWithScale(FlutterWidgetBean widgetBean, double scale) {
    final text = widgetBean.properties['text'] ?? 'Text View';
    final fontSize =
        double.tryParse(widgetBean.properties['fontSize'] ?? '14') ?? 14.0;
    final textColor =
        _parseColor(widgetBean.properties['textColor'] ?? '#000000');
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');
    final fontWeight =
        _parseFontWeight(widgetBean.properties['fontWeight'] ?? 'normal');
    final textAlign =
        _parseTextAlign(widgetBean.properties['gravity'] ?? 'left');

    return Container(
      color: backgroundColor,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize * scale,
            color: textColor,
            fontWeight: fontWeight,
          ),
          textAlign: textAlign,
          maxLines: int.tryParse(widgetBean.properties['lines'] ?? '1') ?? 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildEditTextWithScale(FlutterWidgetBean widgetBean, double scale) {
    final hint = widgetBean.properties['hint'] ?? 'Enter text';
    final text = widgetBean.properties['text'] ?? '';
    final fontSize =
        double.tryParse(widgetBean.properties['fontSize'] ?? '14') ?? 14.0;
    final textColor =
        _parseColor(widgetBean.properties['textColor'] ?? '#000000');
    final hintColor =
        _parseColor(widgetBean.properties['hintColor'] ?? '#757575');
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');

    return Container(
      color: backgroundColor,
      child: TextField(
        controller: TextEditingController(text: text),
        enabled: false, // Read-only in preview
        style: TextStyle(
          fontSize: fontSize * scale,
          color: textColor,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: fontSize * scale,
            color: hintColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4 * scale),
          ),
          contentPadding: EdgeInsets.all(8 * scale),
        ),
      ),
    );
  }

  Widget _buildButtonWithScale(FlutterWidgetBean widgetBean, double scale) {
    final text = widgetBean.properties['text'] ?? 'Button';
    final fontSize =
        double.tryParse(widgetBean.properties['fontSize'] ?? '14') ?? 14.0;
    final textColor =
        _parseColor(widgetBean.properties['textColor'] ?? '#FFFFFF');
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#2196F3');

    return Container(
      color: backgroundColor,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize * scale,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildImageViewWithScale(FlutterWidgetBean widgetBean, double scale) {
    final src = widgetBean.properties['src'] ?? 'default_image';
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#F5F5F5');

    return Container(
      color: backgroundColor,
      child: Center(
        child: Icon(
          Icons.image,
          size: 32 * scale,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildLinearLayoutWithScale(
      FlutterWidgetBean widgetBean, double scale) {
    final orientation = widgetBean.properties['orientation'] ?? 'vertical';
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');
    final gravity =
        _parseMainAxisAlignment(widgetBean.properties['gravity'] ?? 'left');

    return Container(
      color: backgroundColor,
      child: orientation == 'vertical'
          ? Column(
              mainAxisAlignment: gravity,
              children: _buildChildWidgetsWithScale(widgetBean, scale),
            )
          : Row(
              mainAxisAlignment: gravity,
              children: _buildChildWidgetsWithScale(widgetBean, scale),
            ),
    );
  }

  Widget _buildRelativeLayoutWithScale(
      FlutterWidgetBean widgetBean, double scale) {
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');

    return Container(
      color: backgroundColor,
      child: Stack(
        children: _buildChildWidgetsWithScale(widgetBean, scale),
      ),
    );
  }

  Widget _buildScrollViewWithScale(FlutterWidgetBean widgetBean, double scale) {
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');

    return Container(
      color: backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: _buildChildWidgetsWithScale(widgetBean, scale),
        ),
      ),
    );
  }

  Widget _buildListViewWithScale(FlutterWidgetBean widgetBean, double scale) {
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');
    final itemCount =
        int.tryParse(widgetBean.properties['itemCount'] ?? '3') ?? 3;

    return Container(
      color: backgroundColor,
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item ${index + 1}'),
            leading: Icon(Icons.list),
          );
        },
      ),
    );
  }

  Widget _buildProgressBarWithScale(
      FlutterWidgetBean widgetBean, double scale) {
    final progress =
        double.tryParse(widgetBean.properties['progress'] ?? '50') ?? 50.0;
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#F5F5F5');

    return Container(
      color: backgroundColor,
      child: Center(
        child: SizedBox(
          width: 200 * scale,
          child: LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSeekBarWithScale(FlutterWidgetBean widgetBean, double scale) {
    final progress =
        double.tryParse(widgetBean.properties['progress'] ?? '50') ?? 50.0;
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#F5F5F5');

    return Container(
      color: backgroundColor,
      child: Center(
        child: SizedBox(
          width: 200 * scale,
          child: Slider(
            value: progress,
            min: 0,
            max: 100,
            onChanged: (value) {
              // Read-only in preview
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchWithScale(FlutterWidgetBean widgetBean, double scale) {
    final checked = widgetBean.properties['checked'] == 'true';
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');

    return Container(
      color: backgroundColor,
      child: Center(
        child: Switch(
          value: checked,
          onChanged: (value) {
            // Read-only in preview
          },
        ),
      ),
    );
  }

  Widget _buildCheckBoxWithScale(FlutterWidgetBean widgetBean, double scale) {
    final text = widgetBean.properties['text'] ?? 'Check Box';
    final checked = widgetBean.properties['checked'] == 'true';
    final textColor =
        _parseColor(widgetBean.properties['textColor'] ?? '#000000');
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');

    return Container(
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            value: checked,
            onChanged: (value) {
              // Read-only in preview
            },
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 14 * scale,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioButtonWithScale(
      FlutterWidgetBean widgetBean, double scale) {
    final text = widgetBean.properties['text'] ?? 'Radio Button';
    final checked = widgetBean.properties['checked'] == 'true';
    final textColor =
        _parseColor(widgetBean.properties['textColor'] ?? '#000000');
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');

    return Container(
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio<bool>(
            value: true,
            groupValue: checked ? true : false,
            onChanged: (value) {
              // Read-only in preview
            },
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 14 * scale,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpinnerWithScale(FlutterWidgetBean widgetBean, double scale) {
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');

    return Container(
      color: backgroundColor,
      child: Center(
        child: DropdownButton<String>(
          value: 'Item 1',
          items: ['Item 1', 'Item 2', 'Item 3'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            // Read-only in preview
          },
        ),
      ),
    );
  }

  Widget _buildCalendarViewWithScale(
      FlutterWidgetBean widgetBean, double scale) {
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');

    return Container(
      color: backgroundColor,
      child: Center(
        child: Icon(
          Icons.calendar_today,
          size: 32 * scale,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildWebViewWithScale(FlutterWidgetBean widgetBean, double scale) {
    final url = widgetBean.properties['url'] ?? 'https://example.com';
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');

    return Container(
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.web,
              size: 32 * scale,
              color: Colors.grey[600],
            ),
            SizedBox(height: 8 * scale),
            Text(
              'WebView',
              style: TextStyle(
                fontSize: 12 * scale,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapViewWithScale(FlutterWidgetBean widgetBean, double scale) {
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');

    return Container(
      color: backgroundColor,
      child: Center(
        child: Icon(
          Icons.map,
          size: 32 * scale,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildAdViewWithScale(FlutterWidgetBean widgetBean, double scale) {
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#F5F5F5');

    return Container(
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.ads_click,
              size: 24 * scale,
              color: Colors.grey[600],
            ),
            SizedBox(height: 4 * scale),
            Text(
              'Ad View',
              style: TextStyle(
                fontSize: 10 * scale,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtonWithScale(
      FlutterWidgetBean widgetBean, double scale) {
    final icon = widgetBean.properties['icon'] ?? 'add';
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FF5722');

    return Container(
      color: backgroundColor,
      child: Center(
        child: Icon(
          _parseIcon(icon),
          size: 24 * scale,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUnknownWidgetWithScale(
      FlutterWidgetBean widgetBean, double scale) {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Text(
          widgetBean.type,
          style: TextStyle(
            fontSize: 10 * scale,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChildWidgetsWithScale(
      FlutterWidgetBean widgetBean, double scale) {
    // For now, return empty list. In a real implementation, this would
    // build child widgets based on the widget's children property
    return [];
  }

  // Utility methods for parsing properties
  Color _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) return Colors.transparent;
    if (colorString.startsWith('#')) {
      try {
        return Color(
            int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
      } catch (e) {
        return Colors.transparent;
      }
    }
    return Colors.transparent;
  }

  FontWeight _parseFontWeight(String weight) {
    switch (weight.toLowerCase()) {
      case 'bold':
        return FontWeight.bold;
      case 'w100':
        return FontWeight.w100;
      case 'w200':
        return FontWeight.w200;
      case 'w300':
        return FontWeight.w300;
      case 'w400':
        return FontWeight.w400;
      case 'w500':
        return FontWeight.w500;
      case 'w600':
        return FontWeight.w600;
      case 'w700':
        return FontWeight.w700;
      case 'w800':
        return FontWeight.w800;
      case 'w900':
        return FontWeight.w900;
      default:
        return FontWeight.normal;
    }
  }

  TextAlign _parseTextAlign(String gravity) {
    switch (gravity.toLowerCase()) {
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      case 'justify':
        return TextAlign.justify;
      default:
        return TextAlign.left;
    }
  }

  MainAxisAlignment _parseMainAxisAlignment(String gravity) {
    switch (gravity.toLowerCase()) {
      case 'center':
        return MainAxisAlignment.center;
      case 'end':
        return MainAxisAlignment.end;
      case 'spacearound':
        return MainAxisAlignment.spaceAround;
      case 'spacebetween':
        return MainAxisAlignment.spaceBetween;
      case 'spaceevenly':
        return MainAxisAlignment.spaceEvenly;
      default:
        return MainAxisAlignment.start;
    }
  }

  IconData _parseIcon(String icon) {
    switch (icon.toLowerCase()) {
      case 'add':
        return Icons.add;
      case 'edit':
        return Icons.edit;
      case 'delete':
        return Icons.delete;
      case 'search':
        return Icons.search;
      case 'share':
        return Icons.share;
      case 'favorite':
        return Icons.favorite;
      case 'home':
        return Icons.home;
      case 'settings':
        return Icons.settings;
      default:
        return Icons.add;
    }
  }

  // Optional ViewDummy overlay for enhanced drag feedback
  Widget _buildViewDummyOverlay() {
    // This would be used when dragging existing widgets
    // For now, return empty since we're using DragTarget for palette widgets
    return const SizedBox.shrink();
  }
}

// SKETCHWARE PRO STYLE DATA STRUCTURES
class WidgetPosition {
  final double left;
  final double top;
  final double width;
  final double height;

  WidgetPosition({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });
}

class GridPainter extends CustomPainter {
  final double scale;

  GridPainter({required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1 * scale;

    final gridSize = 20 * scale;

    // Vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
