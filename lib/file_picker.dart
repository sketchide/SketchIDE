import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ProjectDialog extends StatefulWidget {
  const ProjectDialog({super.key});

  @override
  _ProjectDialogState createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<ProjectDialog> {
  final TextEditingController _appNameController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _packageNameController = TextEditingController();
  PlatformFile? _appLogoFile; // Use PlatformFile to store the selected file

  Future<void> _pickAppLogo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _appLogoFile = result.files.single;
      });
    } else {
      // User canceled the picker
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("No App Logo Selected"),
            content: const Text("Please select an app logo."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
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
              decoration: const InputDecoration(labelText: "Enter App Name"),
            ),
            TextField(
              controller: _projectNameController,
              decoration:
                  const InputDecoration(labelText: "Enter Project Name"),
            ),
            TextField(
              controller: _packageNameController,
              decoration:
                  const InputDecoration(labelText: "Enter App Package Name"),
            ),
            TextButton(
              onPressed: _pickAppLogo,
              child: const Text("Choose App Logo"),
            ),
            if (_appLogoFile != null) ...[
              const SizedBox(height: 10),
              // Display the selected image using Image.file or Image.memory
              // depending on whether you want to display from a file or memory
              // Example using Image.memory (assuming you have the bytes of the image):
              Image.memory(_appLogoFile!.bytes!),
              // Example using Image.file (if you have the file path):
              // Image.file(File(_appLogoFile!.path!)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Handle project creation logic here using the controllers and _appLogoFile
            // You can access the selected file path using _appLogoFile!.path
            Navigator.of(context).pop();
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
