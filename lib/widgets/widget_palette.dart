import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/flutter_widget_bean.dart';
import '../controllers/drag_controller.dart';

/// Widget Palette (Left Sidebar) - EXACTLY matches Sketchware Pro's PaletteWidget
class WidgetPalette extends StatefulWidget {
  final Function(FlutterWidgetBean) onWidgetSelected;
  final Function(FlutterWidgetBean, Offset)
      onWidgetDragged; // Add drag callback
  final DragController? dragController; // Add drag controller
  final bool isVisible;

  const WidgetPalette({
    super.key,
    required this.onWidgetSelected,
    required this.onWidgetDragged, // Add drag callback
    this.dragController, // Add drag controller
    this.isVisible = true,
  });

  @override
  State<WidgetPalette> createState() => _WidgetPaletteState();
}

class _WidgetPaletteState extends State<WidgetPalette> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 120, // EXACTLY 120dp like Sketchware Pro
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          // Create New Widget Card (like Sketchware Pro)
          _buildCreateNewWidgetCard(),

          // Widget List with Sections
          Expanded(
            child: _buildWidgetList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateNewWidgetCard() {
    return Container(
      margin: const EdgeInsets.all(4),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () => _showCreateWidgetDialog(),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  size: 28,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 3),
                Text(
                  'Create New Widget',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetList() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Layout Section
          _buildSectionHeader('Layout'),
          _buildLayoutWidgets(),

          // Widget Section
          _buildSectionHeader('Widget'),
          _buildWidgetItems(),

          // Bottom padding
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildLayoutWidgets() {
    return Column(
      children: [
        _buildDraggableWidgetCard(
            'LinearLayout', Icons.view_agenda, 'Linear Layout'),
        _buildDraggableWidgetCard(
            'RelativeLayout', Icons.view_quilt, 'Relative Layout'),
        _buildDraggableWidgetCard(
            'ScrollView', Icons.vertical_align_center, 'Scroll View'),
        _buildDraggableWidgetCard(
            'HorizontalScrollView', Icons.horizontal_rule, 'Horizontal Scroll'),
        _buildDraggableWidgetCard('ListView', Icons.list, 'List View'),
        _buildDraggableWidgetCard('GridView', Icons.grid_on, 'Grid View'),
        _buildDraggableWidgetCard(
            'RecyclerView', Icons.repeat, 'Recycler View'),
        _buildDraggableWidgetCard(
            'ViewPager', Icons.view_carousel, 'View Pager'),
      ],
    );
  }

  Widget _buildWidgetItems() {
    return Column(
      children: [
        _buildDraggableWidgetCard('TextView', Icons.text_fields, 'Text View'),
        _buildDraggableWidgetCard('EditText', Icons.input, 'Edit Text'),
        _buildDraggableWidgetCard('Button', Icons.smart_button, 'Button'),
        _buildDraggableWidgetCard('ImageView', Icons.image, 'Image View'),
        _buildDraggableWidgetCard(
            'ProgressBar', Icons.trending_up, 'Progress Bar'),
        _buildDraggableWidgetCard('SeekBar', Icons.tune, 'Seek Bar'),
        _buildDraggableWidgetCard('Switch', Icons.toggle_on, 'Switch'),
        _buildDraggableWidgetCard('CheckBox', Icons.check_box, 'Check Box'),
        _buildDraggableWidgetCard(
            'RadioButton', Icons.radio_button_checked, 'Radio Button'),
        _buildDraggableWidgetCard(
            'Spinner', Icons.arrow_drop_down_circle, 'Spinner'),
        _buildDraggableWidgetCard(
            'CalendarView', Icons.calendar_today, 'Calendar'),
        _buildDraggableWidgetCard('WebView', Icons.web, 'Web View'),
        _buildDraggableWidgetCard('MapView', Icons.map, 'Map View'),
        _buildDraggableWidgetCard('AdView', Icons.ads_click, 'Ad View'),
        _buildDraggableWidgetCard(
            'FloatingActionButton', Icons.add_circle, 'FAB'),
      ],
    );
  }

  Widget _buildDraggableWidgetCard(String type, IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Draggable<FlutterWidgetBean>(
          // SKETCHWARE PRO STYLE: Create drag data
          data: _createWidgetBean(type, icon, label),

          // SKETCHWARE PRO STYLE: Drag feedback (shadow/parchayi)
          feedback: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 120,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20, color: Colors.blue.shade600),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SKETCHWARE PRO STYLE: Drag start feedback
          onDragStarted: () {
            print('🎯 DRAG STARTED: $type'); // Debug output
            HapticFeedback.mediumImpact();
          },

          // SKETCHWARE PRO STYLE: Drag end feedback
          onDragEnd: (details) {
            print('🎯 DRAG ENDED: $type at ${details.offset}'); // Debug output
            HapticFeedback.lightImpact();
          },

          // SKETCHWARE PRO STYLE: Child widget
          child: InkWell(
            onTap: () {
              print('🎯 WIDGET TAPPED: $type'); // Debug output
              _addWidget(type);
            },
            onLongPress: () {
              print('🎯 WIDGET LONG PRESSED: $type'); // Debug output
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: Colors.blue.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // SKETCHWARE PRO STYLE: Create widget bean for drag
  FlutterWidgetBean _createWidgetBean(
      String type, IconData icon, String label) {
    return FlutterWidgetBean(
      id: FlutterWidgetBean.generateId(),
      type: type,
      properties: _getDefaultProperties(type),
      children: [],
      position: PositionBean(x: 0, y: 0, width: 200, height: 50),
      events: {},
      layout: _getDefaultLayout(type),
    );
  }

  // SKETCHWARE PRO STYLE: Get default properties for widget type
  Map<String, dynamic> _getDefaultProperties(String type) {
    switch (type) {
      case 'Button':
        return {
          'text': 'Button',
          'backgroundColor': '#2196F3',
          'textColor': '#FFFFFF',
        };
      case 'TextView':
        return {
          'text': 'Text View',
          'textColor': '#000000',
          'textSize': 16.0,
        };
      case 'EditText':
        return {
          'hint': 'Enter text...',
          'textColor': '#000000',
          'backgroundColor': '#FFFFFF',
        };
      case 'ImageView':
        return {
          'src': '',
          'scaleType': 'centerCrop',
        };
      case 'LinearLayout':
        return {
          'orientation': 'vertical',
          'backgroundColor': '#FFFFFF',
        };
      case 'RelativeLayout':
        return {
          'backgroundColor': '#FFFFFF',
        };
      case 'FrameLayout':
        return {
          'backgroundColor': '#FFFFFF',
        };
      case 'ScrollView':
        return {
          'backgroundColor': '#FFFFFF',
        };
      case 'HorizontalScrollView':
        return {
          'backgroundColor': '#FFFFFF',
        };
      case 'GridView':
        return {
          'numColumns': 2,
          'backgroundColor': '#FFFFFF',
        };
      case 'ListView':
        return {
          'backgroundColor': '#FFFFFF',
        };
      case 'FloatingActionButton':
        return {
          'icon': 'add',
          'backgroundColor': '#FF5722',
        };
      default:
        return {};
    }
  }

  // SKETCHWARE PRO STYLE: Get default layout for widget type
  LayoutBean _getDefaultLayout(String type) {
    switch (type) {
      case 'LinearLayout':
      case 'RelativeLayout':
      case 'FrameLayout':
        return LayoutBean(
          width: LayoutBean.MATCH_PARENT,
          height: LayoutBean.WRAP_CONTENT,
          paddingLeft: 16,
          paddingTop: 16,
          paddingRight: 16,
          paddingBottom: 16,
        );
      case 'ScrollView':
      case 'HorizontalScrollView':
        return LayoutBean(
          width: LayoutBean.MATCH_PARENT,
          height: LayoutBean.WRAP_CONTENT,
        );
      case 'GridView':
        return LayoutBean(
          width: LayoutBean.MATCH_PARENT,
          height: LayoutBean.WRAP_CONTENT,
        );
      case 'ListView':
        return LayoutBean(
          width: LayoutBean.MATCH_PARENT,
          height: LayoutBean.WRAP_CONTENT,
        );
      default:
        return LayoutBean(
          width: LayoutBean.WRAP_CONTENT,
          height: LayoutBean.WRAP_CONTENT,
        );
    }
  }

  void _showCreateWidgetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Widget'),
        content: const Text('This will open the widget creation dialog.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement custom widget creation
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  // SKETCHWARE PRO STYLE: Add widget on tap
  void _addWidget(String type) {
    final widgetBean = _createWidgetBean(type, Icons.widgets, type);
    widget.onWidgetSelected(widgetBean);
  }
}
