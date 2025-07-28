import 'package:flutter/material.dart';
import '../models/flutter_widget_bean.dart';
import '../services/mobile_frame_widget_factory_service.dart';
import '../controllers/mobile_frame_touch_controller.dart';
import '../services/selection_service.dart';

/// Child Widget Service - Manages child widget relationships and rendering
/// Matches Sketchware Pro's child widget management system
class ChildWidgetService {
  static final ChildWidgetService _instance = ChildWidgetService._internal();
  factory ChildWidgetService() => _instance;
  ChildWidgetService._internal();

  /// Get all child widgets for a parent widget
  List<FlutterWidgetBean> getChildWidgets(
    FlutterWidgetBean parentWidget,
    List<FlutterWidgetBean> allWidgets,
  ) {
    final childIds = parentWidget.children;
    final childWidgets = <FlutterWidgetBean>[];

    for (final childId in childIds) {
      final childWidget = allWidgets.firstWhere(
        (widget) => widget.id == childId,
        orElse: () => FlutterWidgetBean(
          id: childId,
          type: 'Unknown',
          properties: {},
          children: [],
          position: PositionBean(x: 0, y: 0, width: 100, height: 100),
          events: {},
          layout: LayoutBean(),
        ),
      );
      childWidgets.add(childWidget);
    }

    // SKETCHWARE PRO STYLE: Sort children by index (like ItemLinearLayout.a())
    childWidgets.sort((a, b) => a.index.compareTo(b.index));
    return childWidgets;
  }

  /// Add a child widget to a parent widget
  void addChildWidget(
    FlutterWidgetBean parentWidget,
    FlutterWidgetBean childWidget,
    List<FlutterWidgetBean> allWidgets,
  ) {
    // SKETCHWARE PRO STYLE: Update parent's children list
    final updatedParent = parentWidget.copyWith(
      children: [...parentWidget.children, childWidget.id],
    );

    // SKETCHWARE PRO STYLE: Update child's parent reference
    final updatedChild = childWidget.copyWith(
      parentId: parentWidget.id,
      parent: parentWidget.id,
      parentType: _getParentType(parentWidget.type),
      index: parentWidget.children.length,
    );

    // Update the widgets in the list
    final parentIndex = allWidgets.indexWhere((w) => w.id == parentWidget.id);
    final childIndex = allWidgets.indexWhere((w) => w.id == childWidget.id);

    if (parentIndex != -1) {
      allWidgets[parentIndex] = updatedParent;
    }
    if (childIndex != -1) {
      allWidgets[childIndex] = updatedChild;
    }
  }

  /// Remove a child widget from a parent widget
  void removeChildWidget(
    FlutterWidgetBean parentWidget,
    FlutterWidgetBean childWidget,
    List<FlutterWidgetBean> allWidgets,
  ) {
    // SKETCHWARE PRO STYLE: Remove child from parent's children list
    final updatedParent = parentWidget.copyWith(
      children:
          parentWidget.children.where((id) => id != childWidget.id).toList(),
    );

    // SKETCHWARE PRO STYLE: Clear child's parent reference
    final updatedChild = childWidget.copyWith(
      parentId: null,
      parent: 'root',
      parentType: 0,
      index: -1,
    );

    // Update the widgets in the list
    final parentIndex = allWidgets.indexWhere((w) => w.id == parentWidget.id);
    final childIndex = allWidgets.indexWhere((w) => w.id == childWidget.id);

    if (parentIndex != -1) {
      allWidgets[parentIndex] = updatedParent;
    }
    if (childIndex != -1) {
      allWidgets[childIndex] = updatedChild;
    }
  }

  /// Build child widgets for a parent widget with layout-specific rendering
  List<Widget> buildChildWidgets(
    FlutterWidgetBean parentWidget,
    List<FlutterWidgetBean> allWidgets,
    double scale,
    MobileFrameTouchController? touchController,
    SelectionService? selectionService,
  ) {
    final childWidgets = getChildWidgets(parentWidget, allWidgets);

    // SKETCHWARE PRO STYLE: Layout-specific child rendering
    switch (parentWidget.type) {
      case 'Row':
        return _buildRowChildren(
            childWidgets, allWidgets, scale, touchController, selectionService);
      case 'Column':
        return _buildColumnChildren(
            childWidgets, allWidgets, scale, touchController, selectionService);
      case 'Stack':
        return _buildStackChildren(
            childWidgets, allWidgets, scale, touchController, selectionService);
      case 'Container':
        return _buildContainerChildren(
            childWidgets, allWidgets, scale, touchController, selectionService);
      default:
        return _buildDefaultChildren(
            childWidgets, allWidgets, scale, touchController, selectionService);
    }
  }

