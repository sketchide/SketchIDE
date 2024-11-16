import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/dracula.dart'; // Dark theme

class SourceCodeScreen extends StatelessWidget {
  const SourceCodeScreen({super.key});

  // Dummy JSON data to simulate reading from a JSON file
  final String jsonCodeData = '''
  {
    "sourceCode": "import 'package:flutter/material.dart';\\n\\nvoid main() {\\n  runApp(const MyApp());\\n}\\n\\nclass MyApp extends StatelessWidget {\\n  const MyApp({super.key});\\n\\n  @override\\n  Widget build(BuildContext context) {\\n    return MaterialApp(\\n      title: 'Hello World App',\\n      theme: ThemeData(\\n        primarySwatch: Colors.blue,\\n      ),\\n      home: const HelloWorldScreen(),\\n    );\\n  }\\n}\\n\\nclass HelloWorldScreen extends StatelessWidget {\\n  const HelloWorldScreen({super.key});\\n\\n  @override\\n  Widget build(BuildContext context) {\\n    return Scaffold(\\n      appBar: AppBar(\\n        title: const Text('Hello World'),\\n      ),\\n      body: const Center(\\n        child: Text(\\n          'Hello, World!',\\n          style: TextStyle(fontSize: 24),\\n        ),\\n      ),\\n    );\\n  }\\n}"
  }
  '''; // Simulate reading from JSON

  @override
  Widget build(BuildContext context) {
    // Parse the JSON data to retrieve the source code
    Map<String, dynamic> codeData = jsonDecode(jsonCodeData);
    String sourceCode = codeData["sourceCode"];

    // Split the code by lines to add line numbers
    List<String> lines = sourceCode.split('\n');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Source Code'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side: Line numbers
                      Container(
                        width: 50, // Fixed width for line numbers
                        color: Colors.grey[900],
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: lines.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Text(
                                (index + 1).toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Courier',
                                ),
                                textAlign: TextAlign.right,
                              ),
                            );
                          },
                        ),
                      ),
                      // Right side: Code lines with syntax highlighting
                      Expanded(
                        child: Container(
                          color: Colors.black12,
                          child: HighlightView(
                            sourceCode, // The raw code from JSON
                            language: 'dart', // Language for syntax highlighting
                            theme: draculaTheme, // Dark theme for syntax highlighting
                            padding: const EdgeInsets.all(12.0),
                            textStyle: const TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
