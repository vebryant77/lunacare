
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../mood_page.dart' as mood;
import 'period_repository.dart';

// ======================================================
// MODEL SIKLUS UNTUK LAPORAN
// ======================================================

class ReportCycle {
  final DateTime previousStart;
  final DateTime currentStart;
  final int days;

  const ReportCycle({
    required this.previousStart,
    required this.currentStart,
    required this.days,
  });

  bool get outsideReference => days < 21 || days > 35;
}

// ======================================================
// HEALTH REPORT SERVICE
// ======================================================

class HealthReportService {
  HealthReportService._();

  static const PdfColor pink =
      PdfColor(0.85, 0.49, 0.62);

  static const PdfColor darkPink =
      PdfColor(0.78, 0.37, 0.53);

  static const PdfColor lightPink =
      PdfColor(1.0, 0.93, 0.96);

  static const PdfColor darkText =
      PdfColor(0.28, 0.23, 0.26);

  static const PdfColor softText =
      PdfColor(0.52, 0.48, 0.50);

  static const PdfColor gray =
      PdfColor(0.92, 0.92, 0.94);

  static const PdfColor navy =
      PdfColor(0.30, 0.37, 0.48);

  static const PdfColor orange =
      PdfColor(1.0, 0.69, 0.18);

  // ====================================================
  // FORMAT TANGGAL
  // ====================================================

