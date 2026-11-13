
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
// PROFILE PAGE
// ======================================================

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController(text: 'User');

  final TextEditingController _emailController =
      TextEditingController(text: 'user@example.com');

  String displayName = 'User';

  DateTime? birthDate;

  bool notificationEnabled = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // ======================================================
  // FORMAT TANGGAL
  // ======================================================

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

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // ======================================================
  // PILIH TANGGAL LAHIR
  // ======================================================

  Future<void> selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Pilih Tanggal Lahir',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );

    if (picked != null && mounted) {
      setState(() {
        birthDate = picked;
      });
    }
  }

  // ======================================================
  // SIMPAN PROFIL
  // ======================================================

  void saveProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      displayName = _nameController.text.trim();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Perubahan profil berhasil disimpan sementara.',
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ======================================================
  // STYLE TEXT FIELD
  // ======================================================

  InputDecoration inputStyle(
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: kPinkDark,
        size: 21,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: kBorder,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: kBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: kPink,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
    );
  }

  // ======================================================
  // BUILD
  // ======================================================

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
          'Profil Pengguna',
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
          15,
          20,
          35,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // FOTO PROFIL DAN NAMA
              // ==========================================

              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 43,
                      backgroundColor: kPinkLight,
                      child: Icon(
                        Icons.person_outline_rounded,
                        color: kPinkDark,
                        size: 47,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      displayName,
                      style: const TextStyle(
                        color: kTextDark,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Pengguna LunaCare',
                      style: TextStyle(
                        color: kTextSoft,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ==========================================
              // INFORMASI PRIBADI
              // ==========================================

              const Text(
                'Informasi Pribadi',
                style: TextStyle(
                  color: kTextDark,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              // NAMA

              const Text(
                'Nama Lengkap',
                style: TextStyle(
                  color: kTextDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: inputStyle(
                  'Masukkan nama lengkap',
                  Icons.person_outline,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // EMAIL

              const Text(
                'Email',
                style: TextStyle(
                  color: kTextDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: inputStyle(
                  'Masukkan email',
                  Icons.email_outlined,
                ),
                validator: (value) {
                  final email = value?.trim() ?? '';

                  if (email.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }

                  if (!RegExp(
                    r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                  ).hasMatch(email)) {
                    return 'Format email tidak valid';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // TANGGAL LAHIR

              const Text(
                'Tanggal Lahir',
                style: TextStyle(
                  color: kTextDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              InkWell(
                onTap: selectBirthDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 17,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: kBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.cake_outlined,
                        color: kPinkDark,
                        size: 21,
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          birthDate == null
                              ? 'Pilih tanggal lahir'
                              : formatDate(birthDate!),
                          style: TextStyle(
                            color: birthDate == null
                                ? kTextSoft
                                : kTextDark,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      const Icon(
                        Icons.calendar_today_outlined,
                        color: kTextSoft,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Divider(
                color: kBorder,
              ),

              const SizedBox(height: 22),

              // ==========================================
              // PENGATURAN NOTIFIKASI
              // ==========================================

              const Text(
                'Pengaturan Notifikasi',
                style: TextStyle(
                  color: kTextDark,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Atur pengingat untuk membantu memantau menstruasimu.',
                style: TextStyle(
                  color: kTextSoft,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
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
                      width: 43,
                      height: 43,
                      decoration: BoxDecoration(
                        color: kPinkLight,
                        borderRadius:
                            BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.notifications_none_outlined,
                        color: kPinkDark,
                        size: 23,
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pengingat Menstruasi',
                            style: TextStyle(
                              color: kTextDark,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            'Aktifkan atau nonaktifkan pengingat',
                            style: TextStyle(
                              color: kTextSoft,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Switch(
                      value: notificationEnabled,
                      activeThumbColor: kPink,
                      onChanged: (value) {
                        setState(() {
                          notificationEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ==========================================
              // SIMPAN PERUBAHAN
              // ==========================================

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: saveProfile,
                  icon: const Icon(
                    Icons.save_outlined,
                  ),
                  label: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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

              const SizedBox(height: 17),

              const Center(
                child: Text(
                  'Pengaturan profil masih dalam tahap pengembangan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kTextSoft,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
