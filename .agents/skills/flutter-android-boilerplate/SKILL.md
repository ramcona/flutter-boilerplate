---
name: flutter-android-boilerplate
description: >-
  Master guideline for any agent or developer working on a Flutter Android
  project scaffolded from this boilerplate. Covers architecture, data layer,
  state management, theming, localization, notifications, Gradle, and coding
  conventions.
---

# Flutter Android Boilerplate — Developer & Agent Guideline

> **Read this first.** This file is the single source of truth for every
> engineer and AI agent working on a project derived from this boilerplate.

---

## 1. Tech Stack at a Glance

| Concern | Library / Approach |
|---|---|
| Language | Dart 3 / Flutter SDK ≥ 3.2 |
| State management | **Riverpod 2** (`flutter_riverpod`, `riverpod_annotation`) |
| Local database | **Drift 2** (typed SQLite, code-generated) |
| Notifications | `flutter_local_notifications` + `timezone` |
| Preferences | `shared_preferences` (injected via ProviderScope) |
| i18n | `flutter_localizations` + `intl` + ARB files → `flutter gen-l10n` |
| Build system | **Gradle 8.14 KTS** · Kotlin 1.9 · Java 17 · desugaring enabled |
| Linting | `flutter_lints` + `custom_lint` + `riverpod_lint` |
| Testing | `flutter_test` + `mocktail` |

---

## 2. Folder Structure

```
lib/
├── main.dart                     # Bootstrap: init prefs, notifications, runApp
├── app.dart                      # Root MaterialApp: theme, locale, home gate
│
├── core/
│   ├── constants/
│   │   └── app_constants.dart    # Magic strings, prefs keys, durations
│   ├── theme/
│   │   └── app_theme.dart        # AppColors, AppTheme (light + dark), M3
│   └── utils/                    # Pure functions: date helpers, math, etc.
│
├── data/
│   ├── database/
│   │   ├── app_database.dart     # @DriftDatabase: tables, DAOs, migrations
│   │   ├── tables/               # One file per Drift Table
│   │   └── daos/                 # One file per DriftAccessor
│   ├── repositories/             # Business logic, UUID gen, orchestration
│   └── providers/
│       └── database_provider.dart # Riverpod providers for DB + repositories
│
├── features/
│   ├── home/                     # Feature slice: screen + internal providers
│   ├── onboarding/               # Multi-page onboarding; sets prefs flag
│   └── settings/
│       ├── providers/
│       │   └── settings_provider.dart  # Theme mode + locale (SharedPrefs)
│       └── settings_screen.dart
│
├── l10n/
│   ├── app_en.arb                # English template (@@locale: en)
│   └── app_id.arb                # Example second locale
│
└── shared/
    ├── services/
    │   └── notification_service.dart  # Local notification scheduling
    └── widgets/
        └── main_nav_shell.dart        # IndexedStack bottom-nav host

android/
├── app/
│   ├── build.gradle.kts          # Signing, desugaring, applicationId, minSdk
│   └── src/
│       ├── main/AndroidManifest.xml  # Notification permissions pre-wired
│       ├── debug/AndroidManifest.xml
│       └── profile/AndroidManifest.xml
├── build.gradle.kts              # allprojects repos, build dir redirect
├── settings.gradle.kts           # Plugin versions (AGP 8.9.1, Kotlin 1.9.24)
├── gradle.properties             # JVM heap tuning, AndroidX flags
└── gradle/wrapper/
    └── gradle-wrapper.properties # Gradle 8.14
```

---

## 3. Architecture Rules

### 3.1 Layers (strictly enforce)

```
Widget / Screen
    ↓ watches
Riverpod Provider (StreamProvider / NotifierProvider)
    ↓ reads
Repository  (business logic, UUID gen, validation)
    ↓ calls
DAO  (pure SQL / Drift queries only)
    ↓
Database (AppDatabase / SQLite)
```

- **Screens** are stateless `ConsumerWidget` or `ConsumerStatefulWidget`. No business logic.
- **Providers** wire repositories to the UI. Keep them thin.
- **Repositories** own UUID generation (`uuid` package), business rules, and DAO orchestration.
- **DAOs** only contain `SELECT`, `INSERT`, `UPDATE`, `DELETE` — no UUID or business logic.
- **No network calls** in this architecture. Flag any feature that seems to need one.

### 3.2 State Management (Riverpod)

