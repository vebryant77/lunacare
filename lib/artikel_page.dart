
import 'package:flutter/material.dart';

// ======================================================
// WARNA
// ======================================================

const Color kPink = Color(0xFFD97E9E);
const Color kPinkDark = Color(0xFFC85F87);
const Color kPinkLight = Color(0xFFFFEAF1);
const Color kBackground = Color(0xFFFFF9FB);
const Color kTextDark = Color(0xFF493A42);
const Color kTextSoft = Color(0xFF8B7B83);
const Color kBorder = Color(0xFFEDE3E7);

// ======================================================
// MODEL DATA ARTIKEL
// ======================================================

class BagianArtikel {
  final String judul;
  final String isi;

  const BagianArtikel({
    required this.judul,
    required this.isi,
  });
}

class Artikel {
  final String id;
  final String judul;
  final String kategori;
  final String ringkasan;
  final int menitBaca;
  final List<BagianArtikel> bagian;

  const Artikel({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.ringkasan,
    required this.menitBaca,
    required this.bagian,
  });
}

// ======================================================
// DATA ARTIKEL SEMENTARA
// ======================================================

const List<Artikel> daftarArtikel = [
  Artikel(
    id: 'siklus',
    judul: 'Memahami Siklus Menstruasi',
    kategori: 'Menstruasi',
    ringkasan:
        'Kenali cara kerja siklus menstruasi dan pentingnya '
        'mencatat tanggal menstruasi.',
    menitBaca: 3,
    bagian: [
      BagianArtikel(
        judul: 'Apa itu siklus menstruasi?',
        isi:
            'Siklus menstruasi adalah rangkaian perubahan alami '
            'yang terjadi dalam tubuh sebagai bagian dari sistem '
            'reproduksi.\n\n'
            'Siklus dihitung dari hari pertama menstruasi sampai '
            'sehari sebelum menstruasi berikutnya dimulai. '
            'Panjang siklus dapat berbeda pada setiap orang.',
      ),
      BagianArtikel(
        judul: 'Mengapa perlu mencatat menstruasi?',
        isi:
            'Mencatat tanggal mulai dan selesai menstruasi '
            'membantu kita mengenali pola siklus tubuh.\n\n'
            'Dari catatan tersebut, pengguna dapat mengetahui '
            'riwayat menstruasi dan memperkirakan kapan '
            'menstruasi berikutnya mungkin datang.',
      ),
      BagianArtikel(
        judul: 'Hal yang perlu diperhatikan',
        isi:
            'Prediksi menstruasi tidak selalu tepat karena '
            'siklus dapat berubah.\n\n'
            'Apabila terjadi perubahan siklus yang mengkhawatirkan, '
            'perdarahan sangat banyak, atau menstruasi tidak '
            'datang selama beberapa bulan, sebaiknya '
            'berkonsultasi dengan tenaga kesehatan.',
      ),
    ],
  ),

  Artikel(
    id: 'nyeri',
    judul: 'Tips Mengurangi Nyeri Haid',
    kategori: 'Kesehatan',
    ringkasan:
        'Langkah sederhana untuk membantu mengurangi '
        'rasa tidak nyaman selama menstruasi.',
    menitBaca: 3,
    bagian: [
      BagianArtikel(
        judul: 'Mengapa nyeri haid terjadi?',
        isi:
            'Nyeri haid sering terjadi akibat kontraksi rahim '
            'selama menstruasi.\n\n'
            'Rasa nyeri biasanya muncul di perut bagian bawah '
            'dan terkadang terasa sampai punggung atau paha.',
      ),
      BagianArtikel(
        judul: 'Cara membantu mengurangi nyeri',
        isi:
            'Beberapa langkah yang dapat dicoba adalah '
            'mengompres perut dengan air hangat, melakukan '
            'gerakan ringan, dan beristirahat dengan cukup.\n\n'
            'Menjaga kebutuhan cairan tubuh juga penting '
            'untuk kesehatan sehari-hari.',
      ),
      BagianArtikel(
        judul: 'Kapan perlu diperiksa?',
        isi:
            'Jika nyeri sangat berat, semakin memburuk, '
            'atau sampai mengganggu aktivitas sehari-hari, '
            'sebaiknya periksakan diri ke tenaga kesehatan.',
      ),
    ],
  ),

  Artikel(
    id: 'mood',
    judul: 'Menjaga Mood Saat PMS',
    kategori: 'Wellness',
    ringkasan:
        'Pahami perubahan suasana hati menjelang menstruasi '
        'dan cara mengelolanya.',
    menitBaca: 3,
    bagian: [
      BagianArtikel(
        judul: 'Apa itu PMS?',
        isi:
            'Premenstrual syndrome (PMS) adalah kumpulan gejala '
            'yang dapat muncul sebelum menstruasi.\n\n'
            'Gejalanya dapat berupa perubahan mood, '
            'mudah lelah, perut kembung, atau nyeri payudara.',
      ),
      BagianArtikel(
        judul: 'Cara menjaga suasana hati',
        isi:
            'Usahakan memiliki waktu tidur yang cukup, '
            'makan secara teratur, dan melakukan aktivitas '
            'fisik ringan sesuai kemampuan.\n\n'
            'Beristirahat atau berbicara dengan orang '
            'yang dipercaya juga dapat membantu.',
      ),
      BagianArtikel(
        judul: 'Manfaat mencatat mood',
        isi:
            'Mencatat mood secara rutin dapat membantu '
            'mengenali perubahan suasana hati yang mungkin '
            'berkaitan dengan siklus menstruasi.\n\n'
            'Jika gejala emosional sangat berat atau '
            'mengganggu aktivitas, konsultasikan dengan '
            'tenaga kesehatan.',
      ),
    ],
  ),

  Artikel(
    id: 'kebersihan',
    judul: 'Menjaga Kebersihan Saat Menstruasi',
    kategori: 'Kebersihan',
    ringkasan:
        'Tips menjaga kebersihan dan kenyamanan tubuh '
        'selama menstruasi.',
    menitBaca: 2,
    bagian: [
      BagianArtikel(
        judul: 'Pentingnya kebersihan',
        isi:
            'Menjaga kebersihan selama menstruasi dapat '
            'membantu meningkatkan kenyamanan dan '
            'mengurangi risiko iritasi.',
      ),
      BagianArtikel(
        judul: 'Kebiasaan yang dianjurkan',
        isi:
            'Ganti produk menstruasi secara berkala sesuai '
            'kebutuhan dan petunjuk penggunaannya.\n\n'
            'Cuci tangan sebelum dan sesudah mengganti '
            'produk menstruasi. Bersihkan bagian luar '
            'area genital dengan lembut.',
      ),
      BagianArtikel(
        judul: 'Perhatikan keluhan',
        isi:
            'Jika muncul iritasi berat, nyeri, atau '
            'keluhan tidak biasa, sebaiknya berkonsultasi '
            'dengan tenaga kesehatan.',
      ),
    ],
  ),

  Artikel(
    id: 'nutrisi',
    judul: 'Pola Makan Saat Menstruasi',
    kategori: 'Nutrisi',
    ringkasan:
        'Pentingnya makanan seimbang untuk membantu '
        'menjaga kesehatan selama menstruasi.',
    menitBaca: 2,
    bagian: [
      BagianArtikel(
        judul: 'Pentingnya nutrisi',
        isi:
            'Tubuh tetap membutuhkan energi dan zat gizi '
            'yang cukup selama menstruasi.\n\n'
            'Mengonsumsi makanan bervariasi membantu '
            'memenuhi kebutuhan nutrisi harian.',
      ),
      BagianArtikel(
        judul: 'Pilihan makanan',
        isi:
            'Utamakan pola makan seimbang yang mencakup '
            'sayur, buah, sumber protein, dan karbohidrat.\n\n'
            'Sumber zat besi juga penting sebagai '
            'bagian dari pola makan yang sehat.',
      ),
      BagianArtikel(
        judul: 'Penuhi kebutuhan cairan',
        isi:
            'Minumlah air yang cukup sesuai kebutuhan '
            'tubuh dan aktivitas sehari-hari.\n\n'
            'Tidak ada satu makanan khusus yang dapat '
            'mengatasi semua keluhan menstruasi.',
      ),
    ],
  ),
];

