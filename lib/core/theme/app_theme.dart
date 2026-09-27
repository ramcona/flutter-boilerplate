import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ---------------------------------------------------------------------------
// DESIGN SYSTEM COLOR TOKENS
// ---------------------------------------------------------------------------
// Replace these with your own brand colors.
// Keep semantic names so the rest of the codebase stays stable.
// ---------------------------------------------------------------------------

/// Brand / design-system colors.
class AppColors {
  // --- Brand palette ---
  static const Color ink       = Color(0xFF1E2340); // primary text
  static const Color paper     = Color(0xFFFFF8EC); // scaffold background
  static const Color primary   = Color(0xFF3FBFB2); // primary accent / CTA
  static const Color secondary = Color(0xFFFFB84D); // secondary accent
  static const Color highlight = Color(0xFFFF6F91); // highlights / badges

  // --- Semantic: status ---
  static const Color successLight          = Color(0xFF2E7D32);
  static const Color successDark           = Color(0xFF81C784);
  static const Color successContainerLight = Color(0xFFE8F5E9);
  static const Color successContainerDark  = Color(0xFF1B4D2E);

  static const Color errorLight            = Color(0xFFC62828);
  static const Color errorDark             = Color(0xFFE57373);
  static const Color errorContainerLight   = Color(0xFFFFEBEE);
  static const Color errorContainerDark    = Color(0xFF4E1616);

  static const Color warningLight          = Color(0xFFF57F17);
  static const Color warningDark           = Color(0xFFFFD54F);
  static const Color warningContainerLight = Color(0xFFFFF8E1);
  static const Color warningContainerDark  = Color(0xFF4D3800);

  static const Color infoLight             = Color(0xFF1565C0);
  static const Color infoDark              = Color(0xFF64B5F6);
  static const Color infoContainerLight    = Color(0xFFE3F2FD);
  static const Color infoContainerDark     = Color(0xFF0D3B66);

  // --- Context-aware helpers ---

  static Color text(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? Colors.white.withValues(alpha: 0.95)
      : ink;

  static Color subtext(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? Colors.white60
      : ink.withValues(alpha: 0.6);

  static Color card(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF222638)
      : Colors.white;

  static Color background(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF141724)
      : paper;

  static Color success(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? successDark : successLight;

  static Color successContainer(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? successContainerDark : successContainerLight;

  static Color danger(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? errorDark : errorLight;

  static Color dangerContainer(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? errorContainerDark : errorContainerLight;

  static Color warning(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? warningDark : warningLight;

  static Color warningContainer(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? warningContainerDark : warningContainerLight;

  static Color info(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? infoDark : infoLight;

  static Color infoContainer(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? infoContainerDark : infoContainerLight;
}

// ---------------------------------------------------------------------------
// THEME
// ---------------------------------------------------------------------------

/// Central Material 3 theme configuration.
/// Change [seedColor] and [fontFamily] to match your design system.
class AppTheme {
  AppTheme._();

  /// Primary display font. Must match the family name in pubspec.yaml fonts.
  static const String fontFamily = 'AppFont';

  /// Fallback families for CJK / Arabic scripts.
  static const List<String> fontFamilyFallback = [
    'Noto Sans JP',
    'Noto Sans KR',
    'Noto Sans SC',
    'Noto Sans Arabic',
  ];

  /// Material 3 seed color — drives the entire color scheme.
  static const Color seedColor = AppColors.primary;

  static const SystemUiOverlayStyle lightSystemUiOverlayStyle =
      SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static const SystemUiOverlayStyle darkSystemUiOverlayStyle =
      SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  static ThemeData lightThemeData() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.paper,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: lightSystemUiOverlayStyle,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData darkThemeData() {
    const darkBackground = Color(0xFF141724);
    const darkCard = Color(0xFF222638);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
      surface: darkCard,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: darkSystemUiOverlayStyle,
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
