import 'dart:convert';

enum Gender { male, female }

class Child {
  final String id;
  final String name;
  final String? nik;
  final DateTime birthDate;
  final Gender gender;
  final int gestationalWeeks; // Normal: >= 37 minggu. < 37: prematur
  final String? parentName;
  final String? phone;
  final String? posyanduName;
  final String? notes;

  Child({
    required this.id,
    required this.name,
    this.nik,
    required this.birthDate,
    required this.gender,
    this.gestationalWeeks = 40,
    this.parentName,
    this.phone,
    this.posyanduName,
    this.notes,
  });

  bool get isPremature => gestationalWeeks < 37;

  /// Usia Kronologis (Tahun, Bulan, Hari)
  AgeDuration getChronologicalAge([DateTime? referenceDate]) {
    final now = referenceDate ?? DateTime.now();
    return _calculateAge(birthDate, now);
  }

  /// Usia Koreksi: Digunakan jika prematur (< 37 minggu) sampai anak berusia 2 tahun kronologis.
  /// Usia Koreksi = Usia Kronologis - (40 minggu - usia gestasi saat lahir).
  AgeDuration getCorrectedAge([DateTime? referenceDate]) {
    final now = referenceDate ?? DateTime.now();
    final chrono = getChronologicalAge(now);
    
    // Koreksi hanya berlaku jika prematur dan usia kronologis belum melampaui 24 bulan
    if (!isPremature || chrono.totalMonths >= 24) {
      return chrono;
    }

    final prematureWeeks = 40 - gestationalWeeks;
    final prematureDays = prematureWeeks * 7;
    final correctedBirthDate = birthDate.add(Duration(days: prematureDays));

    if (now.isBefore(correctedBirthDate)) {
      return AgeDuration(years: 0, months: 0, days: 0, totalMonths: 0);
    }

    return _calculateAge(correctedBirthDate, now);
  }

  /// Usia yang digunakan untuk menentukan paket KPSP resmi (Kemenkes SDIDTK)
  AgeDuration getEffectiveAgeForKpsp([DateTime? referenceDate]) {
    final now = referenceDate ?? DateTime.now();
    final chrono = getChronologicalAge(now);
    if (isPremature && chrono.totalMonths < 24) {
      return getCorrectedAge(now);
    }
    return chrono;
  }

  /// Menentukan kelompok umur KPSP resmi terdekat sesuai aturan Kemenkes RI:
  /// Standar: 3, 6, 9, 12, 15, 18, 21, 24, 30, 36, 42, 48, 54, 60, 66, 72 bulan.
  /// Bila umur anak berada di antara 2 periode skrining (misal 4.5 bulan),
  /// digunakan paket skrining umur yang lebih muda (3 bulan) atau paket terdekat sesuai petunjuk teknis.
  int getTargetKpspMonth([DateTime? referenceDate]) {
    final effectiveAge = getEffectiveAgeForKpsp(referenceDate);
    final totalMonths = effectiveAge.totalMonths;
    const kpspMilestones = [3, 6, 9, 12, 15, 18, 21, 24, 30, 36, 42, 48, 54, 60, 66, 72];

    if (totalMonths < 3) return 3;
    if (totalMonths >= 72) return 72;

    for (int i = kpspMilestones.length - 1; i >= 0; i--) {
      if (totalMonths >= kpspMilestones[i]) {
        return kpspMilestones[i];
      }
    }
    return 3;
  }

  static AgeDuration _calculateAge(DateTime fromDate, DateTime toDate) {
    int years = toDate.year - fromDate.year;
    int months = toDate.month - fromDate.month;
    int days = toDate.day - fromDate.day;

    if (days < 0) {
      // Ambil hari dari bulan sebelumnya
      final prevMonthLastDay = DateTime(toDate.year, toDate.month, 0).day;
      days += prevMonthLastDay;
      months -= 1;
    }

    if (months < 0) {
      years -= 1;
      months += 12;
    }

    final totalMonths = (years * 12) + months;
    return AgeDuration(
      years: years < 0 ? 0 : years,
      months: months < 0 ? 0 : months,
      days: days < 0 ? 0 : days,
      totalMonths: totalMonths < 0 ? 0 : totalMonths,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nik': nik,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender.name,
      'gestationalWeeks': gestationalWeeks,
      'parentName': parentName,
      'phone': phone,
      'posyanduName': posyanduName,
      'notes': notes,
    };
  }

  factory Child.fromMap(Map<String, dynamic> map) {
    return Child(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      nik: map['nik'],
      birthDate: DateTime.parse(map['birthDate']),
      gender: map['gender'] == 'female' ? Gender.female : Gender.male,
      gestationalWeeks: map['gestationalWeeks'] ?? 40,
      parentName: map['parentName'],
      phone: map['phone'],
      posyanduName: map['posyanduName'],
      notes: map['notes'],
    );
  }

  String toJson() => json.encode(toMap());
  factory Child.fromJson(String source) => Child.fromMap(json.decode(source));
}

class AgeDuration {
  final int years;
  final int months;
  final int days;
  final int totalMonths;

  AgeDuration({
    required this.years,
    required this.months,
    required this.days,
    required this.totalMonths,
  });

  String get formatted {
    if (years > 0) {
      return '$years tahun $months bulan $days hari';
    } else {
      return '$months bulan $days hari';
    }
  }

  String get shortFormatted {
    if (years > 0) {
      return '${years}th ${months}bln';
    } else {
      return '${months}bln ${days}hr';
    }
  }
}
