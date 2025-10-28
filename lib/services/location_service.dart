// lib/services/location_service.dart
import 'package:geolocator/geolocator.dart';

/// LocationService
/// - Meminta permission lokasi bila perlu
/// - Mengembalikan Position (lat, lon)
class LocationService {
  Future<bool> _checkAndRequestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Layanan lokasi dimatikan. Hidupkan lokasi pada device.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Izin lokasi ditolak secara permanen.');
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<Position> getCurrentPosition() async {
    final ok = await _checkAndRequestPermission();
    if (!ok) throw Exception('Izin lokasi tidak diberikan');
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
