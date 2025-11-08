import 'package:flutter/material.dart';
import '../controllers/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = InheritedThemeController.of(context);
    final mode = controller.mode;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Theme Mode",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: mode,
              onChanged: (v) => controller.setTheme(v!),
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: mode,
              onChanged: (v) => controller.setTheme(v!),
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System Default'),
              value: ThemeMode.system,
              groupValue: mode,
              onChanged: (v) => controller.setTheme(v!),
            ),
            const Spacer(),
            Center(
              child: Text(
                'Current: ${mode.name.toUpperCase()}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          ],
        ),
      ),
    );
  }
}
