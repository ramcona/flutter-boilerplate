import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'features/settings/providers/settings_provider.dart';
import 'shared/services/notification_service.dart';

/// ---------------------------------------------------------------------------
/// ENTRY POINT
/// ---------------------------------------------------------------------------
/// Bootstrap order:
///   1. Ensure Flutter bindings are initialized.
///   2. Load SharedPreferences (injected via ProviderScope overrides).
///   3. Initialize local notifications (fail-safe).
///   4. Wrap root widget with ProviderScope.
/// ---------------------------------------------------------------------------

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  try {
    await NotificationService.initialize();
  } catch (_) {
    // Notification init failures should never crash the app.
  }

  runApp(
    ProviderScope(
      overrides: [
        // Inject the pre-initialized SharedPreferences instance.
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const App(),
    ),
  );
}
