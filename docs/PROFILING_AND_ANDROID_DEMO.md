# Profiling evidence & Android demo (manual steps)

## Profiling (MAD rubric — ~3 points)

1. Run the app in **profile mode** on Android (best for real performance data):
   ```bash
   flutter run --profile -d <your-android-device-id>
   ```
2. Open **DevTools** when the terminal prints the DevTools URL, or run:
   ```bash
   dart devtools
   ```
3. In DevTools, open **Performance**:
   - Tap through: Splash → Login → Home → Search → Reading screen.
   - On Reading screen, wait for the `compute()` stats loader to finish (isolate work).
4. Capture **2 screenshots**:
   - Performance timeline while scrolling the home list.
   - CPU / frame chart while opening the reading screen (isolate spike).
5. Add a short note (3–5 sentences) in your report:
   - What you measured (frame time, jank, isolate offload).
   - What you optimized (`compute()` in `reading_screen.dart`, cached images, etc.).

Optional: enable the performance overlay once in code for a demo screenshot:
```dart
// MaterialApp — debug only
showPerformanceOverlay: kDebugMode,
```

---

## Android demo (ads, notifications, Workmanager, permissions)

Windows desktop **does not** support Google Mobile Ads or Workmanager. Use a phone or emulator.

### 1. List devices
```bash
flutter devices
```

### 2. Start an emulator (if none connected)
```bash
flutter emulators
flutter emulators --launch <emulator_id>
```

### 3. Run on Android
```bash
cd Bookvista2
flutter pub get
flutter run -d android
```

### 4. What to demonstrate
| Feature | Where in app |
|--------|----------------|
| Permissions | Writer upload → pick cover image |
| Notifications | Settings → daily reminder toggle |
| Ads | Home screen banner (test ad unit) |
| Background sync | Logs in console every ~15 min (Workmanager) |
| Supabase books | Home Recent Picks / Top Hits, Library list |

### 5. Release build (optional, faster UI)
```bash
flutter build apk --debug
flutter install -d android
```
