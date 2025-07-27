import 'package:flutter/material.dart';
import 'flutter_widget_bean.dart';

/// ViewInfo - EXACTLY matches Sketchware Pro's ViewInfo system
/// Tracks widget bounds, depth, and drop target information for precise drag & drop
class ViewInfo {
  final Rect bounds;
  final FlutterWidgetBean widget;
  final int index;
  final int depth;
  final bool isDropTarget;
  final bool isHighlighted;
  final String? parentId;
  final List<String> children;

  ViewInfo({
    required this.bounds,
    required this.widget,
    required this.index,
    required this.depth,
    this.isDropTarget = false,
    this.isHighlighted = false,
    this.parentId,
    this.children = const [],
  });

  /// Create a copy with updated properties
  ViewInfo copyWith({
    Rect? bounds,
    FlutterWidgetBean? widget,
    int? index,
    int? depth,
    bool? isDropTarget,
    bool? isHighlighted,
    String? parentId,
    List<String>? children,
  }) {
    return ViewInfo(
      bounds: bounds ?? this.bounds,
      widget: widget ?? this.widget,
      index: index ?? this.index,
      depth: depth ?? this.depth,
      isDropTarget: isDropTarget ?? this.isDropTarget,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      parentId: parentId ?? this.parentId,
      children: children ?? this.children,
    );
  }

  /// Check if a position is within this view's bounds
  bool containsPosition(Offset position) {
    return bounds.contains(position);
  }

  /// Get the center point of this view
  Offset get center {
    return bounds.center;
  }

  /// Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'bounds': {
        'left': bounds.left,
        'top': bounds.top,
        'right': bounds.right,
        'bottom': bounds.bottom,
      },
      'widgetId': widget.id,
      'index': index,
      'depth': depth,
      'isDropTarget': isDropTarget,
      'isHighlighted': isHighlighted,
      'parentId': parentId,
      'children': children,
    };
  }

  /// Create from JSON
  factory ViewInfo.fromJson(
      Map<String, dynamic> json, FlutterWidgetBean widget) {
    final boundsJson = json['bounds'] as Map<String, dynamic>;
    final bounds = Rect.fromLTRB(
      boundsJson['left'].toDouble(),
      boundsJson['top'].toDouble(),
      boundsJson['right'].toDouble(),
      boundsJson['bottom'].toDouble(),
    );

    return ViewInfo(
      bounds: bounds,
      widget: widget,
      index: json['index'] ?? 0,
      depth: json['depth'] ?? 0,
      isDropTarget: json['isDropTarget'] ?? false,
      isHighlighted: json['isHighlighted'] ?? false,
      parentId: json['parentId'],
      children: List<String>.from(json['children'] ?? []),
    );
  }
}

/// DropZoneInfo - Enhanced drop zone information for visual feedback
class DropZoneInfo {
  final Rect bounds;
  final FlutterWidgetBean? targetWidget;
  final int index;
  final int depth;
  final bool isValid;
  final String? message;
  final Color highlightColor;

  DropZoneInfo({
    required this.bounds,
    this.targetWidget,
    required this.index,
    required this.depth,
    this.isValid = true,
    this.message,
    this.highlightColor = Colors.blue,
  });

  /// Check if a position is within this drop zone
  bool containsPosition(Offset position) {
    return bounds.contains(position);
  }

  /// Create a copy with updated properties
  DropZoneInfo copyWith({
    Rect? bounds,
    FlutterWidgetBean? targetWidget,
    int? index,
    int? depth,
    bool? isValid,
    String? message,
    Color? highlightColor,
  }) {
    return DropZoneInfo(
      bounds: bounds ?? this.bounds,
      targetWidget: targetWidget ?? this.targetWidget,
      index: index ?? this.index,
      depth: depth ?? this.depth,
      isValid: isValid ?? this.isValid,
      message: message ?? this.message,
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }
}
