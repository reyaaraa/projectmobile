// lib/widgets/info_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// InfoCard: menampilkan angka AQI besar, status, dan warna sesuai level
class InfoCard extends StatelessWidget {
  final int aqi;
  final String status;
  final Color color;
  const InfoCard({
    super.key,
    required this.aqi,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Kualitas Udara (AQI)',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$aqi',
              style: GoogleFonts.poppins(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              status,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(),
            ),
          ],
        ),
      ),
    );
  }
}
