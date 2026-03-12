```markdown
# Aktivio Mobile Application (Flutter)

## Overview
The Aktivio mobile application is developed using **Flutter** and is designed to work alongside the Aktivio web platform. The mobile app connects to the same backend server used by the website and allows users to access health monitoring and activity management features directly from their smartphones.

The application communicates with the Flask backend through API requests. Both the mobile app and the web platform share the same database and backend services, ensuring that all user data, events, and health information remain synchronized across platforms.

---

## Main Features

- User registration and login
- Profile management
- Add and manage activity events
- Calendar-based event scheduling
- BMI health test
- PHQ mental health test
- Health articles
- Workout recommendations
- Body information pages
- Event and health history tracking

---

## Technology Stack

### Mobile Framework
- Flutter

### Programming Language
- Dart

### Backend Communication
- REST API (Flask backend)

### Database
- MySQL (shared with the web platform)

---

## Requirements

Before running the mobile application, make sure the following tools are installed:

- Flutter SDK
- Android Studio (for Android SDK and emulator)
- Visual Studio Code
- Android Emulator or a physical Android device

---

## Install Flutter

Download Flutter SDK from:

```

[https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)

```

Extract the Flutter SDK and add it to your system PATH.

Verify installation by running:

```

flutter doctor

```

This command checks whether Flutter and its dependencies are correctly installed.

---

## Install Android Studio

1. Download Android Studio from:

```

[https://developer.android.com/studio](https://developer.android.com/studio)

```

2. Install Android Studio.

3. During installation make sure to install:

- Android SDK
- Android SDK Platform Tools
- Android Virtual Device (AVD)

4. Open Android Studio and create an **Android Virtual Device (AVD)**.

---

## Install Visual Studio Code

Download Visual Studio Code from:

```

[https://code.visualstudio.com](https://code.visualstudio.com)

```

Install the following extensions:

- Flutter
- Dart

These extensions allow VS Code to run and debug Flutter applications.

---

## Project Setup

### Step 1: Open the project folder

Open the Flutter project folder in Visual Studio Code.

Example project structure:

```

Aktivio_Flutter/
│
├── lib/
├── android/
├── ios/
├── assets/
├── pubspec.yaml
│
└── README.md

```

---

### Step 2: Install project dependencies

Run the following command inside the project folder:

```

flutter pub get

```

This command installs all required packages defined in **pubspec.yaml**.

---

### Step 3: Start Android Emulator

You can start the emulator from Android Studio:

```

Tools → Device Manager → Start Emulator

```

Or run:

```

flutter emulators --launch <emulator_id>

```

---

## Running the Application

### Run from Terminal

Navigate to the project folder:

```

cd path/to/Aktivio_Flutter

```

Run the application:

```

flutter run

```

Flutter will build the application and launch it on the connected emulator or device.

---

### Run from Visual Studio Code

1. Open the project in VS Code.
2. Select a device or emulator from the device list.
3. Press **Run** or press:

```

F5

```

VS Code will build and run the application.

---

## Backend Connection

The mobile application communicates with the Flask backend server using HTTP requests. The backend processes requests and returns data in JSON format.

Make sure the backend server is running before using the mobile application.

Example backend address:

```

[http://127.0.0.1:5000](http://127.0.0.1:5000)

```

If running on a physical device or emulator, replace localhost with the appropriate IP address of the server machine.

---

## Install Application Packages

If new packages are added to the project, install them using:

```

flutter pub get

```

To update packages:

```

flutter pub upgrade

```

---

## Build Application

To build the application for release:

```

flutter build apk

```

The generated APK file will be located in:

```

build/app/outputs/flutter-apk/

```

---

## System Architecture

The mobile application communicates with the same backend used by the web platform.

```

Mobile Application (Flutter)
│
│ HTTP Requests
▼
Flask Backend Server
│
│ SQL Queries
▼
MySQL Database

```

This architecture ensures that both the mobile application and the web platform share the same data and services.
```
