import 'package:flutter/material.dart';
import '../models/flutter_widget_bean.dart';
import '../models/text_properties.dart';
import '../models/container_properties.dart';
import '../models/text_field_properties.dart';
import '../models/icon_properties.dart';
import '../models/layout_properties.dart';
import '../models/stack_properties.dart';
import '../models/button_properties.dart';
import '../widgets/widget_items/widget_text.dart';
import '../widgets/widget_items/widget_container.dart';
import '../widgets/widget_items/widget_text_field.dart';
import '../widgets/widget_items/widget_icon.dart';
import '../widgets/widget_items/widget_row.dart';
import '../widgets/widget_items/widget_column.dart';
import '../widgets/widget_items/widget_stack.dart';
import '../widgets/widget_items/widget_button.dart'; // Added import for WidgetButton

/// WidgetFactoryService - EXACTLY matches Sketchware Pro's ViewPane.createItemView()
/// Factory service for creating widget instances based on FlutterWidgetBean type
class WidgetFactoryService {
  static const String _tag = 'WidgetFactoryService';

  /// Create a widget instance based on the FlutterWidgetBean type
  /// This follows Sketchware Pro's ViewPane.createItemView() pattern
  static Widget createWidget(
    FlutterWidgetBean widgetBean, {
    double scale = 1.0,
  }) {
    // SKETCHWARE PRO STYLE: Debug logging for widget creation
    print('🏭 CREATING WIDGET: ${widgetBean.id}');
    print('🏭 WIDGET PROPERTIES: ${widgetBean.properties}');

    // SKETCHWARE PRO STYLE: Auto-detect widget type from properties if type is wrong
    String actualType = widgetBean.type;
    if (widgetBean.properties.containsKey('orientation') &&
        widgetBean.properties.containsKey('mainAxisAlignment') &&
        widgetBean.properties.containsKey('crossAxisAlignment')) {
      final orientation = widgetBean.properties['orientation'];
      if (orientation == 1) {
        actualType = 'Column';
      } else if (orientation == 0) {
        actualType = 'Row';
      }
      if (actualType != widgetBean.type) {
        print(
            '🔄 AUTO-CORRECTING WIDGET TYPE: ${widgetBean.type} -> $actualType');
      }
    }

    switch (actualType) {
      case 'Text':
        return WidgetText(
          widgetBean: widgetBean,
          scale: scale,
        );

      case 'Button':
        // FIXED: Button should be a separate widget, not WidgetText
        return WidgetButton(
          widgetBean: widgetBean,
          scale: scale,
        );

      case 'Container':
        return WidgetContainer(
          widgetBean: widgetBean,
          scale: scale,
        );

      case 'TextField':
        return WidgetTextField(
          widgetBean: widgetBean,
          scale: scale,
        );

      case 'Icon':
        return WidgetIcon(
          widgetBean: widgetBean,
          scale: scale,
        );

      case 'Row':
        return WidgetRow(
          widgetBean: widgetBean,
          scale: scale,
        );

      case 'Column':
        return WidgetColumn(
          widgetBean: widgetBean,
          scale: scale,
        );

      case 'Stack':
        return WidgetStack(
          widgetBean: widgetBean,
          scale: scale,
        );

      default:
        // Fallback to Container for unknown types (like Sketchware Pro's getUnknownItemView)
        print(
            '$_tag: Unknown widget type "${widgetBean.type}", falling back to Container');
        return WidgetContainer(
          widgetBean: widgetBean.copyWith(type: 'Container'),
          scale: scale,
        );
    }
  }