- Use `StreamProvider` for live Drift streams (auto-subscribes, rebuilds on DB change).
- Use `NotifierProvider` for complex mutable state (e.g., `SettingsNotifier`).
- Use plain `Provider<T>` for simple singletons (DB, repositories).
- Never use `ref.read` inside `build()`. Use `ref.watch` for reactive reads.
- Inject `SharedPreferences` via `ProviderScope.overrides` in `main()`.

### 3.3 Adding a New Feature / Entity

1. Create `lib/data/database/tables/your_table.dart` — extend `Table`.
2. Create `lib/data/database/daos/your_dao.dart` — annotate `@DriftAccessor`.
3. Register table + DAO in `app_database.dart`; bump `schemaVersion`; add migration.
4. Run: `flutter pub run build_runner build --delete-conflicting-outputs`
5. Create `lib/data/repositories/your_repository.dart`.
6. Add `yourRepositoryProvider` in `database_provider.dart`.
7. Create `lib/features/your_feature/` with screen + providers + widgets.
8. Add route / nav destination in `main_nav_shell.dart`.

---

## 4. Database & Migrations

### Schema versioning

```dart
@override
int get schemaVersion => 1; // Bump on every schema change
```

### Migration pattern

```dart
onUpgrade: (Migrator m, int from, int to) async {
  if (from < 2) {
    await m.addColumn(yourTable, yourTable.newColumn);
  }
  if (from < 3) {
    await m.createTable(anotherTable);
  }
},
```

> [!CAUTION]
> Never change an existing column type or rename a table without a proper migration.
> Always test migrations before shipping. Data loss is permanent on-device.

### DAO conventions

- `watchAll()` → `Stream<List<T>>` for live UI binding.
- `getById(String id)` → `Future<T?>` for one-shot reads.
- `insertItem(Companion)` / `updateItem(Companion)` / `deleteById(String)` for writes.
- Keep all queries in the DAO. No raw SQL in repositories.

---

## 5. Theme & Design System

### Colors

Defined in `lib/core/theme/app_theme.dart` → `AppColors`:

| Token | Usage |
|---|---|
| `AppColors.primary` | Primary CTA, active nav indicator, accent |
| `AppColors.secondary` | Secondary accent, badges |
| `AppColors.highlight` | Highlights, destructive actions |
| `AppColors.paper` | Scaffold background (light) |
| `AppColors.ink` | Primary text (light) |

Context-aware helpers (adapt to dark mode):
```dart
AppColors.text(context)       // primary text
AppColors.subtext(context)    // secondary / caption text
AppColors.card(context)       // card / surface background
AppColors.background(context) // scaffold background
AppColors.danger(context)     // error / destructive
AppColors.success(context)    // success / positive
```

### Updating Brand Colors

1. Open `lib/core/theme/app_theme.dart`.
2. Replace the static `Color` constants in `AppColors`.
3. Change `AppTheme.seedColor` to match your primary brand color.
4. Swap `AppTheme.fontFamily` and update `pubspec.yaml` font assets.

> [!IMPORTANT]
> Never hardcode `Color(0xFF...)` values in widget files. Always reference `AppColors.*`
> so color changes propagate globally.

---

## 6. Localization (i18n)

### Setup

- ARB files live in `lib/l10n/`.
- Run `flutter gen-l10n` (or `flutter pub get`) to regenerate `app_localizations.dart`.
- Access in widgets: `AppLocalizations.of(context).yourKey`

### Adding a new locale

1. Create `lib/l10n/app_XX.arb` (e.g., `app_fr.arb`).
2. Copy all keys from `app_en.arb` and translate values.
3. Run `flutter gen-l10n`.
4. Test with `MaterialApp(locale: Locale('fr'))`.

### RTL support

- Use `EdgeInsetsDirectional` and `AlignmentDirectional` instead of hardcoded left/right.
- Retrofit is expensive — do this from the start.

---

## 7. Notifications

All notification logic is in `lib/shared/services/notification_service.dart`.

### Boot sequence (in `main()`)

```dart
await NotificationService.initialize();
// Then on user login / app resume:
await NotificationService.reRegisterAll();
```

> [!IMPORTANT]
> Always call `reRegisterAll()` on boot. Android may clear scheduled alarms after
> device restart or OS data clear. Do not assume notifications survive.

### Permissions

Request permissions explicitly after onboarding completes:
```dart
await NotificationService.requestPermissions();
```

### AndroidManifest

