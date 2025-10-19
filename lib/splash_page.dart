import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    
    Future.delayed(const Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: Stack(
        fit: StackFit.expand, 
        children: [

          Center(
            child: Column( 
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                CircleAvatar(
                  radius: 180,
                  backgroundColor: Colors.transparent,
                  child: Image.asset('assets/logo.png'),
                ),
                const SizedBox(height: 20), 
                const Text( // 
                  'PAGE & PLAY', 
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo, 
                  ),
                ),
              ],
            ),
          ),

        
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(24.0), 
              child: Text(
                'Dibuat Oleh Fatecha Dena Angga R.',
                style: TextStyle(
                  color: const Color.fromARGB(255, 43, 43, 43),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}