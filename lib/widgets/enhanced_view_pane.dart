import 'package:flutter/material.dart';
import '../models/flutter_widget_bean.dart';
import '../models/view_info.dart';
import '../services/view_info_service.dart';
import 'items/widget_row.dart';
import 'items/widget_column.dart';
import 'items/widget_container.dart';
import 'items/widget_stack.dart';
import 'items/widget_text.dart';
import 'items/widget_text_field.dart';
import 'items/widget_icon.dart';

/// Enhanced View Pane - EXACTLY matches Sketchware Pro's ViewPane
/// Provides sophisticated drop zone detection and visual feedback during drag operations
class EnhancedViewPane extends StatefulWidget {
  final List<FlutterWidgetBean> widgets;
  final Function(FlutterWidgetBean) onWidgetSelected;
  final Function(FlutterWidgetBean, ViewInfo?) onDropTargetChanged;
  final Function(FlutterWidgetBean, DropZoneInfo?) onDropZoneChanged;
  final ViewInfoService viewInfoService;
  final Size containerSize;
  final bool showDropZones;
  final bool showHighlights;

  const EnhancedViewPane({
    super.key,
    required this.widgets,
    required this.onWidgetSelected,
    required this.onDropTargetChanged,
    required this.onDropZoneChanged,
    required this.viewInfoService,
    required this.containerSize,
    this.showDropZones = true,
    this.showHighlights = true,
  });

  @override
  State<EnhancedViewPane> createState() => _EnhancedViewPaneState();
}

class _EnhancedViewPaneState extends State<EnhancedViewPane> {
  @override
  void initState() {
    super.initState();
    // Update view infos when widget initializes
    widget.viewInfoService
        .updateViewInfos(widget.widgets, widget.containerSize);
  }

  @override
  void didUpdateWidget(EnhancedViewPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update view infos when widgets change
    if (oldWidget.widgets != widget.widgets ||
        oldWidget.containerSize != widget.containerSize) {
      widget.viewInfoService
          .updateViewInfos(widget.widgets, widget.containerSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewInfoService,
      builder: (context, child) {
        return CustomMultiChildLayout(
          delegate: ViewPaneLayoutDelegate(
            widget.viewInfoService.viewInfos,
            widget.containerSize,
          ),
          children: [
            // Render all widgets with their drop zones
            for (final viewInfo in widget.viewInfoService.viewInfos)
              LayoutId(
                id: viewInfo.widget.id,
                child: ViewPaneItem(
                  viewInfo: viewInfo,
                  onWidgetSelected: widget.onWidgetSelected,
                  onDropTargetChanged: widget.onDropTargetChanged,
                  onDropZoneChanged: widget.onDropZoneChanged,
                  viewInfoService: widget.viewInfoService,
                  showDropZones: widget.showDropZones,
                  showHighlights: widget.showHighlights,
                ),
              ),

            // Render drop zone overlays
            if (widget.showDropZones)
              for (final dropZone in widget.viewInfoService.dropZones)
                LayoutId(
                  id: 'dropzone_${dropZone.targetWidget?.id}_${dropZone.index}',
                  child: DropZoneOverlay(
                    dropZone: dropZone,
                    isActive:
                        widget.viewInfoService.currentDropZone == dropZone,
                  ),
                ),
          ],
        );
      },
    );
  }
}

/// View Pane Layout Delegate - Manages widget positioning and layout
class ViewPaneLayoutDelegate extends MultiChildLayoutDelegate {
  final List<ViewInfo> viewInfos;
  final Size containerSize;

  ViewPaneLayoutDelegate(this.viewInfos, this.containerSize);

  @override
  void performLayout(Size size) {
    // Layout each widget based on its ViewInfo
    for (final viewInfo in viewInfos) {
      if (hasChild(viewInfo.widget.id)) {
        final childSize =
            layoutChild(viewInfo.widget.id, BoxConstraints.loose(size));
        positionChild(viewInfo.widget.id,
            Offset(viewInfo.bounds.left, viewInfo.bounds.top));
      }
    }

    // Layout drop zone overlays
    for (final viewInfo in viewInfos) {
      final widget = viewInfo.widget;
      if (_isLayoutWidget(widget)) {
        final children = widget.children;
        for (int i = 0; i <= children.length; i++) {
          final dropZoneId = 'dropzone_${widget.id}_$i';
          if (hasChild(dropZoneId)) {
            final dropZoneBounds = _calculateDropZoneBounds(
              viewInfo.bounds,
              widget.type == 'column' ? Axis.vertical : Axis.horizontal,
              i,
              children.length,
            );
            layoutChild(dropZoneId, BoxConstraints.loose(size));
            positionChild(
                dropZoneId, Offset(dropZoneBounds.left, dropZoneBounds.top));
          }
        }
      }
    }
  }

  @override
  bool shouldRelayout(ViewPaneLayoutDelegate oldDelegate) {
    return oldDelegate.viewInfos != viewInfos ||
        oldDelegate.containerSize != containerSize;
  }

