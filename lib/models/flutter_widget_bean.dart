import 'dart:convert';

/// Flutter Widget Data Model (JSON-based like Sketchware Pro's ViewBean)
class FlutterWidgetBean {
  final String id;
  final String type;
  final Map<String, dynamic> properties;
  final String? parentId;
  final List<String> children;
  final PositionBean position;
  final Map<String, String> events;
  final bool isSelected;
  final bool isVisible;
  final String? customCode;

  FlutterWidgetBean({
    required this.id,
    required this.type,
    required this.properties,
    this.parentId,
    this.children = const [],
    required this.position,
    this.events = const {},
    this.isSelected = false,
    this.isVisible = true,
    this.customCode,
  });

  /// Create from JSON
  factory FlutterWidgetBean.fromJson(Map<String, dynamic> json) {
    return FlutterWidgetBean(
      id: json['id'] as String,
      type: json['type'] as String,
      properties: Map<String, dynamic>.from(json['properties'] ?? {}),
      parentId: json['parent_id'] as String?,
      children: List<String>.from(json['children'] ?? []),
      position: PositionBean.fromJson(json['position'] ?? {}),
      events: Map<String, String>.from(json['events'] ?? {}),
      isSelected: json['is_selected'] as bool? ?? false,
      isVisible: json['is_visible'] as bool? ?? true,
      customCode: json['custom_code'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'properties': properties,
      'parent_id': parentId,
      'children': children,
      'position': position.toJson(),
      'events': events,
      'is_selected': isSelected,
      'is_visible': isVisible,
      'custom_code': customCode,
    };
  }

  /// Create copy with updates
  FlutterWidgetBean copyWith({
    String? id,
    String? type,
    Map<String, dynamic>? properties,
    String? parentId,
    List<String>? children,
    PositionBean? position,
    Map<String, String>? events,
    bool? isSelected,
    bool? isVisible,
    String? customCode,
  }) {
    return FlutterWidgetBean(
      id: id ?? this.id,
      type: type ?? this.type,
      properties: properties ?? this.properties,
      parentId: parentId ?? this.parentId,
      children: children ?? this.children,
      position: position ?? this.position,
      events: events ?? this.events,
      isSelected: isSelected ?? this.isSelected,
      isVisible: isVisible ?? this.isVisible,
      customCode: customCode ?? this.customCode,
    );
  }

  /// Generate unique widget ID
  static String generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 1000000).toString().padLeft(6, '0');
    return 'widget_$timestamp$random';
  }

  /// Get widget display name
  String get displayName {
    return properties['text'] ?? type;
  }

  @override
  String toString() {
    return 'FlutterWidgetBean(id: $id, type: $type, displayName: $displayName)';
  }
}

/// Position data for widgets
class PositionBean {
  final double x;
  final double y;
  final double width;
  final double height;
  final double? minWidth;
  final double? maxWidth;
  final double? minHeight;
  final double? maxHeight;

  PositionBean({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
  });

  factory PositionBean.fromJson(Map<String, dynamic> json) {
    return PositionBean(
      x: (json['x'] as num?)?.toDouble() ?? 0.0,
      y: (json['y'] as num?)?.toDouble() ?? 0.0,
      width: (json['width'] as num?)?.toDouble() ?? 100.0,
      height: (json['height'] as num?)?.toDouble() ?? 50.0,
      minWidth: (json['min_width'] as num?)?.toDouble(),
      maxWidth: (json['max_width'] as num?)?.toDouble(),
      minHeight: (json['min_height'] as num?)?.toDouble(),
      maxHeight: (json['max_height'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'min_width': minWidth,
      'max_width': maxWidth,
      'min_height': minHeight,
      'max_height': maxHeight,
    };
  }

  PositionBean copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return PositionBean(
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
    );
  }
}

/// Flutter Widget Types Enum
enum FlutterWidgetType {
  // Layouts
  row('Row', 'row'),
  column('Column', 'column'),
  stack('Stack', 'stack'),
  container('Container', 'container'),
  padding('Padding', 'padding'),
  expanded('Expanded', 'expanded'),
  flexible('Flexible', 'flexible'),
  center('Center', 'center'),
  align('Align', 'align'),
  aspectRatio('AspectRatio', 'aspect_ratio'),
  singleChildScrollView('SingleChildScrollView', 'single_child_scroll_view'),

  // Basic Widgets
  text('Text', 'text'),
  richText('RichText', 'rich_text'),
  sizedBox('SizedBox', 'sized_box'),
  spacer('Spacer', 'spacer'),
  divider('Divider', 'divider'),

