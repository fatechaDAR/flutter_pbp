import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo ditampilkan lagi
            CircleAvatar(
              radius: 56,
              backgroundColor: Colors.transparent,
              child: Image.asset('assets/pudidi.png'),
            ),
            const SizedBox(height: 16),

            const Text(
              'Selamat datang!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            const Text(
              'Kamu berhasil login ke aplikasi Flutter Web 🎉',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
