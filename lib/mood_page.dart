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
  String? selectedLevel;

  final List<String> selectedSymptoms = [];

  final TextEditingController noteController =
      TextEditingController();

  bool hasSaved = false;

  // ======================================================
  // DATA PILIHAN
  // ======================================================

  final List<String> moods = [
    'Senang',
    'Tenang',
    'Biasa',
    'Sedih',
    'Lelah',
  ];

  final List<IconData> moodIcons = [
    Icons.sentiment_very_satisfied_outlined,
    Icons.sentiment_satisfied_outlined,
    Icons.sentiment_neutral_outlined,
    Icons.sentiment_dissatisfied_outlined,
    Icons.battery_2_bar_outlined,
  ];

  final List<String> symptoms = [
    'Kram',
    'Sakit Kepala',
    'Kembung',
    'Mual',
    'Jerawat',
    'Nyeri Payudara',
    'Pegal',
    'Sulit Tidur',
  ];

  final List<String> complaintLevels = [
    'Ringan',
    'Sedang',
    'Berat',
  ];

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  // ======================================================
  // PILIH / HAPUS GEJALA
  // ======================================================

  void toggleSymptom(String symptom) {
    setState(() {
      if (selectedSymptoms.contains(symptom)) {
        selectedSymptoms.remove(symptom);
      } else {
        selectedSymptoms.add(symptom);
      }
    });
  }

  // ======================================================
  // SIMPAN
  // ======================================================

  void saveLog() {
    if (selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pilih mood terlebih dahulu.',
          ),
        ),
      );

      return;
    }

    setState(() {
      hasSaved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Catatan berhasil disimpan.',
        ),
      ),
    );
  }

  // ======================================================
  // RESET
  // ======================================================

  void resetLog() {
    setState(() {
      selectedMood = null;
      selectedLevel = null;
      selectedSymptoms.clear();
      noteController.clear();
      hasSaved = false;
    });
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
          'Mood & Gejala',
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
          10,
          20,
          35,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // INFO
            // ==================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kPinkLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.edit_note_outlined,
                    color: kPinkDark,
                    size: 28,
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      'Catat kondisi yang kamu rasakan hari ini.',
                      style: TextStyle(
                        color: kTextDark,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // MOOD
            // ==================================================

            const Text(
              'Bagaimana mood kamu hari ini?',
              style: TextStyle(
                color: kTextDark,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Pilih satu mood yang paling sesuai.',
              style: TextStyle(
                color: kTextSoft,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 95,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: moods.length,
                separatorBuilder: (
                  context,
                  index,
                ) =>
                    const SizedBox(width: 10),
                itemBuilder: (
                  context,
                  index,
                ) {
                  final mood = moods[index];

                  final selected =
                      selectedMood == mood;

                  return InkWell(
                    borderRadius:
                        BorderRadius.circular(14),
                    onTap: () {
                      setState(() {
                        selectedMood = mood;
                        hasSaved = false;
                      });
                    },
                    child: Container(
                      width: 78,
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? kPinkLight
                            : Colors.white,
                        borderRadius:
                            BorderRadius.circular(14),
                        border: Border.all(
                          color: selected
                              ? kPink
                              : const Color(
                                  0xFFEFE4E8,
                                ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            moodIcons[index],
                            color: selected
                                ? kPinkDark
                                : kTextSoft,
                            size: 28,
                          ),

                          const SizedBox(height: 7),

                          Text(
                            mood,
                            style: TextStyle(
                              color: selected
                                  ? kPinkDark
                                  : kTextDark,
                              fontSize: 11,
                              fontWeight:
                                  selected
                                      ? FontWeight
                                          .bold
                                      : FontWeight
                                          .normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // GEJALA
            // ==================================================

            const Text(
              'Gejala yang dirasakan',
              style: TextStyle(
                color: kTextDark,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Kamu bisa memilih lebih dari satu.',
              style: TextStyle(
                color: kTextSoft,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 15),

            Wrap(
              spacing: 9,
              runSpacing: 9,
              children: symptoms.map(
                (symptom) {
                  final selected =
                      selectedSymptoms.contains(
                    symptom,
                  );

                  return FilterChip(
                    label: Text(symptom),
                    selected: selected,

                    onSelected: (_) {
                      toggleSymptom(symptom);

                      setState(() {
                        hasSaved = false;
                      });
                    },

                    selectedColor: kPinkLight,
                    backgroundColor: Colors.white,

                    side: BorderSide(
                      color: selected
                          ? kPink
                          : const Color(
                              0xFFEFE4E8,
                            ),
                    ),

                    checkmarkColor: kPinkDark,

                    labelStyle: TextStyle(
                      color: selected
                          ? kPinkDark
                          : kTextDark,
                      fontSize: 12,
                    ),
                  );
                },
              ).toList(),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // TINGKAT KELUHAN
            // ==================================================

            const Text(
              'Tingkat keluhan',
              style: TextStyle(
                color: kTextDark,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Pilih berdasarkan kondisi yang kamu rasakan.',
              style: TextStyle(
                color: kTextSoft,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: complaintLevels.map(
                (level) {
                  final selected =
                      selectedLevel == level;

                  return Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(
                        right: 8,
                      ),
                      child: InkWell(
                        borderRadius:
                            BorderRadius.circular(12),
                        onTap: () {
                          setState(() {
                            selectedLevel = level;
                            hasSaved = false;
                          });
                        },
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 13,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? kPinkLight
                                : Colors.white,
                            borderRadius:
                                BorderRadius.circular(
                              12,
                            ),
                            border: Border.all(
                              color: selected
                                  ? kPink
                                  : const Color(
                                      0xFFEFE4E8,
                                    ),
                            ),
                          ),
                          child: Text(
                            level,
                            textAlign:
                                TextAlign.center,
                            style: TextStyle(
                              color: selected
                                  ? kPinkDark
                                  : kTextDark,
                              fontSize: 12,
                              fontWeight:
                                  selected
                                      ? FontWeight
                                          .bold
                                      : FontWeight
                                          .normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // CATATAN
            // ==================================================

            const Text(
              'Catatan tambahan',
              style: TextStyle(
                color: kTextDark,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Bagian ini boleh dikosongkan.',
              style: TextStyle(
                color: kTextSoft,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: noteController,
              maxLines: 4,
              onChanged: (_) {
                setState(() {
                  hasSaved = false;
                });
              },
              decoration: InputDecoration(
                hintText:
                    'Contoh: Hari ini merasa sedikit kram dan lelah...',
                hintStyle: const TextStyle(
                  color: kTextSoft,
                  fontSize: 12,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(
                      0xFFEFE4E8,
                    ),
                  ),
                ),
                enabledBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(
                      0xFFEFE4E8,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // SIMPAN
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: saveLog,
                style:
                    FilledButton.styleFrom(
                  backgroundColor: kPink,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.save_outlined,
                ),
                label: const Text(
                  'Simpan Catatan',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            // ==================================================
            // HASIL
            // ==================================================

            if (hasSaved) ...[
              const SizedBox(height: 30),

              const Divider(),

              const SizedBox(height: 20),

              Row(
                children: [
                  const Text(
                    'Catatan Hari Ini',
                    style: TextStyle(
                      color: kTextDark,
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed: resetLog,
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        color: kPinkDark,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              SavedDataRow(
                title: 'Mood',
                value: selectedMood ?? '-',
              ),

              const SizedBox(height: 12),

              SavedDataRow(
                title: 'Gejala',
                value:
                    selectedSymptoms.isEmpty
                        ? 'Tidak ada'
                        : selectedSymptoms.join(
                            ', ',
                          ),
              ),

              const SizedBox(height: 12),

              SavedDataRow(
                title: 'Keluhan',
                value:
                    selectedLevel ??
                        'Belum dipilih',
              ),

              if (noteController
                  .text
                  .trim()
                  .isNotEmpty) ...[
                const SizedBox(height: 12),

                SavedDataRow(
                  title: 'Catatan',
                  value:
                      noteController.text.trim(),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

// ======================================================
// HASIL CATATAN
// ======================================================

class SavedDataRow extends StatelessWidget {
  final String title;
  final String value;

  const SavedDataRow({
    super.key,
    required this.title,
    required this.value,
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
          color: const Color(
            0xFFEFE4E8,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: kTextSoft,
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              color: kTextDark,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}