import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'features/home/home_screen.dart';
import 'core/notification_service.dart';
import 'core/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const Journey2EuropeApp());
}

class Journey2EuropeApp extends StatelessWidget {
  const Journey2EuropeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, theme, _) {
          return MaterialApp(
            title: 'Journey2Europe',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: theme.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
