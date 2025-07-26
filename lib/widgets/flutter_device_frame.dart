import 'package:flutter/material.dart';
import '../models/flutter_widget_bean.dart';

/// Flutter Device Frame (Center) - EXACTLY matches Sketchware Pro's ViewPane
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
  Offset? _dragStartPosition;
  FlutterWidgetBean? _draggedWidget;
  bool _isDragging = false;
  double _scale = 1.0;
  bool _showStatusBar = true;
  bool _showToolbar = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Column(
        children: [
          // Device Frame Header (like Sketchware Pro)
          _buildDeviceHeader(),

          // Device Frame Content with Phone Simulation
          Expanded(
            child: _buildPhoneSimulation(),
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
          Text(
            'Flutter Device Preview',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const Spacer(),
          // Status Bar Toggle
          IconButton(
            icon: Icon(
              _showStatusBar ? Icons.visibility : Icons.visibility_off,
              size: 18,
            ),
            onPressed: () => setState(() => _showStatusBar = !_showStatusBar),
            tooltip: 'Toggle Status Bar',
          ),
          // Toolbar Toggle
          IconButton(
            icon: Icon(
              _showToolbar ? Icons.view_headline : Icons.view_headline_outlined,
              size: 18,
            ),
            onPressed: () => setState(() => _showToolbar = !_showToolbar),
            tooltip: 'Toggle Toolbar',
          ),
          // Zoom Controls
          IconButton(
            icon: const Icon(Icons.zoom_in, size: 18),
            onPressed: () =>
                setState(() => _scale = (_scale + 0.1).clamp(0.5, 2.0)),
            tooltip: 'Zoom In',
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out, size: 18),
            onPressed: () =>
                setState(() => _scale = (_scale - 0.1).clamp(0.5, 2.0)),
            tooltip: 'Zoom Out',
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneSimulation() {
    return Center(
      child: Container(
        width: 360 * _scale, // Standard phone width
        height: 640 * _scale, // Standard phone height
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20 * _scale),
          border: Border.all(
            color: Colors.grey[600]!,
            width: 2 * _scale,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10 * _scale,
              offset: Offset(0, 5 * _scale),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18 * _scale),
          child: Column(
            children: [
              // Status Bar (like Sketchware Pro)
              if (_showStatusBar) _buildStatusBar(),

              // Toolbar (like Sketchware Pro)
              if (_showToolbar) _buildToolbar(),

              // Main Content Area
              Expanded(
                child: _buildContentArea(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 25 * _scale,
      decoration: const BoxDecoration(
        color: Color(0xFF0084C2), // Exact Sketchware Pro blue
      ),
      child: Row(
        children: [
          // Time
          Padding(
            padding: EdgeInsets.only(left: 16 * _scale),
            child: Text(
              '9:41',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12 * _scale,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Spacer(),
          // Status Icons
          Row(
            children: [
              Icon(
                Icons.signal_cellular_4_bar,
                color: Colors.white,
                size: 12 * _scale,
              ),
              SizedBox(width: 4 * _scale),
              Icon(
                Icons.wifi,
                color: Colors.white,
                size: 12 * _scale,
              ),
              SizedBox(width: 4 * _scale),
              Icon(
                Icons.battery_full,
                color: Colors.white,
                size: 12 * _scale,
              ),
              SizedBox(width: 16 * _scale),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      height: 48 * _scale,
      decoration: const BoxDecoration(
        color: Color(0xFF008DCD), // Exact Sketchware Pro toolbar blue
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16 * _scale),
            child: Text(
              'Toolbar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15 * _scale,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentArea() {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          // Background grid (like Sketchware Pro)
          _buildBackgroundGrid(),

          // Widgets
          ...widget.widgets.map((widgetBean) => _buildWidget(widgetBean)),

          // Drag overlay
          if (_isDragging && _draggedWidget != null) _buildDragOverlay(),
        ],
      ),
    );
  }

  Widget _buildBackgroundGrid() {
    return CustomPaint(
      painter: GridPainter(scale: _scale),
      size: Size.infinite,
    );
  }

  Widget _buildWidget(FlutterWidgetBean widgetBean) {
    final isSelected = widget.selectedWidget?.id == widgetBean.id;

    return Positioned(
      left: widgetBean.position.x * _scale,
      top: widgetBean.position.y * _scale,
      child: GestureDetector(
        onTap: () => widget.onWidgetSelected(widgetBean),
        onPanStart: (details) => _startDrag(widgetBean, details),
        onPanUpdate: (details) => _updateDrag(details),
        onPanEnd: (details) => _endDrag(),
        child: Container(
          width: widgetBean.position.width * _scale,
          height: widgetBean.position.height * _scale,
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
          child: _buildRealWidget(widgetBean),
        ),
      ),
    );
  }

  // REAL WIDGET RENDERING - EXACTLY like Sketchware Pro
  Widget _buildRealWidget(FlutterWidgetBean widgetBean) {
    switch (widgetBean.type) {
      case 'TextView':
        return _buildTextView(widgetBean);
      case 'EditText':
        return _buildEditText(widgetBean);
      case 'Button':
        return _buildButton(widgetBean);
      case 'ImageView':
        return _buildImageView(widgetBean);
      case 'LinearLayout':
        return _buildLinearLayout(widgetBean);
      case 'RelativeLayout':
        return _buildRelativeLayout(widgetBean);
      case 'ScrollView':
        return _buildScrollView(widgetBean);
      case 'ListView':
        return _buildListView(widgetBean);
      case 'ProgressBar':
        return _buildProgressBar(widgetBean);
      case 'SeekBar':
        return _buildSeekBar(widgetBean);
      case 'Switch':
        return _buildSwitch(widgetBean);
      case 'CheckBox':
        return _buildCheckBox(widgetBean);
      case 'RadioButton':
        return _buildRadioButton(widgetBean);
      case 'Spinner':
        return _buildSpinner(widgetBean);
      case 'CalendarView':
        return _buildCalendarView(widgetBean);
      case 'WebView':
        return _buildWebView(widgetBean);
      case 'MapView':
        return _buildMapView(widgetBean);
      case 'AdView':
        return _buildAdView(widgetBean);
      case 'FloatingActionButton':
        return _buildFloatingActionButton(widgetBean);
      default:
        return _buildUnknownWidget(widgetBean);
    }
  }

  Widget _buildTextView(FlutterWidgetBean widgetBean) {
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
            fontSize: fontSize * _scale,
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

  Widget _buildEditText(FlutterWidgetBean widgetBean) {
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
          fontSize: fontSize * _scale,
          color: textColor,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: fontSize * _scale,
            color: hintColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4 * _scale),
          ),
          contentPadding: EdgeInsets.all(8 * _scale),
        ),
      ),
    );
  }

  Widget _buildButton(FlutterWidgetBean widgetBean) {
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
            fontSize: fontSize * _scale,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildImageView(FlutterWidgetBean widgetBean) {
    final src = widgetBean.properties['src'] ?? 'default_image';
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#F5F5F5');

    return Container(
      color: backgroundColor,
      child: Center(
        child: Icon(
          Icons.image,
          size: 32 * _scale,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildLinearLayout(FlutterWidgetBean widgetBean) {
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
              children: _buildChildWidgets(widgetBean),
            )
          : Row(
              mainAxisAlignment: gravity,
              children: _buildChildWidgets(widgetBean),
            ),
    );
  }

  Widget _buildRelativeLayout(FlutterWidgetBean widgetBean) {
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');

    return Container(
      color: backgroundColor,
      child: Stack(
        children: _buildChildWidgets(widgetBean),
      ),
    );
  }

  Widget _buildScrollView(FlutterWidgetBean widgetBean) {
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');

    return Container(
      color: backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: _buildChildWidgets(widgetBean),
        ),
      ),
    );
  }

  Widget _buildListView(FlutterWidgetBean widgetBean) {
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

  Widget _buildProgressBar(FlutterWidgetBean widgetBean) {
    final progress =
        double.tryParse(widgetBean.properties['progress'] ?? '50') ?? 50.0;
    final max = double.tryParse(widgetBean.properties['max'] ?? '100') ?? 100.0;
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#E0E0E0');
    final progressColor =
        _parseColor(widgetBean.properties['progressColor'] ?? '#2196F3');

    return Container(
      color: backgroundColor,
      child: Center(
        child: LinearProgressIndicator(
          value: progress / max,
          backgroundColor: backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
        ),
      ),
    );
  }

  Widget _buildSeekBar(FlutterWidgetBean widgetBean) {
    final progress =
        double.tryParse(widgetBean.properties['progress'] ?? '50') ?? 50.0;
    final max = double.tryParse(widgetBean.properties['max'] ?? '100') ?? 100.0;
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');
    final thumbColor =
        _parseColor(widgetBean.properties['thumbColor'] ?? '#2196F3');

    return Container(
      color: backgroundColor,
      child: Center(
        child: Slider(
          value: progress,
          min: 0,
          max: max,
          activeColor: thumbColor,
          onChanged: null, // Read-only in preview
        ),
      ),
    );
  }

  Widget _buildSwitch(FlutterWidgetBean widgetBean) {
    final checked = widgetBean.properties['checked'] == 'true';
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');

    return Container(
      color: backgroundColor,
      child: Center(
        child: Switch(
          value: checked,
          onChanged: null, // Read-only in preview
        ),
      ),
    );
  }

  Widget _buildCheckBox(FlutterWidgetBean widgetBean) {
    final text = widgetBean.properties['text'] ?? 'Check Box';
    final checked = widgetBean.properties['checked'] == 'true';
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');
    final textColor =
        _parseColor(widgetBean.properties['textColor'] ?? '#000000');

    return Container(
      color: backgroundColor,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: checked,
              onChanged: null, // Read-only in preview
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 14 * _scale,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButton(FlutterWidgetBean widgetBean) {
    final text = widgetBean.properties['text'] ?? 'Radio Button';
    final checked = widgetBean.properties['checked'] == 'true';
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');
    final textColor =
        _parseColor(widgetBean.properties['textColor'] ?? '#000000');

    return Container(
      color: backgroundColor,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio<bool>(
              value: true,
              groupValue: checked ? true : false,
              onChanged: null, // Read-only in preview
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 14 * _scale,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpinner(FlutterWidgetBean widgetBean) {
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');
    final items = ['Option 1', 'Option 2', 'Option 3'];

    return Container(
      color: backgroundColor,
      child: Center(
        child: DropdownButton<String>(
          value: items.first,
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: null, // Read-only in preview
        ),
      ),
    );
  }

  Widget _buildCalendarView(FlutterWidgetBean widgetBean) {
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');

    return Container(
      color: backgroundColor,
      child: Center(
        child: Icon(
          Icons.calendar_today,
          size: 32 * _scale,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildWebView(FlutterWidgetBean widgetBean) {
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
              size: 32 * _scale,
              color: Colors.grey[600],
            ),
            SizedBox(height: 8 * _scale),
            Text(
              'WebView',
              style: TextStyle(
                fontSize: 12 * _scale,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView(FlutterWidgetBean widgetBean) {
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FFFFFF');

    return Container(
      color: backgroundColor,
      child: Center(
        child: Icon(
          Icons.map,
          size: 32 * _scale,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildAdView(FlutterWidgetBean widgetBean) {
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
              size: 24 * _scale,
              color: Colors.grey[600],
            ),
            SizedBox(height: 4 * _scale),
            Text(
              'Ad View',
              style: TextStyle(
                fontSize: 10 * _scale,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(FlutterWidgetBean widgetBean) {
    final icon = widgetBean.properties['icon'] ?? 'add';
    final backgroundColor =
        _parseColor(widgetBean.properties['backgroundColor'] ?? '#FF5722');

    return Container(
      color: backgroundColor,
      child: Center(
        child: Icon(
          _parseIcon(icon),
          size: 24 * _scale,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUnknownWidget(FlutterWidgetBean widgetBean) {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Text(
          widgetBean.type,
          style: TextStyle(
            fontSize: 10 * _scale,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChildWidgets(FlutterWidgetBean widgetBean) {
    // For now, return empty list. In a real implementation, this would
    // build child widgets based on the widget's children property
    return [];
  }

  Widget _buildDragOverlay() {
    if (_draggedWidget == null) return const SizedBox.shrink();

    return Positioned(
      left: _dragStartPosition?.dx ?? 0,
      top: _dragStartPosition?.dy ?? 0,
      child: Opacity(
        opacity: 0.7,
        child: _buildWidget(_draggedWidget!),
      ),
    );
  }

  void _startDrag(FlutterWidgetBean widgetBean, DragStartDetails details) {
    setState(() {
      _draggedWidget = widgetBean;
      _dragStartPosition = details.globalPosition;
      _isDragging = true;
    });
  }

  void _updateDrag(DragUpdateDetails details) {
    if (_draggedWidget != null) {
      setState(() {
        _dragStartPosition = details.globalPosition;
      });
    }
  }

  void _endDrag() {
    if (_draggedWidget != null && _dragStartPosition != null) {
      final newPosition = _draggedWidget!.position.copyWith(
        x: _dragStartPosition!.dx / _scale,
        y: _dragStartPosition!.dy / _scale,
      );

      final updatedWidget = _draggedWidget!.copyWith(position: newPosition);
      widget.onWidgetMoved(updatedWidget);
    }

    setState(() {
      _draggedWidget = null;
      _dragStartPosition = null;
      _isDragging = false;
    });
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
