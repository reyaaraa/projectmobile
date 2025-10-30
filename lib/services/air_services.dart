// lib/services/air_service.dart
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'secure_store.dart';

/// AirService - ambil data AQI dari AirVisual API (pakai nearest_city)
/// Dilengkapi dukungan cari kota lewat koordinat (geocoding)
class AirService {
  final String _fallbackKey = '12680eb5-d113-48f9-ae58-d591c4a9c7b6';
  final String _baseNearest = 'https://api.airvisual.com/v2/nearest_city';

  Future<String> _getKey() async {
    final stored = await SecureStore.readEncrypted('airvisual_key');
    return stored ?? _fallbackKey;
  }

  /// Ambil data berdasarkan lokasi saat ini
  Future<Map<String, dynamic>> fetchNearestCity({
    double? lat,
    double? lon,
  }) async {
    final key = await _getKey();
    final uri = (lat != null && lon != null)
        ? Uri.parse('$_baseNearest?lat=$lat&lon=$lon&key=$key')
        : Uri.parse('$_baseNearest?key=$key');

    try {
      final r = await http.get(uri).timeout(const Duration(seconds: 10));
      if (r.statusCode == 200) {
        final json = jsonDecode(r.body) as Map<String, dynamic>;
        if (json['status'] == 'success') return json;
        throw Exception('AirVisual response: ${json['status']}');
      } else {
        throw Exception('HTTP ${r.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Timeout: AirVisual tidak merespons dalam 10s');
    } catch (e) {
      rethrow;
    }
  }

  /// ✅ Ambil data berdasarkan nama kota (pakai Nominatim + nearest_city)
  Future<Map<String, dynamic>> fetchByCity(String city) async {
    if (city.isEmpty) throw Exception('Nama kota kosong');

    try {
      // 1️⃣ Ambil koordinat dari nama kota (pakai OpenStreetMap Nominatim API)
      final geoUrl = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$city&format=json&limit=1',
      );
      final geoResponse = await http.get(
        geoUrl,
        headers: {'User-Agent': 'ParuGuardApp/1.0 (your_email@example.com)'},
      );

      if (geoResponse.statusCode != 200) {
        throw Exception('Gagal mendapatkan koordinat kota');
      }

      final geoData = jsonDecode(geoResponse.body);
      if (geoData.isEmpty) throw Exception('Kota "$city" tidak ditemukan');

      final lat = double.parse(geoData[0]['lat']);
      final lon = double.parse(geoData[0]['lon']);

      // 2️⃣ Gunakan nearest_city berdasarkan koordinat
      final key = await _getKey();
      final airUrl = Uri.parse('$_baseNearest?lat=$lat&lon=$lon&key=$key');

      final airResponse = await http
          .get(airUrl)
          .timeout(const Duration(seconds: 10));

      if (airResponse.statusCode == 200) {
        final json = jsonDecode(airResponse.body);
        if (json['status'] == 'success') return json;
        throw Exception('AirVisual gagal: ${json['data']['message']}');
      } else {
        throw Exception('HTTP ${airResponse.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal mendapatkan data AQI: $e');
    }
  }
}
