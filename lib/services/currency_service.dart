// lib/services/currency_service.dart
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

/// CurrencyService: convert via exchangerate.host (free) with fallback
class CurrencyService {
  final bool apiMode;
  CurrencyService({this.apiMode = true});

  Future<double> convert(String from, String to, double amount) async {
    if (from.toUpperCase() == to.toUpperCase()) return amount;

    if (apiMode) {
      try {
        final url = Uri.parse(
          'https://api.exchangerate.host/convert?from=$from&to=$to&amount=$amount',
        );
        final r = await http.get(url).timeout(const Duration(seconds: 8));
        if (r.statusCode == 200) {
          final js = jsonDecode(r.body);
          if (js['success'] == true) return (js['result'] as num).toDouble();
        }
      } catch (_) {
        // fallback below
      }
    }

    // fallback rates (demo only)
    final rates = {
      'USD': 1.0,
      'IDR': 0.000067,
      'EUR': 1.08,
      'JPY': 0.0067,
      'SGD': 0.73,
    };
    final f = from.toUpperCase();
    final t = to.toUpperCase();
    if (!rates.containsKey(f) || !rates.containsKey(t))
      throw Exception('Currency unsupported');
    final usd = amount * rates[f]!;
    return usd / rates[t]!;
  }
}
