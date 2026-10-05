import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/child.dart';
import '../models/screening_result.dart';
import '../models/kpsp_question.dart';
import '../data/kpsp_database.dart';
import '../services/storage_service.dart';
import '../services/pdf_report_service.dart';
import 'stimulation_screen.dart';
import 'red_flags_screen.dart';

class ResultScreen extends StatelessWidget {
  final Child child;
  final ScreeningResult result;
  final StorageService storageService;

  const ResultScreen({
    super.key,
    required this.child,
    required this.result,
    required this.storageService,
  });

  Color _getStatusColor() {
    switch (result.status) {
      case KpspStatus.sesuai:
        return Colors.green.shade700;
      case KpspStatus.meragukan:
        return Colors.amber.shade800;
      case KpspStatus.penyimpangan:
        return Colors.red.shade700;
    }
  }

  IconData _getStatusIcon() {
    switch (result.status) {
      case KpspStatus.sesuai:
        return Icons.verified;
      case KpspStatus.meragukan:
        return Icons.help_outline;
      case KpspStatus.penyimpangan:
        return Icons.warning_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final statusIcon = _getStatusIcon();
    final dateFormat = DateFormat('dd MMMM yyyy HH:mm');
    final questions = KpspDatabase.getQuestionsForAge(result.kpspAgeInMonths);
    final unmetQuestions = questions.where((q) => (result.answers[q.id] == false)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Skrining KPSP'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        actions: [
          IconButton(
            tooltip: 'Cetak / Unduh PDF',
            icon: const Icon(Icons.print),
            onPressed: () => PdfReportService.printOrShareReport(
              child: child,
              screening: result,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Banner Status Utama
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: statusColor,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(statusIcon, color: Colors.white, size: 54),
                        const SizedBox(height: 8),
                        Text(
                          result.status.label.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Skor Jawaban YA: ${result.totalYes} / 10  •  TIDAK: ${result.totalNo}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          result.status.recommendation,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Data Anak & Skrining
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Informasi Pemeriksaan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text(dateFormat.format(result.date), style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          ],
                        ),
                        const Divider(),
                        _buildRow('Nama Anak', child.name),
                        _buildRow('Usia Kronologis', result.chronologicalAgeText),
                        if (result.correctedAgeText != null)
                          _buildRow('Usia Koreksi Prematur', '${result.correctedAgeText} (Gestasi ${child.gestationalWeeks} mg)'),
                        _buildRow('Paket Skrining KPSP', '${result.kpspAgeInMonths} Bulan'),
                        _buildRow('Peran Pemeriksa', result.screenerRole),
                        if (result.screenerName != null)
                          _buildRow('Nama Pemeriksa', result.screenerName!),
                        if (result.notes != null)
                          _buildRow('Catatan', result.notes!),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Ringkasan Capaian 4 Sektor Perkembangan
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Capaian 4 Domain Perkembangan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 12),
                        ...DevelopmentSector.values.map((sector) {
                          final summary = result.sectorSummaries[sector.name] ??
                              const SectorSummary(total: 0, yesCount: 0);
                          final pct = summary.total > 0 ? summary.yesCount / summary.total : 0.0;
                          final isPassed = summary.isAllPassed;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          isPassed ? Icons.check_circle : Icons.error_outline,
                                          size: 16,
                                          color: isPassed ? Colors.green.shade700 : Colors.amber.shade800,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(sector.label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                      ],
                                    ),
                                    Text(
                                      '${summary.yesCount}/${summary.total} YA (${(pct * 100).toStringAsFixed(0)}%)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: isPassed ? Colors.green.shade800 : Colors.amber.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: pct,
                                    minHeight: 8,
                                    backgroundColor: Colors.grey.shade200,
                                    color: isPassed ? Colors.green.shade600 : Colors.amber.shade700,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Kemampuan yang Belum Dicapai (Jika ada jawaban "Tidak")
                if (unmetQuestions.isNotEmpty) ...[
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Colors.amber.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.flag, color: Colors.amber.shade900),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Keterampilan yang Perlu Dilatih & Distimulasi (${unmetQuestions.length} Butir):',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade900, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...unmetQuestions.map((q) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.amber.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        q.sector.label,
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber.shade900),
                                      ),
                                    ),
                                    if (q.isRedFlag) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade100,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'RED FLAG',
                                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red.shade900),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(q.question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                const SizedBox(height: 4),
                                Text(
                                  'Saran stimulasi: ${q.instruction}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => StimulationScreen(
                                initialAgeInMonths: result.kpspAgeInMonths,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.fitness_center),
                        label: const Text('Panduan Stimulasi', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey.shade800,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          PdfReportService.printOrShareReport(
                            child: child,
                            screening: result,
                          );
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Cetak / Simpan PDF', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const RedFlagsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.warning_amber, color: Colors.red),
                  label: const Text('Kamus Tanda Bahaya (Red Flags)'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  child: const Text('Kembali ke Halaman Utama'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
          ),
          const Text(': ', style: TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
