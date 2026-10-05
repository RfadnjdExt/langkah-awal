import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../models/child.dart';
import '../models/screening_result.dart';
import '../models/kpsp_question.dart';
import '../data/kpsp_database.dart';

class PdfReportService {
  static Future<void> printOrShareReport({
    required Child child,
    required ScreeningResult screening,
  }) async {
    final doc = pw.Document();
    final dateFormat = DateFormat('dd MMMM yyyy', 'id');
    final formattedDate = dateFormat.format(screening.date);

    final questions = KpspDatabase.getQuestionsForAge(screening.kpspAgeInMonths);

    // Warna status
    PdfColor statusColor;
    if (screening.status == KpspStatus.sesuai) {
      statusColor = PdfColors.green700;
    } else if (screening.status == KpspStatus.meragukan) {
      statusColor = PdfColors.amber800;
    } else {
      statusColor = PdfColors.red700;
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // KOP SURAT BIK KELOMPOK 13
            pw.Container(
              padding: const pw.EdgeInsets.only(bottom: 12),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: PdfColors.blueGrey800, width: 2),
                ),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Container(
                    width: 50,
                    height: 50,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.teal700,
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Center(
                      child: pw.Text(
                        'BIK',
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 14),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'LANGKAH AWAL - KPSP DIGITAL',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.teal900,
                          ),
                        ),
                        pw.Text(
                          'Badan Intelejen Kesehatan (BIK) • Kelompok 13',
                          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800),
                        ),
                        pw.Text(
                          'Instrumen Standar Kemenkes RI: Deteksi Dini Tumbuh Kembang (SDIDTK)',
                          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 14),