// ======================================================
// HALAMAN SEMUA ARTIKEL
// ======================================================

class ArtikelPage extends StatefulWidget {
  const ArtikelPage({super.key});

  @override
  State<ArtikelPage> createState() => _ArtikelPageState();
}

class _ArtikelPageState extends State<ArtikelPage> {
  final TextEditingController searchController =
      TextEditingController();

  String kategoriDipilih = 'Semua';

  final List<String> kategori = [
    'Semua',
    'Menstruasi',
    'Kesehatan',
    'Wellness',
    'Kebersihan',
    'Nutrisi',
  ];

  // ====================================================
  // FILTER ARTIKEL
  // ====================================================

  List<Artikel> get hasilArtikel {
    final keyword = searchController.text
        .trim()
        .toLowerCase();

    return daftarArtikel.where((artikel) {
      final cocokKategori =
          kategoriDipilih == 'Semua' ||
          artikel.kategori == kategoriDipilih;

      final cocokPencarian =
          keyword.isEmpty ||
          artikel.judul.toLowerCase().contains(keyword) ||
          artikel.kategori.toLowerCase().contains(keyword) ||
          artikel.ringkasan.toLowerCase().contains(keyword);

      return cocokKategori && cocokPencarian;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ====================================================
  // BUKA DETAIL
  // ====================================================

  void bukaArtikel(Artikel artikel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetailArtikelPage(artikel: artikel),
      ),
    );
  }

  // ====================================================
  // BUILD
  // ====================================================

  @override
  Widget build(BuildContext context) {
    final hasil = hasilArtikel;

    return Scaffold(
      backgroundColor: kBackground,

      appBar: AppBar(
        backgroundColor: kBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Artikel',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kTextDark,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20, 12, 20, 35,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Artikel Kesehatan',
              style: TextStyle(
                color: kTextDark,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Informasi seputar menstruasi, kesehatan, '
              'dan kondisi tubuh.',
              style: TextStyle(
                color: kTextSoft,
                fontSize: 12,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 22),

            // ==========================================
            // PENCARIAN
            // ==========================================

            TextField(
              controller: searchController,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Cari artikel...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: kTextSoft,
                ),
                suffixIcon: searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          searchController.clear();
                          setState(() {});
                        },
                      ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: kBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: kBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: kPink),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Kategori',
              style: TextStyle(
                color: kTextDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // ==========================================
            // FILTER KATEGORI
            // ==========================================

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: kategori.map((item) {
                  final aktif = item == kategoriDipilih;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(item),
                      selected: aktif,
                      showCheckmark: false,
                      backgroundColor: Colors.white,
                      selectedColor: kPinkLight,
                      side: BorderSide(
                        color: aktif ? kPink : kBorder,
                      ),
                      labelStyle: TextStyle(
                        color: aktif
                            ? kPinkDark
                            : kTextDark,
                        fontSize: 12,
                      ),
                      onSelected: (_) {
                        setState(() {
                          kategoriDipilih = item;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 26),

            Row(
              children: [
                const Text(
                  'Daftar Artikel',
                  style: TextStyle(
                    color: kTextDark,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${hasil.length} artikel',
                  style: const TextStyle(
                    color: kTextSoft,
                    fontSize: 11,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 13),

            // ==========================================
            // HASIL PENCARIAN
            // ==========================================

            if (hasil.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kBorder),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.search_off,
                      color: kTextSoft,
                      size: 32,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Artikel tidak ditemukan',
                      style: TextStyle(
                        color: kTextDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Coba kata kunci atau kategori lain.',
                      style: TextStyle(
                        color: kTextSoft,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...hasil.map(
                (artikel) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: KartuArtikel(
                    artikel: artikel,
                    onTap: () => bukaArtikel(artikel),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// KARTU ARTIKEL
// ======================================================

class KartuArtikel extends StatelessWidget {
  final Artikel artikel;
  final VoidCallback onTap;

  const KartuArtikel({
    super.key,
    required this.artikel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TEMPAT GAMBAR
              Container(
                width: double.infinity,
                height: 155,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      artikel.kategori,
                      style: const TextStyle(
                        color: kPinkDark,
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      artikel.judul,
                      style: const TextStyle(
                        color: kTextDark,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      artikel.ringkasan,
                      style: const TextStyle(
                        color: kTextSoft,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_outlined,
                          size: 15,
                          color: kTextSoft,
                        ),

                        const SizedBox(width: 5),

                        Text(
                          '${artikel.menitBaca} menit baca',
                          style: const TextStyle(
                            color: kTextSoft,
                            fontSize: 11,
                          ),
                        ),

                        const Spacer(),

                        const Text(
                          'Baca Artikel',
                          style: TextStyle(
                            color: kPinkDark,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(width: 4),

                        const Icon(
                          Icons.chevron_right,
                          color: kPinkDark,
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// HALAMAN DETAIL ARTIKEL
// ======================================================

class DetailArtikelPage extends StatelessWidget {
  final Artikel artikel;

  const DetailArtikelPage({
    super.key,
    required this.artikel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,

      appBar: AppBar(
        backgroundColor: kBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Baca Artikel',
          style: TextStyle(
            color: kTextDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20, 12, 20, 35,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TEMPAT GAMBAR DETAIL ARTIKEL
            Container(
              width: double.infinity,
              height: 190,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              artikel.kategori.toUpperCase(),
              style: const TextStyle(
                color: kPinkDark,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              artikel.judul,
              style: const TextStyle(
                color: kTextDark,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.menu_book_outlined,
                  color: kTextSoft,
                  size: 16,
                ),

                const SizedBox(width: 6),

                Text(
                  'LunaCare • ${artikel.menitBaca} menit baca',
                  style: const TextStyle(
                    color: kTextSoft,
                    fontSize: 11,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            const Divider(color: kBorder),

            const SizedBox(height: 18),

            Text(
              artikel.ringkasan,
              style: const TextStyle(
                color: kTextDark,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.7,
              ),
            ),

            // ISI ARTIKEL
            ...artikel.bagian.map(
              (bagian) => Padding(
                padding: const EdgeInsets.only(top: 22),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      bagian.judul,
                      style: const TextStyle(
                        color: kTextDark,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      bagian.isi,
                      style: const TextStyle(
                        color: kTextDark,
                        fontSize: 13,
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: kPinkLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: kPinkDark,
                    size: 20,
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      'Informasi pada artikel ini bersifat '
                      'edukasi umum dan bukan pengganti '
                      'konsultasi dengan tenaga kesehatan.',
                      style: TextStyle(
                        color: kTextDark,
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
