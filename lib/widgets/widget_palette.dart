import 'package:flutter/material.dart';
import '../models/flutter_widget_bean.dart';

/// Widget Palette (Left Sidebar) - EXACTLY matches Sketchware Pro's PaletteWidget
class WidgetPalette extends StatefulWidget {
  final Function(FlutterWidgetBean) onWidgetSelected;
  final bool isVisible;

  const WidgetPalette({
    super.key,
    required this.onWidgetSelected,
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
        _buildWidgetCard('LinearLayout', Icons.view_agenda, 'Linear Layout'),
        _buildWidgetCard('RelativeLayout', Icons.view_quilt, 'Relative Layout'),
        _buildWidgetCard(
            'ScrollView', Icons.vertical_align_center, 'Scroll View'),
        _buildWidgetCard(
            'HorizontalScrollView', Icons.horizontal_rule, 'Horizontal Scroll'),
        _buildWidgetCard('ListView', Icons.list, 'List View'),
        _buildWidgetCard('GridView', Icons.grid_on, 'Grid View'),
        _buildWidgetCard('RecyclerView', Icons.repeat, 'Recycler View'),
        _buildWidgetCard('ViewPager', Icons.view_carousel, 'View Pager'),
      ],
    );
  }

  Widget _buildWidgetItems() {
    return Column(
      children: [
        _buildWidgetCard('TextView', Icons.text_fields, 'Text View'),
        _buildWidgetCard('EditText', Icons.input, 'Edit Text'),
        _buildWidgetCard('Button', Icons.smart_button, 'Button'),
        _buildWidgetCard('ImageView', Icons.image, 'Image View'),
        _buildWidgetCard('ProgressBar', Icons.trending_up, 'Progress Bar'),
        _buildWidgetCard('SeekBar', Icons.tune, 'Seek Bar'),
        _buildWidgetCard('Switch', Icons.toggle_on, 'Switch'),
        _buildWidgetCard('CheckBox', Icons.check_box, 'Check Box'),
        _buildWidgetCard(
            'RadioButton', Icons.radio_button_checked, 'Radio Button'),
        _buildWidgetCard('Spinner', Icons.arrow_drop_down_circle, 'Spinner'),
        _buildWidgetCard('CalendarView', Icons.calendar_today, 'Calendar'),
        _buildWidgetCard('WebView', Icons.web, 'Web View'),
        _buildWidgetCard('MapView', Icons.map, 'Map View'),
        _buildWidgetCard('AdView', Icons.ads_click, 'Ad View'),
        _buildWidgetCard('FloatingActionButton', Icons.add_circle, 'FAB'),
      ],
    );
  }

  Widget _buildWidgetCard(String type, IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () => _addWidget(type),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addWidget(String type) {
    final widgetBean = _createWidgetBean(type);
    widget.onWidgetSelected(widgetBean);
  }

  FlutterWidgetBean _createWidgetBean(String type) {
    return FlutterWidgetBean(
      id: FlutterWidgetBean.generateId(),
      type: type,
      properties: _getDefaultProperties(type),
      position: PositionBean(x: 100, y: 100, width: 200, height: 50),
    );
  }

  Map<String, dynamic> _getDefaultProperties(String type) {
    switch (type) {
      case 'TextView':
        return {'text': 'Text View'};
      case 'EditText':
        return {'hint': 'Enter text'};
      case 'Button':
        return {'text': 'Button'};
      case 'ImageView':
        return {'src': 'default_image'};
      case 'LinearLayout':
        return {'orientation': 'vertical'};
      case 'RelativeLayout':
        return {};
      case 'ScrollView':
        return {};
      case 'ListView':
        return {};
      case 'ProgressBar':
        return {'progress': '0', 'max': '100'};
      case 'SeekBar':
        return {'progress': '0', 'max': '100'};
      case 'Switch':
        return {'checked': 'false'};
      case 'CheckBox':
        return {'text': 'Check Box', 'checked': 'false'};
      case 'RadioButton':
        return {'text': 'Radio Button', 'checked': 'false'};
      case 'Spinner':
        return {};
      case 'CalendarView':
        return {};
      case 'WebView':
        return {'url': 'https://example.com'};
      case 'MapView':
        return {};
      case 'AdView':
        return {'adUnitId': ''};
      case 'FloatingActionButton':
        return {'icon': 'add'};
      default:
        return {};
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
}
