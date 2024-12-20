import 'package:flutter/material.dart';
import 'package:sketchide/ui/widgets/widgets_view/my_widgets/item_widget_view.dart';

class EventActivity extends StatelessWidget {
  const EventActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ItemWidgetView(
              icon: Icons.toll_outlined,
              iconColor: Colors.blue,
              title: 'StatelessWidget',
              subtitle: 'For static, unchanging UI.',
              onTap: () {
                // Action for StatefulWidget
              },
            ),
          ],
        ),
      ),
    );
  }
}