  bool _isLayoutWidget(FlutterWidgetBean widget) {
    return widget.type == 'column' ||
        widget.type == 'row' ||
        widget.type == 'stack' ||
        widget.type == 'container' ||
        widget.type == 'scaffold';
  }

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
}

/// View Pane Item - Individual widget with drop zone detection
class ViewPaneItem extends StatefulWidget {
  final ViewInfo viewInfo;
  final Function(FlutterWidgetBean) onWidgetSelected;
  final Function(FlutterWidgetBean, ViewInfo?) onDropTargetChanged;
  final Function(FlutterWidgetBean, DropZoneInfo?) onDropZoneChanged;
  final ViewInfoService viewInfoService;
  final bool showDropZones;
  final bool showHighlights;

  const ViewPaneItem({
    super.key,
    required this.viewInfo,
    required this.onWidgetSelected,
    required this.onDropTargetChanged,
    required this.onDropZoneChanged,
    required this.viewInfoService,
    this.showDropZones = true,
    this.showHighlights = true,
  });

  @override
  State<ViewPaneItem> createState() => _ViewPaneItemState();
}

class _ViewPaneItemState extends State<ViewPaneItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final widgetBean = widget.viewInfo.widget;
    final isHighlighted =
        widget.viewInfoService.highlightedViewInfo == widget.viewInfo;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: widget.viewInfo.bounds.width,
          height: widget.viewInfo.bounds.height,
          decoration: BoxDecoration(
            border: _isHovered || isHighlighted
                ? Border.all(
                    color: isHighlighted ? Colors.blue : Colors.grey,
                    width: isHighlighted ? 2.0 : 1.0,
                  )
                : null,
            color: isHighlighted
                ? Colors.blue.withOpacity(0.1)
                : _isHovered
                    ? Colors.grey.withOpacity(0.05)
                    : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => widget.onWidgetSelected(widgetBean),
              onHover: (hovered) {
                setState(() {
                  _isHovered = hovered;
                });
              },
              child: _buildWidgetContent(widgetBean, constraints),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWidgetContent(
      FlutterWidgetBean widget, BoxConstraints constraints) {
    // Build the actual widget content based on type using our new widget classes
    switch (widget.type) {
      // Layout Widgets
      case 'Row':
        return WidgetRow(
          widgetBean: widget,
          isSelected: _isHovered,
          onTap: () => this.widget.onWidgetSelected(widget),
          children: _buildChildren(widget),
        );
      case 'Column':
        return WidgetColumn(
          widgetBean: widget,
          isSelected: _isHovered,
          onTap: () => this.widget.onWidgetSelected(widget),
          children: _buildChildren(widget),
        );
      case 'Container':
        return WidgetContainer(
          widgetBean: widget,
          isSelected: _isHovered,
          onTap: () => this.widget.onWidgetSelected(widget),
          child:
              widget.children.isNotEmpty ? _buildChildren(widget).first : null,
        );
      case 'Stack':
        return WidgetStack(
          widgetBean: widget,
          isSelected: _isHovered,
          onTap: () => this.widget.onWidgetSelected(widget),
          children: _buildChildren(widget),
        );

      // Text & Input Widgets
      case 'Text':
        return WidgetText(
          widgetBean: widget,
          isSelected: _isHovered,
          onTap: () => this.widget.onWidgetSelected(widget),
        );
      case 'TextField':
        return WidgetTextField(
          widgetBean: widget,
          isSelected: _isHovered,
          onTap: () => this.widget.onWidgetSelected(widget),
        );
      case 'Icon':
        return WidgetIcon(
          widgetBean: widget,
          isSelected: _isHovered,
          onTap: () => this.widget.onWidgetSelected(widget),
        );

      // Fallback for unknown widgets
      default:
        return _buildDefaultWidget(widget);
    }
  }

  // Build children widgets recursively
  List<Widget> _buildChildren(FlutterWidgetBean parentWidget) {
    // For now, return empty list since children are stored as IDs
    // TODO: Implement proper child widget lookup from widget list
    return [];
  }

  Widget _buildDefaultWidget(FlutterWidgetBean widget) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, style: BorderStyle.solid),
        color: Colors.grey.withOpacity(0.1),
      ),
      child: Center(
        child: Text(
          '${widget.type}\n(Drop widgets here)',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  // Helper methods removed - now handled by individual widget classes
}

/// Drop Zone Overlay - Visual feedback for drop zones
class DropZoneOverlay extends StatelessWidget {
  final DropZoneInfo dropZone;
  final bool isActive;

  const DropZoneOverlay({
    super.key,
    required this.dropZone,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: dropZone.bounds.width,
      height: dropZone.bounds.height,
      decoration: BoxDecoration(
        color: isActive
            ? dropZone.highlightColor.withOpacity(0.3)
            : dropZone.highlightColor.withOpacity(0.1),
        border: Border.all(
          color: isActive
              ? dropZone.highlightColor
              : dropZone.highlightColor.withOpacity(0.5),
          width: isActive ? 2.0 : 1.0,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: isActive
          ? Center(
              child: Text(
                dropZone.message ?? 'Drop here',
                style: TextStyle(
                  color: dropZone.highlightColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : null,
    );
  }
}
