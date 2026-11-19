
import 'package:flutter/material.dart';
import 'services/period_repository.dart';

const Color kPink = Color(0xFFD97E9E);
const Color kPinkDark = Color(0xFFC85F87);
const Color kPinkLight = Color(0xFFFFEAF1);
const Color kBackground = Color(0xFFFFF9FB);
const Color kTextDark = Color(0xFF493A42);
const Color kTextSoft = Color(0xFF8B7B83);
const Color kBorder = Color(0xFFEDE3E7);

// Kompatibilitas dengan navigasi versi sebelumnya.
class PeriodData {
  final DateTime start;
  final DateTime? end;

  const PeriodData({
    required this.start,
    this.end,
  });
}

String formatPeriodDate(DateTime date) {
  const months = [
    'Januari', 'Februari', 'Maret', 'April',
    'Mei', 'Juni', 'Juli', 'Agustus',
    'September', 'Oktober', 'November', 'Desember',
  ];

  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

class CalendarPage extends StatefulWidget {
  final DateTime? initialStart;
  final DateTime? initialEnd;

  const CalendarPage({
    super.key,
    this.initialStart,
    this.initialEnd,
  });

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final repository = PeriodRepository.instance;

  List<PeriodEntry> periods = [];
  DateTime visibleMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPeriods();
  }

  Future<void> loadPeriods() async {
    try {
      final data = await repository.getPeriods();

      if (!mounted) return;

      setState(() {
        periods = data;
        loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      showMessage('Gagal memuat riwayat: $error');
    }
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void changeMonth(int offset) {
    setState(() {
      visibleMonth = DateTime(
        visibleMonth.year,
        visibleMonth.month + offset,
      );
    });
  }

  bool sameDay(DateTime a, DateTime b) {
    return DateUtils.isSameDay(a, b);
  }

  bool isPeriodDay(DateTime date) {
    for (final period in periods) {
      final start = DateUtils.dateOnly(period.startDate);
      final end = DateUtils.dateOnly(
        period.endDate ?? period.startDate,
      );

      if (!date.isBefore(start) && !date.isAfter(end)) {
        return true;
      }
    }
    return false;
  }

  bool isStartDay(DateTime date) {
    return periods.any(
      (period) => sameDay(period.startDate, date),
    );
  }

  // ====================================================
  // TAMBAH / EDIT MENSTRUASI
  // ====================================================

  Future<void> openEditor({
    PeriodEntry? editing,
  }) async {
    DateTime start = DateUtils.dateOnly(
      editing?.startDate ?? DateTime.now(),
    );

    DateTime? end = editing?.endDate;
    bool saving = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, updateSheet) {
            Future<void> pickStart() async {
              final selected = await showDatePicker(
                context: sheetContext,
                initialDate: start,
                firstDate: DateTime(2020),
                lastDate: DateUtils.dateOnly(DateTime.now()),
                helpText: 'Tanggal Mulai Menstruasi',
              );

              if (selected == null ||
                  !sheetContext.mounted) {
                return;
              }

              updateSheet(() {
                start = DateUtils.dateOnly(selected);

                if (end != null && end!.isBefore(start)) {
                  end = null;
                }
              });
            }

            Future<void> pickEnd() async {
              final today = DateUtils.dateOnly(
                DateTime.now(),
              );

              final selected = await showDatePicker(
                context: sheetContext,
                initialDate: end ?? start,
                firstDate: start,
                lastDate: today,
                helpText: 'Tanggal Selesai Menstruasi',
              );

              if (selected != null &&
                  sheetContext.mounted) {
                updateSheet(() {
                  end = DateUtils.dateOnly(selected);
                });
              }
            }

            Future<void> save() async {
              if (saving) return;

              final today = DateUtils.dateOnly(
                DateTime.now(),
              );

              if (start.isAfter(today)) {
                showMessage(
                  'Tanggal mulai tidak boleh di masa depan.',
                );
                return;
              }

              if (end != null &&
                  (end!.isBefore(start) ||
                      end!.isAfter(today))) {
                showMessage(
                  'Tanggal selesai tidak valid.',
                );
                return;
              }

              // Cegah periode yang saling bertumpukan.
              final newEnd = end ?? start;

              for (final other in periods) {
                if (other.id == editing?.id) continue;

                final otherStart = other.startDate;
                final otherEnd =
                    other.endDate ?? other.startDate;

                final overlaps =
                    !newEnd.isBefore(otherStart) &&
                    !start.isAfter(otherEnd);

                if (overlaps) {
                  showMessage(
                    'Tanggal ini bertumpukan dengan '
                    'riwayat menstruasi lain.',
                  );
                  return;
                }
              }

              updateSheet(() {
                saving = true;
              });

              try {
                await repository.savePeriod(
                  PeriodEntry(
                    id: editing?.id,
                    startDate: start,
                    endDate: end,
                  ),
                );

                if (!mounted) return;

                if (sheetContext.mounted) {
                  Navigator.pop(sheetContext);
                }

                await loadPeriods();

                showMessage(
                  editing == null
                      ? 'Menstruasi berhasil dicatat.'
                      : 'Catatan menstruasi diperbarui.',
                );
              } catch (error) {
                showMessage(
                  'Gagal menyimpan. Pastikan tanggal '
                  'mulai tidak sama dengan catatan lain. '
                  '$error',
                );

                if (sheetContext.mounted) {
                  updateSheet(() {
                    saving = false;
                  });
                }
              }
            }

            return SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  22,
                  24,
                  22,
                  MediaQuery.of(sheetContext)
                          .viewInsets.bottom +
                      26,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      editing == null
                          ? 'Catat Menstruasi'
                          : 'Edit Menstruasi',
                      style: const TextStyle(
                        color: kTextDark,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 7),

                    const Text(
                      'Masukkan tanggal berdasarkan '
                      'menstruasi yang benar-benar dialami.',
                      style: TextStyle(
                        color: kTextSoft,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Tanggal Mulai',
                      style: TextStyle(
                        color: kTextDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    dateSelector(
                      text: formatPeriodDate(start),
                      onTap: pickStart,
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Tanggal Selesai (Opsional)',
                      style: TextStyle(
                        color: kTextDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    dateSelector(
                      text: end == null
                          ? 'Belum dicatat'
                          : formatPeriodDate(end!),
                      onTap: pickEnd,
                    ),

                    if (end != null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            updateSheet(() {
                              end = null;
                            });
                          },
                          child: const Text(
                            'Kosongkan Tanggal Selesai',
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: saving ? null : save,
                        icon: const Icon(
                          Icons.save_outlined,
                        ),
                        label: Text(
                          saving
                              ? 'Menyimpan...'
                              : 'Simpan Menstruasi',
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: kPink,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget dateSelector({
    required String text,
    required VoidCallback onTap,
  }) {
    return Material(
      color: kBackground,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: kBorder),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: kPinkDark,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: kTextDark,
                    fontSize: 13,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: kTextSoft,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ====================================================
  // HAPUS MENSTRUASI
  // ====================================================

  Future<void> deletePeriod(PeriodEntry period) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Menstruasi?'),
          content: Text(
            'Catatan ${formatPeriodDate(period.startDate)} '
            'akan dihapus.',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: kPinkDark,
              ),
              onPressed: () =>
                  Navigator.pop(dialogContext, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || period.id == null) {
      return;
    }

    try {
      await repository.deletePeriod(period.id!);
      await loadPeriods();
      showMessage('Catatan menstruasi dihapus.');
    } catch (error) {
      showMessage('Gagal menghapus catatan: $error');
    }
  }

  // ====================================================
  // GRID KALENDER
  // ====================================================

  Widget buildCalendar() {
    const weekdays = [
      'Sen', 'Sel', 'Rab', 'Kam',
      'Jum', 'Sab', 'Min',
    ];

    const months = [
      'Januari', 'Februari', 'Maret', 'April',
      'Mei', 'Juni', 'Juli', 'Agustus',
      'September', 'Oktober', 'November', 'Desember',
    ];

    final first = DateTime(
      visibleMonth.year,
      visibleMonth.month,
      1,
    );

    final days = DateTime(
      visibleMonth.year,
      visibleMonth.month + 1,
      0,
    ).day;

    final leadingBlanks = first.weekday - 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => changeMonth(-1),
                icon: const Icon(
                  Icons.chevron_left,
                  color: kPinkDark,
                ),
              ),
              Expanded(
                child: Text(
                  '${months[visibleMonth.month - 1]} '
                  '${visibleMonth.year}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: kTextDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => changeMonth(1),
                icon: const Icon(
                  Icons.chevron_right,
                  color: kPinkDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: weekdays
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          color: kTextSoft,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 10),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: leadingBlanks + days,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              if (index < leadingBlanks) {
                return const SizedBox.shrink();
              }

              final day = index - leadingBlanks + 1;

              final date = DateTime(
                visibleMonth.year,
                visibleMonth.month,
                day,
              );

              final periodDay = isPeriodDay(date);
              final startDay = isStartDay(date);
              final isToday = DateUtils.isSameDay(
                date,
                DateTime.now(),
              );

              return Center(
                child: Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: startDay
                        ? kPinkDark
                        : periodDay
                            ? kPinkLight
                            : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isToday && !startDay
                        ? Border.all(color: kPink)
                        : null,
                  ),
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: startDay
                          ? Colors.white
                          : kTextDark,
                      fontSize: 12,
                      fontWeight: startDay || isToday
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 14),

          const Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              CalendarLegend(
                color: kPinkDark,
                text: 'Mulai Haid',
              ),
              CalendarLegend(
                color: kPinkLight,
                text: 'Hari Haid',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ====================================================
  // CARD RIWAYAT
  // ====================================================

  Widget historyCard(PeriodEntry period) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: kBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: kPinkLight,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.water_drop_outlined,
              color: kPinkDark,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  formatPeriodDate(period.startDate),
                  style: const TextStyle(
                    color: kTextDark,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  period.endDate == null
                      ? 'Tanggal selesai belum dicatat'
                      : 'Selesai: '
                        '${formatPeriodDate(period.endDate!)}',
                  style: const TextStyle(
                    color: kTextSoft,
                    fontSize: 11,
                  ),
                ),

                if (period.duration != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Durasi: ${period.duration} hari',
                    style: const TextStyle(
                      color: kPinkDark,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),

          IconButton(
            tooltip: 'Edit',
            onPressed: () => openEditor(editing: period),
            icon: const Icon(
              Icons.edit_outlined,
              color: kPinkDark,
            ),
          ),

          IconButton(
            tooltip: 'Hapus',
            onPressed: () => deletePeriod(period),
            icon: const Icon(
              Icons.delete_outline,
              color: kTextSoft,
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
          'Kalender Menstruasi',
          style: TextStyle(
            color: kTextDark,
            fontSize: 19,
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
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20, 16, 20, 35,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pantau Siklus Menstruasimu',
                    style: TextStyle(
                      color: kTextDark,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 7),

                  const Text(
                    'Catat menstruasi dari bulan ke bulan '
                    'untuk melihat pola siklusmu.',
                    style: TextStyle(
                      color: kTextSoft,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  buildCalendar(),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 49,
                    child: FilledButton.icon(
                      onPressed: () => openEditor(),
                      style: FilledButton.styleFrom(
                        backgroundColor: kPink,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'Tambah Catatan Menstruasi',
                      ),
                    ),
                  ),

                  const SizedBox(height: 29),

                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Riwayat Menstruasi',
                          style: TextStyle(
                            color: kTextDark,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '${periods.length} catatan',
                        style: const TextStyle(
                          color: kTextSoft,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 13),

                  if (periods.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(12),
                        border: Border.all(color: kBorder),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.event_note_outlined,
                            color: kPinkDark,
                            size: 32,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Belum ada catatan menstruasi',
                            style: TextStyle(
                              color: kTextDark,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...periods.reversed.map(historyCard),

                  const SizedBox(height: 13),

                  const Text(
                    'Data disimpan secara lokal di '
                    'perangkat ini. Menghapus aplikasi '
                    'atau data aplikasi dapat '
                    'menghapus riwayat.',
                    style: TextStyle(
                      color: kTextSoft,
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class CalendarLegend extends StatelessWidget {
  final Color color;
  final String text;

  const CalendarLegend({
    super.key,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: kBorder),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: kTextSoft,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
