import 'package:shared_preferences/shared_preferences.dart';
import '../models/child.dart';
import '../models/screening_result.dart';

class StorageService {
  static const String _keyChildren = 'langkah_awal_children';
  static const String _keyScreenings = 'langkah_awal_screenings';
  static const String _keyActiveChildId = 'langkah_awal_active_child_id';
  static const String _keyUserRole = 'langkah_awal_user_role'; // Orang Tua vs Kader Posyandu / Nakes

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final service = StorageService(prefs);
    await service._seedInitialDataIfEmpty();
    return service;
  }

  // =====================
  // CHILDREN
  // =====================
  List<Child> getChildren() {
    final raw = _prefs.getStringList(_keyChildren);
    if (raw == null || raw.isEmpty) return [];
    return raw.map((item) => Child.fromJson(item)).toList();
  }

  Future<void> saveChild(Child child) async {
    final list = getChildren();
    final index = list.indexWhere((c) => c.id == child.id);
    if (index >= 0) {
      list[index] = child;
    } else {
      list.add(child);
    }
    await _saveChildrenList(list);
  }

  Future<void> deleteChild(String childId) async {
    final list = getChildren().where((c) => c.id != childId).toList();
    await _saveChildrenList(list);

    // Hapus juga riwayat skrining anak tersebut
    final screenings = getScreenings().where((s) => s.childId != childId).toList();
    await _saveScreeningsList(screenings);

    // Reset active child id jika yang dihapus sedang aktif
    if (getActiveChildId() == childId) {
      final remaining = list.isNotEmpty ? list.first.id : null;
      await setActiveChildId(remaining);
    }
  }

  Future<void> _saveChildrenList(List<Child> list) async {
    final raw = list.map((c) => c.toJson()).toList();
    await _prefs.setStringList(_keyChildren, raw);
  }

  // =====================
  // ACTIVE CHILD
  // =====================
  String? getActiveChildId() {
    return _prefs.getString(_keyActiveChildId);
  }

  Future<void> setActiveChildId(String? id) async {
    if (id == null) {
      await _prefs.remove(_keyActiveChildId);
    } else {
      await _prefs.setString(_keyActiveChildId, id);
    }
  }

  Child? getActiveChild() {
    final id = getActiveChildId();
    final list = getChildren();
    if (list.isEmpty) return null;
    if (id == null) return list.first;
    return list.firstWhere((c) => c.id == id, orElse: () => list.first);
  }

  // =====================
  // SCREENINGS
  // =====================
  List<ScreeningResult> getScreenings() {
    final raw = _prefs.getStringList(_keyScreenings);
    if (raw == null || raw.isEmpty) return [];
    return raw.map((item) => ScreeningResult.fromJson(item)).toList();
  }

  List<ScreeningResult> getScreeningsForChild(String childId) {
    final all = getScreenings();
    final filtered = all.where((s) => s.childId == childId).toList();
    // Urutkan dari yang paling baru
    filtered.sort((a, b) => b.date.compareTo(a.date));
    return filtered;
  }

  Future<void> saveScreening(ScreeningResult screening) async {
    final list = getScreenings();
    final index = list.indexWhere((s) => s.id == screening.id);
    if (index >= 0) {
      list[index] = screening;
    } else {
      list.insert(0, screening);
    }
    await _saveScreeningsList(list);
  }

  Future<void> deleteScreening(String screeningId) async {
    final list = getScreenings().where((s) => s.id != screeningId).toList();
    await _saveScreeningsList(list);
  }

  Future<void> _saveScreeningsList(List<ScreeningResult> list) async {
    final raw = list.map((s) => s.toJson()).toList();
    await _prefs.setStringList(_keyScreenings, raw);
  }

  // =====================
  // USER ROLE
  // =====================
  String getUserRole() {
    return _prefs.getString(_keyUserRole) ?? 'Orang Tua';
  }

  Future<void> setUserRole(String role) async {
    await _prefs.setString(_keyUserRole, role);
  }

  // =====================
  // SEED STARTER DATA
  // =====================
  Future<void> _seedInitialDataIfEmpty() async {
    if (getChildren().isNotEmpty) return;

    final now = DateTime.now();

    // 1. Rayyan - 9 Bulan Cukup Bulan
    final rayyan = Child(
      id: 'child_1',
      name: 'Rayyan Alfarizi',
      nik: '3171012304240001',
      birthDate: now.subtract(const Duration(days: 9 * 30 + 5)),
      gender: Gender.male,
      gestationalWeeks: 39,
      parentName: 'Siti Rahmawati',
      phone: '081234567890',
      posyanduName: 'Posyandu Melati RW 03',
      notes: 'Anak sehat, aktif bergerak, ASI eksklusif 6 bulan.',
    );

    // 2. Alesha - Lahir Prematur 32 Minggu (Usia Kronologis ~11 bulan, Koreksi ~9 bulan)
    final alesha = Child(
      id: 'child_2',
      name: 'Alesha Zahra (Prematur)',
      nik: '3171012803240002',
      birthDate: now.subtract(const Duration(days: 11 * 30 + 2)),
      gender: Gender.female,
      gestationalWeeks: 32, // Prematur 8 minggu
      parentName: 'Nurul Hidayah',
      phone: '081398765432',
      posyanduName: 'Posyandu Mawar RW 05',
      notes: 'Lahir prematur 32 minggu di RSUD. Memerlukan penyesuaian usia koreksi KPSP.',
    );

    // 3. Kiano - 18 Bulan
    final kiano = Child(
      id: 'child_3',
      name: 'Kiano Pratama',
      nik: '3171011508230003',
      birthDate: now.subtract(const Duration(days: 18 * 30 + 10)),
      gender: Gender.male,
      gestationalWeeks: 40,
      parentName: 'Budi Santoso',
      phone: '085711223344',
      posyanduName: 'Posyandu Cempaka RW 01',
      notes: 'Pemantauan berkala milestone motorik & bahasa.',
    );

    await saveChild(rayyan);
    await saveChild(alesha);
    await saveChild(kiano);
    await setActiveChildId(rayyan.id);

    // Tambahkan 1 riwayat skrining contoh untuk Rayyan (Skrining usia 6 bulan lampau)
    final sampleScreening = ScreeningResult(
      id: 'screening_sample_1',
      childId: rayyan.id,
      childName: rayyan.name,
      date: now.subtract(const Duration(days: 90)),
      kpspAgeInMonths: 6,
      chronologicalAgeText: '6 bulan 5 hari',
      correctedAgeText: null,
      answers: {
        'kpsp_6_1': true,
        'kpsp_6_2': true,
        'kpsp_6_3': true,
        'kpsp_6_4': true,
        'kpsp_6_5': true,
        'kpsp_6_6': true,
        'kpsp_6_7': true,
        'kpsp_6_8': true,
        'kpsp_6_9': true,
        'kpsp_6_10': true,
      },
      totalYes: 10,
      totalNo: 0,
      status: KpspStatus.sesuai,
      sectorSummaries: {
        'motorikKasar': const SectorSummary(total: 3, yesCount: 3),
        'motorikHalus': const SectorSummary(total: 3, yesCount: 3),
        'bicaraBahasa': const SectorSummary(total: 2, yesCount: 2),
        'sosialisasiKemandirian': const SectorSummary(total: 2, yesCount: 2),
      },
      screenerRole: 'Kader Posyandu',
      screenerName: 'Ibu Ratna (Kader)',
      notes: 'Perkembangan sangat baik sesuai usia 6 bulan. Lanjutkan stimulasi.',
    );

    await saveScreening(sampleScreening);
  }
}
