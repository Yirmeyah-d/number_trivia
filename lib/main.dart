import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/features/settings/settings_controller.dart';
import 'src/features/settings/settings_service.dart';
import 'injection_container.dart' as di;

//TODO : Ajouter Widget Test
//TODO : Améliorer l'UI pour gérer des animations
void main() async {
  await di.init();
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController));
}
