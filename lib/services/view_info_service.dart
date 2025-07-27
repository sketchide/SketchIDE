import 'package:flutter/material.dart';
import '../models/flutter_widget_bean.dart';
import '../models/view_info.dart';

/// ViewInfoService - EXACTLY matches Sketchware Pro's ViewPane system
/// Manages ViewInfo objects for precise drop zone detection and visual feedback
class ViewInfoService extends ChangeNotifier {
  final List<ViewInfo> _viewInfos = [];
  final List<DropZoneInfo> _dropZones = [];
  ViewInfo? _highlightedViewInfo;
  DropZoneInfo? _currentDropZone;

  // Getters
  List<ViewInfo> get viewInfos => List.unmodifiable(_viewInfos);
  List<DropZoneInfo> get dropZones => List.unmodifiable(_dropZones);
  ViewInfo? get highlightedViewInfo => _highlightedViewInfo;
  DropZoneInfo? get currentDropZone => _currentDropZone;

  /// Update ViewInfo objects based on current widgets
  /// EXACTLY like Sketchware Pro's ViewPane.updateViewInfos()
  void updateViewInfos(List<FlutterWidgetBean> widgets, Size containerSize) {
    _viewInfos.clear();
    _dropZones.clear();
    
    // Calculate bounds and depth for each widget
    for (int i = 0; i < widgets.length; i++) {
      final widget = widgets[i];
      final bounds = _calculateWidgetBounds(widget, containerSize);
      final depth = _calculateWidgetDepth(widget, widgets);
      
      final viewInfo = ViewInfo(
        bounds: bounds,
        widget: widget,
        index: i,
        depth: depth,
        parentId: widget.parentId,
        children: widget.children,
      );
      
      _viewInfos.add(viewInfo);
      
      // Create drop zones for layout widgets
      if (_isLayoutWidget(widget)) {
        _createDropZonesForWidget(viewInfo, widgets);
      }
    }
    
    notifyListeners();
  }

  /// Get the best drop target at a given position
  /// EXACTLY like Sketchware Pro's ViewPane.getViewInfo()
  ViewInfo? getDropTargetAtPosition(Offset position) {
    ViewInfo? bestTarget;
    int highestDepth = -1;
    
    for (final viewInfo in _viewInfos) {
      if (viewInfo.bounds.contains(position) && 
          viewInfo.depth > highestDepth &&
          _canAcceptDrop(viewInfo.widget)) {
        bestTarget = viewInfo;
        highestDepth = viewInfo.depth;
      }
    }
    
    return bestTarget;
  }

  /// Get drop zone at position for visual feedback
  DropZoneInfo? getDropZoneAtPosition(Offset position) {
    DropZoneInfo? bestZone;
    int highestDepth = -1;
    
    for (final dropZone in _dropZones) {
      if (dropZone.bounds.contains(position) && 
          dropZone.depth > highestDepth) {
        bestZone = dropZone;
        highestDepth = dropZone.depth;
      }
    }
    
    return bestZone;
  }

  /// Highlight a view info for visual feedback
  void highlightViewInfo(ViewInfo? viewInfo) {
    if (_highlightedViewInfo != viewInfo) {
      _highlightedViewInfo = viewInfo;
      notifyListeners();
    }
  }

  /// Set current drop zone for visual feedback
  void setCurrentDropZone(DropZoneInfo? dropZone) {
    if (_currentDropZone != dropZone) {
      _currentDropZone = dropZone;
      notifyListeners();
    }
  }

  /// Calculate widget bounds based on position and layout
  Rect _calculateWidgetBounds(FlutterWidgetBean widget, Size containerSize) {
    final position = widget.position;
    final layout = widget.layout;
    
    double width = position.width;
    double height = position.height;
    
    // Handle MATCH_PARENT and WRAP_CONTENT like Sketchware Pro
    if (layout.width == LayoutBean.MATCH_PARENT) {
      width = containerSize.width - position.x;
    } else if (layout.width == LayoutBean.WRAP_CONTENT) {
      width = _calculateWrapContentWidth(widget);
    }
    
    if (layout.height == LayoutBean.MATCH_PARENT) {
      height = containerSize.height - position.y;
    } else if (layout.height == LayoutBean.WRAP_CONTENT) {
      height = _calculateWrapContentHeight(widget);
    }
    
    return Rect.fromLTWH(position.x, position.y, width, height);
  }

  /// Calculate widget depth in the hierarchy
  int _calculateWidgetDepth(FlutterWidgetBean widget, List<FlutterWidgetBean> allWidgets) {
    int depth = 0;
    String? currentParentId = widget.parentId;
    
    while (currentParentId != null) {
      depth++;
      final parent = allWidgets.firstWhere(
        (w) => w.id == currentParentId,
        orElse: () => FlutterWidgetBean(
          id: '',
          type: '',
          properties: {},
          children: [],
          position: PositionBean(x: 0, y: 0, width: 0, height: 0),
          events: {},
          layout: LayoutBean(),
        ),
      );
      currentParentId = parent.parentId;
    }
    
    return depth;
  }

