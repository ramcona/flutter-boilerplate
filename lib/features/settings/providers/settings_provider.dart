import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// SETTINGS PROVIDER
// ---------------------------------------------------------------------------
// Manages theme mode and locale persisted in SharedPreferences.
// ---------------------------------------------------------------------------

/// SharedPreferences key constants.
const String prefKeyHasCompletedOnboarding = 'has_completed_onboarding';
const String _prefKeyThemeMode = 'theme_mode';
const String _prefKeyLocale = 'locale';

/// Injected SharedPreferences — overridden in main() via ProviderScope.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main()');
});

// ---------------------------------------------------------------------------
// SETTINGS STATE
// ---------------------------------------------------------------------------

@immutable
class AppSettings {
  const AppSettings({this.themeMode = ThemeMode.system, this.locale});

  final ThemeMode themeMode;
  final Locale? locale;

  AppSettings copyWith({ThemeMode? themeMode, Locale? locale}) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}

// ---------------------------------------------------------------------------
// SETTINGS NOTIFIER
// ---------------------------------------------------------------------------

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final rawTheme = prefs.getString(_prefKeyThemeMode);
    final rawLocale = prefs.getString(_prefKeyLocale);

    final themeMode = switch (rawTheme) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    final locale = rawLocale != null ? Locale(rawLocale) : null;

    return AppSettings(themeMode: themeMode, locale: locale);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_prefKeyThemeMode, mode.name);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (locale == null) {
      await prefs.remove(_prefKeyLocale);
    } else {
      await prefs.setString(_prefKeyLocale, locale.languageCode);
    }
    state = state.copyWith(locale: locale);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);

/// Convenience provider returning the current locale (null = system default).
final localeProvider = Provider<Locale?>((ref) {
  return ref.watch(settingsProvider).locale;
});
