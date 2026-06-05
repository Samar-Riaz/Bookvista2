# BookVista

BookVista is a Flutter reading and publishing app built for the **Mobile Application Development (MAD)** course. It combines a glassmorphic dark UI, Supabase authentication and database, Firebase Analytics, Open Library REST search, local notifications, secure storage, background isolates, and Google Mobile Ads (on Android/iOS).

---

## Project overview

| Item | Detail |
|------|--------|
| **Framework** | Flutter 3.x (Dart `>=3.0.0 <4.0.0`) |
| **State management** | Riverpod |
| **Navigation** | `go_router` |
| **Primary backend** | Supabase (Auth + PostgreSQL `books` table) |
| **Secondary backend** | Firebase Core + Analytics |
| **External API** | Open Library Search API |
| **Platforms** | Android, iOS, Windows, Web (full MAD demo on **Android**) |

---

## MAD rubrics — achievement summary

Total rubric weight: **36 points** across 12 areas.

| # | Rubric | Max | Status | Score estimate | Primary evidence |
|---|--------|:---:|:------:|:--------------:|------------------|
| 1 | Flutter Installation | 1 | **Achieved** | 1 / 1 | Multi-platform project builds; `flutter doctor` clean |
| 2 | Complete App GUI | 5 | **Achieved** | 4–5 / 5 | 15 routed screens, bottom nav, animations, responsive layout |
| 3 | Firebase / Supabase Auth & DB | 4 | **Mostly achieved** | 3–4 / 4 | Login, signup, sign-out, session splash; live `books` queries |
| 4 | Security (Encryption & Decryption) | 2 | **Mostly achieved** | 1.5–2 / 2 | `flutter_secure_storage`; isolate cipher demo in reading screen |
| 5 | App Architecture & Organization | 4 | **Achieved** | 3.5–4 / 4 | Feature-first `lib/core` + `lib/features`, Riverpod providers |
| 6 | External REST API (non-Firebase) | 3 | **Achieved** | 2.5–3 / 3 | Open Library HTTP client in search screen |
| 7 | Profiling | 3 | **Partial** (manual) | 2–3 / 3 | DevTools Performance tab — see [docs/PROFILING_AND_ANDROID_DEMO.md](docs/PROFILING_AND_ANDROID_DEMO.md) |
| 8 | Logging & Debugging | 2 | **Achieved** | 2 / 2 | `LoggingService` + styled `logger` output |
| 9 | Notifications & Event Handling | 3 | **Achieved** (mobile) | 2.5–3 / 3 | Daily 8 PM reminders; settings toggles |
| 10 | Background Tasks, Services & Threading | 3 | **Mostly achieved** | 2.5–3 / 3 | `compute()` isolate + Workmanager periodic task (Android/iOS) |
| 11 | Permissions | 2 | **Achieved** (mobile) | 2 / 2 | Gallery permission + image picker on writer upload |
| 12 | Advertisement / Monetization | 3 | **Achieved** (mobile) | 2.5–3 / 3 | Google Mobile Ads test banner on home screen |

**Estimated total: ~30–34 / 36** depending on viva/demo depth (especially profiling screenshots and Android live demo).

### Rubric notes (honest gaps)

- **OTP and forgot-password flows were removed** — auth is login + signup only.
- **Hero carousel** on home is still a static featured card; **Recent Picks**, **Top Hits**, and **Library** load from Supabase.
- **Workmanager sync** logs a mock sync (not a full Supabase write-back yet).
- **Ads, Workmanager, notification permissions** require **Android or iOS** — skipped on Windows desktop by design (`platform_utils.dart`).
- **Profiling** needs you to capture DevTools screenshots yourself (steps in docs).

---

## Feature map by rubric

### 1. Flutter Installation (1 pt)
- Flutter SDK configured; project supports Android, iOS, Windows, Web, Linux, macOS folders.
- Run: `flutter pub get` → `flutter run -d windows` or `flutter run -d android`.

### 2. Complete App GUI (5 pts)
**15 screens** via `lib/core/navigation/app_router.dart`:

| Route | Screen |
|-------|--------|
| `/` | Splash |
| `/onboarding` | Onboarding |
| `/login` | Login |
| `/signup` | Sign up |
| `/home` | Main shell (bottom nav: Home, Search, Library, Activity, Profile) |
| `/search` | Search (also tab) |
| `/library` | Library (also tab) |
| `/activity` | Activity (also tab) |
| `/profile` | Profile (also tab) |
| `/book-detail` | Book detail |
| `/reading` | Reading + typography controls |
| `/bookmarks` | Bookmarks |
| `/settings` | Settings |
| `/writer-upload` | Writer upload |
| `/author-profile` | Author profile |

UI stack: `GoogleFonts`, `flutter_animate`, `BackdropFilter` glassmorphism, `AppColors` HSL palette, light/dark `AppTheme`.

### 3. Firebase / Supabase Auth & DB (4 pts)
- **Supabase** (`lib/core/services/supabase_service.dart`): `signUp`, `signIn`, `signOut`, `fetchBooks`, `fetchRecommendedBooks`, `searchBooks`.
- **Providers** (`lib/core/providers/service_providers.dart`): `booksProvider`, `recommendedBooksProvider`.
- **Live data**: Home Recent Picks / Top Hits; Library list; Search local panel.
- **Session**: Splash checks `Supabase.instance.client.auth.currentSession` → `/home` or `/onboarding`.
- **Firebase**: Core init in `main.dart`; Analytics observer on mobile routes; `gift_a_coffee_clicked` event in settings.
- **Secrets**: `.env` via `flutter_dotenv` (not hardcoded in source).

