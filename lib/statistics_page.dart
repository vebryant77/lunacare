
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'mood_page.dart' as mood;
import 'services/period_repository.dart';
import 'services/health_report_service.dart';

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

const Color kOrange = Color(0xFFFFB22E);
const Color kLine = Color(0xFF596579);

const int minCycle = 21;
const int maxCycle = 35;

// ======================================================
// MODEL CYCLE TRENDS
// ======================================================

class CyclePoint {
  final DateTime startDate;
  final int length;

  const CyclePoint({
    required this.startDate,
    required this.length,
  });

  bool get outsideReference {
    return length < minCycle || length > maxCycle;
  }
}

// ======================================================
// PERHITUNGAN PANJANG SIKLUS
// ======================================================

List<CyclePoint> calculateCyclePoints(
  List<PeriodEntry> periods,
) {
  final sorted = List<PeriodEntry>.from(periods)
    ..sort(
      (a, b) =>
          a.startDate.compareTo(b.startDate),
    );

  final result = <CyclePoint>[];

  for (int i = 1; i < sorted.length; i++) {
    final previous = DateTime(
      sorted[i - 1].startDate.year,
      sorted[i - 1].startDate.month,
      sorted[i - 1].startDate.day,
    );

    final current = DateTime(
      sorted[i].startDate.year,
      sorted[i].startDate.month,
      sorted[i].startDate.day,
    );

    final days = current.difference(previous).inDays;

    if (days > 0) {
      result.add(
        CyclePoint(
          startDate: current,
          length: days,
        ),
      );
    }
  }

  return result;
}

// ======================================================
// RATA-RATA SIKLUS
// ======================================================

double? averageCycle(
  List<CyclePoint> cycles,
) {
  if (cycles.isEmpty) return null;

  final total = cycles.fold<int>(
    0,
    (sum, item) => sum + item.length,
  );

  return total / cycles.length;
}

// ======================================================
// DATA DUMMY MENSTRUASI
// ======================================================

final List<PeriodEntry> demoPeriods = [
  PeriodEntry(
    startDate: DateTime(2026, 5, 3),
    endDate: DateTime(2026, 5, 7),
  ),
  PeriodEntry(
    startDate: DateTime(2026, 5, 31),
    endDate: DateTime(2026, 6, 4),
  ),
  PeriodEntry(
    startDate: DateTime(2026, 7, 2),
    endDate: DateTime(2026, 7, 6),
  ),
  PeriodEntry(
    startDate: DateTime(2026, 7, 27),
    endDate: DateTime(2026, 7, 31),
  ),
  PeriodEntry(
    startDate: DateTime(2026, 9, 7),
    endDate: DateTime(2026, 9, 11),
  ),
  PeriodEntry(
    startDate: DateTime(2026, 10, 6),
    endDate: DateTime(2026, 10, 10),
  ),
  PeriodEntry(
    startDate: DateTime(2026, 11, 4),
    endDate: DateTime(2026, 11, 8),
  ),
];

// ======================================================
// DATA DUMMY MOOD
// ======================================================