  // Input Widgets
  textField('TextField', 'text_field'),
  textFormField('TextFormField', 'text_form_field'),
  elevatedButton('ElevatedButton', 'elevated_button'),
  textButton('TextButton', 'text_button'),
  outlinedButton('OutlinedButton', 'outlined_button'),
  iconButton('IconButton', 'icon_button'),
  checkbox('Checkbox', 'checkbox'),
  switchWidget('Switch', 'switch'),
  slider('Slider', 'slider'),
  dropdownButton('DropdownButton', 'dropdown_button'),
  radio('Radio', 'radio'),

  // Display Widgets
  listView('ListView', 'list_view'),
  gridView('GridView', 'grid_view'),
  image('Image', 'image'),
  iconWidget('Icon', 'icon'),
  circularProgressIndicator(
      'CircularProgressIndicator', 'circular_progress_indicator'),
  linearProgressIndicator(
      'LinearProgressIndicator', 'linear_progress_indicator'),

  // Material Widgets
  card('Card', 'card'),
  appBar('AppBar', 'app_bar'),
  floatingActionButton('FloatingActionButton', 'floating_action_button'),
  bottomNavigationBar('BottomNavigationBar', 'bottom_navigation_bar'),
  tabBar('TabBar', 'tab_bar'),
  tabBarView('TabBarView', 'tab_bar_view'),
  drawer('Drawer', 'drawer'),
  bottomSheet('BottomSheet', 'bottom_sheet'),
  snackBar('SnackBar', 'snack_bar'),
  dialog('Dialog', 'dialog'),

  // Custom Widgets
  custom('Custom Widget', 'custom');

  const FlutterWidgetType(this.displayName, this.value);
  final String displayName;
  final String value;

  String get icon {
    switch (this) {
      case FlutterWidgetType.text:
        return '📝';
      case FlutterWidgetType.container:
        return '📦';
      case FlutterWidgetType.row:
        return '➡️';
      case FlutterWidgetType.column:
        return '⬇️';
      case FlutterWidgetType.stack:
        return '📚';
      case FlutterWidgetType.elevatedButton:
        return '🔘';
      case FlutterWidgetType.textField:
        return '✏️';
      case FlutterWidgetType.image:
        return '🖼️';
      case FlutterWidgetType.listView:
        return '📋';
      case FlutterWidgetType.card:
        return '🃏';
      case FlutterWidgetType.appBar:
        return '📱';
      case FlutterWidgetType.floatingActionButton:
        return '➕';
      case FlutterWidgetType.padding:
        return '📏';
      case FlutterWidgetType.expanded:
        return '↔️';
      case FlutterWidgetType.flexible:
        return '🔧';
      case FlutterWidgetType.center:
        return '🎯';
      case FlutterWidgetType.align:
        return '📍';
      case FlutterWidgetType.aspectRatio:
        return '📐';
      case FlutterWidgetType.singleChildScrollView:
        return '📜';
      case FlutterWidgetType.richText:
        return '📄';
      case FlutterWidgetType.spacer:
        return '␣';
      case FlutterWidgetType.divider:
        return '➖';
      case FlutterWidgetType.textFormField:
        return '📝';
      case FlutterWidgetType.textButton:
        return '🔘';
      case FlutterWidgetType.outlinedButton:
        return '🔘';
      case FlutterWidgetType.iconButton:
        return '🔘';
      case FlutterWidgetType.checkbox:
        return '☑️';
      case FlutterWidgetType.switchWidget:
        return '🔀';
      case FlutterWidgetType.slider:
        return '🎚️';
      case FlutterWidgetType.dropdownButton:
        return '📋';
      case FlutterWidgetType.radio:
        return '🔘';
      case FlutterWidgetType.gridView:
        return '📊';
      case FlutterWidgetType.iconWidget:
        return '🎨';
      case FlutterWidgetType.circularProgressIndicator:
        return '⭕';
      case FlutterWidgetType.linearProgressIndicator:
        return '📊';
      case FlutterWidgetType.bottomNavigationBar:
        return '📱';
      case FlutterWidgetType.tabBar:
        return '📑';
      case FlutterWidgetType.tabBarView:
        return '📄';
      case FlutterWidgetType.drawer:
        return '📂';
      case FlutterWidgetType.bottomSheet:
        return '📄';
      case FlutterWidgetType.snackBar:
        return '🍫';
      case FlutterWidgetType.dialog:
        return '💬';
      case FlutterWidgetType.custom:
        return '🔧';
      case FlutterWidgetType.sizedBox:
        return '📏';
    }
  }

  static FlutterWidgetType fromString(String value) {
    try {
      return FlutterWidgetType.values.firstWhere(
        (type) => type.value == value,
        orElse: () => FlutterWidgetType.custom,
      );
    } catch (e) {
      return FlutterWidgetType.custom;
    }
  }
}