  /// Create a FlutterWidgetBean with proper strongly typed properties
  /// This follows Sketchware Pro's pattern of creating ViewBean with proper properties
  static FlutterWidgetBean createWidgetBean(
    String type, {
    String? id,
    Map<String, dynamic>? customProperties,
  }) {
    final widgetId = id ?? FlutterWidgetBean.generateSimpleId();

    switch (type) {
      case 'Text':
        // EXACTLY matches Sketchware Pro's IconTextView
        return FlutterWidgetBean(
          id: widgetId,
          type: type,
          properties: {
            'text': 'TextView', // ✅ EXACT: Like Sketchware Pro's getName()
            'textSize': 14.0,
            'textColor': '#000000',
            'textStyle': 'normal',
            'gravity': 'left',
          },
          children: [],
          position: PositionBean(x: 0, y: 0, width: 50, height: 30),
          events: {},
          layout: LayoutBean(
            width: -2, // WRAP_CONTENT
            height: -2, // WRAP_CONTENT
            paddingLeft: 8, // Like Sketchware Pro
            paddingTop: 8, // Like Sketchware Pro
            paddingRight: 8, // Like Sketchware Pro
            paddingBottom: 8, // Like Sketchware Pro
          ),
        );

      case 'Button':
        // EXACTLY matches Sketchware Pro's IconButton
        final buttonProps = ButtonProperties(
          text: 'Button',
          textSize: 14.0,
          textColor: '#FFFFFF',
          textStyle: 'normal',
          textAlign: 'center',
          backgroundColor: '#2196F3',
          cornerRadius: 4.0,
          enabled: true,
        );
        return FlutterWidgetBean(
          id: widgetId,
          type: type,
          properties: buttonProps.toJson(),
          children: [],
          position: PositionBean(x: 0, y: 0, width: 80, height: 40),
          events: {},
          layout: LayoutBean(
            width: -2, // WRAP_CONTENT
            height: -2, // WRAP_CONTENT
            paddingLeft: 8, // Like Sketchware Pro
            paddingTop: 8, // Like Sketchware Pro
            paddingRight: 8, // Like Sketchware Pro
            paddingBottom: 8, // Like Sketchware Pro
          ),
        );

      case 'Container':
        final containerProps = ContainerProperties();
        return FlutterWidgetBean(
          id: widgetId,
          type: type,
          properties: containerProps.toJson(),
          children: [],
          position: PositionBean(x: 0, y: 0, width: 50, height: 30),
          events: {},
          layout: LayoutBean(
            width: -2, 
            height: -2, 
            paddingLeft: 8, 
            paddingTop: 8, 
            paddingRight: 8, 
            paddingBottom: 8, 
          ),
        );

      case 'TextField':
        final textFieldProps = TextFieldProperties();
        return FlutterWidgetBean(
          id: widgetId,
          type: type,
          properties: {
            'text': '',
            'hint': 'EditText', 
            'textSize': 14.0,
            'textColor': '#000000',
            'hintColor': '#757575',
            'inputType': 1, 
            'imeOption': 0, 
            'singleLine': 0,
            'line': 0,
            'textFont': 'default_font',
              'textType': 0, 
          },
          children: [],
          position: PositionBean(x: 0, y: 0, width: 150, height: 40),
          events: {},
          layout: LayoutBean(
            width: -1, 
            height: -2, 
            paddingLeft: 8,
            paddingTop: 4,
            paddingRight: 8,
            paddingBottom: 4,
          ),
        );

      case 'Icon':
        final iconProps = IconProperties();
        return FlutterWidgetBean(
          id: widgetId,
          type: type,
          properties: {
            'iconName':
                'image', 
            'iconSize': 24.0,
            'iconColor': 0xFF000000,
            'semanticLabel': 'Icon',
          },
          children: [],
          position: PositionBean(x: 0, y: 0, width: 50, height: 50),
          events: {},
          layout: LayoutBean(
            width: -2, 
            height: -2, 
            paddingLeft: 8,
            paddingTop: 8,
            paddingRight: 8,
            paddingBottom: 8,
          ),
        );

      case 'Row':
        
        return FlutterWidgetBean(
          id: widgetId,
          type: type,
          properties: {
            'orientation': 0, // HORIZONTAL (like Sketchware Pro)
            'mainAxisAlignment': 'start',
            'crossAxisAlignment': 'center',
            'mainAxisSize': 'max',
          },
          children: [],
          position: PositionBean(
              x: 0,
              y: 0,
              width: -1,
              height: -2), 
          events: {},
          layout: LayoutBean(
            width: -1, 
            height: -2, 
            paddingLeft: 8, 
            paddingTop: 8, 
            paddingRight: 8, 
            paddingBottom: 8, 
            orientation: 0, 
          ),
        );

      case 'Column':
        return FlutterWidgetBean(
          id: widgetId,
          type: type,
          properties: {
            'orientation': 1, 
            'mainAxisAlignment': 'start',
            'crossAxisAlignment': 'center',
            'mainAxisSize': 'max',
          },
          children: [],
          position: PositionBean(
              x: 0,
              y: 0,
              width: -2,
              height:
                  -1), 
          events: {},
          layout: LayoutBean(
            width: -2, 
            height: -1, 
            paddingLeft: 8, 
            paddingTop: 8, 
            paddingRight: 8, 
            paddingBottom: 8, 
            orientation: 1, 
          ),
        );

      case 'Stack':
        final stackProps = StackProperties();
        return FlutterWidgetBean(
          id: widgetId,
          type: type,
          properties: stackProps.toJson(),
          children: [],
          position: PositionBean(x: 0, y: 0, width: 100, height: 60),
          events: {},
          layout: LayoutBean(
            width: -1, 
            height: -1, 
            paddingLeft: 8, 
            paddingTop: 8, 
            paddingRight: 8, 
            paddingBottom: 8, 
          ),
        );

      default:
        // Fallback to Container for unknown types
        print('$_tag: Unknown widget type "$type", falling back to Container');
        final containerProps = ContainerProperties();
        return FlutterWidgetBean(
          id: widgetId,
          type: 'Container',
          properties: containerProps.toJson(),
          children: [],
          position: PositionBean(x: 0, y: 0, width: 150, height: 80),
          events: {},
          layout: LayoutBean(
            width: -2, 
            height: -2, 
            paddingLeft: 16,
            paddingTop: 16,
            paddingRight: 16,
            paddingBottom: 16,
          ),
        );
    }
  }

