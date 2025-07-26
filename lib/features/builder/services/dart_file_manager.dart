import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import '../../../models/sketchide_project.dart';
import '../models/dart_file_bean.dart';
import '../models/widget_data.dart';
import '../services/file_sync_service.dart';
import 'code_generator.dart';

class DartFileManager {
  static const String _filesConfigName = 'dart_files.json';

  // Get all Dart files for a project
  static Future<List<DartFileBean>> getAllDartFiles(
      SketchIDEProject project) async {
    try {
      final configFile = File(
          'projects/$_filesConfigName'); // Temporary path since SketchIDEProject doesn't have projectPath
      List<DartFileBean> files = [];

      if (await configFile.exists()) {
        final content = await configFile.readAsString();
        final List<dynamic> filesJson = jsonDecode(content);
        files = filesJson.map((json) => DartFileBean.fromJson(json)).toList();
      } else {
        // Create default files if config doesn't exist
        files = await _createDefaultFiles(project);
      }

      return files;
    } catch (e) {
      print('Error loading Dart files: $e');
      return [];
    }
  }

  // Create default files for a new project
  static Future<List<DartFileBean>> _createDefaultFiles(
      SketchIDEProject project) async {
    final List<DartFileBean> files = [
      DartFileBean.mainDart(
          'projects'), // Temporary path since SketchIDEProject doesn't have projectPath
    ];

    // Create the actual files
    for (final file in files) {
      await _createDartFile(file, project);
    }

    // Create default widgets for main.dart
    await _createDefaultWidgetsForMain(project);

    // Save the configuration
    await _saveFilesConfig(project, files);

    return files;
  }

  // Create default widgets for main.dart (Hello World structure)
  static Future<void> _createDefaultWidgetsForMain(
      SketchIDEProject project) async {
    try {
      final List<WidgetData> defaultWidgets = [
        // Text widget for Hello World
        WidgetData(
          id: 'text_1',
          type: 'text',
          properties: {
            'text': 'Hello World!',
            'fontSize': 24.0,
            'color': '#000000',
            'alignment': 'center',
          },
        ),
      ];

      // Save widgets to the project
      await _saveWidgetsToFile(project, 'main.dart', defaultWidgets);
    } catch (e) {
      print('Error creating default widgets: $e');
    }
  }

  // Create a new Dart file
  static Future<DartFileBean> createDartFile(
    SketchIDEProject project,
    DartFileType fileType,
    String name,
  ) async {
    DartFileBean newFile;

    switch (fileType) {
      case DartFileType.page:
        newFile = DartFileBean.customPage('projects',
            name); // Temporary path since SketchIDEProject doesn't have projectPath
        break;
      case DartFileType.service:
        newFile = DartFileBean.service('projects',
            name); // Temporary path since SketchIDEProject doesn't have projectPath
        break;
      case DartFileType.model:
        newFile = DartFileBean.model('projects',
            name); // Temporary path since SketchIDEProject doesn't have projectPath
        break;
      case DartFileType.widget:
        newFile = DartFileBean.widget('projects',
            name); // Temporary path since SketchIDEProject doesn't have projectPath
        break;
      default:
        throw ArgumentError('Cannot create main.dart file manually');
    }

    // Create the actual file
    await _createDartFile(newFile, project);

    // Add to existing files
    final existingFiles = await getAllDartFiles(project);
    existingFiles.add(newFile);
    await _saveFilesConfig(project, existingFiles);

    return newFile;
  }

  // Create the actual Dart file with default content
  static Future<void> _createDartFile(
      DartFileBean file, SketchIDEProject project) async {
    try {
      final dartFile = File(file.filePath);
      final directory = dartFile.parent;

      // Create directory if it doesn't exist
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Generate default content
      final content = _generateDefaultContent(file, project);

      // Write the file
      await dartFile.writeAsString(content);
      print('Created Dart file: ${file.filePath}');
    } catch (e) {
      print('Error creating Dart file ${file.filePath}: $e');
      rethrow;
    }
  }