  /// Build children for Row layout (horizontal flow)
  List<Widget> _buildRowChildren(
    List<FlutterWidgetBean> childWidgets,
    List<FlutterWidgetBean> allWidgets,
    double scale,
    MobileFrameTouchController? touchController,
    SelectionService? selectionService,
  ) {
    final builtWidgets = <Widget>[];

    for (final childWidget in childWidgets) {
      // SKETCHWARE PRO STYLE: Create frame widget for child
      final frameWidget = MobileFrameWidgetFactoryService.createFrameWidget(
        widgetBean: childWidget,
        scale: scale,
        allWidgets: allWidgets,
        touchController: touchController,
        selectionService: selectionService,
      );
      builtWidgets.add(frameWidget);
    }

    return builtWidgets;
  }

  /// Build children for Column layout (vertical flow)
  List<Widget> _buildColumnChildren(
    List<FlutterWidgetBean> childWidgets,
    List<FlutterWidgetBean> allWidgets,
    double scale,
    MobileFrameTouchController? touchController,
    SelectionService? selectionService,
  ) {
    final builtWidgets = <Widget>[];

    for (final childWidget in childWidgets) {
      // SKETCHWARE PRO STYLE: Create frame widget for child
      final frameWidget = MobileFrameWidgetFactoryService.createFrameWidget(
        widgetBean: childWidget,
        scale: scale,
        allWidgets: allWidgets,
        touchController: touchController,
        selectionService: selectionService,
      );
      builtWidgets.add(frameWidget);
    }

    return builtWidgets;
  }

  /// Build children for Stack layout (overlay positioning)
  List<Widget> _buildStackChildren(
    List<FlutterWidgetBean> childWidgets,
    List<FlutterWidgetBean> allWidgets,
    double scale,
    MobileFrameTouchController? touchController,
    SelectionService? selectionService,
  ) {
    final builtWidgets = <Widget>[];

    for (final childWidget in childWidgets) {
      // SKETCHWARE PRO STYLE: Create frame widget for child
      final frameWidget = MobileFrameWidgetFactoryService.createFrameWidget(
        widgetBean: childWidget,
        scale: scale,
        allWidgets: allWidgets,
        touchController: touchController,
        selectionService: selectionService,
      );
      builtWidgets.add(frameWidget);
    }

    return builtWidgets;
  }

  /// Build children for Container layout (single child)
  List<Widget> _buildContainerChildren(
    List<FlutterWidgetBean> childWidgets,
    List<FlutterWidgetBean> allWidgets,
    double scale,
    MobileFrameTouchController? touchController,
    SelectionService? selectionService,
  ) {
    final builtWidgets = <Widget>[];

    for (final childWidget in childWidgets) {
      // SKETCHWARE PRO STYLE: Create frame widget for child
      final frameWidget = MobileFrameWidgetFactoryService.createFrameWidget(
        widgetBean: childWidget,
        scale: scale,
        allWidgets: allWidgets,
        touchController: touchController,
        selectionService: selectionService,
      );
      builtWidgets.add(frameWidget);
    }

    return builtWidgets;
  }

  /// Build children for default layout (fallback)
  List<Widget> _buildDefaultChildren(
    List<FlutterWidgetBean> childWidgets,
    List<FlutterWidgetBean> allWidgets,
    double scale,
    MobileFrameTouchController? touchController,
    SelectionService? selectionService,
  ) {
    final builtWidgets = <Widget>[];

    for (final childWidget in childWidgets) {
      // SKETCHWARE PRO STYLE: Create frame widget for child
      final frameWidget = MobileFrameWidgetFactoryService.createFrameWidget(
        widgetBean: childWidget,
        scale: scale,
        allWidgets: allWidgets,
        touchController: touchController,
        selectionService: selectionService,
      );
      builtWidgets.add(frameWidget);
    }

    return builtWidgets;
  }

