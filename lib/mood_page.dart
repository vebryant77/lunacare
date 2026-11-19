
import 'package:flutter/material.dart';

// ======================================================
// WARNA LUNACARE
// ======================================================

const Color kPink = Color(0xFFD97E9E);
const Color kPinkDark = Color(0xFFC85F87);
const Color kPinkLight = Color(0xFFFFEAF1);
const Color kBackground = Color(0xFFFFF9FB);
const Color kTextDark = Color(0xFF493A42);
const Color kTextSoft = Color(0xFF8B7B83);
const Color kBorder = Color(0xFFEDE3E7);

// ======================================================
// MODEL DATA MOOD
// ======================================================

class MoodRecord {
  final DateTime date;
  final String mood;
  final String note;

  const MoodRecord({
    required this.date,
    required this.mood,
    required this.note,
  });
}

// ======================================================
// PENYIMPANAN SEMENTARA MOOD
// ======================================================

class MoodJournal extends ChangeNotifier {
  final List<MoodRecord> _records = [];

  List<MoodRecord> get records {
    final result = List<MoodRecord>.from(_records);

    result.sort(
      (a, b) => b.date.compareTo(a.date),
    );

    return result;
  }

  bool sameDate(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  MoodRecord? findByDate(DateTime date) {
    for (final record in _records) {
      if (sameDate(record.date, date)) {
        return record;
      }
    }

    return null;
  }

  // Satu tanggal memiliki satu catatan mood.
  // Jika disimpan lagi, catatan sebelumnya diperbarui.

  void save(MoodRecord record) {
    _records.removeWhere(
      (item) => sameDate(item.date, record.date),
    );

    _records.add(record);
    notifyListeners();
  }

  void delete(DateTime date) {
    _records.removeWhere(
      (item) => sameDate(item.date, date),
    );

    notifyListeners();
  }
}

// Digunakan juga oleh statistics_page.dart.
final MoodJournal moodJournal = MoodJournal();

// ======================================================
// PILIHAN MOOD
// ======================================================

class MoodOption {
  final String name;
  final String emoji;

  const MoodOption(this.name, this.emoji);
}

const List<MoodOption> moodOptions = [
  MoodOption('Senang', '😊'),
  MoodOption('Tenang', '😌'),
  MoodOption('Biasa', '😐'),
  MoodOption('Sedih', '😢'),
  MoodOption('Lelah', '😴'),
  MoodOption('Cemas', '😟'),
  MoodOption('Mudah Marah', '😠'),
];

// ======================================================
// MODEL REKOMENDASI
// ======================================================

class MoodRecommendation {
  final String message;
  final List<String> foods;
  final List<String> activities;

