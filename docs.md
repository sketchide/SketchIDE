# 📚 SketchIDE Technical Documentation

This document explains the **frameworks**, **features**, **storage structure**, and **default behavior** of projects created with **SketchIDE**.

---

## **1. Frameworks Used**

### **Frontend**
- **Flutter (Dart)** → Cross-platform mobile app development (Android & iOS)
- **Material Design Components** → UI consistency
- **Scoped Storage (SAF)** → Google Play compliant file handling

### **Backend (Local Data Handling)**
- **Hive DB** →  
  - Used for **project metadata** & **quick access cache**  
  - No native dependencies → fast & lightweight
- **SQLite** →  
  - Used for **structured project configurations**, version control of UI/logic
  - Ideal for storing complex relational data

### **Build System**
- **Gradle (Android)**
- **Xcode (iOS)**
- **Dart/Flutter Build Pipeline** → Compiles to APK, AAB, IPA

---

## **2. Features Implemented**

### **Core Features**
1. **Project Creation**
   - App name, package name, icon, default Dart structure
2. **UI/Logic Visual Editor**
   - Layout builder (JSON-based)
   - Block programming for app logic
3. **Project Management**
   - Edit project settings
   - Delete project
   - Export project (source) / Export & Sign (build)
4. **Search & Filter**
   - Quick project lookup
5. **UI**
   - Drawer navigation
   - Floating action button for creating projects
   - Project list with icons and metadata

### **Storage Compliance**
- Uses **Scoped Storage** → All files saved inside the app sandbox  
- SAF for **import/export** operations

---

## **3. Project Storage Structure**

All projects are stored in the following sandbox path:
/Android/data/com.sketchide.app/files/projects/<projectId>/

### **Folder Tree**
```plaintext
<projectId>/
├── meta.json                 # Project metadata
├── icon.png                  # User-selected or default app icon
│
├── lib/                      # Dart source files
│   ├── main.dart
│   └── home_page.dart
│
├── ui/                       # Layout structure
│   └── main.json
│
├── logic/                    # Event flow & block programming
│   └── main_logic.json
│
├── assets/                   # User assets
│   ├── default_banner.png
│   └── example.png
│
├── android/                  # Android-specific resources
│   ├── app/src/main/
│   │   ├── AndroidManifest.xml
│   │   ├── java/
│   │   ├── res/mipmap-*/ic_launcher.png
│   │   └── values/strings.xml
│   └── build.gradle
│
├── ios/                      # iOS-specific resources
│   ├── Runner.xcodeproj/
│   ├── Runner/
│   │   ├── AppDelegate.swift
│   │   ├── Info.plist
│   │   └── Assets.xcassets/AppIcon.appiconset/
│   └── Podfile
│
├── pubspec.yaml              # Flutter dependencies & metadata
│
└── build/                    # Compiled output
    ├── android/app-release.apk
    ├── android/app-release.aab
    └── ios/app-release.ipa
{
  "appName": "MyApp",
  "packageName": "com.example.myapp",
  "version": "1.0.0",
  "description": "Default app created using SketchIDE",
  "created": "2025-07-25T10:30:00Z"
}


import 'package:flutter/material.dart';
import 'home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}


import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Welcome to MyApp')),
    );
  }
}

 Project CRUD (Change & Delete)
Change Project Settings → Updates meta.json, optionally regenerates project files.

Delete Project → Removes the entire folder from /projects/<projectId>/.

Both operations use Hive + SQLite to maintain app cache and sync.

6. Why Hive + SQLite?
Hive → Simple key-value for fast project list, settings, user preferences.

SQLite → Complex relational structure for UI nodes & logic blocks.

7. Compliance
Scoped Storage → All files inside app sandbox.

SAF → Used for export/import to external storage.

Play Store Policy Safe → No unrestricted file access.

