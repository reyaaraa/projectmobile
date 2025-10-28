// lib/services/air_service.dart
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'secure_store.dart';

/// AirService - mengambil data AQI dari IQAir AirVisual API
/// - Jika SecureStore menyimpan key 'airvisual_key', akan dipakai.
/// - Endpoint: nearest_city (opsional: kirim lat/lon agar lokasi lebih akurat).
class AirService {
  // fallback dev key (jika belum simpan ke SecureStore)
  final String _fallbackKey = '12680eb5-d113-48f9-ae58-d591c4a9c7b6';
  final String _base = 'https://api.airvisual.com/v2/nearest_city';

  Future<String> _getKey() async {
    final stored = await SecureStore.readEncrypted('airvisual_key');
    return stored ?? _fallbackKey;
  }

  /// Ambil AQI. Bila lat/lon diberikan, panggil API dengan koordinat tersebut.
  Future<Map<String, dynamic>> fetchNearestCity({
    double? lat,
    double? lon,
  }) async {
    final key = await _getKey();
    final uri = (lat != null && lon != null)
        ? Uri.parse('$_base?lat=$lat&lon=$lon&key=$key')
        : Uri.parse('$_base?key=$key');

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
}