**Supabase `books` table expected columns:** `title`, `author`, `cover_url` (optional: `progress`, `rating`, `genre`, `reviews_count`).

### 4. Security — Encryption & Decryption (2 pts)
- **Secure storage** (`lib/core/services/secure_storage_service.dart`): Android EncryptedSharedPreferences, iOS Keychain — stores settings like reminders and typography scale.
- **Decryption demo** (`lib/features/books/screens/reading_screen.dart`): Caesar-shift encode/decode inside a `compute()` isolate to show off-main-thread crypto-style processing.

### 5. App Architecture & Code Organization (4 pts)

```text
lib/
├── core/
│   ├── navigation/     app_router.dart
│   ├── providers/      service_providers.dart
│   ├── services/       supabase, firebase, ads, notifications, permissions, etc.
│   ├── theme/          app_theme.dart, app_colors.dart
│   └── utils/          platform_utils.dart, book_mapper.dart
└── features/
    ├── auth/           splash, onboarding, login, signup
    ├── author/         writer upload, author profile
    ├── books/          detail, reading, bookmarks
    ├── home/           home, search, library, activity, profile, main nav
    └── settings/       settings screen
```

### 6. External REST API (3 pts)
- `lib/core/services/open_library_service.dart` → `GET https://openlibrary.org/search.json?q=...`
- `lib/features/home/screens/search_screen.dart` shows **Local Collection (Supabase)** and **Global Catalog (Open Library)** side by side.

### 7. Profiling (3 pts)
- App is profileable with **Flutter DevTools → Performance**.
- Heavy work offloaded with `compute()` on reading screen.
- **Action required:** record timeline + 2 screenshots — see [docs/PROFILING_AND_ANDROID_DEMO.md](docs/PROFILING_AND_ANDROID_DEMO.md).

### 8. Logging & Debugging (2 pts)
- `lib/core/services/logging_service.dart` wraps the `logger` package with emoji/timestamp console output across auth, network, ads, notifications, and background tasks.

### 9. Notifications & Event Handling (3 pts)
- `lib/core/services/notification_service.dart`: channels, permission requests, daily 8:00 PM `zonedSchedule` reminder.
- `lib/features/settings/screens/settings_screen.dart`: toggle schedules/cancels reminder.

### 10. Background Tasks, Services & Threading (3 pts)
- **Isolate:** `compute(parseBookTextStats, ...)` in `reading_screen.dart`.
- **Background service:** `workmanager` in `background_sync_service.dart` — periodic 15-minute task (Android/iOS; mock sync body).

### 11. Permissions (2 pts)
- `lib/core/services/permission_service.dart`: `permission_handler` for photos/storage.
- `lib/features/author/screens/writer_upload_screen.dart`: requests permission → `image_picker` → preview cover.

### 12. Advertisement / Monetization (3 pts)
- `lib/core/services/ad_service.dart`: Google Mobile Ads SDK init (mobile only).
- `lib/features/home/screens/home_screen.dart`: `BookVistaBannerAd` test banner.

---

## Tech stack

| Category | Packages |
|----------|----------|
| Backend | `supabase_flutter`, `firebase_core`, `firebase_analytics` |
| State | `flutter_riverpod`, `riverpod` |
| Navigation | `go_router` |
| Network | `http` (Open Library) |
| Storage | `flutter_secure_storage`, `shared_preferences` |
| UI | `google_fonts`, `flutter_animate`, `cached_network_image`, `lottie` |
| Device | `permission_handler`, `image_picker`, `flutter_local_notifications`, `workmanager`, `google_mobile_ads` |
| Config | `flutter_dotenv` |
| Dev | `logger`, `flutter_test`, `build_runner` |

---

## Getting started

### Prerequisites
- Flutter SDK `>=3.0.0`
- Android Studio or VS Code + Flutter/Dart extensions
- For full rubric demo: **Android emulator or physical device**
- Supabase project with `books` table and Auth enabled

### Environment setup

```bash
cd Bookvista2
copy .env.example .env    # Windows — use cp on macOS/Linux
```

Edit `.env`:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

### Install and run

```bash
flutter pub get
flutter test
flutter run -d android    # recommended for full MAD demo
flutter run -d windows    # UI preview (no ads/workmanager)
```

### VS Code launch configs
- **BookVista (Windows)** — `deviceId: windows`
- **BookVista (Chrome)** — `deviceId: chrome`

Defined in `.vscode/launch.json`.

---

## Supabase setup (minimal)

```sql
create table if not exists books (
  id bigint generated always as identity primary key,
  title text not null,
  author text,
  cover_url text,
  progress float default 0.5,
  rating float default 4.5,
  genre text
);

alter table books enable row level security;
create policy "Allow public read" on books for select using (true);
```

Insert sample rows, then open Home and Library in the app.

---

## Platform behaviour

| Feature | Android / iOS | Windows / Web |
|---------|:-------------:|:-------------:|
| Supabase auth & books | Yes | Yes |
| Firebase Analytics | Yes | Limited / skipped |
| Google Mobile Ads | Yes | Skipped |
| Workmanager | Yes | Skipped |
| Local notifications | Yes | Limited |
| Gallery permissions | Yes | Limited |

Controlled by `lib/core/utils/platform_utils.dart` (`isMobilePlatform`).

---

## Project documents

| File | Purpose |
|------|---------|
| [REPORT.md](REPORT.md) | Full project flow, architecture, and teammate onboarding |
| [docs/PROFILING_AND_ANDROID_DEMO.md](docs/PROFILING_AND_ANDROID_DEMO.md) | DevTools profiling + Android demo steps |
| [.env.example](.env.example) | Environment variable template |

---

## Team

Semester 6 — Mobile Application Development (MAD)  
BookVista — Final semester project
