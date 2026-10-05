import 'package:flutter/material.dart';
import '../models/kpsp_question.dart';
import '../data/red_flags_database.dart';

class RedFlagsScreen extends StatefulWidget {
  const RedFlagsScreen({super.key});

  @override
  State<RedFlagsScreen> createState() => _RedFlagsScreenState();
}

class _RedFlagsScreenState extends State<RedFlagsScreen> {
  DevelopmentSector? _selectedSector;

  @override
  Widget build(BuildContext context) {
    final flags = _selectedSector == null
        ? RedFlagsDatabase.redFlags
        : RedFlagsDatabase.redFlags.where((r) => r.sector == _selectedSector).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kamus Tanda Bahaya (Red Flags)'),
      ),
      body: Column(
        children: [
          // Banner Peringatan Medis
          Container(
            padding: const EdgeInsets.all(14),
            color: Colors.red.shade50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red.shade800, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PENTING: Jangan Menunda Pemeriksaan!',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade900, fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Jika menemukan tanda bahaya (Red Flags) di bawah ini pada anak Anda, jangan menunggu jadwal skrining KPSP berikutnya. Segera bawa ke Dokter Spesialis Anak (Sp.A) atau Puskesmas.',
                        style: TextStyle(fontSize: 12, color: Colors.red.shade800, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Filter Domain
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Semua Red Flags'),
                  selected: _selectedSector == null,
                  onSelected: (val) {
                    if (val) setState(() => _selectedSector = null);
                  },
                ),
                const SizedBox(width: 8),
                ...DevelopmentSector.values.map((s) {
                  final isSelected = _selectedSector == s;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(s.label),
                      selected: isSelected,
                      selectedColor: Colors.red.shade700,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      onSelected: (val) {
                        setState(() {
                          _selectedSector = val ? s : null;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          // Daftar Kartu Red Flag
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: flags.length,
              itemBuilder: (context, index) {
                final item = flags[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: Colors.red.shade200),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item.sector.label,
                                style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Batas Usia: ${item.ageRange}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.title,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red.shade900),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.warningText,
                          style: const TextStyle(fontSize: 13, height: 1.3),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.biotech, size: 14, color: Colors.blueGrey),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Makna Klinis: ${item.clinicalSignificance}',
                                      style: const TextStyle(fontSize: 11.5, color: Colors.blueGrey),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.local_hospital, size: 14, color: Colors.red.shade800),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Tindakan: ${item.actionRequired}',
                                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Colors.red.shade900),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
