import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/settings_screen.dart';
// import 'screens/settings_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case '/registration':
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
