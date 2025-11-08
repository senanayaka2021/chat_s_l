import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes.dart';
import 'controllers/theme_controller.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 🔹 REQUIRED for SharedPreferences

  final prefs = await SharedPreferences.getInstance();
  final isProfileSetup = prefs.getBool('isProfileSetup') ?? false;

  runApp(MyAppController(isProfileSetup: isProfileSetup));
}

class MyAppController extends StatefulWidget {
  final bool isProfileSetup;
  const MyAppController({super.key, required this.isProfileSetup});

  @override
  State<MyAppController> createState() => _MyAppControllerState();
}

class _MyAppControllerState extends State<MyAppController> {
  final ThemeController themeController = ThemeController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Private Messenger',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.mode,

          // 🔹 Auto-redirect based on SharedPreferences
          home:  RegistrationScreen(),
          
          // widget.isProfileSetup
          //     ? const HomeScreen()
          //     : const RegistrationScreen(),

          onGenerateRoute: AppRoutes.generateRoute,

          builder: (context, child) {
            return InheritedThemeController(
              controller: themeController,
              child: child!,
            );
          },
        );
      },
    );
  }
}
