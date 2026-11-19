
import 'package:flutter/material.dart';

import 'calendar_page.dart';
import 'mood_page.dart';
import 'statistics_page.dart';
import 'profile_page.dart';
import 'artikel_page.dart' as artikel;
import 'services/period_repository.dart';

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
// MAIN
// ======================================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LunaCareApp());
}

class LunaCareApp extends StatelessWidget {
  const LunaCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LunaCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPink,
        ),
        scaffoldBackgroundColor: kBackground,
      ),
      home: const LoginPage(),
    );
  }
}

// ======================================================
// LOGIN DEMO
// ======================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  InputDecoration inputStyle(
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kBorder),
      ),
    );
  }

  void login() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 430,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.nightlight_round,
                    size: 56,
                    color: kPink,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'LunaCare',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kPink,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Smart Menstrual & Wellness Tracker',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kTextSoft,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 43),

                  const Text(
                    'Selamat Datang',
                    style: TextStyle(
                      color: kTextDark,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 7),

                  const Text(
                    'Masuk untuk melanjutkan ke LunaCare.',
                    style: TextStyle(
                      color: kTextSoft,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 26),

                  const Text(
                    'Email',
                    style: TextStyle(
                      color: kTextDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: emailController,
                    keyboardType:
                        TextInputType.emailAddress,
                    decoration: inputStyle(
                      'Masukkan email',
                      Icons.email_outlined,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Password',
                    style: TextStyle(
                      color: kTextDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: inputStyle(
                      'Masukkan password',
                      Icons.lock_outline,
                    ).copyWith(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword =
                                !obscurePassword;
                          });
                        },
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    height: 50,
                    child: FilledButton(
                      onPressed: login,
                      style: FilledButton.styleFrom(
                        backgroundColor: kPink,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Masuk'),
                    ),
                  ),

                  const SizedBox(height: 23),

                  const Text(
                    'Login masih menggunakan mode demo.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kTextSoft,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ======================================================
// HOME PAGE
// ======================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final repository = PeriodRepository.instance;

  List<PeriodEntry> periods = [];

  @override
  void initState() {
    super.initState();
    loadMenstrualHistory();
  }

  Future<void> loadMenstrualHistory() async {
    try {
      final data = await repository.getPeriods();

      if (!mounted) return;

      setState(() {
        periods = data;
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal memuat riwayat menstruasi: $error',
          ),
        ),
      );
    }
  }

  PeriodEntry? get latestPeriod {
    if (periods.isEmpty) return null;
    return periods.last;
  }

  DateTime? get periodStart => latestPeriod?.startDate;

  DateTime? get periodEnd => latestPeriod?.endDate;

  int? get periodDuration => latestPeriod?.duration;

  // ====================================================
  // HITUNG HARI SIKLUS
  // ====================================================

  int? get cycleDay {
    if (periodStart == null) return null;

    final difference = DateUtils.dateOnly(
      DateTime.now(),
    ).difference(
      DateUtils.dateOnly(periodStart!),
    ).inDays;

    if (difference < 0) return null;

    return difference + 1;
  }

  // ====================================================
  // PERKIRAAN BERDASARKAN RIWAYAT
  // ====================================================

  int? get averageCycleLength {
    if (periods.length < 2) return null;

    int totalDays = 0;
    int totalCycles = 0;

    for (int i = 1; i < periods.length; i++) {
      final difference = periods[i]
          .startDate
          .difference(periods[i - 1].startDate)
          .inDays;

      if (difference > 0) {
        totalDays += difference;
        totalCycles++;
      }
    }

    if (totalCycles == 0) return null;

    return (totalDays / totalCycles).round();
  }

  DateTime? get nextPeriod {
    final start = periodStart;
    final average = averageCycleLength;

    if (start == null || average == null) {
      return null;
    }

    return DateUtils.dateOnly(start).add(
      Duration(days: average),
    );
  }

  String formatDate(DateTime date) {
    return formatPeriodDate(date);
  }

  // ====================================================
  // NAVIGASI KALENDER
  // ====================================================

  Future<void> openCalendar() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => const CalendarPage(),
      ),
    );

    if (!mounted) return;

    // Baca ulang SQLite setelah kembali dari Kalender.
    await loadMenstrualHistory();
  }

  // ====================================================
  // NAVIGASI MOOD
  // ====================================================

  void openMood() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MoodPage(),
      ),
    );
  }

  // ====================================================
  // NAVIGASI STATISTIK
  // ====================================================

  void openStatistics() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const StatisticsPage(),
      ),
    );
  }

  // ====================================================
  // NAVIGASI PROFIL
  // ====================================================

  void openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfilePage(),
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

      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            HomeHeader(
              onProfileTap: openProfile,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20, 22, 20, 30,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const GreetingSection(),

                    const SizedBox(height: 23),

                    CycleStatusCard(
                      cycleDay: cycleDay,
                      periodStart: periodStart,
                      nextPeriod: nextPeriod,
                      formatDate: formatDate,
                    ),

                    const SizedBox(height: 27),

                    MainMenuSection(
                      onCalendarTap: openCalendar,
                      onMoodTap: openMood,
                    ),

                    const SizedBox(height: 28),

                    HomeCalendarSection(
                      periodStart: periodStart,
                      periodEnd: periodEnd,
                    ),

                    const SizedBox(height: 26),

                    SummarySection(
                      latestPeriod: latestPeriod,
                      nextPeriod: nextPeriod,
                      formatDate: formatDate,
                    ),

                    const SizedBox(height: 30),

                    const ArtikelHomeSection(),
                  ],
                ),
              ),
            ),

            SafeArea(
              top: false,
              child: BottomNavigation(
                onCalendarTap: openCalendar,
                onStatisticsTap: openStatistics,
                onProfileTap: openProfile,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// HEADER
// ======================================================

class HomeHeader extends StatelessWidget {
  final VoidCallback onProfileTap;

  const HomeHeader({
    super.key,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: kBorder),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.nightlight_round,
            color: kPink,
            size: 23,
          ),

          const SizedBox(width: 7),

          const Text(
            'LunaCare',
            style: TextStyle(
              color: kPink,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          const Icon(
            Icons.notifications_none_outlined,
            color: kTextSoft,
          ),

          const SizedBox(width: 16),

          InkWell(
            onTap: onProfileTap,
            borderRadius: BorderRadius.circular(30),
            child: const CircleAvatar(
              radius: 17,
              backgroundColor: kPinkLight,
              child: Icon(
                Icons.person_outline,
                color: kPinkDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// GREETING
// ======================================================

class GreetingSection extends StatelessWidget {
  const GreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halo, User!',
          style: TextStyle(
            color: kTextDark,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 6),

        Text(
          'Pantau siklus dan kondisi tubuhmu hari ini.',
          style: TextStyle(
            color: kTextSoft,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

// ======================================================
// STATUS SIKLUS
// ======================================================

class CycleStatusCard extends StatelessWidget {
  final int? cycleDay;
  final DateTime? periodStart;
  final DateTime? nextPeriod;
  final String Function(DateTime) formatDate;

  const CycleStatusCard({
    super.key,
    required this.cycleDay,
    required this.periodStart,
    required this.nextPeriod,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kPink,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 67,
            height: 67,
            decoration: BoxDecoration(
             color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.spa_outlined,
              color: Colors.white,
              size: 35,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Status Siklus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  cycleDay == null
                      ? 'Belum ada data'
                      : 'Hari ke-$cycleDay',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                if (periodStart == null)
                  const Text(
                    'Catat menstruasi untuk '
                    'mulai memantau siklus.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  )
                else ...[
                  Text(
                    'Haid terakhir: '
                    '${formatDate(periodStart!)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    nextPeriod == null
                        ? 'Prediksi tersedia setelah '
                          'minimal dua catatan.'
                        : 'Perkiraan berikutnya: '
                          '${formatDate(nextPeriod!)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// MENU UTAMA
// ======================================================

class MainMenuSection extends StatelessWidget {
  final VoidCallback onCalendarTap;
  final VoidCallback onMoodTap;

  const MainMenuSection({
    super.key,
    required this.onCalendarTap,
    required this.onMoodTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Menu Utama',
          style: TextStyle(
            color: kTextDark,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 13),

        Row(
          children: [
            Expanded(
              child: HomeMenuCard(
                icon: Icons.calendar_month_outlined,
                label: 'Catat Menstruasi',
                onTap: onCalendarTap,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: HomeMenuCard(
                icon: Icons.mood_outlined,
                label: 'Catat Mood',
                onTap: onMoodTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class HomeMenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const HomeMenuCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 118,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kBorder),
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: kPinkLight,
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: kPinkDark,
                  size: 24,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: kTextDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
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
// KALENDER MINI DI BERANDA
// ======================================================

class HomeCalendarSection extends StatelessWidget {
  final DateTime? periodStart;
  final DateTime? periodEnd;

  const HomeCalendarSection({
    super.key,
    required this.periodStart,
    required this.periodEnd,
  });

  bool isPeriod(DateTime date) {
    if (periodStart == null) return false;

    final start = DateUtils.dateOnly(periodStart!);
    final end = DateUtils.dateOnly(
      periodEnd ?? periodStart!,
    );

    final day = DateUtils.dateOnly(date);

    return !day.isBefore(start) && !day.isAfter(end);
  }

  @override
  Widget build(BuildContext context) {
    final shown = periodStart ?? DateTime.now();

    final first = DateTime(
      shown.year,
      shown.month,
      1,
    );

    final days = DateTime(
      shown.year,
      shown.month + 1,
      0,
    ).day;

    final blankDays = first.weekday - 1;

    const months = [
      'Januari', 'Februari', 'Maret', 'April',
      'Mei', 'Juni', 'Juli', 'Agustus',
      'September', 'Oktober', 'November', 'Desember',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Kalender Siklus',
                  style: TextStyle(
                    color: kTextDark,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Text(
                '${months[shown.month - 1]} '
                '${shown.year}',
                style: const TextStyle(
                  color: kTextSoft,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Row(
            children: [
              CalendarDay('Sen'),
              CalendarDay('Sel'),
              CalendarDay('Rab'),
              CalendarDay('Kam'),
              CalendarDay('Jum'),
              CalendarDay('Sab'),
              CalendarDay('Min'),
            ],
          ),

          const SizedBox(height: 9),

          GridView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            itemCount: blankDays + days,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              if (index < blankDays) {
                return const SizedBox.shrink();
              }

              final day = index - blankDays + 1;

              final date = DateTime(
                shown.year,
                shown.month,
                day,
              );

              final highlighted = isPeriod(date);
              final today = DateUtils.isSameDay(
                date,
                DateTime.now(),
              );

              return Center(
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: highlighted
                        ? kPink
                        : today
                            ? kPinkLight
                            : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: highlighted
                          ? Colors.white
                          : kTextDark,
                      fontSize: 11,
                      fontWeight: highlighted || today
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CalendarDay extends StatelessWidget {
  final String label;

  const CalendarDay(
    this.label, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: kTextSoft,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

// ======================================================
// RINGKASAN HOMEPAGE
// ======================================================

class SummarySection extends StatelessWidget {
  final PeriodEntry? latestPeriod;
  final DateTime? nextPeriod;
  final String Function(DateTime) formatDate;

  const SummarySection({
    super.key,
    required this.latestPeriod,
    required this.nextPeriod,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    String periodDescription =
        'Belum ada catatan menstruasi.';

    if (latestPeriod != null) {
      periodDescription =
          'Mulai: ${formatDate(latestPeriod!.startDate)}';

      if (latestPeriod!.duration != null) {
        periodDescription +=
            '\nDurasi: ${latestPeriod!.duration} hari';
      } else {
        periodDescription +=
            '\nTanggal selesai belum dicatat.';
      }
    }

    final nextDescription = nextPeriod == null
        ? 'Belum cukup riwayat untuk membuat '
          'perkiraan berdasarkan siklus.'
        : '${formatDate(nextPeriod!)}\n'
          'Perkiraan berdasarkan rata-rata '
          'panjang siklus sebelumnya.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan',
          style: TextStyle(
            color: kTextDark,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        SimpleInfoBox(
          icon: Icons.history,
          title: 'Menstruasi Terakhir',
          text: periodDescription,
        ),

        const SizedBox(height: 10),

        SimpleInfoBox(
          icon: Icons.event_outlined,
          title: 'Perkiraan Berikutnya',
          text: nextDescription,
        ),
      ],
    );
  }
}

class SimpleInfoBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const SimpleInfoBox({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: kPinkLight,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: kPinkDark,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: kTextDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  text,
                  style: const TextStyle(
                    color: kTextSoft,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// ARTIKEL HOMEPAGE
// ======================================================

class ArtikelHomeSection extends StatelessWidget {
  const ArtikelHomeSection({super.key});

  void openAllArticles(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const artikel.ArtikelPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final latestArticles =
        artikel.daftarArtikel.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Artikel',
                style: TextStyle(
                  color: kTextDark,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            TextButton(
              onPressed: () => openAllArticles(context),
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  color: kPinkDark,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        ...latestArticles.map(
          (item) => Padding(
            padding: const EdgeInsets.only(
              bottom: 13,
            ),
            child: ArtikelHomeCard(
              artikelData: item,
            ),
          ),
        ),
      ],
    );
  }
}

class ArtikelHomeCard extends StatelessWidget {
  final artikel.Artikel artikelData;

  const ArtikelHomeCard({
    super.key,
    required this.artikelData,
  });

  void openArticle(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => artikel.DetailArtikelPage(
          artikel: artikelData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: () => openArticle(context),
        borderRadius: BorderRadius.circular(13),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: kBorder),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                height: 140,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(13),
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
                      artikelData.kategori,
                      style: const TextStyle(
                        color: kPinkDark,
                        fontSize: 10,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      artikelData.judul,
                      style: const TextStyle(
                        color: kTextDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
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
// BOTTOM NAVIGATION
// ======================================================

class BottomNavigation extends StatelessWidget {
  final VoidCallback onCalendarTap;
  final VoidCallback onStatisticsTap;
  final VoidCallback onProfileTap;

  const BottomNavigation({
    super.key,
    required this.onCalendarTap,
    required this.onStatisticsTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        8, 9, 8, 14,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: kBorder),
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: BottomNavItem(
              icon: Icons.home_rounded,
              label: 'Beranda',
              active: true,
            ),
          ),

          Expanded(
            child: InkWell(
              onTap: onCalendarTap,
              child: const BottomNavItem(
                icon: Icons.calendar_month_outlined,
                label: 'Kalender',
              ),
            ),
          ),

          Expanded(
            child: InkWell(
              onTap: onStatisticsTap,
              child: const BottomNavItem(
                icon: Icons.bar_chart_outlined,
                label: 'Statistik',
              ),
            ),
          ),

          Expanded(
            child: InkWell(
              onTap: onProfileTap,
              child: const BottomNavItem(
                icon: Icons.person_outline,
                label: 'Profil',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: active ? kPinkDark : kTextSoft,
            size: 21,
          ),

          const SizedBox(height: 4),

          Text(
            label,
            style: TextStyle(
              color: active ? kPinkDark : kTextSoft,
              fontSize: 10,
              fontWeight: active
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
