/// ---------------------------------------------------------------------------
/// APP-WIDE CONSTANTS
/// ---------------------------------------------------------------------------
/// Keep magic strings and numeric values out of widgets. Reference from here.

class AppConstants {
  AppConstants._();

  // SharedPreferences keys
  static const String prefKeyHasCompletedOnboarding = 'has_completed_onboarding';
  static const String prefKeyThemeMode = 'theme_mode';
  static const String prefKeyLocale = 'locale';

  // Notification channel IDs
  static const String notifChannelDailyId = 'daily_reminder_channel';
  static const String notifChannelDailyName = 'Daily Reminders';

  // Pagination
  static const int pageSize = 20;

  // Animation durations
  static const Duration animShort  = Duration(milliseconds: 200);
  static const Duration animMedium = Duration(milliseconds: 350);
  static const Duration animLong   = Duration(milliseconds: 500);
}
