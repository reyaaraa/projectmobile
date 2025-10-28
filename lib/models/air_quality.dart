// lib/models/air_quality.dart
class AirQuality {
  final String city;
  final String state;
  final String country;
  final int aqi;

  AirQuality({
    required this.city,
    required this.state,
    required this.country,
    required this.aqi,
  });

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final curr = data['current'] ?? {};
    final poll = curr['pollution'] ?? {};
    return AirQuality(
      city: data['city'] ?? 'Unknown',
      state: data['state'] ?? '',
      country: data['country'] ?? '',
      aqi: (poll['aqius'] ?? 0) is int
          ? poll['aqius']
          : (poll['aqius'] ?? 0).toInt(),
    );
  }
}
