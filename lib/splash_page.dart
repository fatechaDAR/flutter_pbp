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
    // Delay 3 detik, lalu pindah ke LoginPage
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
      // DIUBAH: Menggunakan Stack untuk menumpuk widget
      body: Stack(
        fit: StackFit.expand, // Membuat Stack memenuhi layar
        children: [
          // Widget 1: Logo di tengah layar (sama seperti sebelumnya)
          Center(
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.transparent,
              child: Image.asset('assets/logo.png'),
            ),
          ),

          // BARU: Widget 2: Teks kredit di kiri bawah
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(24.0), // Beri jarak dari tepi
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