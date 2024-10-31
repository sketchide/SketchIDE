
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ProjectDialog extends StatefulWidget {
  const ProjectDialog({super.key});

  @override
  _ProjectDialogState createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<ProjectDialog> {
  final TextEditingController _appNameController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();

  final TextEditingController _packageNameController = TextEditingController();
  File? _appLogoFile;

  Future<void> _pickAppLogo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _appLogoFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create New Project"),
      content: SingleChildScrollView( 
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _appNameController,
              decoration: const InputDecoration(labelText: 'App Name'),
            ),
            TextField(
              controller: _projectNameController,
              decoration: const InputDecoration(labelText: 'Project Name'),
            ),
            TextField(
              controller: _packageNameController,
              decoration: const InputDecoration(labelText: 'Package Name'),
            ),
            ElevatedButton(
              onPressed: _pickAppLogo,
              child: const Text('Choose App Logo'),
            ),
            if (_appLogoFile != null) ...[
              const SizedBox(height: 10),
              Image.file(_appLogoFile!),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); 
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Handle project creation logic here using the controllers and _appLogoFile
            Navigator.of(context).pop();
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