  static String formatDate(DateTime date) {
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

  // ====================================================
  // HITUNG PANJANG SIKLUS
  // ====================================================

  static List<ReportCycle> getCycles(
    List<PeriodEntry> periods,
  ) {
    final sorted = List<PeriodEntry>.from(periods)
      ..sort(
        (a, b) => a.startDate.compareTo(b.startDate),
      );

    final result = <ReportCycle>[];

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
          ReportCycle(
            previousStart: previous,
            currentStart: current,
            days: days,
          ),
        );
      }
    }

    return result;
  }

  // ====================================================
  // RATA-RATA SIKLUS
  // ====================================================

  static double? getAverageCycle(
    List<ReportCycle> cycles,
  ) {
    if (cycles.isEmpty) return null;

    final total = cycles.fold<int>(
      0,
      (sum, item) => sum + item.days,
    );

    return total / cycles.length;
  }

  // ====================================================
  // HITUNG MOOD
  // ====================================================

  static Map<String, int> countMoods(
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

  static String getTopMood(
    Map<String, int> counts,
  ) {
    if (counts.isEmpty) return '-';

    final highest = counts.values.reduce(math.max);

    if (highest == 0) return '-';

    final names = counts.entries
        .where((entry) => entry.value == highest)
        .map((entry) => entry.key)
        .toList();

    return names.length > 1 ? 'Seri' : names.first;
  }

  // ====================================================
  // KOMPONEN JUDUL BAGIAN PDF
  // ====================================================

  static pw.Widget sectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(
        top: 16,
        bottom: 9,
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          color: darkText,
        ),
      ),
    );
  }

  // ====================================================
  // KOMPONEN KARTU RINGKASAN PDF
  // ====================================================

  static pw.Widget summaryCard(
    String label,
    String value,
  ) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(13),
        decoration: pw.BoxDecoration(
          color: lightPink,
          borderRadius: pw.BorderRadius.circular(9),
        ),
        child: pw.Column(
          crossAxisAlignment:
              pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label,
              style: const pw.TextStyle(
                fontSize: 9,
                color: softText,
              ),
            ),

            pw.SizedBox(height: 7),

            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 17,
                fontWeight: pw.FontWeight.bold,
                color: darkPink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ====================================================
  // TABEL PDF
  // ====================================================

  static pw.Widget reportTable({
    required List<String> headers,
    required List<List<String>> rows,
  }) {
    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: rows,
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontSize: 9,
        fontWeight: pw.FontWeight.bold,
      ),
      headerDecoration: const pw.BoxDecoration(
        color: darkPink,
      ),
      cellStyle: const pw.TextStyle(
        color: darkText,
        fontSize: 9,
      ),
      cellPadding: const pw.EdgeInsets.all(7),
      border: pw.TableBorder.all(
        color: gray,
        width: 0.5,
      ),
      oddRowDecoration: const pw.BoxDecoration(
        color: PdfColor(0.98, 0.97, 0.98),
      ),
    );
  }

  // ====================================================
  // GRAFIK GARIS CYCLE TRENDS DALAM PDF
  // ====================================================

  static pw.Widget cycleChart(
    List<ReportCycle> cycles,
  ) {
    if (cycles.isEmpty) {
      return pw.Container(
        padding: const pw.EdgeInsets.all(18),
        child: pw.Text(
          'Belum cukup data untuk menampilkan '
          'grafik tren siklus.',
          style: const pw.TextStyle(
            fontSize: 10,
            color: softText,
          ),
        ),
      );
    }

    final recent = cycles.length > 6
        ? cycles.sublist(cycles.length - 6)
        : cycles;

    final minValue = recent
        .map((item) => item.days)
        .reduce(math.min);

    final maxValue = recent
        .map((item) => item.days)
        .reduce(math.max);

    final double yMin =
        math.min(15, minValue - 5).toDouble();

    final double yMax =
        math.max(45, maxValue + 5).toDouble();

    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: gray,
          width: 0.7,
        ),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          pw.CustomPaint(
            size: const PdfPoint(470, 160),
            painter: (canvas, size) {
              const double left = 15;
              const double right = 15;
              const double bottom = 14;
              const double top = 14;

              final width =
                  size.x - left - right;

              final height =
                  size.y - bottom - top;

              // PDF menggunakan sumbu Y dari bawah.
              double getY(double days) {
                return bottom +
                    ((days - yMin) / (yMax - yMin)) *
                        height;
              }

              double getX(int index) {
                if (recent.length == 1) {
                  return left + width / 2;
                }

                return left +
                    index * width /
                        (recent.length - 1);
              }

              // AREA ACUAN 21-35 HARI
              canvas.setFillColor(gray);
              canvas.drawRect(
                left,
                getY(21),
                width,
                getY(35) - getY(21),
              );
              canvas.fillPath();

              // GRID HORIZONTAL
              canvas.setStrokeColor(
                const PdfColor(0.85, 0.85, 0.87),
              );
              canvas.setLineWidth(0.5);

              for (int day = 15; day <= 60; day += 5) {
                if (day < yMin || day > yMax) {
                  continue;
                }

                final y = getY(day.toDouble());

                canvas.drawLine(
                  left,
                  y,
                  size.x - right,
                  y,
                );
              }

              final points = <PdfPoint>[];

              for (int i = 0; i < recent.length; i++) {
                points.add(
                  PdfPoint(
                    getX(i),
                    getY(recent[i].days.toDouble()),
                  ),
                );
              }

              // GARIS MELENGKUNG
              if (points.length > 1) {
                canvas.setStrokeColor(navy);
                canvas.setLineWidth(2.4);

                canvas.moveTo(
                  points.first.x,
                  points.first.y,
                );

                for (int i = 1;
                    i < points.length;
                    i++) {
                  final previous = points[i - 1];
                  final current = points[i];

                  final middleX =
                      (previous.x + current.x) / 2;

                  canvas.curveTo(
                    middleX,
                    previous.y,
                    middleX,
                    current.y,
                    current.x,
                    current.y,
                  );
                }

                canvas.strokePath();
              }

              // TITIK DATA
              for (int i = 0;
                  i < points.length;
                  i++) {
                final point = points[i];

                final outside =
                    recent[i].outsideReference;

                if (outside) {
                  canvas.setFillColor(
                    const PdfColor(1.0, 0.91, 0.73),
                  );

                  canvas.drawEllipse(
                    point.x,
                    point.y,
                    12,
                    12,
                  );

                  canvas.fillPath();
                }

                canvas.setFillColor(
                  PdfColors.white,
                );

                canvas.drawEllipse(
                  point.x,
                  point.y,
                  6.5,
                  6.5,
                );

                canvas.fillPath();

                canvas.setFillColor(
                  outside ? orange : navy,
                );

                canvas.drawEllipse(
                  point.x,
                  point.y,
                  4.5,
                  4.5,
                );

                canvas.fillPath();
              }
            },
          ),

          pw.SizedBox(height: 7),

          pw.Row(
            mainAxisAlignment:
                pw.MainAxisAlignment.spaceBetween,
            children: recent.map((item) {
              return pw.Column(
                children: [
                  pw.Text(
                    '${item.days} hari',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                      color: item.outsideReference
                          ? orange
                          : navy,
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    '${item.currentStart.day}/'
                    '${item.currentStart.month}',
                    style: const pw.TextStyle(
                      fontSize: 8,
                      color: softText,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ====================================================
  // GRAFIK DISTRIBUSI MOOD PDF
  // ====================================================

  static pw.Widget moodDistribution(
    Map<String, int> counts,
  ) {
    int maximum = 0;

    for (final count in counts.values) {
      maximum = math.max(maximum, count);
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(13),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: gray,
          width: 0.7,
        ),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: mood.moodOptions.map((option) {
          final value = counts[option.name] ?? 0;

          final double barWidth = maximum == 0
              ? 0.0
              : (value / maximum) * 250;

          return pw.Padding(
            padding: const pw.EdgeInsets.only(
              bottom: 9,
            ),
            child: pw.Row(
              children: [
                pw.SizedBox(
                  width: 88,
                  child: pw.Text(
                    option.name,
                    style: const pw.TextStyle(
                      fontSize: 9,
                      color: darkText,
                    ),
                  ),
                ),

                pw.Container(
                  width: 250,
                  height: 10,
                  color: lightPink,
                  child: pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Container(
                      width: barWidth,
                      height: 10,
                      color: darkPink,
                    ),
                  ),
                ),

                pw.SizedBox(width: 10),

                pw.Text(
                  '$value',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: darkText,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ====================================================
  // GENERATE PDF
  // ====================================================

  static Future<Uint8List> generatePdf({
    required List<PeriodEntry> periods,
    required List<mood.MoodRecord> moodRecords,
    required bool isDemoData,
  }) async {
    final sortedPeriods =
        List<PeriodEntry>.from(periods)
          ..sort(
            (a, b) =>
                a.startDate.compareTo(b.startDate),
          );

    final sortedMoods =
        List<mood.MoodRecord>.from(moodRecords)
          ..sort(
            (a, b) => b.date.compareTo(a.date),
          );

    final cycles = getCycles(sortedPeriods);
    final average = getAverageCycle(cycles);

    final latestPeriod = sortedPeriods.isEmpty
        ? null
        : sortedPeriods.last;

    final counts = countMoods(sortedMoods);
    final topMood = getTopMood(counts);

    final document = pw.Document(
      title: 'LunaCare Health Report',
      author: 'LunaCare',
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        maxPages: 100,

        footer: (context) {
          return pw.Column(
            children: [
              pw.Divider(color: gray),
              pw.Row(
                mainAxisAlignment:
                    pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'LunaCare - Menstrual & Wellness Tracker',
                    style: const pw.TextStyle(
                      color: softText,
                      fontSize: 8,
                    ),
                  ),
                  pw.Text(
                    'Halaman ${context.pageNumber} '
                    'dari ${context.pagesCount}',
                    style: const pw.TextStyle(
                      color: softText,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ],
          );
        },

        build: (context) {
          return [
            // ========================================
            // HEADER PDF
            // ========================================

            pw.Container(
              padding: const pw.EdgeInsets.all(18),
              decoration: pw.BoxDecoration(
                color: lightPink,
                borderRadius:
                    pw.BorderRadius.circular(10),
              ),
              child: pw.Column(
                crossAxisAlignment:
                    pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'LUNACARE',
                    style: pw.TextStyle(
                      color: darkPink,
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 5),

                  pw.Text(
                    'MENSTRUAL & WELLNESS HEALTH REPORT',
                    style: pw.TextStyle(
                      color: darkText,
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 9),

                  pw.Text(
                    'Tanggal laporan: '
                    '${formatDate(DateTime.now())}',
                    style: const pw.TextStyle(
                      color: softText,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 11),

            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(10),
              color: isDemoData
                  ? const PdfColor(1.0, 0.95, 0.85)
                  : const PdfColor(0.95, 0.96, 0.98),
              child: pw.Text(
                isDemoData
                    ? 'DATA SIMULASI - UNTUK '
                      'PENGUJIAN APLIKASI'
                    : 'DATA DARI REPOSITORY APLIKASI',
                style: pw.TextStyle(
                  color: darkText,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),

            pw.SizedBox(height: 8),

            pw.Text(
              'Dokumen ini adalah ringkasan '
              'pencatatan dalam aplikasi LunaCare. '
              'Bukan diagnosis atau surat keterangan medis.',
              style: const pw.TextStyle(
                fontSize: 9,
                color: softText,
              ),
            ),

            // ========================================
            // RINGKASAN MENSTRUASI
            // ========================================

            sectionTitle('1. Ringkasan Menstruasi'),

            pw.Row(
              children: [
                summaryCard(
                  'Rata-rata Siklus',
                  average == null
                      ? '-'
                      : '${average.toStringAsFixed(1)} hari',
                ),

                pw.SizedBox(width: 9),

                summaryCard(
                  'Durasi Haid Terakhir',
                  latestPeriod?.duration == null
                      ? '-'
                      : '${latestPeriod!.duration} hari',
                ),

                pw.SizedBox(width: 9),

                summaryCard(
                  'Siklus Terhitung',
                  '${cycles.length}',
                ),
              ],
            ),

            // ========================================
            // CYCLE TRENDS
            // ========================================

            sectionTitle('2. Cycle Trends'),

            cycleChart(cycles),

            pw.SizedBox(height: 8),

            pw.Text(
              'Panjang siklus dihitung dari '
              'tanggal mulai menstruasi ke '
              'tanggal mulai menstruasi berikutnya. '
              'Rentang acuan umum yang digunakan '
              'adalah 21-35 hari untuk orang dewasa.',
              style: const pw.TextStyle(
                fontSize: 9,
                color: softText,
              ),
            ),

            // ========================================
            // RIWAYAT MENSTRUASI
            // ========================================

            sectionTitle('3. Riwayat Menstruasi'),

            if (sortedPeriods.isEmpty)
              pw.Text(
                'Belum ada catatan menstruasi.',
              )
            else
              reportTable(
                headers: [
                  'Mulai',
                  'Selesai',
                  'Durasi',
                ],
                rows: sortedPeriods.reversed.map((item) {
                  return [
                    formatDate(item.startDate),
                    item.endDate == null
                        ? '-'
                        : formatDate(item.endDate!),
                    item.duration == null
                        ? '-'
                        : '${item.duration} hari',
                  ];
                }).toList(),
              ),

            // ========================================
            // RINGKASAN MOOD
            // ========================================

            sectionTitle('4. Ringkasan Mood'),

            pw.Row(
              children: [
                summaryCard(
                  'Total Catatan',
                  '${sortedMoods.length} hari',
                ),

                pw.SizedBox(width: 9),

                summaryCard(
                  'Mood Terbanyak',
                  topMood,
                ),
              ],
            ),

            sectionTitle('5. Distribusi Mood'),

            moodDistribution(counts),

            // ========================================
            // RIWAYAT MOOD
            // ========================================

            sectionTitle('6. Riwayat Mood'),

            if (sortedMoods.isEmpty)
              pw.Text(
                'Belum ada catatan mood.',
              )
            else
              reportTable(
                headers: [
                  'Tanggal',
                  'Mood',
                  'Catatan',
                ],
                rows: sortedMoods.map((item) {
                  return [
                    formatDate(item.date),
                    item.mood,
                    item.note.isEmpty
                        ? '-'
                        : item.note
                            .replaceAll(
                              RegExp(r'[\r\n]+'),
                              ' ',
                            )
                            .trim(),
                  ];
                }).toList(),
              ),

            // ========================================
            // DISCLAIMER
            // ========================================

            pw.SizedBox(height: 20),

            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: const PdfColor(
                  0.96,
                  0.96,
                  0.97,
                ),
                borderRadius:
                    pw.BorderRadius.circular(8),
              ),
              child: pw.Text(
                'Catatan: Hasil analisis siklus '
                'merupakan informasi berdasarkan '
                'tanggal yang dicatat pengguna. '
                'Siklus di luar rentang acuan '
                'tidak otomatis menunjukkan '
                'gangguan kesehatan. '
                'Konsultasikan dengan tenaga kesehatan '
                'jika mengalami keluhan atau '
                'perubahan siklus yang mengkhawatirkan.',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: softText,
                ),
              ),
            ),

            pw.SizedBox(height: 10),

            pw.Text(
              'Laporan dibuat otomatis oleh LunaCare.',
              style: const pw.TextStyle(
                color: softText,
                fontSize: 8,
              ),
            ),
          ];
        },
      ),
    );

    return document.save();
  }

  // ====================================================
  // BUKA DIALOG SIMPAN / CETAK PDF
  // ====================================================

  static Future<void> downloadReport({
    required List<PeriodEntry> periods,
    required List<mood.MoodRecord> moodRecords,
    required bool isDemoData,
  }) async {
    final bytes = await generatePdf(
      periods: periods,
      moodRecords: moodRecords,
      isDemoData: isDemoData,
    );

    final fileName =
        'LunaCare_Health_Report_'
        '${dateKey(DateTime.now())}.pdf';

    await Printing.layoutPdf(
      name: fileName,
      onLayout: (format) async => bytes,
    );
  }
}
