import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/child.dart';
import '../models/screening_result.dart';
import '../services/storage_service.dart';
import '../services/pdf_report_service.dart';
import 'result_screen.dart';

class HistoryScreen extends StatefulWidget {
  final Child child;
  final StorageService storageService;

  const HistoryScreen({
    super.key,
    required this.child,
    required this.storageService,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List<ScreeningResult> _screenings;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _screenings = widget.storageService.getScreeningsForChild(widget.child.id);
    });
  }

  Color _getStatusColor(KpspStatus status) {
    switch (status) {
      case KpspStatus.sesuai:
        return Colors.green.shade700;
      case KpspStatus.meragukan:
        return Colors.amber.shade800;
      case KpspStatus.penyimpangan:
        return Colors.red.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy, HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Milestone - ${widget.child.name}'),
      ),
      body: _screenings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off, size: 72, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada riwayat skrining untuk anak ini.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lakukan skrining pertama untuk memantau tumbuh kembangnya.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _screenings.length,
              itemBuilder: (context, index) {
                final item = _screenings[index];
                final statusColor = _getStatusColor(item.status);

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: statusColor.withValues(alpha: 0.4), width: 1.5),
                  ),
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => ResultScreen(
                            child: widget.child,
                            result: item,
                            storageService: widget.storageService,
                          ),
                        ),
                      );
                    },
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
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item.status.badgeText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              Text(
                                dateFormat.format(item.date),
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Paket KPSP ${item.kpspAgeInMonths} Bulan',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Usia saat periksa: ${item.chronologicalAgeText}',
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                    ),
                                    if (item.correctedAgeText != null)
                                      Text(
                                        'Usia Koreksi: ${item.correctedAgeText}',
                                        style: TextStyle(fontSize: 12, color: Colors.teal.shade800),
                                      ),
                                  ],
                                ),
                              ),
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: statusColor.withValues(alpha: 0.12),
                                child: Text(
                                  '${item.totalYes}/10',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pemeriksa: ${item.screenerName ?? item.screenerRole}',
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Cetak PDF',
                                    icon: const Icon(Icons.print, size: 20, color: Colors.teal),
                                    onPressed: () => PdfReportService.printOrShareReport(
                                      child: widget.child,
                                      screening: item,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Hapus Catatan',
                                    icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Hapus Catatan Skrining?'),
                                          content: const Text('Tindakan ini tidak dapat dibatalkan.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(ctx, false),
                                              child: const Text('Batal'),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                              onPressed: () => Navigator.pop(ctx, true),
                                              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        await widget.storageService.deleteScreening(item.id);
                                        _loadData();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
