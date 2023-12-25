import 'package:essential_app/auth/auth.dart';
import 'package:essential_app/auth/login_or_register.dart';
import 'package:essential_app/firebase_options.dart';
import 'package:essential_app/pages/home_page.dart';
import 'package:essential_app/pages/profile_page.dart';
import 'package:essential_app/pages/users_page.dart';
import 'package:essential_app/theme/dark_mode.dart';
import 'package:essential_app/theme/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/auth': (context) => const AuthPage(),
        '/login_register_page': (context) => const LoginOrRegister(),
        '/home_page': (context) => HomePage(),
        '/profile_page': (context) => ProfilePage(),
        '/users_page': (context) => const UsersPage(),
      },
    );
  }
}