  /// Check if widget can accept drops
  bool _canAcceptDrop(FlutterWidgetBean widget) {
    // Layout widgets can accept drops
    return widget.type == 'column' || 
           widget.type == 'row' || 
           widget.type == 'stack' || 
           widget.type == 'container' ||
           widget.type == 'scaffold';
  }

  /// Check if widget is a layout widget
  bool _isLayoutWidget(FlutterWidgetBean widget) {
    return widget.type == 'column' || 
           widget.type == 'row' || 
           widget.type == 'stack' || 
           widget.type == 'container' ||
           widget.type == 'scaffold';
  }

  /// Create drop zones for a layout widget
  void _createDropZonesForWidget(ViewInfo viewInfo, List<FlutterWidgetBean> allWidgets) {
    final widget = viewInfo.widget;
    final bounds = viewInfo.bounds;
    
    if (widget.type == 'column' || widget.type == 'row') {
      // Create drop zones for each child position
      final children = widget.children;
      if (children.isEmpty) {
        // Empty layout - create single drop zone
        _dropZones.add(DropZoneInfo(
          bounds: bounds,
          targetWidget: widget,
          index: 0,
          depth: viewInfo.depth + 1,
          message: 'Drop here to add widget',
          highlightColor: Colors.green,
        ));
      } else {
        // Create drop zones between children
        for (int i = 0; i <= children.length; i++) {
          final dropZoneBounds = _calculateDropZoneBounds(
            bounds, 
            widget.type == 'column' ? Axis.vertical : Axis.horizontal,
            i,
            children.length,
          );
          
          _dropZones.add(DropZoneInfo(
            bounds: dropZoneBounds,
            targetWidget: widget,
            index: i,
            depth: viewInfo.depth + 1,
            message: 'Drop here to insert at position $i',
            highlightColor: Colors.blue,
          ));
        }
      }
    } else if (widget.type == 'stack') {
      // Stack - create overlay drop zones
      _dropZones.add(DropZoneInfo(
        bounds: bounds,
        targetWidget: widget,
        index: widget.children.length,
        depth: viewInfo.depth + 1,
        message: 'Drop here to overlay widget',
        highlightColor: Colors.purple,
      ));
    }
  }

  /// Calculate drop zone bounds for linear layouts
  Rect _calculateDropZoneBounds(
    Rect parentBounds, 
    Axis direction, 
    int index, 
    int childCount,
  ) {
    const dropZoneSize = 20.0;
    
    if (direction == Axis.vertical) {
      final itemHeight = parentBounds.height / (childCount + 1);
      final y = parentBounds.top + (index * itemHeight);
      
      return Rect.fromLTWH(
        parentBounds.left,
        y - dropZoneSize / 2,
        parentBounds.width,
        dropZoneSize,
      );
    } else {
      final itemWidth = parentBounds.width / (childCount + 1);
      final x = parentBounds.left + (index * itemWidth);
      
      return Rect.fromLTWH(
        x - dropZoneSize / 2,
        parentBounds.top,
        dropZoneSize,
        parentBounds.height,
      );
    }
  }

  /// Calculate wrap content width
  double _calculateWrapContentWidth(FlutterWidgetBean widget) {
    // Default width for wrap content
    switch (widget.type) {
      case 'text':
        final text = widget.properties['text'] ?? '';
        return text.length * 8.0 + 20.0; // Approximate text width
      case 'button':
        return 100.0;
      default:
        return 200.0;
    }
  }

  /// Calculate wrap content height
  double _calculateWrapContentHeight(FlutterWidgetBean widget) {
    // Default height for wrap content
    switch (widget.type) {
      case 'text':
        return 24.0;
      case 'button':
        return 48.0;
      default:
        return 50.0;
    }
  }

  /// Clear all view infos and drop zones
  void clear() {
    _viewInfos.clear();
    _dropZones.clear();
    _highlightedViewInfo = null;
    _currentDropZone = null;
    notifyListeners();
  }

  /// Get view info by widget ID
  ViewInfo? getViewInfoByWidgetId(String widgetId) {
    try {
      return _viewInfos.firstWhere((info) => info.widget.id == widgetId);
    } catch (e) {
      return null;
    }
  }

  /// Update view info bounds (called when widget moves)
  void updateViewInfoBounds(String widgetId, Rect newBounds) {
    final index = _viewInfos.indexWhere((info) => info.widget.id == widgetId);
    if (index != -1) {
      final oldInfo = _viewInfos[index];
      _viewInfos[index] = oldInfo.copyWith(bounds: newBounds);
      
      // Update related drop zones
      _updateDropZonesForWidget(oldInfo.widget);
      
      notifyListeners();
    }
  }

  /// Update drop zones for a specific widget
  void _updateDropZonesForWidget(FlutterWidgetBean widget) {
    // Remove old drop zones for this widget
    _dropZones.removeWhere((zone) => zone.targetWidget?.id == widget.id);
    
    // Recreate drop zones
    final viewInfo = getViewInfoByWidgetId(widget.id);
    if (viewInfo != null && _isLayoutWidget(widget)) {
      _createDropZonesForWidget(viewInfo, _viewInfos.map((info) => info.widget).toList());
    }
  }
} 