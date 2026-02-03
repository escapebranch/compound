import 'package:flutter/material.dart';

/// Global theme notifier for the application.
/// Allows switching between light, dark, and system theme modes.
final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.dark);