  // Generate default content for a Dart file
  static String _generateDefaultContent(
      DartFileBean file, SketchIDEProject project) {
    switch (file.fileType) {
      case DartFileType.main:
        return _generateDefaultMainDartContent(project);
      case DartFileType.page:
        return _generatePageContent(file, project);
      case DartFileType.service:
        return _generateServiceContent(file, project);
      case DartFileType.model:
        return _generateModelContent(file, project);
      case DartFileType.widget:
        return _generateWidgetContent(file, project);
    }
  }

  // Generate default main.dart with Hello World structure
  static String _generateDefaultMainDartContent(SketchIDEProject project) {
    final StringBuffer code = StringBuffer();

    code.writeln("import 'package:flutter/material.dart';");
    code.writeln("");
    code.writeln("void main() {");
    code.writeln("  runApp(const MyApp());");
    code.writeln("}");
    code.writeln("");
    code.writeln("class MyApp extends StatelessWidget {");
    code.writeln("  const MyApp({super.key});");
    code.writeln("");
    code.writeln("  @override");
    code.writeln("  Widget build(BuildContext context) {");
    code.writeln("    return MaterialApp(");
    code.writeln("      title: '${project.projectInfo.appName}',");
    code.writeln("      theme: ThemeData(");
    code.writeln("        primarySwatch: Colors.blue,");
    code.writeln("        useMaterial3: true,");
    code.writeln("      ),");
    code.writeln("      home: const MyHomePage(),");
    code.writeln("    );");
    code.writeln("  }");
    code.writeln("}");
    code.writeln("");
    code.writeln("class MyHomePage extends StatelessWidget {");
    code.writeln("  const MyHomePage({super.key});");
    code.writeln("");
    code.writeln("  @override");
    code.writeln("  Widget build(BuildContext context) {");
    code.writeln("    return Scaffold(");
    code.writeln("      appBar: AppBar(");
    code.writeln("        title: const Text('Home'),");
    code.writeln("      ),");
    code.writeln("      body: const Center(");
    code.writeln("        child: Text(");
    code.writeln("          'Hello World!',");
    code.writeln("          style: TextStyle(fontSize: 24),");
    code.writeln("        ),");
    code.writeln("      ),");
    code.writeln("    );");
    code.writeln("  }");
    code.writeln("}");

    return code.toString();
  }

  static String _generatePageContent(
      DartFileBean file, SketchIDEProject project) {
    final className = file.className;
    final StringBuffer code = StringBuffer();

    code.writeln("import 'package:flutter/material.dart';");
    code.writeln("");
    code.writeln("class $className extends StatelessWidget {");
    code.writeln("  const $className({super.key});");
    code.writeln("");
    code.writeln("  @override");
    code.writeln("  Widget build(BuildContext context) {");
    code.writeln("    return Scaffold(");
    code.writeln("      appBar: AppBar(");
    code.writeln("        title: const Text('$className'),");
    code.writeln("      ),");
    code.writeln("      body: const Center(");
    code.writeln("        child: Text(");
    code.writeln("          'Welcome to $className',");
    code.writeln("          style: TextStyle(fontSize: 20),");
    code.writeln("        ),");
    code.writeln("      ),");
    code.writeln("    );");
    code.writeln("  }");
    code.writeln("}");

    return code.toString();
  }

  static String _generateServiceContent(
      DartFileBean file, SketchIDEProject project) {
    final className = file.className;
    final StringBuffer code = StringBuffer();

    code.writeln("class $className {");
    code.writeln(
        "  static final $className _instance = $className._internal();");
    code.writeln("");
    code.writeln("  factory $className() {");
    code.writeln("    return _instance;");
    code.writeln("  }");
    code.writeln("");
    code.writeln("  $className._internal();");
    code.writeln("");
    code.writeln("  // Add your service methods here");
    code.writeln("}");
    code.writeln("");

    return code.toString();
  }

  static String _generateModelContent(
      DartFileBean file, SketchIDEProject project) {
    final className = file.className;
    final StringBuffer code = StringBuffer();

    code.writeln("class $className {");
    code.writeln("  final String id;");
    code.writeln("  final String name;");
    code.writeln("");
    code.writeln("  $className({");
    code.writeln("    required this.id,");
    code.writeln("    required this.name,");
    code.writeln("  });");
    code.writeln("");
    code.writeln("  factory $className.fromJson(Map<String, dynamic> json) {");
    code.writeln("    return $className(");
    code.writeln("      id: json['id'] ?? '',");
    code.writeln("      name: json['name'] ?? '',");
    code.writeln("    );");
    code.writeln("  }");
    code.writeln("");
    code.writeln("  Map<String, dynamic> toJson() {");
    code.writeln("    return {");
    code.writeln("      'id': id,");
    code.writeln("      'name': name,");
    code.writeln("    };");
    code.writeln("  }");
    code.writeln("}");
    code.writeln("");

    return code.toString();
  }

