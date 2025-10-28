// lib/widgets/converter_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/currency_service.dart';
import '../utils/time_utils.dart';

class ConverterCard extends StatefulWidget {
  const ConverterCard({super.key});
  @override
  State<ConverterCard> createState() => _ConverterCardState();
}

class _ConverterCardState extends State<ConverterCard> {
  final CurrencyService _currency = CurrencyService(apiMode: true);
  final TextEditingController _amountCtrl = TextEditingController(text: '1000');
  String _from = 'IDR';
  String _to = 'USD';
  double? _converted;
  String _timeFrom = '-';
  String _timeTo = '-';

  Future<void> _doConvert() async {
    final amt = double.tryParse(_amountCtrl.text.replaceAll(',', '')) ?? 0;
    try {
      final res = await _currency.convert(_from, _to, amt);
      setState(() => _converted = res);
    } catch (e) {
      setState(() => _converted = null);
      // small in-UI error; not using SnackBar for critical alerts
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Konversi gagal: $e')));
    }
  }

  void _doTimeConvert() {
    final now = DateTime.now();
    // contoh: convert ke UTC (offset 0)
    final converted = TimeUtils.convertToOffset(now, 0);
    setState(() {
      _timeFrom = now.toLocal().toString();
      _timeTo = converted.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              'Konversi Uang & Waktu',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Jumlah'),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _from,
                  items: ['IDR', 'USD', 'EUR', 'JPY', 'SGD']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) {
                    setState(() => _from = v!);
                  },
                ),
                const SizedBox(width: 8),
                const Icon(Icons.swap_horiz),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _to,
                  items: ['USD', 'IDR', 'EUR', 'JPY', 'SGD']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) {
                    setState(() => _to = v!);
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _doConvert,
                  child: const Text('Hitung'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_converted != null)
              Text(
                'Hasil: ${_converted!.toStringAsFixed(2)} $_to',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _doTimeConvert,
                  child: const Text('Konversi Waktu'),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Lokal: $_timeFrom'),
                    Text('Target(UTC): $_timeTo'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