  /// Check if a widget can have children
  bool canHaveChildren(String widgetType) {
    return ['Container', 'Row', 'Column', 'Stack'].contains(widgetType);
  }

  /// Check if a widget is a layout widget
  bool isLayoutWidget(String widgetType) {
    return ['Row', 'Column', 'Stack'].contains(widgetType);
  }

  /// Get parent type code (matches Sketchware Pro's parent type system)
  int _getParentType(String parentType) {
    switch (parentType) {
      case 'Row':
        return 1; // LinearLayout
      case 'Column':
        return 1; // LinearLayout
      case 'Stack':
        return 2; // RelativeLayout
      case 'Container':
        return 0; // No specific layout
      default:
        return 0;
    }
  }

  /// Get root widgets (widgets without parents)
  List<FlutterWidgetBean> getRootWidgets(List<FlutterWidgetBean> allWidgets) {
    return allWidgets
        .where((widget) =>
            widget.parentId == null ||
            widget.parentId?.isEmpty == true ||
            widget.parent == 'root')
        .toList();
  }

  /// Get widget depth in the hierarchy
  int getWidgetDepth(
      FlutterWidgetBean widget, List<FlutterWidgetBean> allWidgets) {
    int depth = 0;
    FlutterWidgetBean? currentWidget = widget;

    while (currentWidget != null &&
        currentWidget.parentId != null &&
        currentWidget.parentId!.isNotEmpty &&
        currentWidget.parent != 'root') {
      depth++;
      currentWidget = allWidgets.firstWhere(
        (w) => w.id == currentWidget!.parentId,
        orElse: () => FlutterWidgetBean(
          id: 'root',
          type: 'Root',
          properties: {},
          children: [],
          position: PositionBean(x: 0, y: 0, width: 100, height: 100),
          events: {},
          layout: LayoutBean(),
        ),
      );
    }

    return depth;
  }

  /// Update widget indices after changes
  void updateWidgetIndices(
      FlutterWidgetBean parentWidget, List<FlutterWidgetBean> allWidgets) {
    final childWidgets = getChildWidgets(parentWidget, allWidgets);

    for (int i = 0; i < childWidgets.length; i++) {
      final childWidget = childWidgets[i];
      final updatedChild = childWidget.copyWith(index: i);

      final childIndex = allWidgets.indexWhere((w) => w.id == childWidget.id);
      if (childIndex != -1) {
        allWidgets[childIndex] = updatedChild;
      }
    }
  }

  /// Get widget by ID
  FlutterWidgetBean? getWidgetById(
      String widgetId, List<FlutterWidgetBean> allWidgets) {
    try {
      return allWidgets.firstWhere((widget) => widget.id == widgetId);
    } catch (e) {
      return null;
    }
  }

  /// Check if a widget is a child of another widget
  bool isChildOf(
      FlutterWidgetBean childWidget, FlutterWidgetBean parentWidget) {
    return childWidget.parentId == parentWidget.id;
  }

  /// Get all descendants of a widget
  List<FlutterWidgetBean> getDescendants(
      FlutterWidgetBean parentWidget, List<FlutterWidgetBean> allWidgets) {
    final descendants = <FlutterWidgetBean>[];
    final childWidgets = getChildWidgets(parentWidget, allWidgets);

    for (final childWidget in childWidgets) {
      descendants.add(childWidget);
      descendants.addAll(getDescendants(childWidget, allWidgets));
    }

    return descendants;
  }

  /// Check if a widget has children
  bool hasChildren(FlutterWidgetBean widget) {
    return widget.children.isNotEmpty;
  }

  /// Get total widget count including children
  int getWidgetCount(
      FlutterWidgetBean widget, List<FlutterWidgetBean> allWidgets) {
    int count = 1; // Count the widget itself
    final childWidgets = getChildWidgets(widget, allWidgets);

    for (final childWidget in childWidgets) {
      count += getWidgetCount(childWidget, allWidgets);
    }

    return count;
  }
}
