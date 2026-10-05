import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/child.dart';

class ChildFormDialog extends StatefulWidget {
  final Child? initialChild;
  final Function(Child) onSave;

  const ChildFormDialog({
    super.key,
    this.initialChild,
    required this.onSave,
  });

  @override
  State<ChildFormDialog> createState() => _ChildFormDialogState();
}

class _ChildFormDialogState extends State<ChildFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _nikController;
  late TextEditingController _parentNameController;
  late TextEditingController _phoneController;
  late TextEditingController _posyanduController;
  late TextEditingController _notesController;

  late DateTime _birthDate;
  late Gender _gender;
  late int _gestationalWeeks;
  bool _isPrematureToggle = false;

  @override
  void initState() {
    super.initState();
    final c = widget.initialChild;
    _nameController = TextEditingController(text: c?.name ?? '');
    _nikController = TextEditingController(text: c?.nik ?? '');
    _parentNameController = TextEditingController(text: c?.parentName ?? '');
    _phoneController = TextEditingController(text: c?.phone ?? '');
    _posyanduController = TextEditingController(text: c?.posyanduName ?? '');
    _notesController = TextEditingController(text: c?.notes ?? '');

    _birthDate = c?.birthDate ?? DateTime.now().subtract(const Duration(days: 180));
    _gender = c?.gender ?? Gender.male;
    _gestationalWeeks = c?.gestationalWeeks ?? 40;
    _isPrematureToggle = (c != null && c.gestationalWeeks < 37);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _parentNameController.dispose();
    _phoneController.dispose();
    _posyanduController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 6)), // Maksimal 6 tahun
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy');
    final dummyChild = Child(
      id: 'preview',
      name: _nameController.text,
      birthDate: _birthDate,
      gender: _gender,
      gestationalWeeks: _isPrematureToggle ? _gestationalWeeks : 40,
    );
    final chronoAge = dummyChild.getChronologicalAge();
    final correctedAge = dummyChild.getCorrectedAge();
    final kpspTarget = dummyChild.getTargetKpspMonth();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      widget.initialChild == null ? Icons.person_add : Icons.edit,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.initialChild == null ? 'Tambah Profil Anak' : 'Ubah Data Anak',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama Lengkap
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nama Lengkap Anak *',
                            prefixIcon: Icon(Icons.badge_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (val) =>
                              (val == null || val.trim().isEmpty) ? 'Nama anak wajib diisi' : null,
                        ),
                        const SizedBox(height: 12),

                        // NIK & Jenis Kelamin
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: _nikController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'NIK Anak (Opsional)',
                                  prefixIcon: Icon(Icons.credit_card),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<Gender>(
                                initialValue: _gender,
                                decoration: const InputDecoration(
                                  labelText: 'Jenis Kelamin',
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: Gender.male,
                                    child: Text('Laki-laki'),
                                  ),
                                  DropdownMenuItem(
                                    value: Gender.female,
                                    child: Text('Perempuan'),
                                  ),
                                ],
                                onChanged: (val) {
                                  if (val != null) setState(() => _gender = val);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Tanggal Lahir
                        InkWell(
                          onTap: _pickDate,
                          borderRadius: BorderRadius.circular(8),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Tanggal Lahir *',
                              prefixIcon: Icon(Icons.cake_outlined),
                              border: OutlineInputBorder(),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(dateFormat.format(_birthDate), style: const TextStyle(fontWeight: FontWeight.bold)),
                                const Icon(Icons.calendar_month, color: Colors.teal),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Bagian Prematuritas & Usia Koreksi
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.child_care, color: Colors.amber.shade900),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text(
                                      'Riwayat Kelahiran Prematur (< 37 Minggu)',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ),
                                  Switch(
                                    value: _isPrematureToggle,
                                    activeThumbColor: Colors.amber.shade800,
                                    onChanged: (val) {
                                      setState(() {
                                        _isPrematureToggle = val;
                                        if (val && _gestationalWeeks >= 37) {
                                          _gestationalWeeks = 32;
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                              if (_isPrematureToggle) ...[
                                const SizedBox(height: 6),
                                Text(
                                  'Usia kehamilan saat lahir: $_gestationalWeeks Minggu (${40 - _gestationalWeeks} minggu lebih awal)',
                                  style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
                                ),
                                Slider(
                                  value: _gestationalWeeks.toDouble(),
                                  min: 24,
                                  max: 36,
                                  divisions: 12,
                                  label: '$_gestationalWeeks Minggu',
                                  activeColor: Colors.amber.shade800,
                                  onChanged: (val) {
                                    setState(() {
                                      _gestationalWeeks = val.round();
                                    });
                                  },
                                ),
                                Text(
                                  'Catatan IDAI: Anak prematur dihitung Usia Koreksi hingga umur 2 tahun agar tidak salah mendiagnosis keterlambatan.',
                                  style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey.shade700),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Kalkulator Preview Usia Real-Time
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.teal.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calculate, color: Colors.teal.shade800),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Usia Kronologis: ${chronoAge.formatted}',
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    if (_isPrematureToggle)
                                      Text('Usia Koreksi: ${correctedAge.formatted}',
                                          style: TextStyle(fontSize: 12, color: Colors.teal.shade900, fontWeight: FontWeight.bold)),
                                    Text('Paket Soal KPSP yang Sesuai: $kpspTarget Bulan',
                                        style: TextStyle(fontSize: 12, color: Colors.teal.shade800)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Data Tambahan (Orang Tua & Posyandu)
                        TextFormField(
                          controller: _parentNameController,
                          decoration: const InputDecoration(
                            labelText: 'Nama Orang Tua / Wali',
                            prefixIcon: Icon(Icons.people_outline),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  labelText: 'No. Handphone / WhatsApp',
                                  prefixIcon: Icon(Icons.phone_outlined),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _posyanduController,
                                decoration: const InputDecoration(
                                  labelText: 'Posyandu / Puskesmas',
                                  prefixIcon: Icon(Icons.local_hospital_outlined),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _notesController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Catatan Khusus (Riwayat Medis/Kelahiran)',
                            prefixIcon: Icon(Icons.notes),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Tombol Simpan
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final child = Child(
                          id: widget.initialChild?.id ?? 'child_${DateTime.now().millisecondsSinceEpoch}',
                          name: _nameController.text.trim(),
                          nik: _nikController.text.trim().isEmpty ? null : _nikController.text.trim(),
                          birthDate: _birthDate,
                          gender: _gender,
                          gestationalWeeks: _isPrematureToggle ? _gestationalWeeks : 40,
                          parentName: _parentNameController.text.trim().isEmpty ? null : _parentNameController.text.trim(),
                          phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
                          posyanduName: _posyanduController.text.trim().isEmpty ? null : _posyanduController.text.trim(),
                          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
                        );
                        widget.onSave(child);
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan Data'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
