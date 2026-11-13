
import 'package:flutter/material.dart';

import 'calendar_page.dart';
import 'mood_page.dart';
import 'statistics_page.dart';
import 'profile_page.dart';
import 'artikel_page.dart' as artikel;

void main() {
  runApp(const LunaCareApp());
}

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
// APP
// ======================================================

class LunaCareApp extends StatelessWidget {
  const LunaCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LunaCare',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPink,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

// ======================================================
// LOGIN
// ======================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    // Login demo, belum Firebase.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
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
        borderSide: const BorderSide(color: kBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kBorder),
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
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 30,
            ),
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
                    color: kPink,
                    size: 56,
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

                  const SizedBox(height: 45),

                  const Text(
                    'Selamat Datang',
                    style: TextStyle(
                      color: kTextDark,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Masuk untuk melanjutkan ke LunaCare.',
                    style: TextStyle(
                      color: kTextSoft,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 28),

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
                    keyboardType: TextInputType.emailAddress,
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
                    obscureText: hidePassword,
                    decoration: inputStyle(
                      'Masukkan password',
                      Icons.lock_outline,
                    ).copyWith(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    height: 52,
                    child: FilledButton(
                      onPressed: login,
                      style: FilledButton.styleFrom(
                        backgroundColor: kPink,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum punya akun? ',
                        style: TextStyle(color: kTextSoft),
                      ),
                      Text(
                        'Daftar',
                        style: TextStyle(
                          color: kPinkDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
  DateTime? periodStart;
  DateTime? periodEnd;

  String formatDate(DateTime date) {
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

    return '${date.day} ${months[date.month - 1]} '
        '${date.year}';
  }

  // ====================================================
  // DATA SIKLUS
  // ====================================================

  int get periodDuration {
    if (periodStart == null || periodEnd == null) {
      return 0;
    }

    return DateUtils.dateOnly(periodEnd!)
            .difference(DateUtils.dateOnly(periodStart!))
            .inDays +
        1;
  }

  int? get cycleDay {
    if (periodStart == null) return null;

    final today = DateUtils.dateOnly(DateTime.now());
    final start = DateUtils.dateOnly(periodStart!);

    final difference = today.difference(start).inDays;

    if (difference < 0) return null;

    return difference + 1;
  }

  DateTime? get nextPeriod {
    if (periodStart == null) return null;

    // Prediksi demo sementara: siklus 28 hari.
    return DateUtils.dateOnly(periodStart!).add(
      const Duration(days: 28),
    );
  }

  // ====================================================
  // NAVIGASI HALAMAN
  // ====================================================

  Future<void> openCalendar() async {
    final result = await Navigator.push<PeriodData>(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarPage(
          initialStart: periodStart,
          initialEnd: periodEnd,
        ),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        periodStart = result.start;
        periodEnd = result.end;
      });
    }
  }

  void openMoodPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MoodPage(),
      ),
    );
  }

  void openStatisticsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StatisticsPage(),
      ),
    );
  }

  void openProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  void chatbotComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Fitur Chatbot masih dalam tahap pengembangan.',
        ),
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
              onProfileTap: openProfilePage,
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

                    const SizedBox(height: 24),

                    CycleStatusCard(
                      cycleDay: cycleDay,
                      periodStart: periodStart,
                      nextPeriod: nextPeriod,
                      formatDate: formatDate,
                    ),

                    const SizedBox(height: 28),

                    MainMenuSection(
                      onCalendarTap: openCalendar,
                      onMoodTap: openMoodPage,
                      onChatbotTap: chatbotComingSoon,
                    ),

                    const SizedBox(height: 30),

                    HomeCalendarSection(
                      periodStart: periodStart,
                      periodEnd: periodEnd,
                    ),

                    const SizedBox(height: 26),

                    SummarySection(
                      periodStart: periodStart,
                      nextPeriod: nextPeriod,
                      duration: periodDuration,
                      formatDate: formatDate,
                    ),

                    const SizedBox(height: 30),

                    // ARTIKEL SUDAH BISA DIKLIK
                    const ArtikelHomeSection(),
                  ],
                ),
              ),
            ),

            SafeArea(
              top: false,
              child: BottomNavigation(
                onCalendarTap: openCalendar,
                onStatisticsTap: openStatisticsPage,
                onProfileTap: openProfilePage,
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                size: 21,
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
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: kTextDark,
          ),
        ),

        SizedBox(height: 6),

        Text(
          'Pantau siklus dan kondisi tubuhmu hari ini.',
          style: TextStyle(
            fontSize: 13,
            color: kTextSoft,
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
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.spa_outlined,
              color: Colors.white,
              size: 37,
            ),
          ),

          const SizedBox(width: 17),

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

                const SizedBox(height: 4),

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

                const SizedBox(height: 5),

                if (periodStart == null)
                  const Text(
                    'Catat menstruasi untuk mulai '
                    'memantau siklus.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      height: 1.3,
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

                  if (nextPeriod != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      'Berikutnya: '
                      '${formatDate(nextPeriod!)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ],
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
  final VoidCallback onChatbotTap;

  const MainMenuSection({
    super.key,
    required this.onCalendarTap,
    required this.onMoodTap,
    required this.onChatbotTap,
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
                label: 'Catat\nMenstruasi',
                onTap: onCalendarTap,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: HomeMenuCard(
                icon: Icons.mood_outlined,
                label: 'Mood &\nGejala',
                onTap: onMoodTap,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: HomeMenuCard(
                icon: Icons.chat_bubble_outline,
                label: 'Chatbot\nAI',
                onTap: onChatbotTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ======================================================
// CARD MENU HORIZONTAL
// ======================================================

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
          height: 120,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kBorder),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: kPinkLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: kPinkDark,
                  size: 24,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: kTextDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
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
// KALENDER HOMEPAGE
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
    if (periodStart == null || periodEnd == null) {
      return false;
    }

    final selected = DateUtils.dateOnly(date);
    final start = DateUtils.dateOnly(periodStart!);
    final end = DateUtils.dateOnly(periodEnd!);

    return !selected.isBefore(start) &&
        !selected.isAfter(end);
  }

  @override
  Widget build(BuildContext context) {
    final shownDate = periodStart ?? DateTime.now();

    final firstDay = DateTime(
      shownDate.year,
      shownDate.month,
      1,
    );

    final totalDays = DateTime(
      shownDate.year,
      shownDate.month + 1,
      0,
    ).day;

    final emptyBefore = firstDay.weekday - 1;

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
          Row(
            children: [
              const Text(
                'Kalender Siklus',
                style: TextStyle(
                  color: kTextDark,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              Text(
                '${months[shownDate.month - 1]} '
                '${shownDate.year}',
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
            physics: const NeverScrollableScrollPhysics(),
            itemCount: emptyBefore + totalDays,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              if (index < emptyBefore) {
                return const SizedBox();
              }

              final day = index - emptyBefore + 1;

              final date = DateTime(
                shownDate.year,
                shownDate.month,
                day,
              );

              final menstruation = isPeriod(date);

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
                    color: menstruation
                        ? kPink
                        : today
                            ? kPinkLight
                            : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: menstruation
                          ? Colors.white
                          : kTextDark,
                      fontSize: 11,
                      fontWeight: menstruation || today
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

// ======================================================
// LABEL HARI KALENDER
// ======================================================

class CalendarDay extends StatelessWidget {
  final String text;

  const CalendarDay(
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
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

// ======================================================
// RINGKASAN
// ======================================================

class SummarySection extends StatelessWidget {
  final DateTime? periodStart;
  final DateTime? nextPeriod;
  final int duration;
  final String Function(DateTime) formatDate;

  const SummarySection({
    super.key,
    required this.periodStart,
    required this.nextPeriod,
    required this.duration,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    final cycleText = periodStart == null
        ? 'Belum ada data menstruasi.'
        : 'Durasi haid: $duration hari\n'
          'Asumsi panjang siklus: 28 hari';

    final nextText = nextPeriod == null
        ? 'Perkiraan akan muncul setelah data '
          'menstruasi dicatat.'
        : 'Perkiraan haid berikutnya:\n'
          '${formatDate(nextPeriod!)}';

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
          title: 'Siklus Menstruasi',
          text: cycleText,
        ),

        const SizedBox(height: 10),

        SimpleInfoBox(
          icon: Icons.event_outlined,
          title: 'Perkiraan Berikutnya',
          text: nextText,
        ),
      ],
    );
  }
}

// ======================================================
// INFO RINGKASAN
// ======================================================

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
              size: 21,
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

                const SizedBox(height: 5),

                Text(
                  text,
                  style: const TextStyle(
                    color: kTextSoft,
                    fontSize: 11,
                    height: 1.4,
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
// ARTIKEL DI HOMEPAGE
// ======================================================

class ArtikelHomeSection extends StatelessWidget {
  const ArtikelHomeSection({super.key});

  void bukaSemuaArtikel(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const artikel.ArtikelPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final artikelTerbaru =
        artikel.daftarArtikel.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Artikel',
              style: TextStyle(
                color: kTextDark,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            // TOMBOL LIHAT SEMUA
            TextButton(
              onPressed: () => bukaSemuaArtikel(context),
              style: TextButton.styleFrom(
                foregroundColor: kPinkDark,
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 30),
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Lihat Semua',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),

        const SizedBox(height: 13),

        // TIGA ARTIKEL PERTAMA
        ...artikelTerbaru.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: ArtikelHomeCard(artikelData: item),
          ),
        ),
      ],
    );
  }
}

// ======================================================
// CARD ARTIKEL HOMEPAGE
// ======================================================

class ArtikelHomeCard extends StatelessWidget {
  final artikel.Artikel artikelData;

  const ArtikelHomeCard({
    super.key,
    required this.artikelData,
  });

  void bukaDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => artikel.DetailArtikelPage(
          artikel: artikelData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => bukaDetail(context),
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
              // PLACEHOLDER GAMBAR
              Container(
                width: double.infinity,
                height: 145,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  15, 13, 15, 15,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      artikelData.kategori,
                      style: const TextStyle(
                        color: kPinkDark,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 5),

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
        8, 9, 8, 15,
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

// ======================================================
// BOTTOM NAV ITEM
// ======================================================

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
      padding: const EdgeInsets.symmetric(vertical: 6),
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
