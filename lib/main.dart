
import 'package:flutter/material.dart';
import 'project_dialog.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.
key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SketchIDE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<
MyHomePage> {
  void _showProjectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ProjectDialog(); 
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _showProjectDialog,
          child: const Text('Create New Project'),
        ),
      ),
    );
  }
}
