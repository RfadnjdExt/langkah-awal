import 'package:flutter_test/flutter_test.dart';
import 'package:langkah_awal/models/child.dart';
import 'package:langkah_awal/models/screening_result.dart';
import 'package:langkah_awal/data/kpsp_database.dart';

void main() {
  group('KPSP Logic & Calculator Unit Tests', () {
    test('Kalkulator Usia Kronologis Normal (Aterm)', () {
      final birthDate = DateTime(2025, 1, 10);
      final refDate = DateTime(2025, 10, 10); // 9 bulan persis
      final child = Child(
        id: 'test_1',
        name: 'Bayi Sehat',
        birthDate: birthDate,
        gender: Gender.male,
        gestationalWeeks: 40,
      );

      final chrono = child.getChronologicalAge(refDate);
      expect(chrono.totalMonths, 9);
      expect(child.isPremature, false);
      expect(child.getTargetKpspMonth(refDate), 9);
    });

    test('Kalkulator Usia Koreksi Bayi Prematur (32 Minggu)', () {
      final birthDate = DateTime(2024, 11, 1);
      final refDate = DateTime(2025, 10, 1); // Kronologis: 11 bulan
      final child = Child(
        id: 'test_prematur',
        name: 'Bayi Prematur',
        birthDate: birthDate,
        gender: Gender.female,
        gestationalWeeks: 32, // Prematur 8 minggu (56 hari)
      );

      expect(child.isPremature, true);
      final chrono = child.getChronologicalAge(refDate);
      final corrected = child.getCorrectedAge(refDate);

      expect(chrono.totalMonths, 11);
      // Usia koreksi lebih muda sekitar 2 bulan (8 minggu) -> ~9 bulan
      expect(corrected.totalMonths, lessThan(chrono.totalMonths));
      expect(corrected.totalMonths, inInclusiveRange(8, 9));

      // Paket KPSP yang dipilih harus menyesuaikan usia koreksi
      final targetKpsp = child.getTargetKpspMonth(refDate);
      expect(targetKpsp, inInclusiveRange(6, 9));
    });

    test('Klasifikasi Hasil KPSP Kemenkes RI', () {
      // 9 dan 10 YA -> Sesuai (S)
      expect(ScreeningResult.calculateStatus(10), KpspStatus.sesuai);
      expect(ScreeningResult.calculateStatus(9), KpspStatus.sesuai);

      // 7 dan 8 YA -> Meragukan (M)
      expect(ScreeningResult.calculateStatus(8), KpspStatus.meragukan);
      expect(ScreeningResult.calculateStatus(7), KpspStatus.meragukan);

      // <= 6 YA -> Kemungkinan Penyimpangan (P)
      expect(ScreeningResult.calculateStatus(6), KpspStatus.penyimpangan);
      expect(ScreeningResult.calculateStatus(5), KpspStatus.penyimpangan);
      expect(ScreeningResult.calculateStatus(0), KpspStatus.penyimpangan);
    });

    test('Kelengkapan Bank Soal KPSP 10 Butir per Kelompok Umur', () {
      final milestones = [3, 6, 9, 12, 18, 24, 36, 48, 60, 72];
      for (final m in milestones) {
        final questions = KpspDatabase.getQuestionsForAge(m);
        expect(questions.length, 10, reason: 'Paket KPSP $m bulan harus memiliki tepat 10 butir soal');
      }
    });
  });
}
