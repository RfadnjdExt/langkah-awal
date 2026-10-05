import 'dart:convert';

enum KpspStatus {
  sesuai, // 9-10 Ya (Hijau)
  meragukan, // 7-8 Ya (Kuning)
  penyimpangan; // <= 6 Ya (Merah)

  String get label {
    switch (this) {
      case KpspStatus.sesuai:
        return 'Perkembangan Sesuai (S)';
      case KpspStatus.meragukan:
        return 'Perkembangan Meragukan (M)';
      case KpspStatus.penyimpangan:
        return 'Kemungkinan Penyimpangan (P)';
    }
  }

  String get badgeText {
    switch (this) {
      case KpspStatus.sesuai:
        return 'SESUAI';
      case KpspStatus.meragukan:
        return 'MERAGUKAN';
      case KpspStatus.penyimpangan:
        return 'PENYIMPANGAN';
    }
  }

  String get recommendation {
    switch (this) {
      case KpspStatus.sesuai:
        return 'Beri pujian kepada orang tua karena telah mengasuh anak dengan baik. Teruskan pola asuh dan stimulasi sesuai tahapan umur berikutnya. Lakukan skrining KPSP berkala pada jadwal umur selanjutnya.';
      case KpspStatus.meragukan:
        return 'Beri petunjuk kepada orang tua untuk melakukan stimulasi intensif selama 2 minggu, terutama pada kemampuan yang belum dicapai (jawaban "Tidak"). Jadwalkan pemeriksaan/skrining ulang KPSP setelah 2 minggu.';
      case KpspStatus.penyimpangan:
        return 'Segera rujuk anak ke Puskesmas, Rumah Sakit, atau Dokter Spesialis Anak (Sp.A) untuk pemeriksaan diagnostik tumbuh kembang lebih komprehensif. Bawa lembar hasil KPSP ini.';
    }
  }
}

class SectorSummary {
  final int total;
  final int yesCount;

  const SectorSummary({required this.total, required this.yesCount});

  int get noCount => total - yesCount;
  double get percentage => total > 0 ? (yesCount / total) * 100 : 0;
  bool get isAllPassed => yesCount == total;

  Map<String, dynamic> toMap() => {
    'total': total,
    'yesCount': yesCount,
  };

  factory SectorSummary.fromMap(Map<String, dynamic> map) => SectorSummary(
    total: map['total'] ?? 0,
    yesCount: map['yesCount'] ?? 0,
  );
}

class ScreeningResult {
  final String id;
  final String childId;
  final String childName;
  final DateTime date;
  final int kpspAgeInMonths;
  final String chronologicalAgeText;
  final String? correctedAgeText;
  final Map<String, bool> answers; // questionId -> true (Ya) / false (Tidak)
  final int totalYes;
  final int totalNo;
  final KpspStatus status;
  final Map<String, SectorSummary> sectorSummaries; // sector.name -> SectorSummary
  final String screenerRole;
  final String? screenerName;
  final String? notes;

  ScreeningResult({
    required this.id,
    required this.childId,
    required this.childName,
    required this.date,
    required this.kpspAgeInMonths,
    required this.chronologicalAgeText,
    this.correctedAgeText,
    required this.answers,
    required this.totalYes,
    required this.totalNo,
    required this.status,
    required this.sectorSummaries,
    this.screenerRole = 'Orang Tua',
    this.screenerName,
    this.notes,
  });

  static KpspStatus calculateStatus(int yesCount) {
    if (yesCount >= 9) {
      return KpspStatus.sesuai;
    } else if (yesCount >= 7) {
      return KpspStatus.meragukan;
    } else {
      return KpspStatus.penyimpangan;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'childId': childId,
      'childName': childName,
      'date': date.toIso8601String(),
      'kpspAgeInMonths': kpspAgeInMonths,
      'chronologicalAgeText': chronologicalAgeText,
      'correctedAgeText': correctedAgeText,
      'answers': answers,
      'totalYes': totalYes,
      'totalNo': totalNo,
      'status': status.name,
      'sectorSummaries': sectorSummaries.map((k, v) => MapEntry(k, v.toMap())),
      'screenerRole': screenerRole,
      'screenerName': screenerName,
      'notes': notes,
    };
  }

  factory ScreeningResult.fromMap(Map<String, dynamic> map) {
    final rawSummaries = map['sectorSummaries'] as Map<String, dynamic>? ?? {};
    final parsedSummaries = rawSummaries.map(
      (k, v) => MapEntry(k, SectorSummary.fromMap(v as Map<String, dynamic>)),
    );

    return ScreeningResult(
      id: map['id'] ?? '',
      childId: map['childId'] ?? '',
      childName: map['childName'] ?? '',
      date: DateTime.parse(map['date']),
      kpspAgeInMonths: map['kpspAgeInMonths'] ?? 3,
      chronologicalAgeText: map['chronologicalAgeText'] ?? '',
      correctedAgeText: map['correctedAgeText'],
      answers: Map<String, bool>.from(map['answers'] ?? {}),
      totalYes: map['totalYes'] ?? 0,
      totalNo: map['totalNo'] ?? 0,
      status: KpspStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => KpspStatus.sesuai,
      ),
      sectorSummaries: parsedSummaries,
      screenerRole: map['screenerRole'] ?? 'Orang Tua',
      screenerName: map['screenerName'],
      notes: map['notes'],
    );
  }

  String toJson() => json.encode(toMap());
  factory ScreeningResult.fromJson(String source) => ScreeningResult.fromMap(json.decode(source));
}
