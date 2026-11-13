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

// ======================================================
// DATA YANG DIKIRIM KE HOMEPAGE
// ======================================================

class PeriodData {
  final DateTime start;
  final DateTime end;

  const PeriodData({
    required this.start,
    required this.end,
  });
}

// ======================================================
// CALENDAR PAGE
// ======================================================

class CalendarPage extends StatefulWidget {
  final DateTime? initialStart;
  final DateTime? initialEnd;

  const CalendarPage({
    super.key,
    this.initialStart,
    this.initialEnd,
  });

  @override
  State<CalendarPage> createState() =>
      _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime currentMonth;

  DateTime? periodStart;
  DateTime? periodEnd;

  @override
  void initState() {
    super.initState();

    periodStart = widget.initialStart;
    periodEnd = widget.initialEnd;

    if (periodStart != null) {
      currentMonth = DateTime(
        periodStart!.year,
        periodStart!.month,
      );
    } else {
      currentMonth = DateTime.now();
    }
  }

  // ======================================================
  // NAMA BULAN
  // ======================================================

  String monthName(int month) {
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

    return months[month - 1];
  }

  String formatDate(DateTime date) {
    return '${date.day} ${monthName(date.month)} ${date.year}';
  }

  // ======================================================
  // BULAN
  // ======================================================

  void previousMonth() {
    setState(() {
      currentMonth = DateTime(
        currentMonth.year,
        currentMonth.month - 1,
      );
    });
  }

  void nextMonth() {
    setState(() {
      currentMonth = DateTime(
        currentMonth.year,
        currentMonth.month + 1,
      );
    });
  }

  // ======================================================
  // CEK MENSTRUASI
  // ======================================================

  bool isPeriodDate(DateTime date) {
    if (periodStart == null ||
        periodEnd == null) {
      return false;
    }

    final selected =
        DateUtils.dateOnly(date);

    final start =
        DateUtils.dateOnly(periodStart!);

    final end =
        DateUtils.dateOnly(periodEnd!);

    return !selected.isBefore(start) &&
        !selected.isAfter(end);
  }

  // ======================================================
  // FORM INPUT MENSTRUASI
  // ======================================================

