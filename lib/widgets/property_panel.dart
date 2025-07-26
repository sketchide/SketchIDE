import 'package:flutter/material.dart';
import '../models/flutter_widget_bean.dart';

/// Property Panel (Bottom) - EXACTLY matches Sketchware Pro's ViewProperty
class PropertyPanel extends StatefulWidget {
  final FlutterWidgetBean selectedWidget;
  final Function(FlutterWidgetBean) onPropertyChanged;
  final List<FlutterWidgetBean> allWidgets;
  final Function(FlutterWidgetBean) onWidgetDeleted;

  const PropertyPanel({
    super.key,
    required this.selectedWidget,
    required this.onPropertyChanged,
    required this.allWidgets,
    required this.onWidgetDeleted,
  });

  @override
  State<PropertyPanel> createState() => _PropertyPanelState();
}

class _PropertyPanelState extends State<PropertyPanel> {
  int _selectedGroupId = 0;
  final List<PropertyGroup> _groups = [
    PropertyGroup(0, 'Basic'),
    PropertyGroup(1, 'Recent'),
    PropertyGroup(2, 'Event'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170, // EXACTLY 170dp like Sketchware Pro
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Widget Selector Header (like Sketchware Pro)
          _buildWidgetSelectorHeader(),

          // Property Groups (horizontal tabs like Sketchware Pro)
          _buildPropertyGroups(),

          // Property Content
          Expanded(
            child: _buildPropertyContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetSelectorHeader() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          // Widget Selector Dropdown
          Expanded(
            child: DropdownButtonFormField<String>(
              value: widget.selectedWidget.id,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                border: OutlineInputBorder(),
              ),
              items: widget.allWidgets.map((widgetBean) {
                return DropdownMenuItem(
                  value: widgetBean.id,
                  child: Text(
                    widgetBean.id.startsWith('_')
                        ? widgetBean.id.substring(1)
                        : widgetBean.id,
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  final selectedWidget = widget.allWidgets.firstWhere(
                    (w) => w.id == value,
                  );
                  widget.onPropertyChanged(selectedWidget);
                }
              },
            ),
          ),

          const SizedBox(width: 8),

          // Delete Button
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            onPressed: () => _showDeleteDialog(),
            tooltip: 'Delete Widget',
          ),

          // Save Button
          IconButton(
            icon: const Icon(Icons.save, size: 20),
            onPressed: () => _saveWidget(),
            tooltip: 'Save Widget',
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyGroups() {
    return Container(
      height: 32,
      padding: const EdgeInsets.only(left: 4, top: 2),
      child: Row(
        children: _groups.map((group) {
          final isSelected = group.id == _selectedGroupId;
          return GestureDetector(
            onTap: () => setState(() => _selectedGroupId = group.id),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                group.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPropertyContent() {
    switch (_selectedGroupId) {
      case 0: // Basic
        return _buildBasicProperties();
      case 1: // Recent
        return _buildRecentProperties();
      case 2: // Event
        return _buildEventProperties();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBasicProperties() {
    return Row(
      children: [
        // Horizontal Scrolling Property Items
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                // ID Property
                PropertyTextItem(
                  label: 'ID',
                  value: widget.selectedWidget.id,
                  propertyKey: 'property_id',
                  enabled: false,
                  onChanged: (value) => _updateProperty('property_id', value),
                ),

                // Layout Properties
                PropertyTextItem(
                  label: 'Width',
                  value: '${widget.selectedWidget.position.width}',
                  propertyKey: 'property_layout_width',
                  onChanged: (value) => _updateLayoutProperty('width', value),
                ),

                PropertyTextItem(
                  label: 'Height',
                  value: '${widget.selectedWidget.position.height}',
                  propertyKey: 'property_layout_height',
                  onChanged: (value) => _updateLayoutProperty('height', value),
                ),

                // Text Properties
                PropertyTextItem(
                  label: 'Text',
                  value: widget.selectedWidget.properties['text'] ?? '',
                  propertyKey: 'property_text',
                  onChanged: (value) => _updateProperty('property_text', value),
                ),

                PropertyTextItem(
                  label: 'Hint',
                  value: widget.selectedWidget.properties['hint'] ?? '',
                  propertyKey: 'property_hint',
                  onChanged: (value) => _updateProperty('property_hint', value),
                ),

                // Color Properties
                PropertyColorItem(
                  label: 'Background',
                  value: widget.selectedWidget.properties['backgroundColor'] ??
                      '#FFFFFF',
                  propertyKey: 'property_background_color',
                  onChanged: (value) =>
                      _updateProperty('property_background_color', value),
                ),

                PropertyColorItem(
                  label: 'Text Color',
                  value: widget.selectedWidget.properties['textColor'] ??
                      '#000000',
                  propertyKey: 'property_text_color',
                  onChanged: (value) =>
                      _updateProperty('property_text_color', value),
                ),

                // Font Properties
                PropertyTextItem(
                  label: 'Font Size',
                  value: widget.selectedWidget.properties['fontSize'] ?? '14',
                  propertyKey: 'property_text_size',
                  onChanged: (value) =>
                      _updateProperty('property_text_size', value),
                ),

                PropertySpinnerItem(
                  label: 'Font Weight',
                  value: widget.selectedWidget.properties['fontWeight'] ??
                      'normal',
                  options: [
                    'normal',
                    'bold',
                    'w100',
                    'w200',
                    'w300',
                    'w400',
                    'w500',
                    'w600',
                    'w700',
                    'w800',
                    'w900'
                  ],
                  propertyKey: 'property_text_style',
                  onChanged: (value) =>
                      _updateProperty('property_text_style', value),
                ),

                // Layout Properties
                PropertyTextItem(
                  label: 'Margin',
                  value: '0',
                  propertyKey: 'property_margin',
                  onChanged: (value) =>
                      _updateProperty('property_margin', value),
                ),

                PropertyTextItem(
                  label: 'Padding',
                  value: '0',
                  propertyKey: 'property_padding',
                  onChanged: (value) =>
                      _updateProperty('property_padding', value),
                ),

                PropertySpinnerItem(
                  label: 'Gravity',
                  value: widget.selectedWidget.properties['gravity'] ?? 'left',
                  options: ['left', 'center', 'right'],
                  propertyKey: 'property_gravity',
                  onChanged: (value) =>
                      _updateProperty('property_gravity', value),
                ),

                PropertySpinnerItem(
                  label: 'Layout Gravity',
                  value: widget.selectedWidget.properties['layoutGravity'] ??
                      'left',
                  options: ['left', 'center', 'right', 'top', 'bottom'],
                  propertyKey: 'property_layout_gravity',
                  onChanged: (value) =>
                      _updateProperty('property_layout_gravity', value),
                ),

                PropertyTextItem(
                  label: 'Weight',
                  value: '0',
                  propertyKey: 'property_weight',
                  onChanged: (value) =>
                      _updateProperty('property_weight', value),
                ),

                PropertySpinnerItem(
                  label: 'Orientation',
                  value: widget.selectedWidget.properties['orientation'] ??
                      'vertical',
                  options: ['vertical', 'horizontal'],
                  propertyKey: 'property_orientation',
                  onChanged: (value) =>
                      _updateProperty('property_orientation', value),
                ),

                // Transform Properties
                PropertyTextItem(
                  label: 'Alpha',
                  value: '1.0',
                  propertyKey: 'property_alpha',
                  onChanged: (value) =>
                      _updateProperty('property_alpha', value),
                ),

                PropertyTextItem(
                  label: 'Rotation',
                  value: '0',
                  propertyKey: 'property_rotate',
                  onChanged: (value) =>
                      _updateProperty('property_rotate', value),
                ),

                PropertyTextItem(
                  label: 'Scale X',
                  value: '1.0',
                  propertyKey: 'property_scale_x',
                  onChanged: (value) =>
                      _updateProperty('property_scale_x', value),
                ),

                PropertyTextItem(
                  label: 'Scale Y',
                  value: '1.0',
                  propertyKey: 'property_scale_y',
                  onChanged: (value) =>
                      _updateProperty('property_scale_y', value),
                ),

                PropertyTextItem(
                  label: 'Translation X',
                  value: '0',
                  propertyKey: 'property_translation_x',
                  onChanged: (value) =>
                      _updateProperty('property_translation_x', value),
                ),

                PropertyTextItem(
                  label: 'Translation Y',
                  value: '0',
                  propertyKey: 'property_translation_y',
                  onChanged: (value) =>
                      _updateProperty('property_translation_y', value),
                ),
              ],
            ),
          ),
        ),

        // See All Floating Button (like Sketchware Pro)
        Container(
          width: 60,
          height: 82,
          margin: const EdgeInsets.only(right: 8),
          child: FloatingActionButton(
            mini: true,
            onPressed: () => _showAllProperties(),
            child: const Icon(Icons.more_horiz, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentProperties() {
    return const Center(
      child: Text(
        'Recent properties will appear here',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }

  Widget _buildEventProperties() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Events',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildEventItem('onClick', 'Click Event'),
          _buildEventItem('onLongClick', 'Long Click Event'),
          _buildEventItem('onTextChanged', 'Text Changed Event'),
          _buildEventItem('onCheckedChanged', 'Checked Changed Event'),
        ],
      ),
    );
  }

  Widget _buildEventItem(String eventName, String displayName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              displayName,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 16),
            onPressed: () => _addEvent(eventName),
            tooltip: 'Add Event',
          ),
        ],
      ),
    );
  }

  void _updateProperty(String key, String value) {
    final updatedProperties =
        Map<String, dynamic>.from(widget.selectedWidget.properties);
    updatedProperties[key] = value;

    final updatedWidget =
        widget.selectedWidget.copyWith(properties: updatedProperties);
    widget.onPropertyChanged(updatedWidget);
  }

  void _updateLayoutProperty(String key, String value) {
    final newValue = double.tryParse(value) ?? 0.0;
    final position = widget.selectedWidget.position;

    PositionBean newPosition;
    switch (key) {
      case 'width':
        newPosition = position.copyWith(width: newValue);
        break;
      case 'height':
        newPosition = position.copyWith(height: newValue);
        break;
      default:
        return;
    }

    final updatedWidget = widget.selectedWidget.copyWith(position: newPosition);
    widget.onPropertyChanged(updatedWidget);
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Widget'),
        content: Text(
            'Are you sure you want to delete "${widget.selectedWidget.id}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onWidgetDeleted(widget.selectedWidget);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _saveWidget() {
    // Save widget changes
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Widget saved successfully'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showAllProperties() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('All Properties'),
        content: const Text('All properties dialog will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _addEvent(String eventName) {
    // Add event to widget
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $eventName event'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

// Property Widget Classes - EXACTLY like Sketchware Pro
class PropertyTextItem extends StatelessWidget {
  final String label;
  final String value;
  final String propertyKey;
  final bool enabled;
  final Function(String) onChanged;

  const PropertyTextItem({
    super.key,
    required this.label,
    required this.value,
    required this.propertyKey,
    this.enabled = true,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          SizedBox(
            width: 80,
            child: TextFormField(
              initialValue: value,
              enabled: enabled,
              style: const TextStyle(fontSize: 11),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                border: OutlineInputBorder(),
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyColorItem extends StatelessWidget {
  final String label;
  final String value;
  final String propertyKey;
  final Function(String) onChanged;

  const PropertyColorItem({
    super.key,
    required this.label,
    required this.value,
    required this.propertyKey,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _parseColor(value),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                width: 60,
                child: TextFormField(
                  initialValue: value,
                  style: const TextStyle(fontSize: 11),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
}

class PropertySpinnerItem extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final String propertyKey;
  final Function(String) onChanged;

  const PropertySpinnerItem({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.propertyKey,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          SizedBox(
            width: 80,
            child: DropdownButtonFormField<String>(
              value: value,
              isDense: true,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                border: OutlineInputBorder(),
              ),
              items: options
                  .map((option) => DropdownMenuItem(
                        value: option,
                        child: Text(
                          option,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ))
                  .toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyCheckItem extends StatelessWidget {
  final String label;
  final bool value;
  final String propertyKey;
  final Function(bool) onChanged;

  const PropertyCheckItem({
    super.key,
    required this.label,
    required this.value,
    required this.propertyKey,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          SizedBox(
            width: 80,
            child: Checkbox(
              value: value,
              onChanged: (newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyGroup {
  final int id;
  final String name;

  PropertyGroup(this.id, this.name);
}