            // JUDUL LAPORAN
            pw.Center(
              child: pw.Text(
                'LEMBAR HASIL SKRINING PERKEMBANGAN ANAK (KPSP)',
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  decoration: pw.TextDecoration.underline,
                ),
              ),
            ),
            pw.SizedBox(height: 14),

            // IDENTITAS ANAK & PEMERIKSAAN (2 Kolom)
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(6),
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Kolom Kiri
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Nama Anak', child.name),
                        _buildInfoRow('NIK', child.nik ?? '-'),
                        _buildInfoRow('Jenis Kelamin', child.gender == Gender.male ? 'Laki-laki' : 'Perempuan'),
                        _buildInfoRow('Tanggal Lahir', dateFormat.format(child.birthDate)),
                        _buildInfoRow('Nama Orang Tua', child.parentName ?? '-'),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 12),
                  // Kolom Kanan
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Tanggal Periksa', formattedDate),
                        _buildInfoRow('Usia Kronologis', screening.chronologicalAgeText),
                        if (screening.correctedAgeText != null)
                          _buildInfoRow('Usia Koreksi (Prematur)', '${screening.correctedAgeText} (Gestasi ${child.gestationalWeeks} mg)'),
                        _buildInfoRow('Paket Soal KPSP', '${screening.kpspAgeInMonths} Bulan'),
                        _buildInfoRow('Pemeriksa', '${screening.screenerName ?? "-"} (${screening.screenerRole})'),
                        _buildInfoRow('Posyandu / Faskes', child.posyanduName ?? '-'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 14),

            // KOTAK HASIL DAN STATUS EVALUASI
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: pw.BorderRadius.circular(6),
                border: pw.Border.all(color: statusColor, width: 2),
              ),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    flex: 3,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'KESIMPULAN EVALUASI PERKEMBANGAN:',
                          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700),
                        ),
                        pw.SizedBox(height: 3),
                        pw.Text(
                          screening.status.label.toUpperCase(),
                          style: pw.TextStyle(
                            fontSize: 13,
                            fontWeight: pw.FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          screening.status.recommendation,
                          style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.blueGrey900),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 12),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: pw.BoxDecoration(
                      color: statusColor,
                      borderRadius: pw.BorderRadius.circular(6),
                    ),
                    child: pw.Column(
                      children: [
                        pw.Text(
                          'SKOR YA',
                          style: pw.TextStyle(fontSize: 8, color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          '${screening.totalYes} / 10',
                          style: pw.TextStyle(fontSize: 16, color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          'Tidak: ${screening.totalNo}',
                          style: const pw.TextStyle(fontSize: 8, color: PdfColors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 12),

            // REKAP PER SEKTOR PERKEMBANGAN
            pw.Text(
              'Capaian 4 Domain Perkembangan:',
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),
            pw.Row(
              children: DevelopmentSector.values.map((sector) {
                final summary = screening.sectorSummaries[sector.name] ??
                    const SectorSummary(total: 0, yesCount: 0);
                return pw.Expanded(
                  child: pw.Container(
                    margin: const pw.EdgeInsets.only(right: 6),
                    padding: const pw.EdgeInsets.all(6),
                    decoration: pw.BoxDecoration(
                      color: summary.isAllPassed ? PdfColors.green50 : PdfColors.amber50,
                      border: pw.Border.all(
                        color: summary.isAllPassed ? PdfColors.green300 : PdfColors.amber300,
                      ),
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          sector.label,
                          style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold),
                          maxLines: 1,
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Ya: ${summary.yesCount}/${summary.total} (${summary.percentage.toStringAsFixed(0)}%)',
                          style: pw.TextStyle(
                            fontSize: 8,
                            color: summary.isAllPassed ? PdfColors.green900 : PdfColors.amber900,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            pw.SizedBox(height: 14),

            // TABEL RINCIAN 10 BUTIR KUESIONER
            pw.Text(
              'Rincian Jawaban Kuesioner (10 Butir Kemenkes):',
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              columnWidths: {
                0: const pw.FixedColumnWidth(20),
                1: const pw.FixedColumnWidth(70),
                2: const pw.FlexColumnWidth(),
                3: const pw.FixedColumnWidth(35),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.teal800),
                  children: [
                    _buildTableHeader('No'),
                    _buildTableHeader('Domain'),
                    _buildTableHeader('Keterampilan yang Dinilai'),
                    _buildTableHeader('Hasil'),
                  ],
                ),
                ...List.generate(questions.length, (index) {
                  final q = questions[index];
                  final isYes = screening.answers[q.id] ?? false;
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: index % 2 == 0 ? PdfColors.white : PdfColors.grey50,
                    ),
                    children: [
                      _buildTableCell('${index + 1}', alignCenter: true),
                      _buildTableCell(q.sector.label),
                      _buildTableCell(q.question),
                      _buildTableCell(
                        isYes ? 'YA' : 'TIDAK',
                        alignCenter: true,
                        color: isYes ? PdfColors.green800 : PdfColors.red800,
                        isBold: true,
                      ),
                    ],
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 16),

            // TANDA TANGAN
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text('Orang Tua / Wali', style: const pw.TextStyle(fontSize: 9)),
                    pw.SizedBox(height: 38),
                    pw.Text('(${child.parentName ?? "..............................."})', style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text('Pemeriksa / Kader / Nakes', style: const pw.TextStyle(fontSize: 9)),
                    pw.SizedBox(height: 38),
                    pw.Text('(${screening.screenerName ?? "..............................."})', style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text(
                'Dicetak otomatis melalui Aplikasi Langkah Awal - BIK Kelompok 13',
                style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey600),
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'KPSP_${child.name}_${screening.kpspAgeInMonths}Bulan.pdf',
    );
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2.5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 85,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
            ),
          ),
          pw.Text(': ', style: pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.black),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget _buildTableCell(
    String text, {
    bool alignCenter = false,
    PdfColor? color,
    bool isBold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: pw.Text(
        text,
        textAlign: alignCenter ? pw.TextAlign.center : pw.TextAlign.left,
        style: pw.TextStyle(
          fontSize: 7.5,
          color: color ?? PdfColors.black,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}
