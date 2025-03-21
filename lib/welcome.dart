
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome',
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Text(
              'User!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 80),
            Image.asset(
              'img/Gunter.gif',
              width: 200,
            ),
            const SizedBox(height: 120),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/game');
              },
              child: Image.asset(
                'img/start.png',
                width: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}