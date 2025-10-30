class ProdukModel {
  final String kategori;
  final String nama;
  final String deskripsi;
  final String foto; // path dari assets/images
  final int harga; // harga dalam Rupiah

  ProdukModel({
    required this.kategori,
    required this.nama,
    required this.deskripsi,
    required this.foto,
    required this.harga,
  });
}

// =============================
// Daftar Produk Dummy
// =============================

final List<ProdukModel> daftarProduk = [
  // =============================
  // KATEGORI MASKER
  // =============================
  ProdukModel(
    kategori: 'Masker',
    nama: 'Masker N95 Premium',
    deskripsi:
        'Masker N95 dengan 5 lapisan filter untuk perlindungan maksimal terhadap polusi udara dan debu halus.',
    foto: 'assets/images/masker_n95.jpeg',
    harga: 25000,
  ),
  ProdukModel(
    kategori: 'Masker',
    nama: 'Masker KF94 Putih',
    deskripsi:
        'Masker dengan desain 3D yang nyaman digunakan dan mampu menyaring partikel mikro dengan efisiensi tinggi.',
    foto: 'assets/images/masker_kf94.jpg',
    harga: 20000,
  ),
  // ProdukModel(
  //   kategori: 'Masker',
  //   nama: 'Masker Kain Reusable',
  //   deskripsi:
  //       'Masker kain tiga lapis yang bisa dicuci ulang, ramah lingkungan dan cocok untuk penggunaan sehari-hari.',
  //   foto: 'assets/images/masker_kain.png',
  //   harga: 15000,
  // ),

  // =============================
  // KATEGORI OBAT-OBATAN
  // =============================
  ProdukModel(
    kategori: 'Obat-obatan',
    nama: 'Inhaler Herbal Mint',
    deskripsi:
        'Inhaler dengan kandungan mint alami untuk membantu melegakan hidung tersumbat dan menyegarkan pernapasan.',
    foto: 'assets/images/inhaler_herbal.jpg',
    harga: 30000,
  ),
  ProdukModel(
    kategori: 'Obat-obatan',
    nama: 'Obat Batuk Herbal Jahe',
    deskripsi:
        'Obat batuk cair dengan ekstrak jahe dan madu yang membantu meredakan batuk serta menghangatkan tenggorokan.',
    foto: 'assets/images/obat_batuk.png',
    harga: 35000,
  ),
  ProdukModel(
    kategori: 'Obat-obatan',
    nama: 'Saline Nasal Spray',
    deskripsi:
        'Semprotan hidung berbasis air garam steril untuk membersihkan saluran pernapasan dari debu dan polusi.',
    foto: 'assets/images/nasal_spray.jpg',
    harga: 40000,
  ),

  // =============================
  // KATEGORI SUPLEMEN
  // =============================
  ProdukModel(
    kategori: 'Suplemen',
    nama: 'Vitamin C 1000mg',
    deskripsi:
        'Suplemen vitamin C dosis tinggi untuk menjaga daya tahan tubuh, terutama di kondisi udara buruk.',
    foto: 'assets/images/vitamin_c.jpeg',
    harga: 50000,
  ),
  ProdukModel(
    kategori: 'Suplemen',
    nama: 'Propolis Liquid Extract',
    deskripsi:
        'Ekstrak propolis alami dengan kandungan antioksidan tinggi untuk mendukung sistem imun tubuh.',
    foto: 'assets/images/propolis.jpg',
    harga: 75000,
  ),
  ProdukModel(
    kategori: 'Suplemen',
    nama: 'Madu Murni 250ml',
    deskripsi:
        'Madu alami kaya enzim dan mineral yang membantu meningkatkan stamina dan menjaga kesehatan paru-paru.',
    foto: 'assets/images/madu.png',
    harga: 60000,
  ),
];
