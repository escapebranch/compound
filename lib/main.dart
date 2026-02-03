import 'package:compound/core/data/app_database.dart';
import 'package:compound/core/theme/theme.dart';
import 'package:compound/core/theme/theme_notifier.dart';
import 'package:compound/features/calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Global database instance
late final AppDatabase database;

/// Install year (cached for quick access)
late final int installYear;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database and get install year
  database = AppDatabase();
  installYear = await database.getInstallYear();

  // Set system UI overlay style for immersive experience
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Enable edge-to-edge mode on Android
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const CompoundApp());
}

class CompoundApp extends StatelessWidget {
  const CompoundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Compound',
          debugShowCheckedModeBanner: false,

          // Theme Configuration
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: currentMode,
          home: const HomePage(),
        );
      },
    );
  }
}