  static String _generateWidgetContent(
      DartFileBean file, SketchIDEProject project) {
    final className = file.className;
    final StringBuffer code = StringBuffer();

    code.writeln("import 'package:flutter/material.dart';");
    code.writeln("");
    code.writeln("class $className extends StatelessWidget {");
    code.writeln("  final String? title;");
    code.writeln("  final VoidCallback? onPressed;");
    code.writeln("");
    code.writeln("  const $className({");
    code.writeln("    super.key,");
    code.writeln("    this.title,");
    code.writeln("    this.onPressed,");
    code.writeln("  });");
    code.writeln("");
    code.writeln("  @override");
    code.writeln("  Widget build(BuildContext context) {");
    code.writeln("    return Container(");
    code.writeln("      padding: const EdgeInsets.all(16),");
    code.writeln("      child: Column(");
    code.writeln("        children: [");
    code.writeln("          Text(");
    code.writeln("            title ?? '$className',");
    code.writeln("            style: const TextStyle(fontSize: 18),");
    code.writeln("          ),");
    code.writeln("          if (onPressed != null)");
    code.writeln("            ElevatedButton(");
    code.writeln("              onPressed: onPressed,");
    code.writeln("              child: const Text('Action'),");
    code.writeln("            ),");
    code.writeln("        ],");
    code.writeln("      ),");
    code.writeln("    );");
    code.writeln("  }");
    code.writeln("}");
    code.writeln("");

    return code.toString();
  }

  // Delete a Dart file
  static Future<bool> deleteDartFile(
      SketchIDEProject project, DartFileBean file) async {
    try {
      // Don't allow deletion of main.dart
      if (file.fileType == DartFileType.main) {
        print('Cannot delete main.dart file');
        return false;
      }

      // Delete the actual file
      final dartFile = File(file.filePath);
      if (await dartFile.exists()) {
        await dartFile.delete();
        print('Deleted Dart file: ${file.filePath}');
      }

      // Remove from configuration
      final existingFiles = await getAllDartFiles(project);
      existingFiles.removeWhere((f) => f.fileName == file.fileName);
      await _saveFilesConfig(project, existingFiles);

      return true;
    } catch (e) {
      print('Error deleting Dart file ${file.filePath}: $e');
      return false;
    }
  }

  // Update widgets in a specific Dart file
  static Future<void> updateFileWithWidgets(
    SketchIDEProject project,
    DartFileBean file,
    List<WidgetData> widgets,
  ) async {
    try {
      // Generate updated code with widgets
      String updatedContent;
      switch (file.fileType) {
        case DartFileType.page:
          updatedContent = _generatePageWithWidgets(file, project, widgets);
          break;
        case DartFileType.widget:
          updatedContent = _generateWidgetWithWidgets(file, project, widgets);
          break;
        default:
          // For other file types, keep the original content
          return;
      }

      // Write the updated content
      final dartFile = File(file.filePath);
      await dartFile.writeAsString(updatedContent);

      // Save widgets data
      await _saveWidgetsToFile(project, file.fileName, widgets);

      print('Updated file ${file.filePath} with ${widgets.length} widgets');
    } catch (e) {
      print('Error updating file ${file.filePath}: $e');
      rethrow;
    }
  }

  static String _generatePageWithWidgets(
      DartFileBean file, SketchIDEProject project, List<WidgetData> widgets) {
    final className = file.className;
    final StringBuffer code = StringBuffer();

    code.writeln("import 'package:flutter/material.dart';");
    code.writeln("");
    code.writeln("class $className extends StatelessWidget {");
    code.writeln("  const $className({super.key});");
    code.writeln("");
    code.writeln("  @override");
    code.writeln("  Widget build(BuildContext context) {");
    code.writeln("    return Scaffold(");
    code.writeln("      appBar: AppBar(");
    code.writeln("        title: const Text('$className'),");
    code.writeln("      ),");
    code.writeln("      body: Column(");
    code.writeln("        children: [");

    // Generate widget code for each widget
    for (final widget in widgets) {
      code.writeln("          ${_generateWidgetCode(widget)},");
    }

    code.writeln("        ],");
    code.writeln("      ),");
    code.writeln("    );");
    code.writeln("  }");
    code.writeln("}");
    code.writeln("");

    return code.toString();
  }