  const MoodRecommendation({
    required this.message,
    required this.foods,
    required this.activities,
  });
}

// ======================================================
// DATA REKOMENDASI BERDASARKAN MOOD
// ======================================================

const Map<String, MoodRecommendation> moodRecommendations = {
  'Senang': MoodRecommendation(
    message:
        'Senang mendengar suasana hatimu sedang baik! '
        'Pertahankan kebiasaan yang membuatmu nyaman.',
    foods: [
      'Makanan seimbang dengan sayur dan protein.',
      'Buah segar seperti pisang, apel, atau jeruk.',
      'Minum air yang cukup sepanjang hari.',
    ],
    activities: [
      'Luangkan waktu untuk hobi yang kamu sukai.',
      'Jalan santai atau olahraga ringan.',
      'Tuliskan hal menyenangkan yang terjadi hari ini.',
    ],
  ),

  'Tenang': MoodRecommendation(
    message:
        'Suasana hati yang tenang bisa menjadi '
        'kesempatan untuk merawat diri.',
    foods: [
      'Oatmeal atau roti gandum dengan buah.',
      'Makanan utama yang mengandung protein dan sayur.',
      'Air putih sesuai kebutuhan tubuh.',
    ],
    activities: [
      'Membaca buku atau mendengarkan musik.',
      'Melakukan peregangan ringan.',
      'Mempertahankan rutinitas tidur yang teratur.',
    ],
  ),

  'Biasa': MoodRecommendation(
    message:
        'Tidak masalah jika hari ini terasa biasa saja. '
        'Tetap perhatikan kebutuhan tubuhmu, ya.',
    foods: [
      'Nasi, sayur, dan lauk berprotein.',
      'Buah atau kacang sebagai camilan.',
      'Minum air putih yang cukup.',
    ],
    activities: [
      'Berjalan santai selama 10–15 menit.',
      'Melakukan aktivitas sesuai kemampuan.',
      'Memberikan waktu untuk beristirahat.',
    ],
  ),

  'Sedih': MoodRecommendation(
    message:
        'Kalau hari ini terasa berat, berikan waktu '
        'untuk dirimu sendiri. Kamu boleh beristirahat '
        'dan mencari dukungan.',
    foods: [
      'Usahakan tetap makan secara teratur.',
      'Pilih makanan seimbang seperti nasi, telur, '
          'sayur, dan buah.',
      'Penuhi kebutuhan cairan tubuh.',
    ],
    activities: [
      'Ceritakan perasaanmu kepada orang tepercaya.',
      'Coba jalan santai jika kamu merasa nyaman.',
      'Dengarkan musik atau lakukan hobi yang menenangkan.',
    ],
  ),

  'Lelah': MoodRecommendation(
    message:
        'Tubuhmu mungkin membutuhkan istirahat. '
        'Tidak perlu memaksakan diri menyelesaikan '
        'semuanya sekaligus.',
    foods: [
      'Makanan utama seperti nasi, ikan atau telur, '
          'dan sayuran.',
      'Buah sebagai camilan praktis.',
      'Air putih untuk memenuhi kebutuhan cairan.',
    ],
    activities: [
      'Beristirahat dari aktivitas berat.',
      'Melakukan peregangan ringan bila nyaman.',
      'Mengusahakan tidur yang cukup dan teratur.',
    ],
  ),

  'Cemas': MoodRecommendation(
    message:
        'Ketika merasa cemas, coba fokus pada '
        'satu hal kecil yang bisa dilakukan sekarang.',
    foods: [
      'Usahakan makan teratur, misalnya oatmeal '
          'dengan buah.',
      'Camilan seperti yogurt atau kacang jika cocok.',
      'Perhatikan apakah kafein memperburuk kecemasan.',
    ],
    activities: [
      'Melakukan latihan pernapasan perlahan.',
      'Menuliskan hal yang membuatmu khawatir.',
      'Berjalan santai atau berbicara dengan '
          'orang yang dipercaya.',
    ],
  ),

  'Mudah Marah': MoodRecommendation(
    message:
        'Kalau emosi terasa lebih sensitif, '
        'ambil jeda sebelum melanjutkan aktivitas.',
    foods: [
      'Makan secara teratur.',
      'Buah, roti gandum, atau kacang sebagai camilan.',
      'Minum air yang cukup.',
    ],
    activities: [
      'Mengambil jeda dari situasi yang membuat kesal.',
      'Melakukan pernapasan perlahan.',
      'Berjalan santai atau mendengarkan musik.',
    ],
  ),
};

// ======================================================
// FORMAT TANGGAL
// ======================================================

String formatMoodDate(DateTime date) {
  const months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  return '${date.day} '
      '${months[date.month - 1]} '
      '${date.year}';
}

// ======================================================
// MOOD PAGE
// ======================================================

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  String? selectedMood;

  final TextEditingController noteController =
      TextEditingController();

  bool hasSaved = false;

  // ====================================================
  // TANGGAL OTOMATIS DARI HP
  // ====================================================

  DateTime get today {
    return DateUtils.dateOnly(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    loadSavedMood();
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  // ====================================================
  // MEMUAT MOOD HARI INI
  // ====================================================

  void loadSavedMood() {
    final existing = moodJournal.findByDate(today);

    selectedMood = existing?.mood;
    noteController.text = existing?.note ?? '';
    hasSaved = existing != null;
  }

  // ====================================================
  // SIMPAN MOOD DENGAN TANGGAL OTOMATIS
  // ====================================================

  void saveMood() {
    if (selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pilih suasana hati terlebih dahulu.',
          ),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    // Tanggal diambil saat tombol Simpan ditekan.
    final currentDate = DateUtils.dateOnly(
      DateTime.now(),
    );

    moodJournal.save(
      MoodRecord(
        date: currentDate,
        mood: selectedMood!,
        note: noteController.text.trim(),
      ),
    );

    setState(() {
      hasSaved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Mood berhasil dicatat pada '
          '${formatMoodDate(currentDate)}.',
        ),
      ),
    );
  }

  // ====================================================
  // BATALKAN PERUBAHAN
  // ====================================================

  void resetForm() {
    setState(() {
      loadSavedMood();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Form dikembalikan ke catatan terakhir.',
        ),
      ),
    );
  }

  // ====================================================
  // CARD UMUM
  // ====================================================

  Widget sectionCard({
    required String title,
    required Widget child,
    String? subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: kTextDark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (subtitle != null) ...[
            const SizedBox(height: 5),

            Text(
              subtitle,
              style: const TextStyle(
                color: kTextSoft,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],

          const SizedBox(height: 15),

          child,
        ],
      ),
    );
  }

  // ====================================================
  // ITEM REKOMENDASI
  // ====================================================

  Widget adviceItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: kPinkDark,
            size: 18,
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: kTextDark,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================
  // SARAN OTOMATIS BERDASARKAN MOOD
  // ====================================================

