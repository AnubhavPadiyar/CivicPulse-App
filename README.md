# CivicPulse — Flutter Android App

> Civic complaint management, in your pocket. Pixel-faithful port of the CivicPulse web platform.

---

## Screens

### Splash
- Animated logo on launch
- Checks saved auth token → auto-navigates to Home or Login

### Login / Register
- Tabbed layout (no screen change between Login and Register)
- Blue hero panel matches the web design
- Inline field validation with error states

### Home
- Hero banner with username and submit CTA
- Horizontal scroll list of recent complaints
- Category grid (Roads, Water, Electricity, Sanitation…)
- 3-step "How It Works" explainer

### Submit Complaint
- Category chip picker → description field → GPS or manual location
- Optional photo attachment
- AI processing notice before submit
- Confirmation dialog shows assigned `CP-XXXXXXXX` ID

### Track Complaint
- Search by `CP-XXXXXXXX`
- 4-stage visual timeline: `Submitted` → `Under Review` → `In Progress` → `Resolved`
- Shows assigned department, last updated, and admin remarks

### Profile
- Points, badges, and filterable complaints list (All / Open / Resolved)
- Tap complaint → opens Track screen pre-filled
- Logout at the bottom

---

## Project Structure

```
civicpulse_app/
├── android/
│   └── app/src/main/
│       └── AndroidManifest.xml         # Cleartext traffic, permissions
├── lib/
│   ├── main.dart                       # Entry point, MaterialApp, route table
│   ├── theme.dart                      # Colors, text styles, ThemeData
│   │
│   ├── models/
│   │   └── models.dart                 # User, Complaint, Badge, Category
│   │
│   ├── services/
│   │   ├── api_service.dart            # All HTTP calls (auth, complaints, track)
│   │   └── storage_service.dart        # SharedPreferences (token, user cache)
│   │
│   ├── widgets/
│   │   ├── widgets.dart                # Barrel export
│   │   ├── category_chip.dart          # Category pill used in Submit
│   │   ├── complaint_card.dart         # Card used in Home + Profile
│   │   ├── status_timeline.dart        # 4-stage progress indicator
│   │   └── badge_tile.dart             # Badge display in Profile
│   │
│   └── screens/
│       ├── splash_screen.dart
│       ├── login_screen.dart
│       ├── home_screen.dart
│       ├── submit_screen.dart
│       ├── track_screen.dart
│       └── profile_screen.dart
│
├── assets/
│   ├── images/
│   │   └── logo.png
│   └── icons/                          # Category icons (SVG or PNG)
│
└── pubspec.yaml
```

---


## Roadmap

| Feature | Priority |
|---------|----------|
|  Push notifications — status update alerts via FCM | High |
|  Map view — plot complaints on a live map | High |
|  Fix Gemini AI routing — reliable department assignment + confidence score | High |
|  Admin dashboard screen (department-side view) | Medium |
|  Offline mode — queue complaints when no internet | Medium |
|  Multi-language support (Hindi + regional) | Low |
|  iOS build | Low |