final List<mood.MoodRecord> demoMoods = [
  mood.MoodRecord(
    date: DateTime(2026, 11, 8),
    mood: 'Senang',
    note: 'Hari yang menyenangkan.',
  ),
  mood.MoodRecord(
    date: DateTime(2026, 11, 9),
    mood: 'Tenang',
    note: 'Beristirahat dengan cukup.',
  ),
  mood.MoodRecord(
    date: DateTime(2026, 11, 10),
    mood: 'Senang',
    note: 'Aktivitas berjalan lancar.',
  ),
  mood.MoodRecord(
    date: DateTime(2026, 11, 11),
    mood: 'Biasa',
    note: 'Hari berjalan seperti biasa.',
  ),
  mood.MoodRecord(
    date: DateTime(2026, 11, 12),
    mood: 'Lelah',
    note: 'Banyak aktivitas hari ini.',
  ),
  mood.MoodRecord(
    date: DateTime(2026, 11, 13),
    mood: 'Sedih',
    note: 'Sedang tidak bersemangat.',
  ),
  mood.MoodRecord(
    date: DateTime(2026, 11, 14),
    mood: 'Senang',
    note: 'Berkumpul bersama teman.',
  ),
  mood.MoodRecord(
    date: DateTime(2026, 11, 15),
    mood: 'Cemas',
    note: 'Memikirkan beberapa tugas.',
  ),
  mood.MoodRecord(
    date: DateTime(2026, 11, 16),
    mood: 'Tenang',
    note: 'Merasa lebih santai.',
  ),
  mood.MoodRecord(
    date: DateTime(2026, 11, 17),
    mood: 'Sedih',
    note: 'Suasana hati kurang baik.',
  ),
  mood.MoodRecord(
    date: DateTime(2026, 11, 18),
    mood: 'Lelah',
    note: 'Perlu banyak istirahat.',
  ),
  mood.MoodRecord(
    date: DateTime(2026, 11, 19),
    mood: 'Senang',
    note: 'Suasana hati membaik.',
  ),
];

// ======================================================
// FORMAT TANGGAL
// ======================================================

String statsDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  return '${date.day} '
      '${months[date.month - 1]} '
      '${date.year}';
}

// ======================================================
// STATISTICS PAGE
// ======================================================

class StatisticsPage extends StatefulWidget {
  final DateTime? periodStart;
  final DateTime? periodEnd;

  const StatisticsPage({
    super.key,
    this.periodStart,
    this.periodEnd,
  });

  @override
  State<StatisticsPage> createState() {
    return _StatisticsPageState();
  }
}

class _StatisticsPageState extends State<StatisticsPage> {
  final repository = PeriodRepository.instance;

  List<PeriodEntry> savedPeriods = [];

  bool loading = true;
  bool showDemoData = true;
  bool generatingPdf = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // ====================================================
  // AMBIL DATA REPOSITORY
  // ====================================================