  static String _generateWidgetCode(WidgetData widget) {
    switch (widget.type) {
      case 'text':
        final text = widget.properties['text'] ?? 'Text';
        final fontSize = widget.properties['fontSize'] ?? 16.0;
        final color = widget.properties['color'] ?? '#000000';
        return "Text('$text', style: TextStyle(fontSize: $fontSize, color: Color(0xFF${color.replaceAll('#', '')})),)";
      case 'button':
        final text = widget.properties['text'] ?? 'Button';
        return "ElevatedButton(onPressed: () {}, child: Text('$text'),)";
      case 'edittext':
        return "TextField(decoration: InputDecoration(border: OutlineInputBorder(),),)";
      case 'image':
        final src = widget.properties['src'] ?? '';
        return "Image.network('$src', width: 100, height: 100,)";
      default:
        return "Container(child: Text('${widget.type}'),)";
    }
  }

  static String _generateWidgetWithWidgets(
      DartFileBean file, SketchIDEProject project, List<WidgetData> widgets) {
    final className = file.className;
    final StringBuffer code = StringBuffer();

    code.writeln("import 'package:flutter/material.dart';");
    code.writeln("");
    code.writeln("class $className extends StatelessWidget {");
    code.writeln("  const $className({super.key});");
    code.writeln("");
    code.writeln("  @override");
    code.writeln("  Widget build(BuildContext context) {");
    code.writeln("    return Container(");
    code.writeln("      padding: const EdgeInsets.all(16),");
    code.writeln("      child: Column(");
    code.writeln("        children: [");

    // Generate widget code for each widget
    for (final widget in widgets) {
      code.writeln("          ${_generateWidgetCode(widget)},");
    }

    code.writeln("        ],");
    code.writeln("      ),");
    code.writeln("    );");
    code.writeln("  }");
    code.writeln("}");
    code.writeln("");

    return code.toString();
  }

  // Save widgets to a specific file
  static Future<void> _saveWidgetsToFile(SketchIDEProject project,
      String fileName, List<WidgetData> widgets) async {
    try {
      final widgetsDir = Directory(
          'projects/ui'); // Temporary path since SketchIDEProject doesn't have projectPath
      if (!await widgetsDir.exists()) {
        await widgetsDir.create(recursive: true);
      }

      final widgetsFile = File(
          'projects/ui/${fileName.replaceAll('.dart', '.json')}'); // Temporary path since SketchIDEProject doesn't have projectPath
      final widgetsJson = widgets.map((widget) => widget.toJson()).toList();
      await widgetsFile.writeAsString(jsonEncode(widgetsJson));
    } catch (e) {
      print('Error saving widgets to file: $e');
    }
  }

  // Save files configuration
  static Future<void> _saveFilesConfig(
      SketchIDEProject project, List<DartFileBean> files) async {
    try {
      final configFile = File(
          'projects/$_filesConfigName'); // Temporary path since SketchIDEProject doesn't have projectPath
      final filesJson = files.map((file) => file.toJson()).toList();
      await configFile.writeAsString(jsonEncode(filesJson));
    } catch (e) {
      print('Error saving files config: $e');
    }
  }

  // Get the default file (main.dart)
  static Future<DartFileBean?> getDefaultFile(SketchIDEProject project) async {
    final files = await getAllDartFiles(project);
    try {
      return files.firstWhere((file) => file.isDefault);
    } catch (e) {
      return files.isNotEmpty ? files.first : null;
    }
  }

  // Get a specific file by name
  static Future<DartFileBean?> getFileByName(
      SketchIDEProject project, String fileName) async {
    final files = await getAllDartFiles(project);
    try {
      return files.firstWhere((file) => file.fileName == fileName);
    } catch (e) {
      return null;
    }
  }
}
