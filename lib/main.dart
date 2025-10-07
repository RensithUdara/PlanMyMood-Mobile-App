import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/app_controller.dart';
import 'controllers/mood_controller.dart';
import 'controllers/task_controller.dart';
import 'utils/app_constants.dart';
import 'utils/app_theme.dart';
import 'views/screens/splash_screen.dart';

void main() {
  runApp(const PlanMyMoodApp());
}

class PlanMyMoodApp extends StatelessWidget {
  const PlanMyMoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppController()),
        ChangeNotifierProvider(create: (_) => MoodController()),
        ChangeNotifierProvider(create: (_) => TaskController()),
      ],
      child: Consumer<AppController>(
        builder: (context, appController, child) {
          return MaterialApp(
            title: AppConstants.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode:
                appController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}


