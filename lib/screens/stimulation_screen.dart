import 'package:flutter/material.dart';
import '../models/kpsp_question.dart';
import '../data/stimulation_database.dart';

class StimulationScreen extends StatefulWidget {
  final DevelopmentSector? initialSector;
  final int? initialAgeInMonths;

  const StimulationScreen({
    super.key,
    this.initialSector,
    this.initialAgeInMonths,
  });

  @override
  State<StimulationScreen> createState() => _StimulationScreenState();
}

class _StimulationScreenState extends State<StimulationScreen> {
  DevelopmentSector? _selectedSector;

  @override
  void initState() {
    super.initState();
    _selectedSector = widget.initialSector;
  }

  Color _getSectorColor(DevelopmentSector sector) {
    switch (sector) {
      case DevelopmentSector.motorikKasar:
        return Colors.blue.shade700;
      case DevelopmentSector.motorikHalus:
        return Colors.amber.shade800;
      case DevelopmentSector.bicaraBahasa:
        return Colors.purple.shade700;
      case DevelopmentSector.sosialisasiKemandirian:
        return Colors.teal.shade700;
    }
  }

  IconData _getSectorIcon(DevelopmentSector sector) {
    switch (sector) {
      case DevelopmentSector.motorikKasar:
        return Icons.directions_run;
      case DevelopmentSector.motorikHalus:
        return Icons.pan_tool_alt;
      case DevelopmentSector.bicaraBahasa:
        return Icons.record_voice_over;
      case DevelopmentSector.sosialisasiKemandirian:
        return Icons.people;
    }
  }

  @override
  Widget build(BuildContext context) {
    final allItems = StimulationDatabase.getAllStimulations();
    final filtered = _selectedSector == null
        ? allItems
        : allItems.where((i) => i.sector == _selectedSector).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panduan Stimulasi Terarah'),
      ),
      body: Column(
        children: [
          // Header info box
          Container(
            padding: const EdgeInsets.all(14),
            color: Colors.teal.shade50,
            child: Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.teal.shade800, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Stimulasi yang konsisten selama 2 minggu dapat membantu mengejar milestone yang belum tercapai pada pemeriksaan KPSP.',
                    style: TextStyle(fontSize: 12, color: Colors.teal.shade900, height: 1.3),
                  ),
                ),
              ],
            ),
          ),

          // Sector filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Semua Domain'),
                  selected: _selectedSector == null,
                  onSelected: (val) {
                    if (val) setState(() => _selectedSector = null);
                  },
                ),
                const SizedBox(width: 8),
                ...DevelopmentSector.values.map((s) {
                  final isSelected = _selectedSector == s;
                  final color = _getSectorColor(s);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      avatar: Icon(_getSectorIcon(s), size: 16, color: isSelected ? Colors.white : color),
                      label: Text(s.label),
                      selected: isSelected,
                      selectedColor: color,
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

          // List Panduan
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final item = filtered[index];
                final color = _getSectorColor(item.sector);

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: color.withValues(alpha: 0.4)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(_getSectorIcon(item.sector), size: 14, color: color),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.sector.label,
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item.ageRangeText,
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.description,
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade800, height: 1.3),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Langkah Praktis Stimulasi Harian:',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        ...item.practicalSteps.map((step) => Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.check_circle_outline, size: 16, color: Colors.teal),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(step, style: const TextStyle(fontSize: 12.5, height: 1.3)),
                              ),
                            ],
                          ),
                        )),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber.shade200),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.tips_and_updates, size: 16, color: Colors.amber.shade900),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Tips Orang Tua: ${item.tips}',
                                  style: TextStyle(fontSize: 11.5, color: Colors.amber.shade900, fontStyle: FontStyle.italic),
                                ),
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
