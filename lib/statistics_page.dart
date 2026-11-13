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
// STATISTICS PAGE
// ======================================================

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,

      // ==================================================
      // APP BAR
      // ==================================================

      appBar: AppBar(
        backgroundColor: kBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: kTextDark,
            size: 20,
          ),
        ),

        title: const Text(
          'Statistik & Riwayat',
          style: TextStyle(
            color: kTextDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ==================================================
      // BODY
      // ==================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          35,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // SUBTITLE
            // ==================================================

            const Text(
              'Ringkasan data kesehatanmu',
              style: TextStyle(
                color: kTextDark,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Data sementara berdasarkan beberapa siklus terakhir.',
              style: TextStyle(
                color: kTextSoft,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 22),

            // ==================================================
            // SUMMARY
            // ==================================================

            const Row(
              children: [
                Expanded(
                  child: StatisticBox(
                    icon: Icons.calendar_month_outlined,
                    value: '28',
                    unit: 'hari',
                    label: 'Rata-rata Siklus',
                  ),
                ),

                SizedBox(width: 10),

                Expanded(
                  child: StatisticBox(
                    icon: Icons.water_drop_outlined,
                    value: '5',
                    unit: 'hari',
                    label: 'Durasi Haid',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            const Row(
              children: [
                Expanded(
                  child: StatisticBox(
                    icon: Icons.mood_outlined,
                    value: 'Tenang',
                    unit: '',
                    label: 'Mood Terakhir',
                  ),
                ),

                SizedBox(width: 10),

                Expanded(
                  child: StatisticBox(
                    icon: Icons.health_and_safety_outlined,
                    value: 'Kram',
                    unit: '',
                    label: 'Gejala Terakhir',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ==================================================
            // GRAFIK SIKLUS
            // ==================================================

            const Text(
              'Panjang Siklus',
              style: TextStyle(
                color: kTextDark,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Perbandingan tiga siklus terakhir',
              style: TextStyle(
                color: kTextSoft,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: kBorder,
                ),
              ),
              child: const Column(
                children: [
                  CycleProgress(
                    month: 'Agustus',
                    days: 27,
                    progress: 0.77,
                  ),

                  SizedBox(height: 18),

                  CycleProgress(
                    month: 'September',
                    days: 29,
                    progress: 0.83,
                  ),

                  SizedBox(height: 18),

                  CycleProgress(
                    month: 'Oktober',
                    days: 28,
                    progress: 0.80,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // MOOD
            // ==================================================

            const Text(
              'Mood Tercatat',
              style: TextStyle(
                color: kTextDark,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Contoh ringkasan mood dalam 7 hari terakhir',
              style: TextStyle(
                color: kTextSoft,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: kBorder,
                ),
              ),
              child: const Column(
                children: [
                  MoodRow(
                    icon: Icons.sentiment_very_satisfied_outlined,
                    mood: 'Senang',
                    count: '3 hari',
                  ),

                  Divider(
                    height: 25,
                    color: kBorder,
                  ),

                  MoodRow(
                    icon: Icons.sentiment_satisfied_outlined,
                    mood: 'Tenang',
                    count: '2 hari',
                  ),

                  Divider(
                    height: 25,
                    color: kBorder,
                  ),

                  MoodRow(
                    icon: Icons.sentiment_neutral_outlined,
                    mood: 'Biasa',
                    count: '1 hari',
                  ),

                  Divider(
                    height: 25,
                    color: kBorder,
                  ),

                  MoodRow(
                    icon: Icons.sentiment_dissatisfied_outlined,
                    mood: 'Sedih',
                    count: '1 hari',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // GEJALA
            // ==================================================

            const Text(
              'Gejala yang Sering Dirasakan',
              style: TextStyle(
                color: kTextDark,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SymptomTag(
                  text: 'Kram',
                  count: '4x',
                ),

                SymptomTag(
                  text: 'Kembung',
                  count: '3x',
                ),

                SymptomTag(
                  text: 'Pegal',
                  count: '2x',
                ),

                SymptomTag(
                  text: 'Sakit Kepala',
                  count: '2x',
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ==================================================
            // RIWAYAT MENSTRUASI
            // ==================================================

            const Row(
              children: [
                Text(
                  'Riwayat Menstruasi',
                  style: TextStyle(
                    color: kTextDark,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Spacer(),

                Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: kPinkDark,
                    fontSize: 11,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            const HistoryItem(
              month: 'Oktober 2026',
              date: '1 - 5 Oktober 2026',
              duration: '5 hari',
            ),

            const SizedBox(height: 9),

            const HistoryItem(
              month: 'September 2026',
              date: '3 - 7 September 2026',
              duration: '5 hari',
            ),

            const SizedBox(height: 9),

            const HistoryItem(
              month: 'Agustus 2026',
              date: '5 - 9 Agustus 2026',
              duration: '5 hari',
            ),

            const SizedBox(height: 28),

            // ==================================================
            // KETERANGAN
            // ==================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
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
                    size: 19,
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      'Data statistik pada versi ini masih menggunakan data contoh. Integrasi dengan data pengguna akan dikembangkan pada tahap berikutnya.',
                      style: TextStyle(
                        color: kTextSoft,
                        fontSize: 11,
                        height: 1.4,
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

// ======================================================
// STATISTIC BOX
// ======================================================

class StatisticBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;
  final String label;

  const StatisticBox({
    super.key,
    required this.icon,
    required this.value,
    required this.unit,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: kPinkDark,
            size: 23,
          ),

          const Spacer(),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: kTextDark,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),

                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 2,
                  ),
                  child: Text(
                    unit,
                    style: const TextStyle(
                      color: kTextSoft,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 4),

          Text(
            label,
            style: const TextStyle(
              color: kTextSoft,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// CYCLE PROGRESS
// ======================================================

class CycleProgress extends StatelessWidget {
  final String month;
  final int days;
  final double progress;

  const CycleProgress({
    super.key,
    required this.month,
    required this.days,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              month,
              style: const TextStyle(
                color: kTextDark,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),

            const Spacer(),

            Text(
              '$days hari',
              style: const TextStyle(
                color: kTextSoft,
                fontSize: 11,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: kPinkLight,
            valueColor:
                const AlwaysStoppedAnimation<Color>(
              kPink,
            ),
          ),
        ),
      ],
    );
  }
}

// ======================================================
// MOOD ROW
// ======================================================

class MoodRow extends StatelessWidget {
  final IconData icon;
  final String mood;
  final String count;

  const MoodRow({
    super.key,
    required this.icon,
    required this.mood,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: kPinkDark,
          size: 24,
        ),

        const SizedBox(width: 12),

        Text(
          mood,
          style: const TextStyle(
            color: kTextDark,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),

        const Spacer(),

        Text(
          count,
          style: const TextStyle(
            color: kTextSoft,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// ======================================================
// SYMPTOM TAG
// ======================================================

class SymptomTag extends StatelessWidget {
  final String text;
  final String count;

  const SymptomTag({
    super.key,
    required this.text,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: kBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: kTextDark,
              fontSize: 11,
            ),
          ),

          const SizedBox(width: 7),

          Text(
            count,
            style: const TextStyle(
              color: kPinkDark,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// HISTORY ITEM
// ======================================================

class HistoryItem extends StatelessWidget {
  final String month;
  final String date;
  final String duration;

  const HistoryItem({
    super.key,
    required this.month,
    required this.date,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: kPinkLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.calendar_today_outlined,
              color: kPinkDark,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  month,
                  style: const TextStyle(
                    color: kTextDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  date,
                  style: const TextStyle(
                    color: kTextSoft,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          Text(
            duration,
            style: const TextStyle(
              color: kPinkDark,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}