Pre-wired in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
```

---

## 8. Android / Gradle Setup

### First-time setup

1. Copy `android/local.properties.example` → `android/local.properties`.
2. Set `flutter.sdk=/path/to/flutter`.

### Release signing

1. Generate a keystore: `keytool -genkey -v -keystore release.jks ...`
2. Create `android/key.properties`:
   ```
   storePassword=<password>
   keyPassword=<password>
   keyAlias=<alias>
   storeFile=../release.jks
   ```
3. `key.properties` is already in `.gitignore` — **never commit it**.

### Changing application ID

In `android/app/build.gradle.kts`:
```kotlin
namespace = "com.yourcompany.yourapp"
defaultConfig {
    applicationId = "com.yourcompany.yourapp"
}
```

Also update `android:label` in `AndroidManifest.xml`.

### Gradle versions

| Component | Version |
|---|---|
| Gradle Wrapper | 8.14 |
| Android Gradle Plugin | 8.9.1 |
| Kotlin | 1.9.24 |
| Java / JVM target | 17 |
| `desugar_jdk_libs` | 2.1.4 |

> [!TIP]
> `isCoreLibraryDesugaringEnabled = true` is required for `flutter_local_notifications`
> timezone support on Android < API 26. Do not remove it.

---

## 9. Testing

### Unit tests (`test/unit/`)

- Test repositories with an **in-memory Drift DB**:
  ```dart
  AppDatabase(NativeDatabase.memory())
  ```
- Test all pure utility functions in `lib/core/utils/`.
- Points invariants, date boundaries, and currency math must have tests.

### Widget tests (`test/widget/`)

- Use `ProviderScope` overrides to inject mock repositories.
- Pump only the widget under test, not the full app.

### Running tests

```bash
flutter test
flutter test --coverage
```

---

## 10. Coding Conventions

| Rule | Detail |
|---|---|
| File names | `snake_case.dart` |
| Class names | `PascalCase` |
| Private members | `_camelCase` |
| Providers | `camelCaseProvider` |
| Constants | `camelCase` (Dart convention) |
| Comments | Use `///` for public APIs, `//` for inline |
| No magic numbers | Extract to `AppConstants` or local `const` |
| No business logic in widgets | Move to repository or provider |
| No `print()` | Use `debugPrint()` in debug builds only |
| Imports order | dart → flutter → packages → relative |

### Before every PR

```bash
flutter analyze
flutter test
dart format .
```

---

## 11. Getting Started (New Project Checklist)

- [ ] Clone / copy this boilerplate
- [ ] Update `pubspec.yaml`: `name`, `description`, font family
- [ ] Update `android/app/build.gradle.kts`: `namespace`, `applicationId`
- [ ] Update `android/app/src/main/AndroidManifest.xml`: `android:label`
- [ ] Replace font files in `assets/fonts/` (or remove font section from pubspec)
- [ ] Replace placeholder colors in `AppColors` / `AppTheme.seedColor`
- [ ] Add your domain tables in `lib/data/database/tables/`
- [ ] Run `flutter pub get && flutter pub run build_runner build`
- [ ] Add your ARB translation keys to `lib/l10n/app_en.arb`
- [ ] Run `flutter gen-l10n`
- [ ] Run `flutter analyze && flutter test`
- [ ] Create `android/key.properties` for release builds
- [ ] Ship 🚀

---

## 12. Key Files Quick Reference

| File | Purpose |
|---|---|
| [`lib/main.dart`](../lib/main.dart) | Bootstrap entry point |
| [`lib/app.dart`](../lib/app.dart) | Root MaterialApp widget |
| [`lib/core/theme/app_theme.dart`](../lib/core/theme/app_theme.dart) | Colors + ThemeData |
| [`lib/core/constants/app_constants.dart`](../lib/core/constants/app_constants.dart) | App-wide constants |
| [`lib/data/database/app_database.dart`](../lib/data/database/app_database.dart) | Drift DB + migrations |
| [`lib/data/providers/database_provider.dart`](../lib/data/providers/database_provider.dart) | Riverpod DB + repo providers |
| [`lib/features/settings/providers/settings_provider.dart`](../lib/features/settings/providers/settings_provider.dart) | Theme + locale state |
| [`lib/shared/services/notification_service.dart`](../lib/shared/services/notification_service.dart) | Local notifications |
| [`lib/shared/widgets/main_nav_shell.dart`](../lib/shared/widgets/main_nav_shell.dart) | Bottom-nav host |
| [`android/app/build.gradle.kts`](../android/app/build.gradle.kts) | App Gradle config |
| [`android/settings.gradle.kts`](../android/settings.gradle.kts) | Gradle plugin versions |
| [`lib/l10n/app_en.arb`](../lib/l10n/app_en.arb) | English string template |