  Widget recommendationSection() {
    if (selectedMood == null) {
      return const SizedBox.shrink();
    }

    final recommendation =
        moodRecommendations[selectedMood]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Saran untuk Hari Ini',
          style: TextStyle(
            color: kTextDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 7),

        const Text(
          'Saran sederhana berdasarkan '
          'suasana hati yang kamu pilih.',
          style: TextStyle(
            color: kTextSoft,
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 15),

        // ==========================================
        // PESAN MOOD
        // ==========================================

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kPinkLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.favorite_border,
                color: kPinkDark,
                size: 23,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mood: $selectedMood',
                      style: const TextStyle(
                        color: kPinkDark,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      recommendation.message,
                      style: const TextStyle(
                        color: kTextDark,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 13),

        // ==========================================
        // SARAN MAKANAN
        // ==========================================

        sectionCard(
          title: 'Saran Makanan',
          subtitle:
              'Pilihan makanan untuk mendukung '
              'pola makan seimbang.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: recommendation.foods
                .map(adviceItem)
                .toList(),
          ),
        ),

        const SizedBox(height: 13),

        // ==========================================
        // SARAN AKTIVITAS
        // ==========================================

        sectionCard(
          title: 'Saran Aktivitas',
          subtitle:
              'Pilih kegiatan yang terasa nyaman '
              'untuk dilakukan.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: recommendation.activities
                .map(adviceItem)
                .toList(),
          ),
        ),

        const SizedBox(height: 15),

        const Text(
          'Saran ini bersifat edukasi umum, bukan '
          'diagnosis atau pengobatan. Jika perubahan '
          'mood sangat berat, berlangsung lama, '
          'atau mengganggu aktivitas, konsultasikan '
          'dengan tenaga kesehatan.',
          style: TextStyle(
            color: kTextSoft,
            fontSize: 11,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ====================================================
  // BUILD HALAMAN
  // ====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,

      appBar: AppBar(
        backgroundColor: kBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Catat Mood',
          style: TextStyle(
            color: kTextDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          14,
          20,
          35,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // HEADER
            // ==========================================

            const Text(
              'Bagaimana perasaanmu hari ini?',
              style: TextStyle(
                color: kTextDark,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Pilih mood untuk mendapatkan '
              'saran makanan dan aktivitas '
              'yang sesuai.',
              style: TextStyle(
                color: kTextSoft,
                fontSize: 12,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 23),

            // ==========================================
            // PILIH MOOD
            // ==========================================

            sectionCard(
              title: 'Pilih Mood',
              subtitle:
                  'Pilih satu suasana hati '
                  'yang paling sesuai.',
              child: GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: moodOptions.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final mood = moodOptions[index];

                  final selected =
                      selectedMood == mood.name;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedMood = mood.name;
                        hasSaved = false;
                      });
                    },
                    borderRadius:
                        BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected
                            ? kPinkLight
                            : Colors.white,
                        borderRadius:
                            BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? kPink
                              : kBorder,
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(
                            mood.emoji,
                            style: const TextStyle(
                              fontSize: 27,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            mood.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: selected
                                  ? kPinkDark
                                  : kTextDark,
                              fontSize: 11,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            // ==========================================
            // CATATAN TAMBAHAN
            // ==========================================

            sectionCard(
              title: 'Catatan Tambahan',
              subtitle:
                  'Opsional, ceritakan apa '
                  'yang kamu rasakan hari ini.',
              child: TextField(
                controller: noteController,
                maxLines: 3,
                onChanged: (_) {
                  if (hasSaved) {
                    setState(() {
                      hasSaved = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText:
                      'Contoh: Hari ini merasa lelah '
                      'setelah banyak aktivitas...',
                  hintStyle: const TextStyle(
                    color: kTextSoft,
                    fontSize: 12,
                  ),
                  filled: true,
                  fillColor: kBackground,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: kBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: kBorder),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==========================================
            // TOMBOL SIMPAN
            // ==========================================

            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: saveMood,
                icon: const Icon(
                  Icons.save_outlined,
                ),
                label: const Text(
                  'Simpan Mood',
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: kPink,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(11),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 6),

            Center(
              child: TextButton(
                onPressed: resetForm,
                child: const Text(
                  'Batalkan Perubahan',
                  style: TextStyle(
                    color: kPinkDark,
                    fontSize: 12,
                  ),
                ),
              ),
            ),

            // ==========================================
            // KONFIRMASI SIMPAN
            // ==========================================

            if (hasSaved) ...[
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kBorder),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: kPinkDark,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        'Mood $selectedMood berhasil '
                        'dicatat pada '
                        '${formatMoodDate(today)}.',
                        style: const TextStyle(
                          color: kTextDark,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ==========================================
            // SARAN SESUAI MOOD
            // ==========================================

            if (selectedMood != null) ...[
              const SizedBox(height: 27),
              recommendationSection(),
            ],
          ],
        ),
      ),
    );
  }
}
