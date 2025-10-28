import 'dart:math';
import 'package:flutter/material.dart';

/// 🧭 CompassWidget (Versi Simulasi)
/// Kompas versi ringan tanpa plugin — tetap berfungsi secara visual
/// Menampilkan arah secara acak (berputar pelan) untuk simulasi arah.
class CompassWidget extends StatefulWidget {
  const CompassWidget({super.key});

  @override
  State<CompassWidget> createState() => _CompassWidgetState();
}

class _CompassWidgetState extends State<CompassWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Animasi memutar terus (360 derajat)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // hitung arah derajat (0–360)
        final heading = (_animation.value * (180 / pi)) % 360;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 🔵 Lingkaran luar kompas
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFEFF7F5),
                      border: Border.all(
                        color: const Color(0xFF2BB5A3),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.2),
                          blurRadius: 6,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),

                  // 🧭 Jarum kompas
                  Transform.rotate(
                    angle: _animation.value,
                    child: const Icon(
                      Icons.navigation,
                      size: 50,
                      color: Color(0xFF2BB5A3),
                    ),
                  ),

                  // Titik tengah
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Derajat & arah mata angin
            Text(
              'Heading: ${heading.toStringAsFixed(0)}°',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A3C40),
              ),
            ),
            Text(
              _getDirectionText(heading),
              style: const TextStyle(fontSize: 14, color: Color(0xFF1A3C40)),
            ),
          ],
        );
      },
    );
  }

  /// 🔍 Fungsi untuk ubah derajat ke teks arah mata angin
  String _getDirectionText(double heading) {
    if (heading >= 337.5 || heading < 22.5) return "Utara (N)";
    if (heading >= 22.5 && heading < 67.5) return "Timur Laut (NE)";
    if (heading >= 67.5 && heading < 112.5) return "Timur (E)";
    if (heading >= 112.5 && heading < 157.5) return "Tenggara (SE)";
    if (heading >= 157.5 && heading < 202.5) return "Selatan (S)";
    if (heading >= 202.5 && heading < 247.5) return "Barat Daya (SW)";
    if (heading >= 247.5 && heading < 292.5) return "Barat (W)";
    return "Barat Laut (NW)";
  }
}
