# CivicPulse Flutter App

A pixel-faithful Flutter Android app for the CivicPulse civic complaint platform.

## Screens

| Screen | Description |
|--------|-------------|
| Splash | Auto-login check, animated logo |
| Login / Register | Tabbed auth with blue hero panel (matches HTML design) |
| Home | Hero section, recent reports, categories grid, how-it-works |
| Submit | Category picker, complaint text, location, AI notice |
| Track | CP-XXXXXXXX search + status timeline |
| Profile | Points, badges, my complaints, logout |

## Setup

### 1. Prerequisites
- Flutter SDK 3.x
- Android Studio / VS Code
- Your backend running (Node.js + MongoDB)

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Configure backend URL
Open `lib/services/api_service.dart` and update:
```dart
static const String baseUrl = 'http://10.0.2.2:5000/api';
//  ↑ 10.0.2.2 = localhost from Android emulator
//  Use your machine's LAN IP (e.g. 192.168.1.x) for a real device
```

### 4. Run
```bash
flutter run
```

## Color Reference (matches your HTML)

| Variable | Value |
|----------|-------|
| `--blue` | `#2C5AA0` |
| `--blue-dark` | `#1e3f72` |
| `--teal` | `#00A8A8` |
| `--bg` | `#F5F7FA` |
| `--text` | `#222222` |

## Project Structure

```
lib/
├── main.dart               # Entry point
├── theme.dart              # Colors + ThemeData
├── models/
│   └── models.dart         # User, Complaint
├── services/
│   └── api_service.dart    # All API calls
├── widgets/
│   └── widgets.dart        # Shared UI components
└── screens/
    ├── splash_screen.dart
    ├── login_screen.dart
    ├── home_screen.dart
    ├── submit_screen.dart
    ├── track_screen.dart
    └── profile_screen.dart
```

## Notes
- The app uses `usesCleartextTraffic="true"` in AndroidManifest for localhost HTTP.
  Remove this for production HTTPS.
- Backend IP `10.0.2.2` works for Android emulator → your PC's localhost.
  For physical device on same WiFi, use your PC's local IP.
