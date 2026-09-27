# Flutter Android Boilerplate

> Offline-first · Riverpod 2 · Drift (SQLite) · Material 3 · Localization-ready · Gradle KTS

A production-ready Flutter Android project scaffold distilled from a real shipped app.
Clone it, rename a few identifiers, and start building your own features immediately.

---

## What's included

| Layer | What you get |
|---|---|
| **Entry point** | `main.dart` — SharedPrefs injection, safe notification init, ProviderScope |
| **Root widget** | `app.dart` — MaterialApp with theme, locale, and onboarding gate |
| **Theme** | Full Material 3 light + dark, brand color tokens, context-aware helpers |
| **State management** | Riverpod 2 providers wired end-to-end |
| **Database** | Drift 2 with example Table, DAO, Repository, and migration skeleton |
| **Settings** | Theme mode + locale persisted to SharedPreferences |
| **Onboarding** | Multi-page with animated page indicators |
| **Navigation** | `IndexedStack` bottom-nav shell (screens stay alive on tab switch) |
| **Notifications** | `flutter_local_notifications` + timezone, daily reminder, re-register on boot |
| **Localization** | ARB files → `flutter gen-l10n`, English + Indonesian included |
| **Gradle** | KTS scripts, Gradle 8.14, AGP 8.9.1, Kotlin 1.9.24, Java 17, desugaring |
| **Linting** | `flutter_lints` + `custom_lint` + `riverpod_lint` |
| **Testing** | `flutter_test` + `mocktail` skeleton |

---

## Quick Start

```bash
# 1. Clone
git clone https://github.com/you/flutter-android-boilerplate.git my_app
cd my_app

# 2. Rename the package (do this before pub get)
#    Replace all occurrences of "flutter_boilerplate" and "com.example.flutter_boilerplate"

# 3. Install dependencies
flutter pub get

# 4. Generate Drift code + l10n
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n

# 5. Run
flutter run
```

---

## Project Structure

```
lib/
├── main.dart                     # Bootstrap
├── app.dart                      # Root MaterialApp
├── core/
│   ├── constants/app_constants.dart
│   ├── theme/app_theme.dart      # AppColors + AppTheme
│   └── utils/                    # Pure utility functions
├── data/
│   ├── database/
│   │   ├── app_database.dart     # Drift @DriftDatabase
│   │   ├── tables/               # ExampleTable → your tables
│   │   └── daos/                 # ExampleDao → your DAOs
│   ├── repositories/             # Business logic + UUID generation
│   └── providers/database_provider.dart
├── features/
│   ├── home/                     # Starter home screen with live DB stream
│   ├── onboarding/               # 3-page onboarding flow
│   └── settings/                 # Theme + locale settings
├── l10n/
│   ├── app_en.arb                # English (template)
│   └── app_id.arb                # Indonesian
└── shared/
    ├── services/notification_service.dart
    └── widgets/main_nav_shell.dart

android/
├── app/build.gradle.kts          # Signing, applicationId, minSdk
├── build.gradle.kts              # Root Gradle
├── settings.gradle.kts           # Plugin versions
└── gradle.properties             # JVM + AndroidX flags
```

---

## Customization Checklist

- [ ] **Package name** — `android/app/build.gradle.kts` → `namespace` & `applicationId`
- [ ] **App name** — `android/app/src/main/AndroidManifest.xml` → `android:label`; `lib/app.dart` → `title`
- [ ] **Brand colors** — `lib/core/theme/app_theme.dart` → `AppColors.*` & `AppTheme.seedColor`
- [ ] **Font** — replace files in `assets/fonts/`, update `pubspec.yaml`, change `AppTheme.fontFamily`
- [ ] **Domain models** — add Drift tables in `lib/data/database/tables/`, run build_runner
- [ ] **Translations** — add keys to `lib/l10n/app_en.arb`, run `flutter gen-l10n`
- [ ] **Signing** — create `android/key.properties` (gitignored)

---

## Architecture

```
Screen (ConsumerWidget)
  └─ watches ─> StreamProvider / NotifierProvider
                  └─ reads ─> Repository  (UUID gen, business rules)
                                └─ calls ─> DAO  (SQL queries only)
                                             └─> Drift / SQLite
```

**Rules:**
- No business logic in widgets. No network calls anywhere.
- Repositories own UUID generation and validation.
- DAOs own only queries — no `Uuid()`, no providers.
- All colors via `AppColors.*`, never inline `Color(0xFF...)`.

---

## Agent Guideline

The full developer + AI agent guideline is in:

```
.agents/skills/flutter-android-boilerplate/SKILL.md
```

If you're using Antigravity or a similar AI coding assistant, register that path
as a skill so any agent that opens this project automatically reads the conventions
before making changes.

---

## Tech Versions

| Library | Version |
|---|---|
| Flutter SDK | ≥ 3.2 |
| Dart SDK | ≥ 3.2 < 4.0 |
| flutter_riverpod | 2.5.x |
| drift | 2.18.x |
| flutter_local_notifications | 17.x |
| Gradle | 8.14 |
| Android Gradle Plugin | 8.9.1 |
| Kotlin | 1.9.24 |
| Java / JVM target | 17 |

---

## License

MIT — do whatever you want. Attribution appreciated but not required.