  /// Get strongly typed properties from FlutterWidgetBean
  /// This provides type-safe access to widget properties
  static dynamic getTypedProperties(FlutterWidgetBean widgetBean) {
    // SKETCHWARE PRO STYLE: Debug logging for property type resolution
    print('🔧 GETTING TYPED PROPERTIES: ${widgetBean.id}');
    print('🔧 PROPERTIES: ${widgetBean.properties}');

    // SKETCHWARE PRO STYLE: Auto-detect widget type from properties if type is wrong
    String actualType = widgetBean.type;
    if (widgetBean.properties.containsKey('orientation') &&
        widgetBean.properties.containsKey('mainAxisAlignment') &&
        widgetBean.properties.containsKey('crossAxisAlignment')) {
      final orientation = widgetBean.properties['orientation'];
      if (orientation == 1) {
        actualType = 'Column';
      } else if (orientation == 0) {
        actualType = 'Row';
      }
      if (actualType != widgetBean.type) {
        print(
            '🔄 AUTO-CORRECTING PROPERTY TYPE: ${widgetBean.type} -> $actualType');
      }
    }

    switch (actualType) {
      case 'Text':
        return TextProperties.fromJson(widgetBean.properties);

      case 'Button':
        return ButtonProperties.fromJson(widgetBean.properties);

      case 'Container':
        return ContainerProperties.fromJson(widgetBean.properties);

      case 'TextField':
        return TextFieldProperties.fromJson(widgetBean.properties);

      case 'Icon':
        return IconProperties.fromJson(widgetBean.properties);

      case 'Row':
      case 'Column':
        return LayoutProperties.fromJson(widgetBean.properties);

      case 'Stack':
        return StackProperties.fromJson(widgetBean.properties);

      default:
        print('⚠️ UNKNOWN WIDGET TYPE: ${widgetBean.type}');
        print('⚠️ WIDGET PROPERTIES: ${widgetBean.properties}');
        return widgetBean.properties; 
    }
  }
}
