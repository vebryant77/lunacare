
import 'package:flutter/material.dart';

// ======================================================
// LUNACARE - DUMMY PERIOD REPOSITORY
// ======================================================
//
// Penyimpanan sementara tanpa SQLite.
//
// Kelebihan:
// - Bisa berjalan di Windows
// - Bisa berjalan di Android
// - Bisa berjalan di iOS
// - Tidak memerlukan database
// - Mendukung tambah, edit, dan hapus menstruasi
// - Bisa digunakan untuk grafik Cycle Trends
//
// Keterbatasan:
// Data kembali ke kondisi awal saat aplikasi
// dijalankan ulang atau Hot Restart.
//
// ======================================================

// ======================================================
// MODEL DATA MENSTRUASI
// ======================================================

class PeriodEntry {
  final int? id;
  final DateTime startDate;
  final DateTime? endDate;

  const PeriodEntry({
    this.id,
    required this.startDate,
    this.endDate,
  });

  // Menghitung durasi menstruasi.
  int? get duration {
    if (endDate == null) {
      return null;
    }

    return DateUtils.dateOnly(endDate!)
            .difference(
              DateUtils.dateOnly(startDate),
            )
            .inDays +
        1;
  }
}

// ======================================================
// FUNGSI FORMAT TANGGAL
// ======================================================

String dateKey(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');

  return '$year-$month-$day';
}

// ======================================================
// REPOSITORY MENSTRUASI
// ======================================================

class PeriodRepository {
  PeriodRepository._();

  static final PeriodRepository instance =
      PeriodRepository._();

  // ====================================================
  // DATA DUMMY MENSTRUASI
  // ====================================================

  final List<PeriodEntry> _periods = [
    PeriodEntry(
      id: 1,
      startDate: DateTime(2026, 5, 3),
      endDate: DateTime(2026, 5, 7),
    ),

    PeriodEntry(
      id: 2,
      startDate: DateTime(2026, 5, 31),
      endDate: DateTime(2026, 6, 4),
    ),

    PeriodEntry(
      id: 3,
      startDate: DateTime(2026, 7, 2),
      endDate: DateTime(2026, 7, 6),
    ),

    PeriodEntry(
      id: 4,
      startDate: DateTime(2026, 7, 27),
      endDate: DateTime(2026, 7, 31),
    ),

    PeriodEntry(
      id: 5,
      startDate: DateTime(2026, 9, 7),
      endDate: DateTime(2026, 9, 11),
    ),

    PeriodEntry(
      id: 6,
      startDate: DateTime(2026, 10, 6),
      endDate: DateTime(2026, 10, 10),
    ),

    PeriodEntry(
      id: 7,
      startDate: DateTime(2026, 11, 4),
      endDate: DateTime(2026, 11, 8),
    ),
  ];

  // ID berikutnya untuk catatan baru.
  int _nextId = 8;

  // ====================================================
  // AMBIL SELURUH RIWAYAT MENSTRUASI
  // ====================================================

  Future<List<PeriodEntry>> getPeriods() async {
    final result = List<PeriodEntry>.from(_periods);

    result.sort(
      (a, b) => a.startDate.compareTo(b.startDate),
    );

    return result;
  }

  // ====================================================
  // MENYIMPAN ATAU MENGEDIT MENSTRUASI
  // ====================================================

  Future<void> savePeriod(PeriodEntry entry) async {
    final start = DateUtils.dateOnly(entry.startDate);

    final end = entry.endDate == null
        ? null
        : DateUtils.dateOnly(entry.endDate!);

    // Validasi tanggal.
    if (end != null && end.isBefore(start)) {
      throw StateError(
        'Tanggal selesai tidak boleh sebelum '
        'tanggal mulai.',
      );
    }

    // Cegah tanggal mulai yang sama.
    final duplicate = _periods.any(
      (item) =>
          item.id != entry.id &&
          DateUtils.isSameDay(
            item.startDate,
            start,
          ),
    );

    if (duplicate) {
      throw StateError(
        'Sudah ada catatan menstruasi '
        'pada tanggal tersebut.',
      );
    }

    // TAMBAH CATATAN BARU
    if (entry.id == null) {
      _periods.add(
        PeriodEntry(
          id: _nextId,
          startDate: start,
          endDate: end,
        ),
      );

      _nextId++;
    } else {
      // EDIT CATATAN LAMA
      final index = _periods.indexWhere(
        (item) => item.id == entry.id,
      );

      if (index == -1) {
        throw StateError(
          'Catatan menstruasi tidak ditemukan.',
        );
      }

      _periods[index] = PeriodEntry(
        id: entry.id,
        startDate: start,
        endDate: end,
      );
    }
  }

  // ====================================================
  // HAPUS MENSTRUASI
  // ====================================================

  Future<void> deletePeriod(int id) async {
    _periods.removeWhere(
      (item) => item.id == id,
    );
  }

  // ====================================================
  // AMBIL MENSTRUASI TERAKHIR
  // ====================================================

  Future<PeriodEntry?> getLatestPeriod() async {
    final periods = await getPeriods();

    if (periods.isEmpty) {
      return null;
    }

    return periods.last;
  }
}