  Future<void> showPeriodForm() async {
    DateTime? temporaryStart = periodStart;
    DateTime? temporaryEnd = periodEnd;

    final result =
        await showModalBottomSheet<PeriodData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (
            context,
            setBottomSheetState,
          ) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                22,
                20,
                22,
                MediaQuery.of(context)
                        .viewInsets
                        .bottom +
                    30,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 45,
                      height: 5,
                      decoration: BoxDecoration(
                        color:
                            Colors.grey.shade300,
                        borderRadius:
                            BorderRadius.circular(
                                10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Catat Menstruasi',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                      color: kTextDark,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Masukkan tanggal mulai dan selesai menstruasi.',
                    style: TextStyle(
                      fontSize: 13,
                      color: kTextSoft,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // =========================================
                  // TANGGAL MULAI
                  // =========================================

                  const Text(
                    'Tanggal Mulai',
                    style: TextStyle(
                      color: kTextDark,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  InkWell(
                    onTap: () async {
                      final picked =
                          await showDatePicker(
                        context: context,
                        initialDate:
                            temporaryStart ??
                                DateTime.now(),
                        firstDate:
                            DateTime(2020),
                        lastDate:
                            DateTime(2035),
                      );

                      if (picked != null) {
                        setBottomSheetState(
                          () {
                            temporaryStart =
                                picked;

                            if (temporaryEnd !=
                                    null &&
                                temporaryEnd!
                                    .isBefore(
                                  temporaryStart!,
                                )) {
                              temporaryEnd =
                                  null;
                            }
                          },
                        );
                      }
                    },
                    child: InputDateBox(
                      icon: Icons
                          .calendar_month_outlined,
                      text:
                          temporaryStart ==
                                  null
                              ? 'Pilih tanggal mulai'
                              : formatDate(
                                  temporaryStart!,
                                ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // =========================================
                  // TANGGAL SELESAI
                  // =========================================

                  const Text(
                    'Tanggal Selesai',
                    style: TextStyle(
                      color: kTextDark,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  InkWell(
                    onTap:
                        temporaryStart == null
                            ? null
                            : () async {
                                final picked =
                                    await showDatePicker(
                                  context:
                                      context,
                                  initialDate:
                                      temporaryEnd ??
                                          temporaryStart!,
                                  firstDate:
                                      temporaryStart!,
                                  lastDate:
                                      DateTime(
                                    2035,
                                  ),
                                );

                                if (picked !=
                                    null) {
                                  setBottomSheetState(
                                    () {
                                      temporaryEnd =
                                          picked;
                                    },
                                  );
                                }
                              },
                    child: InputDateBox(
                      icon: Icons
                          .event_available_outlined,
                      text:
                          temporaryEnd == null
                              ? 'Pilih tanggal selesai'
                              : formatDate(
                                  temporaryEnd!,
                                ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // =========================================
                  // SIMPAN
                  // =========================================

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed:
                          temporaryStart ==
                                      null ||
                                  temporaryEnd ==
                                      null
                              ? null
                              : () {
                                  Navigator.pop(
                                    sheetContext,
                                    PeriodData(
                                      start:
                                          temporaryStart!,
                                      end:
                                          temporaryEnd!,
                                    ),
                                  );
                                },
                      style:
                          FilledButton.styleFrom(
                        backgroundColor: kPink,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            15,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    // ==================================================
    // SETELAH SIMPAN
    // LANGSUNG KEMBALI KE HOMEPAGE
    // ==================================================

    if (result != null && mounted) {
      setState(() {
        periodStart = result.start;
        periodEnd = result.end;
      });

      Navigator.pop(
        context,
        result,
      );
    }
  }

  // ======================================================
  // BUILD
  // ======================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,

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
          ),
        ),

        title: const Text(
          'Kalender Siklus',
          style: TextStyle(
            color: kTextDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          30,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ==================================================
            // INFO
            // ==================================================

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: kPinkLight,
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.favorite_border,
                    color: kPinkDark,
                    size: 30,
                  ),

                  SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pantau Siklusmu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                            color: kTextDark,
                          ),
                        ),

                        SizedBox(height: 3),

                        Text(
                          'Catat tanggal menstruasi untuk membantu memantau siklus.',
                          style: TextStyle(
                            color: kTextSoft,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ==================================================
            // KALENDER
            // ==================================================

            Container(
              padding:
                  const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color:
                        Color(0x0B493A42),
                    blurRadius: 10,
                    offset:
                        Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed:
                            previousMonth,
                        icon: const Icon(
                          Icons.chevron_left,
                          color: kPinkDark,
                        ),
                      ),

                      Expanded(
                        child: Text(
                          '${monthName(currentMonth.month)} ${currentMonth.year}',
                          textAlign:
                              TextAlign.center,
                          style:
                              const TextStyle(
                            color: kTextDark,
                            fontSize: 17,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed:
                            nextMonth,
                        icon: const Icon(
                          Icons.chevron_right,
                          color: kPinkDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  const Row(
                    children: [
                      DayHeader('Sen'),
                      DayHeader('Sel'),
                      DayHeader('Rab'),
                      DayHeader('Kam'),
                      DayHeader('Jum'),
                      DayHeader('Sab'),
                      DayHeader('Min'),
                    ],
                  ),

                  const SizedBox(height: 8),

                  buildCalendarDays(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // CATATAN
            // ==================================================

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Catatan Menstruasi',
                    style: TextStyle(
                      color: kTextDark,
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (periodStart == null ||
                      periodEnd == null)
                    const Text(
                      'Belum ada data menstruasi yang dicatat.',
                      style: TextStyle(
                        color: kTextSoft,
                      ),
                    )
                  else ...[
                    PeriodInformation(
                      title: 'Mulai',
                      value: formatDate(
                        periodStart!,
                      ),
                    ),

                    const SizedBox(height: 12),

                    PeriodInformation(
                      title: 'Selesai',
                      value: formatDate(
                        periodEnd!,
                      ),
                    ),

                    const SizedBox(height: 12),

                    PeriodInformation(
                      title: 'Durasi',
                      value:
                          '${periodEnd!.difference(periodStart!).inDays + 1} hari',
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // BUTTON
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.icon(
                onPressed: showPeriodForm,
                style:
                    FilledButton.styleFrom(
                  backgroundColor: kPink,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(
                  Icons.add,
                ),
                label: Text(
                  periodStart == null
                      ? 'Catat Menstruasi'
                      : 'Ubah Catatan Menstruasi',
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // KALENDER DAYS
  // ======================================================

  Widget buildCalendarDays() {
    final firstDay = DateTime(
      currentMonth.year,
      currentMonth.month,
      1,
    );

    final totalDays = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
      0,
    ).day;

    final emptyBefore =
        firstDay.weekday - 1;

    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      itemCount:
          emptyBefore + totalDays,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemBuilder: (
        context,
        index,
      ) {
        if (index < emptyBefore) {
          return const SizedBox();
        }

        final day =
            index - emptyBefore + 1;

        final date = DateTime(
          currentMonth.year,
          currentMonth.month,
          day,
        );

        final menstruation =
            isPeriodDate(date);

        final today =
            DateUtils.isSameDay(
          date,
          DateTime.now(),
        );

        return Center(
          child: Container(
            width: 38,
            height: 38,
            alignment:
                Alignment.center,
            decoration: BoxDecoration(
              color: menstruation
                  ? kPink
                  : today
                      ? kPinkLight
                      : Colors
                          .transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$day',
              style: TextStyle(
                color: menstruation
                    ? Colors.white
                    : today
                        ? kPinkDark
                        : kTextDark,
                fontSize: 12,
                fontWeight:
                    menstruation ||
                            today
                        ? FontWeight.bold
                        : FontWeight
                            .normal,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ======================================================
// WIDGETS
// ======================================================

class InputDateBox extends StatelessWidget {
  final IconData icon;
  final String text;

  const InputDateBox({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius:
            BorderRadius.circular(15),
        border: Border.all(
          color:
              const Color(0xFFF0DFE6),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: kPinkDark,
          ),

          const SizedBox(width: 12),

          Text(
            text,
            style: const TextStyle(
              color: kTextDark,
            ),
          ),
        ],
      ),
    );
  }
}

class DayHeader extends StatelessWidget {
  final String text;

  const DayHeader(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: kTextSoft,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}

class PeriodInformation
    extends StatelessWidget {
  final String title;
  final String value;

  const PeriodInformation({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:
              const BoxDecoration(
            color: kPink,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 10),

        Text(
          '$title:',
          style: const TextStyle(
            color: kTextSoft,
          ),
        ),

        const Spacer(),

        Text(
          value,
          style: const TextStyle(
            color: kTextDark,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ],
    );
  }
}