import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'features/home/home_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Journey2EuropeApp());
}

class Journey2EuropeApp extends StatelessWidget {
  const Journey2EuropeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journey2Europe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
