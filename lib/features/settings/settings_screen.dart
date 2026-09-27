import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/settings_provider.dart';

// ---------------------------------------------------------------------------
// SETTINGS SCREEN
// ---------------------------------------------------------------------------
// Starter screen for app settings. Wire up your own preferences below.
// ---------------------------------------------------------------------------

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final textColor = AppColors.text(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Theme ---
          _SectionHeader(label: 'Appearance'),
          Card(
            color: AppColors.card(context),
            child: Column(
              children: ThemeMode.values.map((mode) {
                return RadioListTile<ThemeMode>(
                  title: Text(
                    switch (mode) {
                      ThemeMode.system => 'System default',
                      ThemeMode.light => 'Light',
                      ThemeMode.dark => 'Dark',
                    },
                    style: TextStyle(color: textColor),
                  ),
                  value: mode,
                  groupValue: settings.themeMode,
                  activeColor: AppColors.primary,
                  onChanged: (m) {
                    if (m != null) notifier.setThemeMode(m);
                  },
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // --- About ---
          _SectionHeader(label: 'About'),
          Card(
            color: AppColors.card(context),
            child: ListTile(
              title: Text('Version', style: TextStyle(color: textColor)),
              trailing: Text('1.0.0', style: TextStyle(color: AppColors.subtext(context))),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: AppColors.subtext(context),
        ),
      ),
    );
  }
}
