import 'package:flutter/material.dart';
import '../models/child.dart';
import '../models/kpsp_question.dart';
import '../models/screening_result.dart';
import '../data/kpsp_database.dart';
import '../services/storage_service.dart';
import 'result_screen.dart';

class ScreeningScreen extends StatefulWidget {
  final Child child;
  final StorageService storageService;
  final int? initialKpspMonth;

  const ScreeningScreen({
    super.key,
    required this.child,
    required this.storageService,
    this.initialKpspMonth,
  });

  @override
  State<ScreeningScreen> createState() => _ScreeningScreenState();
}

class _ScreeningScreenState extends State<ScreeningScreen> {
  late int _selectedAgeMilestone;
  late List<KpspQuestion> _questions;
  final Map<String, bool> _answers = {}; // questionId -> true (Ya) / false (Tidak)
  int _currentIndex = 0;
  bool _isListViewMode = false;

  final TextEditingController _screenerNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  late String _screenerRole;

  @override
  void initState() {
    super.initState();
    _selectedAgeMilestone = widget.initialKpspMonth ?? widget.child.getTargetKpspMonth();
    _questions = KpspDatabase.getQuestionsForAge(_selectedAgeMilestone);
    _screenerRole = widget.storageService.getUserRole();
  }

  @override
  void dispose() {
    _screenerNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onAgeMilestoneChanged(int newMonth) {
    setState(() {
      _selectedAgeMilestone = newMonth;
      _questions = KpspDatabase.getQuestionsForAge(newMonth);
      _answers.clear();
      _currentIndex = 0;
    });
  }

  void _setAnswer(String questionId, bool isYes) {
    setState(() {
      _answers[questionId] = isYes;
      // Otomatis lanjut ke pertanyaan berikutnya jika dalam mode wizard per langkah
      if (!_isListViewMode && _currentIndex < _questions.length - 1) {
        _currentIndex++;
      }
    });
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

  void _submitScreening() {
    final unansweredCount = _questions.length - _answers.length;
    if (unansweredCount > 0) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Kuesioner Belum Lengkap'),
          content: Text(
            'Masih ada $unansweredCount pertanyaan yang belum dijawab. Apakah Anda yakin ingin menganggap pertanyaan yang belum dijawab sebagai "TIDAK", atau ingin melengkapinya?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Lengkapi Dulu'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _processResults();
              },
              child: const Text('Lanjutkan Saja'),
            ),
          ],
        ),
      );
    } else {
      _processResults();
    }
  }

  void _processResults() {
    int totalYes = 0;
    int totalNo = 0;

    // Hitung per sektor
    final Map<String, int> sectorTotals = {};
    final Map<String, int> sectorYesCounts = {};

    for (var s in DevelopmentSector.values) {
      sectorTotals[s.name] = 0;
      sectorYesCounts[s.name] = 0;
    }

    for (var q in _questions) {
      final isYes = _answers[q.id] ?? false;
      sectorTotals[q.sector.name] = (sectorTotals[q.sector.name] ?? 0) + 1;
      if (isYes) {
        totalYes++;
        sectorYesCounts[q.sector.name] = (sectorYesCounts[q.sector.name] ?? 0) + 1;
      } else {
        totalNo++;
      }
    }

    final Map<String, SectorSummary> sectorSummaries = {};
    for (var s in DevelopmentSector.values) {
      sectorSummaries[s.name] = SectorSummary(
        total: sectorTotals[s.name] ?? 0,
        yesCount: sectorYesCounts[s.name] ?? 0,
      );
    }

    final chrono = widget.child.getChronologicalAge();
    final corrected = widget.child.isPremature ? widget.child.getCorrectedAge() : null;

    final result = ScreeningResult(
      id: 'screening_${DateTime.now().millisecondsSinceEpoch}',
      childId: widget.child.id,
      childName: widget.child.name,
      date: DateTime.now(),
      kpspAgeInMonths: _selectedAgeMilestone,
      chronologicalAgeText: chrono.formatted,
      correctedAgeText: corrected?.formatted,
      answers: Map<String, bool>.from(_answers),
      totalYes: totalYes,
      totalNo: totalNo,
      status: ScreeningResult.calculateStatus(totalYes),
      sectorSummaries: sectorSummaries,
      screenerRole: _screenerRole,
      screenerName: _screenerNameController.text.trim().isEmpty ? null : _screenerNameController.text.trim(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    widget.storageService.saveScreening(result);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => ResultScreen(
          child: widget.child,
          result: result,
          storageService: widget.storageService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chronoAge = widget.child.getChronologicalAge();
    final correctedAge = widget.child.isPremature ? widget.child.getCorrectedAge() : null;
    final answeredCount = _answers.length;
    final progress = _questions.isEmpty ? 0.0 : answeredCount / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skrining KPSP Digital'),
        actions: [
          IconButton(
            tooltip: _isListViewMode ? 'Mode Per Pertanyaan' : 'Mode Semua Daftar',
            icon: Icon(_isListViewMode ? Icons.view_carousel : Icons.view_list),
            onPressed: () {
              setState(() {
                _isListViewMode = !_isListViewMode;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner Info Anak & Pemilihan Usia
          Container(
            color: Colors.teal.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: widget.child.gender == Gender.male ? Colors.blue.shade100 : Colors.pink.shade100,
                  child: Icon(
                    widget.child.gender == Gender.male ? Icons.boy : Icons.girl,
                    color: widget.child.gender == Gender.male ? Colors.blue : Colors.pink,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.child.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        'Usia: ${chronoAge.formatted}${correctedAge != null ? " (Koreksi: ${correctedAge.formatted})" : ""}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
                      ),
                    ],
                  ),
                ),
                // Dropdown Pilihan Paket KPSP
                DropdownButton<int>(
                  value: _selectedAgeMilestone,
                  underline: const SizedBox(),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 13),
                  items: KpspDatabase.availableAgeMilestones.map((m) {
                    return DropdownMenuItem<int>(
                      value: m,
                      child: Text('Paket $m Bulan'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) _onAgeMilestoneChanged(val);
                  },
                ),
              ],
            ),
          ),

          // Progress Bar Kuesioner
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            color: Colors.teal,
            minHeight: 6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Terjawab: $answeredCount dari ${_questions.length} butir',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
              ],
            ),
          ),

          // Konten Pertanyaan (Wizard Mode vs List Mode)
          Expanded(
            child: _isListViewMode ? _buildListViewMode() : _buildWizardMode(),
          ),

          // Bottom Bar Navigasi / Selesai
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildWizardMode() {
    if (_questions.isEmpty) {
      return const Center(child: Text('Tidak ada pertanyaan untuk paket ini.'));
    }

    final q = _questions[_currentIndex];
    final sectorColor = _getSectorColor(q.sector);
    final sectorIcon = _getSectorIcon(q.sector);
    final currentAnswer = _answers[q.id];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Badge Sektor & No Soal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: sectorColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: sectorColor.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(sectorIcon, size: 16, color: sectorColor),
                        const SizedBox(width: 6),
                        Text(
                          q.sector.label,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: sectorColor),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Butir ${_currentIndex + 1} / ${_questions.length}',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Kartu Pertanyaan Utama
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        q.question,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      // Petunjuk Pengujian / Alat
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blueGrey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info_outline, size: 16, color: Colors.blueGrey.shade800),
                                const SizedBox(width: 6),
                                Text(
                                  'Petunjuk Pelaksanaan & Pengujian:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey.shade800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              q.instruction,
                              style: TextStyle(fontSize: 13, color: Colors.blueGrey.shade900, height: 1.3),
                            ),
                            if (q.toolsNeeded != null) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.toys_outlined, size: 14, color: Colors.deepOrange),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Alat yang diperlukan: ${q.toolsNeeded}',
                                    style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.deepOrange),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (q.isRedFlag) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, size: 16, color: Colors.red.shade800),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Milestone Kunci: Keterampilan ini penting untuk mendeteksi tanda bahaya dini.',
                                  style: TextStyle(fontSize: 11, color: Colors.red.shade900, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Pilihan Jawaban YA / TIDAK
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: currentAnswer == false ? Colors.red.shade600 : Colors.white,
                        foregroundColor: currentAnswer == false ? Colors.white : Colors.red.shade700,
                        side: BorderSide(color: Colors.red.shade400, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _setAnswer(q.id, false),
                      icon: const Icon(Icons.close, size: 24),
                      label: const Text(
                        'TIDAK (Belum Bisa)',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: currentAnswer == true ? Colors.green.shade700 : Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: currentAnswer == true ? 4 : 2,
                      ),
                      onPressed: () => _setAnswer(q.id, true),
                      icon: const Icon(Icons.check, size: 24),
                      label: const Text(
                        'YA (Bisa)',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListViewMode() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _questions.length,
      itemBuilder: (context, index) {
        final q = _questions[index];
        final currentAnswer = _answers[q.id];
        final sectorColor = _getSectorColor(q.sector);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: sectorColor,
                      child: Text('${index + 1}',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            q.sector.label,
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: sectorColor),
                          ),
                          const SizedBox(height: 2),
                          Text(q.question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          const SizedBox(height: 6),
                          Text(
                            q.instruction,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilterChip(
                      selected: currentAnswer == false,
                      selectedColor: Colors.red.shade100,
                      label: Text('TIDAK', style: TextStyle(color: currentAnswer == false ? Colors.red.shade900 : Colors.black87)),
                      avatar: Icon(Icons.close, size: 16, color: currentAnswer == false ? Colors.red.shade900 : Colors.grey),
                      onSelected: (_) => _setAnswer(q.id, false),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      selected: currentAnswer == true,
                      selectedColor: Colors.green.shade100,
                      label: Text('YA', style: TextStyle(color: currentAnswer == true ? Colors.green.shade900 : Colors.black87)),
                      avatar: Icon(Icons.check, size: 16, color: currentAnswer == true ? Colors.green.shade900 : Colors.grey),
                      onSelected: (_) => _setAnswer(q.id, true),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (!_isListViewMode) ...[
              OutlinedButton.icon(
                onPressed: _currentIndex > 0
                    ? () => setState(() => _currentIndex--)
                    : null,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Sebelumnya'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _currentIndex < _questions.length - 1
                    ? () => setState(() => _currentIndex++)
                    : null,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Berikutnya'),
              ),
            ],
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade800,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: _submitScreening,
              icon: const Icon(Icons.done_all),
              label: const Text('Selesai & Lihat Hasil', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
