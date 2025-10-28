import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2BB5A3),
        title: Text(
          'Tentang Aplikasi',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Lottie.asset('assets/air.json', width: 220),
            Text(
              'ParuGuard',
              style: GoogleFonts.poppins(
                fontSize: 28,
                color: const Color(0xFF1A3C40),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'ParuGuard membantu memantau kualitas udara di sekitarmu, '
              'agar kamu bisa menjaga kesehatan paru-paru dengan lebih baik 🌿',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: const Color(0xFF1A3C40)),
            ),
            const SizedBox(height: 25),
            Text(
              'Dibuat oleh Rey 🌱',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: const Color(0xFF1C8E82),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
