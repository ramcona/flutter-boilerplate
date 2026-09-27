import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/settings/providers/settings_provider.dart';
import 'l10n/app_localizations.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'shared/widgets/main_nav_shell.dart';

/// ---------------------------------------------------------------------------
/// ROOT APP WIDGET
/// ---------------------------------------------------------------------------
/// ConsumerWidget so it can watch Riverpod providers (settings, locale, prefs).
/// Replace `App` title, theme seed, and supported locales as needed.
/// ---------------------------------------------------------------------------

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final locale = ref.watch(localeProvider);
    final prefs = ref.watch(sharedPreferencesProvider);
    final hasCompletedOnboarding =
        prefs.getBool(prefKeyHasCompletedOnboarding) ?? false;

    return MaterialApp(
      title: 'Flutter Boilerplate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightThemeData(),
      darkTheme: AppTheme.darkThemeData(),
      themeMode: settings.themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: hasCompletedOnboarding
          ? const MainNavShell()
          : const OnboardingScreen(),
    );
  }
}