  Future<void> loadData() async {
    try {
      final result = await repository.getPeriods();

      if (!mounted) return;

      setState(() {
        savedPeriods = result;
        loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal membaca riwayat: $error',
          ),
        ),
      );
    }
  }

  // ====================================================
  // UNDUH HEALTH REPORT PDF
  // ====================================================

  Future<void> downloadHealthReport() async {
    if (generatingPdf) return;

    setState(() {
      generatingPdf = true;
    });

    try {
      // Baca data repository terbaru.
      final latestPeriods =
          await repository.getPeriods();

      if (!mounted) return;

      savedPeriods = latestPeriods;

      final periods = showDemoData
          ? List<PeriodEntry>.from(demoPeriods)
          : List<PeriodEntry>.from(latestPeriods);

      final records = showDemoData
          ? List<mood.MoodRecord>.from(demoMoods)
          : mood.moodJournal.records;

      if (periods.isEmpty && records.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Belum ada data untuk dibuat laporan.',
            ),
          ),
        );
        return;
      }

      await HealthReportService.downloadReport(
        periods: periods,
        moodRecords: records,
        isDemoData: showDemoData,
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal membuat laporan PDF: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          generatingPdf = false;
        });
      }
    }
  }

  // ====================================================
  // CARD UMUM
  // ====================================================

  Widget card(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: kBorder,
        ),
      ),
      child: child,
    );
  }

  Widget sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: kTextDark,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // ====================================================
  // RINGKASAN
  // ====================================================

  Widget summaryCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 118,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: kPinkDark,
            size: 24,
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              color: kTextSoft,
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            value,
            style: const TextStyle(
              color: kTextDark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================
  // LEGENDA GRAFIK
  // ====================================================

  Widget legend(
    Color color,
    String label,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 6),

        Text(
          label,
          style: const TextStyle(
            color: kTextSoft,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  // ====================================================
  // HITUNG FREKUENSI MOOD
  // ====================================================

  Map<String, int> countMoods(
    List<mood.MoodRecord> records,
  ) {
    final counts = <String, int>{};

    for (final option in mood.moodOptions) {
      counts[option.name] = 0;
    }

    for (final record in records) {
      counts[record.mood] =
          (counts[record.mood] ?? 0) + 1;
    }

    return counts;
  }

  // ====================================================
  // MOOD TERBANYAK
  // ====================================================

  String topMood(Map<String, int> counts) {
    if (counts.isEmpty) return '-';

    final maximum = counts.values.reduce(math.max);

    if (maximum == 0) return '-';

    final names = counts.entries
        .where((item) => item.value == maximum)
        .map((item) => item.key)
        .toList();

    return names.length > 1
        ? 'Seri'
        : names.first;
  }

  // ====================================================
  // GRAFIK BATANG MOOD
  // ====================================================

  Widget moodBar(
    String name,
    int count,
    int maximum,
  ) {
    final fraction =
        maximum == 0 ? 0.0 : count / maximum;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              name,
              style: const TextStyle(
                color: kTextDark,
                fontSize: 11,
              ),
            ),
          ),

          Expanded(
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(7),
              child: SizedBox(
                height: 13,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: kPinkLight,
                    ),

                    FractionallySizedBox(
                      alignment:
                          Alignment.centerLeft,
                      widthFactor: fraction,
                      child: Container(
                        color: kPinkDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 24,
            child: Text(
              '$count',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: kTextDark,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================
  // HAPUS MOOD
  // ====================================================

  Future<void> deleteMood(
    mood.MoodRecord record,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Hapus Catatan Mood?',
          ),
          content: Text(
            'Hapus catatan pada '
            '${mood.formatMoodDate(record.date)}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Batal'),
            ),

            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      mood.moodJournal.delete(record.date);
    }
  }

  // ====================================================
  // RIWAYAT MOOD
  // ====================================================

  Widget moodHistory(
    mood.MoodRecord record,
  ) {
    String emoji = '🙂';

    for (final option in mood.moodOptions) {
      if (option.name == record.mood) {
        emoji = option.emoji;
        break;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: card(
        Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: kPinkLight,
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child: Text(
                emoji,
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    record.mood,
                    style: const TextStyle(
                      color: kTextDark,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    mood.formatMoodDate(record.date),
                    style: const TextStyle(
                      color: kTextSoft,
                      fontSize: 11,
                    ),
                  ),

                  if (record.note.isNotEmpty) ...[
                    const SizedBox(height: 7),

                    Text(
                      record.note,
                      style: const TextStyle(
                        color: kTextDark,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            if (!showDemoData)
              IconButton(
                tooltip: 'Hapus catatan',
                onPressed: () {
                  deleteMood(record);
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: kTextSoft,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ====================================================
  // CARD DOWNLOAD PDF
  // ====================================================

  Widget downloadCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: kPinkLight,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: kPink.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_outlined,
                  color: kPinkDark,
                  size: 26,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Health Report',
                      style: TextStyle(
                        color: kTextDark,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      'Laporan kesehatan '
                      'menstruasi dan mood',
                      style: TextStyle(
                        color: kTextSoft,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          const Text(
            'Laporan mencakup:',
            style: TextStyle(
              color: kTextDark,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            '• Ringkasan siklus menstruasi\n'
            '• Grafik Cycle Trends\n'
            '• Riwayat menstruasi\n'
            '• Distribusi dan riwayat mood',
            style: TextStyle(
              color: kTextDark,
              fontSize: 12,
              height: 1.7,
            ),
          ),

          const SizedBox(height: 17),

          SizedBox(
            width: double.infinity,
            height: 49,
            child: FilledButton.icon(
              onPressed: generatingPdf
                  ? null
                  : downloadHealthReport,
              icon: generatingPdf
                  ? const SizedBox(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.file_download_outlined,
                    ),
              label: Text(
                generatingPdf
                    ? 'Membuat PDF...'
                    : 'Unduh Health Report (PDF)',
              ),
              style: FilledButton.styleFrom(
                backgroundColor: kPinkDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(11),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'PDF akan dibuka melalui dialog '
            'simpan atau cetak pada perangkatmu.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kTextSoft,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================
  // BUILD
  // ====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,

      appBar: AppBar(
        backgroundColor: kBackground,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Statistik & Riwayat',
          style: TextStyle(
            color: kTextDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: kPink,
              ),
            )
          : AnimatedBuilder(
              animation: mood.moodJournal,
              builder: (context, _) {
                // =====================================
                // SUMBER DATA MENSTRUASI
                // =====================================

                final periods = showDemoData
                    ? List<PeriodEntry>.from(
                        demoPeriods,
                      )
                    : List<PeriodEntry>.from(
                        savedPeriods,
                      );

                periods.sort(
                  (a, b) => a.startDate.compareTo(
                    b.startDate,
                  ),
                );

                final cycles = calculateCyclePoints(
                  periods,
                );

                final average = averageCycle(cycles);

                final latest = periods.isEmpty
                    ? null
                    : periods.last;

                final recentCycles = cycles.length > 6
                    ? cycles.sublist(
                        cycles.length - 6,
                      )
                    : cycles;

                // =====================================
                // SUMBER DATA MOOD
                // =====================================

                final records = showDemoData
                    ? List<mood.MoodRecord>.from(
                        demoMoods,
                      )
                    : mood.moodJournal.records;

                records.sort(
                  (a, b) => b.date.compareTo(
                    a.date,
                  ),
                );

                final counts = countMoods(
                  records,
                );

                int maxMoodCount = 0;

                for (final value in counts.values) {
                  maxMoodCount = math.max(
                    maxMoodCount,
                    value,
                  );
                }

                return RefreshIndicator(
                  color: kPink,
                  onRefresh: loadData,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      15,
                      20,
                      36,
                    ),
                    children: [
                      // ================================
                      // HEADER
                      // ================================

                      const Text(
                        'Pantau Perkembanganmu',
                        style: TextStyle(
                          color: kTextDark,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        'Lihat perkembangan siklus '
                        'menstruasi dan suasana hati.',
                        style: TextStyle(
                          color: kTextSoft,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ================================
                      // MODE DEMO
                      // ================================

                      card(
                        Row(
                          children: [
                            const Icon(
                              Icons.science_outlined,
                              color: kPinkDark,
                            ),

                            const SizedBox(width: 10),

                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tampilkan Data Contoh',
                                    style: TextStyle(
                                      color: kTextDark,
                                      fontSize: 12,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),

                                  SizedBox(height: 4),

                                  Text(
                                    'Mode presentasi',
                                    style: TextStyle(
                                      color: kTextSoft,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Switch(
                              value: showDemoData,
                              activeThumbColor: kPinkDark,
                              onChanged: (value) {
                                setState(() {
                                  showDemoData = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        showDemoData
                            ? 'Mode demo aktif. '
                              'Data di bawah merupakan simulasi.'
                            : 'Mode repository aktif. '
                              'Saat ini repository masih '
                              'menggunakan data dummy.',
                        style: const TextStyle(
                          color: kTextSoft,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 27),

                      // ================================
                      // RINGKASAN MENSTRUASI
                      // ================================

                      sectionTitle(
                        'Ringkasan Menstruasi',
                      ),

                      const SizedBox(height: 13),

                      Row(
                        children: [
                          Expanded(
                            child: summaryCard(
                              title: 'Rata-rata Siklus',
                              value: average == null
                                  ? '-'
                                  : '${average.toStringAsFixed(1).replaceAll('.', ',')} hari',
                              icon: Icons.autorenew,
                            ),
                          ),

                          const SizedBox(width: 11),

                          Expanded(
                            child: summaryCard(
                              title: 'Durasi Haid Terakhir',
                              value: latest?.duration == null
                                  ? '-'
                                  : '${latest!.duration} hari',
                              icon:
                                  Icons.water_drop_outlined,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 27),

                      // ================================
                      // CYCLE TRENDS
                      // ================================

                      Row(
                        children: [
                          Expanded(
                            child: sectionTitle(
                              'Cycle Trends',
                            ),
                          ),

                          const Icon(
                            Icons.insights_outlined,
                            color: kPinkDark,
                          ),
                        ],
                      ),

                      const SizedBox(height: 13),

                      card(
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tren Siklus Menstruasi',
                              style: TextStyle(
                                color: kTextDark,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              '${cycles.length} siklus tercatat',
                              style: const TextStyle(
                                color: kTextSoft,
                                fontSize: 11,
                              ),
                            ),

                            const SizedBox(height: 20),

                            if (cycles.isEmpty)
                              const SizedBox(
                                height: 210,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.show_chart,
                                        color: kPinkDark,
                                        size: 36,
                                      ),

                                      SizedBox(height: 10),

                                      Text(
                                        'Belum Cukup Data',
                                        style: TextStyle(
                                          color: kTextDark,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),

                                      SizedBox(height: 8),

                                      Text(
                                        'Dibutuhkan minimal '
                                        'dua tanggal mulai menstruasi.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: kTextSoft,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else ...[
                              SizedBox(
                                width: double.infinity,
                                height: 240,
                                child: CustomPaint(
                                  painter: CycleTrendPainter(
                                    cycles: recentCycles,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              Wrap(
                                spacing: 15,
                                runSpacing: 8,
                                children: [
                                  legend(
                                    kLine,
                                    'Dalam rentang',
                                  ),

                                  legend(
                                    kOrange,
                                    'Di luar acuan',
                                  ),
                                ],
                              ),
                            ],

                            const SizedBox(height: 17),

                            const Divider(
                              color: kBorder,
                            ),

                            const SizedBox(height: 12),

                            const Text(
                              'Panjang siklus dihitung '
                              'dari tanggal mulai menstruasi '
                              'ke tanggal mulai menstruasi '
                              'berikutnya.',
                              style: TextStyle(
                                color: kTextDark,
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'Area abu-abu menunjukkan '
                              'rentang acuan umum '
                              '21-35 hari untuk orang dewasa. '
                              'Penanda oranye bukan diagnosis.',
                              style: TextStyle(
                                color: kTextSoft,
                                fontSize: 11,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 27),

                      // ================================
                      // RIWAYAT SIKLUS
                      // ================================

                      sectionTitle('Riwayat Siklus'),

                      const SizedBox(height: 12),

                      if (cycles.isEmpty)
                        card(
                          const Text(
                            'Belum ada panjang siklus '
                            'yang bisa dihitung.',
                            style: TextStyle(
                              color: kTextSoft,
                              fontSize: 12,
                            ),
                          ),
                        )
                      else
                        ...cycles.reversed.take(6).map(
                          (cycle) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: card(
                                Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      alignment:
                                          Alignment.center,
                                      decoration: BoxDecoration(
                                        color:
                                            cycle.outsideReference
                                                ? const Color(
                                                    0xFFFFF3D9,
                                                  )
                                                : kPinkLight,
                                        borderRadius:
                                            BorderRadius.circular(
                                          11,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons
                                            .calendar_month_outlined,
                                        color:
                                            cycle.outsideReference
                                                ? const Color(
                                                    0xFFE19C19,
                                                  )
                                                : kPinkDark,
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${cycle.length} hari',
                                            style:
                                                const TextStyle(
                                              color: kTextDark,
                                              fontSize: 14,
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 5,
                                          ),

                                          Text(
                                            statsDate(
                                              cycle.startDate,
                                            ),
                                            style:
                                                const TextStyle(
                                              color: kTextSoft,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    if (cycle.outsideReference)
                                      const Icon(
                                        Icons.info_outline,
                                        color: kOrange,
                                        size: 20,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                      const SizedBox(height: 27),

                      // ================================
                      // STATISTIK MOOD
                      // ================================

                      const Divider(
                        color: kBorder,
                      ),

                      const SizedBox(height: 20),

                      sectionTitle(
                        'Statistik Mood',
                      ),

                      const SizedBox(height: 13),

                      Row(
                        children: [
                          Expanded(
                            child: summaryCard(
                              title: 'Total Catatan',
                              value:
                                  '${records.length} hari',
                              icon:
                                  Icons.edit_calendar_outlined,
                            ),
                          ),

                          const SizedBox(width: 11),

                          Expanded(
                            child: summaryCard(
                              title: 'Mood Terbanyak',
                              value: topMood(
                                counts,
                              ),
                              icon: Icons.mood_outlined,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 27),

                      sectionTitle(
                        'Distribusi Mood',
                      ),

                      const SizedBox(height: 12),

                      card(
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            if (records.isEmpty)
                              const Padding(
                                padding:
                                    EdgeInsets.only(
                                  bottom: 15,
                                ),
                                child: Text(
                                  'Belum ada catatan mood.',
                                  style: TextStyle(
                                    color: kTextSoft,
                                    fontSize: 12,
                                  ),
                                ),
                              ),

                            ...mood.moodOptions.map(
                              (option) => moodBar(
                                option.name,
                                counts[option.name] ?? 0,
                                maxMoodCount,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 26),

                      Row(
                        children: [
                          Expanded(
                            child: sectionTitle(
                              'Riwayat Mood',
                            ),
                          ),

                          Text(
                            '${records.length} catatan',
                            style: const TextStyle(
                              color: kTextSoft,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      if (records.isEmpty)
                        card(
                          const Text(
                            'Belum ada riwayat mood.',
                            style: TextStyle(
                              color: kTextSoft,
                              fontSize: 12,
                            ),
                          ),
                        )
                      else
                        ...records.take(8).map(
                          moodHistory,
                        ),

                      const SizedBox(height: 30),

                      // ================================
                      // FITUR PREMIUM GRATIS
                      // ================================

                      const Divider(
                        color: kBorder,
                      ),

                      const SizedBox(height: 20),

                      sectionTitle(
                        'Laporan Kesehatan',
                      ),

                      const SizedBox(height: 13),

                      downloadCard(),

                      const SizedBox(height: 20),

                      const Text(
                        'Fitur Health Report tersedia '
                        'gratis di LunaCare. '
                        'Pada versi demo ini, data '
                        'menstruasi belum disimpan '
                        'permanen dan data mood '
                        'masih tersimpan sementara.',
                        style: TextStyle(
                          color: kTextSoft,
                          fontSize: 11,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// ======================================================
// CUSTOM PAINTER CYCLE TRENDS
// ======================================================

class CycleTrendPainter extends CustomPainter {
  final List<CyclePoint> cycles;

  CycleTrendPainter({
    required this.cycles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (cycles.isEmpty) return;

    const double left = 35;
    const double right = 18;
    const double top = 34;
    const double bottom = 45;

    final plotWidth =
        size.width - left - right;

    final plotHeight =
        size.height - top - bottom;

    if (plotWidth <= 0 || plotHeight <= 0) {
      return;
    }

    final minValue = cycles
        .map((item) => item.length)
        .reduce(math.min);

    final maxValue = cycles
        .map((item) => item.length)
        .reduce(math.max);

    final yMin =
        math.min(15, minValue - 5).toDouble();

    final yMax =
        math.max(45, maxValue + 5).toDouble();

    double getY(double days) {
      return top +
          (yMax - days) /
              (yMax - yMin) *
              plotHeight;
    }

    double getX(int index) {
      if (cycles.length == 1) {
        return left + plotWidth / 2;
      }

      return left +
          index * plotWidth /
              (cycles.length - 1);
    }

    // ==================================================
    // AREA ACUAN
    // ==================================================

    canvas.drawRect(
      Rect.fromLTRB(
        left,
        getY(maxCycle.toDouble()),
        size.width - right,
        getY(minCycle.toDouble()),
      ),
      Paint()
        ..color = const Color(
          0xFFF0F1F3,
        ),
    );

    // ==================================================
    // GRID HORIZONTAL
    // ==================================================

    for (int day = 15; day <= 60; day += 5) {
      if (day < yMin || day > yMax) {
        continue;
      }

      final y = getY(day.toDouble());

      canvas.drawLine(
        Offset(left, y),
        Offset(size.width - right, y),
        Paint()
          ..color = const Color(
            0xFFE5E5E8,
          )
          ..strokeWidth = 1,
      );

      paintText(
        canvas,
        '$day',
        Offset(4, y - 7),
        color: kTextSoft,
        fontSize: 10,
      );
    }

    final points = <Offset>[];

    for (int i = 0; i < cycles.length; i++) {
      points.add(
        Offset(
          getX(i),
          getY(
            cycles[i].length.toDouble(),
          ),
        ),
      );
    }

    // ==================================================
    // GRID VERTIKAL
    // ==================================================

    for (final point in points) {
      canvas.drawLine(
        Offset(point.dx, top),
        Offset(
          point.dx,
          size.height - bottom,
        ),
        Paint()
          ..color = const Color(
            0xFFEEEEF0,
          )
          ..strokeWidth = 1,
      );
    }

    // ==================================================
    // GARIS MELENGKUNG
    // ==================================================

    if (points.length > 1) {
      final path = Path()
        ..moveTo(
          points.first.dx,
          points.first.dy,
        );

      for (int i = 1;
          i < points.length;
          i++) {
        final previous = points[i - 1];
        final current = points[i];

        final middleX =
            (previous.dx + current.dx) / 2;

        path.cubicTo(
          middleX,
          previous.dy,
          middleX,
          current.dy,
          current.dx,
          current.dy,
        );
      }

      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(
            0xFFAEB3BE,
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    // ==================================================
    // TITIK GRAFIK
    // ==================================================

    for (int i = 0;
        i < points.length;
        i++) {
      final point = points[i];
      final cycle = cycles[i];

      final outside =
          cycle.outsideReference;

      if (outside) {
        canvas.drawCircle(
          point,
          20,
          Paint()
            ..color = kOrange.withValues(
              alpha: 0.18,
            ),
        );

        canvas.drawCircle(
          point,
          12,
          Paint()
            ..color = kOrange.withValues(
              alpha: 0.27,
            ),
        );
      }

      canvas.drawCircle(
        point,
        8,
        Paint()
          ..color = Colors.white,
      );

      canvas.drawCircle(
        point,
        5.4,
        Paint()
          ..color = outside
              ? kOrange
              : kLine,
      );

      // NILAI PANJANG SIKLUS
      final labelY =
          point.dy < top + 18
              ? point.dy + 12
              : point.dy - 29;

      paintCenteredText(
        canvas,
        '${cycle.length}',
        Offset(point.dx, labelY),
        color: outside
            ? const Color(0xFFE19C19)
            : kTextDark,
        fontSize: 11,
        bold: true,
      );

      // TANGGAL SUMBU X
      paintCenteredText(
        canvas,
        '${cycle.startDate.day}/'
        '${cycle.startDate.month}',
        Offset(
          point.dx,
          size.height - bottom + 17,
        ),
        color: kTextSoft,
        fontSize: 10,
      );
    }
  }

  // ====================================================
  // HELPER TEKS
  // ====================================================

  void paintText(
    Canvas canvas,
    String value,
    Offset offset, {
    Color color = kTextDark,
    double fontSize = 11,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();
    painter.paint(canvas, offset);
  }

  void paintCenteredText(
    Canvas canvas,
    String value,
    Offset offset, {
    Color color = kTextDark,
    double fontSize = 11,
    bool bold = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: bold
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();

    painter.paint(
      canvas,
      Offset(
        offset.dx - painter.width / 2,
        offset.dy,
      ),
    );
  }

  @override
  bool shouldRepaint(
    covariant CycleTrendPainter oldDelegate,
  ) {
    return true;
  }
}
