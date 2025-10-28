// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../services/location_service.dart';
import '../services/air_services.dart';
import '../models/air_quality.dart';
import '../widgets/info_card.dart';
import '../widgets/converter_card.dart';
import '../services/notification_service.dart';
import 'detail_page.dart';

/// HomePage
/// - Menggunakan sensor lokasi (LocationService) untuk menentukan koordinat
/// - Mengambil AQI dari AirVisual (AirService)
/// - Menampilkan kartu InfoCard, ConverterCard (uang & waktu), tombol notifikasi
/// - Notifikasi menggunakan NotificationService (system notification)
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocationService _loc = LocationService();
  final AirService _air = AirService();

  AirQuality? _aqiData;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchWithLocation();
  }

  Future<void> _fetchWithLocation() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final pos = await _loc.getCurrentPosition();
      final json = await _air.fetchNearestCity(
        lat: pos.latitude,
        lon: pos.longitude,
      );
      _aqiData = AirQuality.fromJson(json);
      // Jika AQI berbahaya, kirim notifikasi (system)
      if (_aqiData!.aqi > 200) {
        await NotificationService.showNotification(
          title: 'Peringatan Polusi',
          body: 'AQI ${_aqiData!.aqi} — Hindari keluar rumah!',
        );
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Color _aqiColor(int aqi) {
    if (aqi <= 50) return const Color(0xFF2BB5A3);
    if (aqi <= 100) return Colors.amber;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.red;
    return Colors.purple;
  }

  String _aqiStatus(int aqi) {
    if (aqi <= 50) return 'Udara Baik 🌿 – Aman';
    if (aqi <= 100) return 'Sedang 😐 – Waspada';
    if (aqi <= 150) return 'Tidak Sehat 😷 – Kurangi aktivitas';
    if (aqi <= 200) return 'Buruk 😫 – Gunakan masker';
    return 'Sangat Berbahaya ☠️ – Hindari keluar rumah';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ParuGuard',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2BB5A3),
        actions: [
          IconButton(
            onPressed: () async {
              // manual refresh + notifikasi simple
              await _fetchWithLocation();
              if (_aqiData != null) {
                await NotificationService.showNotification(
                  title: 'ParuGuard',
                  body: 'AQI ${_aqiData!.aqi} (${_aqiData!.city})',
                );
              }
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loading
          ? Center(child: Lottie.asset('assets/loading.json', width: 140))
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error: $_error',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // decorative breathing Lottie
                  Lottie.asset('assets/breathing_exercise.json', width: 180),
                  const SizedBox(height: 8),

                  // location text
                  Text(
                    '${_aqiData!.city}, ${_aqiData!.state}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A3C40),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Info card AQI
                  InfoCard(
                    aqi: _aqiData!.aqi,
                    status: _aqiStatus(_aqiData!.aqi),
                    color: _aqiColor(_aqiData!.aqi),
                  ),
                  const SizedBox(height: 12),

                  // Converter (uang & waktu) inline in main theme (not a separate menu)
                  const ConverterCard(),
                  const SizedBox(height: 12),

                  // Buttons: detail (open detail page) and notify (system)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // buka halaman detail yang menampilkan AQI & cuaca + kompas
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPage(
                                airQuality: _aqiData!,
                                lat: null,
                                lon: null,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Lihat Detail'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C8E82),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          // contoh notifikasi manual
                          await NotificationService.showNotification(
                            title: 'ParuGuard',
                            body: 'AQI sekarang: ${_aqiData!.aqi}',
                          );
                        },
                        icon: const Icon(Icons.notifications),
                        label: const Text('Notifikasi'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
