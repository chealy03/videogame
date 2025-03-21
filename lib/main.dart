import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:videogame/login.dart';
import 'package:videogame/second_page.dart';
import 'package:videogame/signup.dart';
import 'package:videogame/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Game',
      initialRoute: '/signup',
      routes: {
        '/signup': (context) => const SignUpPage(),
        '/login': (context) => const LoginPage(),
        '/welcome': (context) => const WelcomePage(),
        '/game': (context) => const Secondpage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
