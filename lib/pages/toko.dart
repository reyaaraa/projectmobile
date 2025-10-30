import 'package:flutter/material.dart';
import '../models/produk_model.dart';
import '../services/currency_service.dart';

class TokoPage extends StatefulWidget {
  const TokoPage({super.key});

  @override
  State<TokoPage> createState() => _TokoPageState();
}

class _TokoPageState extends State<TokoPage> {
  final _layananKurs = CurrencyService(); // Service untuk konversi mata uang
  String _mataUangDipilih = 'IDR';
  bool _sedangMemuat = false;

  // Simpan hasil konversi biar tidak panggil API berulang kali
  final Map<String, double> _hargaTerkonversi = {};

  // Fungsi untuk konversi harga produk
  Future<double> _dapatkanHarga(double hargaRupiah) async {
    String kunci = '${hargaRupiah}_$_mataUangDipilih';
    if (_hargaTerkonversi.containsKey(kunci)) {
      return _hargaTerkonversi[kunci]!;
    }

    double hasil = hargaRupiah;
    if (_mataUangDipilih != 'IDR') {
      try {
        hasil = await _layananKurs.convert(
          'IDR',
          _mataUangDipilih,
          hargaRupiah,
        );
        _hargaTerkonversi[kunci] = hasil;
      } catch (_) {
        hasil = hargaRupiah;
      }
    }
    return hasil;
  }

  // Mengembalikan simbol mata uang
  String _simbolMataUang(String kode) {
    switch (kode) {
      case 'USD':
        return '\$';
      case 'SGD':
        return 'S\$';
      case 'JPY':
        return '¥';
      case 'IDR':
      default:
        return 'Rp';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil daftar kategori unik dari semua produk
    final daftarKategori = daftarProduk.map((p) => p.kategori).toSet().toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FCFC),
      appBar: AppBar(
        title: const Text(
          'Toko Kesehatan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 3,
      ),

      body: Column(
        children: [
          // ============================
          // BAGIAN PILIHAN MATA UANG
          // ============================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Tampilkan Harga Dalam:",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _mataUangDipilih,
                      icon: const Icon(Icons.arrow_drop_down_rounded),
                      onChanged: (String? baru) async {
                        if (baru == null) return;
                        setState(() {
                          _mataUangDipilih = baru;
                          _sedangMemuat = true;
                          _hargaTerkonversi.clear();
                        });
                        await Future.delayed(const Duration(milliseconds: 500));
                        setState(() => _sedangMemuat = false);
                      },
                      items: const [
                        DropdownMenuItem(value: 'IDR', child: Text('IDR')),
                        DropdownMenuItem(value: 'USD', child: Text('USD')),
                        DropdownMenuItem(value: 'SGD', child: Text('SGD')),
                        DropdownMenuItem(value: 'JPY', child: Text('YEN')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_sedangMemuat)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: CircularProgressIndicator(color: Color(0xFF009688)),
            ),

          // ============================
          // DAFTAR PRODUK BERDASAR KATEGORI
          // ============================
          Expanded(
            child: ListView.builder(
              itemCount: daftarKategori.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, i) {
                final kategori = daftarKategori[i];
                final produkKategori = daftarProduk
                    .where((p) => p.kategori == kategori)
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        kategori,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF009688),
                        ),
                      ),
                    ),

                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: produkKategori.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                      itemBuilder: (context, j) {
                        final produk = produkKategori[j];

                        return FutureBuilder<double>(
                          future: _dapatkanHarga(produk.harga.toDouble()),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF80CBC4),
                                ),
                              );
                            }

                            final harga =
                                snapshot.data ?? produk.harga.toDouble();
                            return _kartuProduk(
                              produk,
                              harga,
                              _simbolMataUang(_mataUangDipilih),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================
  // KOMPONEN KARTU PRODUK
  // ============================
  Widget _kartuProduk(ProdukModel produk, double harga, String simbol) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Gambar produk
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  produk.foto,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Nama produk
            Text(
              produk.nama,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),

            // Deskripsi produk
            Text(
              produk.deskripsi,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),

            // Harga produk
            Text(
              "$simbol ${harga.toStringAsFixed(_mataUangDipilih == 'IDR' ? 0 : 2)}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF00796B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
