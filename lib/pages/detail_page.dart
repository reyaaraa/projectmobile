// lib/pages/detail_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/air_quality.dart';
import '../services/weather_service.dart';
import '../widgets/compass_widget.dart';
import 'package:lottie/lottie.dart';

/// DetailPage
/// - Menampilkan rincian AQI (dari AirQuality model)
/// - Menampilkan kondisi cuaca saat ini (menggunakan WeatherService)
/// - Menampilkan kompas kecil untuk orientasi pengguna
class DetailPage extends StatefulWidget {
  final AirQuality airQuality;
  final double? lat;
  final double? lon;

  const DetailPage({super.key, required this.airQuality, this.lat, this.lon});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final WeatherService _weather = WeatherService();
  Map<String, dynamic>? weatherJson;
  String? weatherError;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      loading = true;
      weatherError = null;
    });
    try {
      if (widget.lat != null && widget.lon != null) {
        weatherJson = await _weather.getWeatherByCoords(
          widget.lat!,
          widget.lon!,
        );
      } else {
        // fallback: coba by city name
        weatherJson = await _weather.getWeatherByCity(widget.airQuality.city);
      }
    } catch (e) {
      weatherError = e.toString();
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final aqi = widget.airQuality.aqi;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2BB5A3),
        title: Text('Detail AQI & Cuaca', style: GoogleFonts.poppins()),
        centerTitle: true,
      ),
      body: loading
          ? Center(child: Lottie.asset('assets/loading.json', width: 140))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    '${widget.airQuality.city}, ${widget.airQuality.state}',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // AQI big display
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'AQI: $aqi',
                          style: GoogleFonts.poppins(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: _aqiColor(aqi),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _aqiStatus(aqi),
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Weather card
                  if (weatherJson != null) _buildWeatherCard(weatherJson!),
                  if (weatherError != null)
                    Text(
                      'Weather error: $weatherError',
                      style: const TextStyle(color: Colors.red),
                    ),

                  const SizedBox(height: 18),
                  // Compass
                  const CompassWidget(),
                  const SizedBox(height: 12),
                  Text(
                    'Gunakan kompas untuk orientasi arah',
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildWeatherCard(Map<String, dynamic> w) {
    final main = w['weather']?[0]?['main'] ?? '-';
    final desc = w['weather']?[0]?['description'] ?? '-';
    final temp = w['main']?['temp'] ?? '-';
    final humidity = w['main']?['humidity'] ?? '-';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              'Cuaca saat ini',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('$main – $desc', style: GoogleFonts.poppins(fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Suhu: ${temp.toString()}°C'),
                Text('Kelembapan: ${humidity.toString()}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _aqiColor(int aqi) {
    if (aqi <= 50) return const Color(0xFF2BB5A3);
    if (aqi <= 100) return Colors.amber;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.red;
    return Colors.purple;
  }

  String _aqiStatus(int aqi) {
    if (aqi <= 50) return 'Udara Baik 🌿 – Aman untuk paru-paru';
    if (aqi <= 100) return 'Sedang 😐 – Waspada bagi penderita asma';
    if (aqi <= 150) return 'Tidak Sehat 😷 – Kurangi aktivitas luar ruangan';
    if (aqi <= 200) return 'Buruk 😫 – Gunakan masker';
    return 'Sangat Berbahaya ☠️ – Hindari keluar rumah!';
  }
}
