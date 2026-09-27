import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/providers/database_provider.dart';

// ---------------------------------------------------------------------------
// HOME SCREEN
// ---------------------------------------------------------------------------
// Replace with your real home screen. This is a starter with a live Drift
// stream, empty state, and a floating action button.
// ---------------------------------------------------------------------------

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(_itemsStreamProvider);
    final textColor = AppColors.text(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () async {
          final repo = ref.read(exampleRepositoryProvider);
          await repo.add('New Item ${DateTime.now().second}');
        },
        child: const Icon(Icons.add),
      ),
      body: itemsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('📭', style: TextStyle(fontSize: 56)),
                  const SizedBox(height: 16),
                  Text(
                    'Nothing here yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add your first item',
                    style: TextStyle(color: AppColors.subtext(context)),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                color: AppColors.card(context),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    item.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  subtitle: item.description != null
                      ? Text(item.description!, style: TextStyle(color: AppColors.subtext(context)))
                      : null,
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: AppColors.danger(context)),
                    onPressed: () async {
                      final repo = ref.read(exampleRepositoryProvider);
                      await repo.delete(item.id);
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text('Error: $err', style: TextStyle(color: AppColors.danger(context))),
        ),
      ),
    );
  }
}

// Internal stream provider — keeps the provider scoped to this file.
final _itemsStreamProvider = StreamProvider((ref) {
  return ref.watch(exampleRepositoryProvider).watchAll();
});
