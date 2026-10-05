import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/child.dart';
import '../models/screening_result.dart';
import '../services/storage_service.dart';
import '../services/pdf_report_service.dart';
import '../widgets/child_form_dialog.dart';
import 'screening_screen.dart';
import 'result_screen.dart';
import 'history_screen.dart';
import 'stimulation_screen.dart';
import 'red_flags_screen.dart';

class HomeScreen extends StatefulWidget {
  final StorageService storageService;

  const HomeScreen({super.key, required this.storageService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Child> _children;
  Child? _activeChild;
  List<ScreeningResult> _childScreenings = [];
  late String _userRole;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _children = widget.storageService.getChildren();
      _activeChild = widget.storageService.getActiveChild();
      _userRole = widget.storageService.getUserRole();
      if (_activeChild != null) {
        _childScreenings = widget.storageService.getScreeningsForChild(_activeChild!.id);
      } else {
        _childScreenings = [];
      }
    });
  }

  void _switchActiveChild(Child child) async {
    await widget.storageService.setActiveChildId(child.id);
    _refreshData();
  }

  void _openAddChildDialog() {
    showDialog(
      context: context,
      builder: (ctx) => ChildFormDialog(
        onSave: (newChild) async {
          await widget.storageService.saveChild(newChild);
          await widget.storageService.setActiveChildId(newChild.id);
          _refreshData();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profil ${newChild.name} berhasil disimpan!')),
          );
        },
      ),
    );
  }

  void _openEditChildDialog(Child child) {
    showDialog(
      context: context,
      builder: (ctx) => ChildFormDialog(
        initialChild: child,
        onSave: (updatedChild) async {
          await widget.storageService.saveChild(updatedChild);
          _refreshData();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data ${updatedChild.name} berhasil diperbarui!')),
          );
        },
      ),
    );
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
    final dateFormat = DateFormat('dd MMM yyyy');
    final active = _activeChild;
    final lastScreening = _childScreenings.isNotEmpty ? _childScreenings.first : null;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'BIK',
                style: TextStyle(fontWeight: FontWeight.w900, color: Colors.teal, fontSize: 13),
              ),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Langkah Awal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Kelompok 13 • KPSP Digital Kemenkes', style: TextStyle(fontSize: 10, color: Colors.white70)),
              ],
            ),
          ],
        ),
        actions: [
          // Switcher Peran Pengguna
          PopupMenuButton<String>(
            tooltip: 'Ganti Peran Pengguna',
            initialValue: _userRole,
            icon: const Icon(Icons.manage_accounts),
            onSelected: (val) async {
              await widget.storageService.setUserRole(val);
              _refreshData();
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'Orang Tua', child: Text('Mode: Orang Tua')),
              const PopupMenuItem(value: 'Kader Posyandu', child: Text('Mode: Kader Posyandu')),
              const PopupMenuItem(value: 'Tenaga Kesehatan', child: Text('Mode: Tenaga Kesehatan (Nakes)')),
            ],
          ),
          IconButton(
            tooltip: 'Tambah Data Balita',
            icon: const Icon(Icons.person_add),
            onPressed: _openAddChildDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Banner Peran Saat Ini
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.teal.shade100),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _userRole == 'Orang Tua'
                            ? Icons.family_restroom
                            : (_userRole == 'Kader Posyandu' ? Icons.volunteer_activism : Icons.medical_services),
                        size: 18,
                        color: Colors.teal.shade800,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Peran Aktif: $_userRole',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal.shade900),
                      ),
                      const Spacer(),
                      const Text(
                        'SDIDTK Kemenkes RI',
                        style: TextStyle(fontSize: 11, color: Colors.teal),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Card Pemilihan & Data Balita Aktif
                if (active != null) _buildActiveChildCard(active, dateFormat),
                if (active == null) _buildNoChildCard(),
                const SizedBox(height: 16),

                // Hero Card: Mulai Skrining KPSP
                if (active != null) _buildScreeningHeroCard(active),
                const SizedBox(height: 16),

                // Kartu Status Hasil Skrining Terakhir
                if (active != null && lastScreening != null)
                  _buildLastScreeningCard(active, lastScreening, dateFormat),
                if (active != null && lastScreening == null)
                  _buildEmptyScreeningPrompt(active),
                const SizedBox(height: 16),

                // Grid Menu Cepat
                const Text('Menu Layanan & Pemantauan:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildQuickMenuGrid(active),
                const SizedBox(height: 18),

                // Info Edukasi KPSP SDIDTK
                _buildEducationCard(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveChildCard(Child child, DateFormat dateFormat) {
    final chrono = child.getChronologicalAge();
    final corrected = child.isPremature ? child.getCorrectedAge() : null;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: child.gender == Gender.male ? Colors.blue.shade100 : Colors.pink.shade100,
                  child: Icon(
                    child.gender == Gender.male ? Icons.boy : Icons.girl,
                    size: 32,
                    color: child.gender == Gender.male ? Colors.blue.shade800 : Colors.pink.shade800,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              child.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (child.isPremature) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'PREMATUR',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber.shade900,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Lahir: ${dateFormat.format(child.birthDate)}  •  ${child.gender == Gender.male ? "Laki-laki" : "Perempuan"}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Usia Kronologis: ${chrono.formatted}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      if (child.isPremature && corrected != null)
                        Text(
                          'Usia Koreksi Prematur: ${corrected.formatted} (${child.gestationalWeeks} mg)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade900,
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      tooltip: 'Ubah Data Balita',
                      icon: const Icon(Icons.edit, size: 20, color: Colors.teal),
                      onPressed: () => _openEditChildDialog(child),
                    ),
                    // Dropdown Switcher Anak
                    PopupMenuButton<Child>(
                      tooltip: 'Pilih Profil Balita Lain',
                      icon: const Icon(Icons.swap_horiz, size: 22),
                      onSelected: _switchActiveChild,
                      itemBuilder: (ctx) => _children.map((c) {
                        return PopupMenuItem<Child>(
                          value: c,
                          child: Text(c.name, style: TextStyle(fontWeight: c.id == child.id ? FontWeight.bold : FontWeight.normal)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoChildCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.child_care, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            const Text('Belum ada data balita terdaftar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _openAddChildDialog,
              icon: const Icon(Icons.add),
              label: const Text('Tambah Balita Pertama'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreeningHeroCard(Child child) {
    final targetMonth = child.getTargetKpspMonth();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade700, Colors.teal.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.teal.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.checklist_rtl, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jadwal Skrining KPSP Rekomendasi:',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      'Paket Usia $targetMonth Bulan (10 Butir)',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Lakukan skrining 10 butir keterampilan motorik kasar, halus, bicara, dan kemandirian untuk deteksi dini tumbuh kembang ${child.name}.',
            style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.teal.shade900,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 2,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => ScreeningScreen(
                      child: child,
                      storageService: widget.storageService,
                    ),
                  ),
                ).then((_) => _refreshData());
              },
              icon: const Icon(Icons.play_arrow_rounded, size: 26),
              label: const Text(
                'Mulai Skrining KPSP Sekarang',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastScreeningCard(Child child, ScreeningResult result, DateFormat dateFormat) {
    final statusColor = _getStatusColor(result.status);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: statusColor.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Hasil Skrining Terakhir',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    result.status.badgeText,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
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
                        'Paket KPSP ${result.kpspAgeInMonths} Bulan (${dateFormat.format(result.date)})',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Skor: ${result.totalYes} YA / 10  •  Tidak: ${result.totalNo}',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        result.status.label,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Cetak / Simpan PDF',
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.teal),
                  onPressed: () => PdfReportService.printOrShareReport(
                    child: child,
                    screening: result,
                  ),
                ),
                IconButton(
                  tooltip: 'Buka Hasil Lengkap',
                  icon: const Icon(Icons.chevron_right, color: Colors.grey),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => ResultScreen(
                          child: child,
                          result: result,
                          storageService: widget.storageService,
                        ),
                      ),
                    ).then((_) => _refreshData());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyScreeningPrompt(Child child) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey.shade50,
      child: const Padding(
        padding: EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.teal),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Belum ada hasil skrining tercatat untuk anak ini. Mulai skrining untuk mencatat rekam milestone pertamanya.',
                style: TextStyle(fontSize: 12.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickMenuGrid(Child? child) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildMenuTile(
          icon: Icons.timeline,
          title: 'Riwayat Milestone',
          subtitle: '${_childScreenings.length} Skrining',
          color: Colors.indigo,
          onTap: child == null
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => HistoryScreen(
                        child: child,
                        storageService: widget.storageService,
                      ),
                    ),
                  ).then((_) => _refreshData());
                },
        ),
        _buildMenuTile(
          icon: Icons.fitness_center,
          title: 'Panduan Stimulasi',
          subtitle: '4 Domain Usia',
          color: Colors.teal,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => const StimulationScreen(),
              ),
            );
          },
        ),
        _buildMenuTile(
          icon: Icons.warning_amber_rounded,
          title: 'Kamus Red Flags',
          subtitle: 'Tanda Bahaya Medis',
          color: Colors.red.shade700,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => const RedFlagsScreen(),
              ),
            );
          },
        ),
        _buildMenuTile(
          icon: Icons.print,
          title: 'Cetak Laporan',
          subtitle: 'Format Resmi BIK',
          color: Colors.blueGrey.shade800,
          onTap: (child != null && _childScreenings.isNotEmpty)
              ? () {
                  PdfReportService.printOrShareReport(
                    child: child,
                    screening: _childScreenings.first,
                  );
                }
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lakukan skrining terlebih dahulu sebelum mencetak laporan.')),
                  );
                },
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.health_and_safety, color: Colors.blueGrey.shade800, size: 20),
              const SizedBox(width: 8),
              Text(
                'Standar Evaluasi KPSP Kemenkes RI',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey.shade900),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '• Skor Ya 9-10 (Hijau): Sesuai (S). Lanjutkan stimulasi rutin.\n'
            '• Skor Ya 7-8 (Kuning): Meragukan (M). Lakukan stimulasi 2 minggu lalu skrining ulang.\n'
            '• Skor Ya ≤ 6 (Merah): Kemungkinan Penyimpangan (P). Segera rujuk ke Puskesmas/Dokter Spesialis Anak.',
            style: TextStyle(fontSize: 12, height: 1.4, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
