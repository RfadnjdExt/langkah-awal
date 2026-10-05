import '../models/kpsp_question.dart';

class RedFlagItem {
  final String title;
  final DevelopmentSector sector;
  final String ageRange;
  final String warningText;
  final String clinicalSignificance;
  final String actionRequired;

  const RedFlagItem({
    required this.title,
    required this.sector,
    required this.ageRange,
    required this.warningText,
    required this.clinicalSignificance,
    required this.actionRequired,
  });
}

class RedFlagsDatabase {
  static const List<RedFlagItem> redFlags = [
    // MOTORIK KASAR
    RedFlagItem(
      title: 'Kepala Belum Tegak (Head Lag Menetap)',
      sector: DevelopmentSector.motorikKasar,
      ageRange: '4 Bulan',
      warningText: 'Saat ditarik dari posisi telentang ke duduk, kepala anak masih terkulai ke belakang dan tidak mampu tegak.',
      clinicalSignificance: 'Kemungkinan kelemahan tonus otot sentral (hipotonia) atau gangguan neurologis.',
      actionRequired: 'Segera periksakan ke Dokter Spesialis Anak untuk evaluasi neurologis dini.',
    ),
    RedFlagItem(
      title: 'Belum Mampu Duduk Mandiri',
      sector: DevelopmentSector.motorikKasar,
      ageRange: '9 Bulan',
      warningText: 'Anak sama sekali belum bisa duduk tanpa ditopang atau selalu jatuh terguling ke samping/belakang.',
      clinicalSignificance: 'Keterlambatan motorik kasar aksial atau kelemahan otot batang tubuh (core trunk muscles).',
      actionRequired: 'Konsultasikan ke Dokter Spesialis Anak / Tim Tumbuh Kembang Faskes.',
    ),
    RedFlagItem(
      title: 'Belum Bisa Berjalan Mandiri',
      sector: DevelopmentSector.motorikKasar,
      ageRange: '18 Bulan',
      warningText: 'Anak berusia 18 bulan belum mampu melangkah sendiri tanpa dituntun atau ditopang.',
      clinicalSignificance: 'Batas akhir (cutoff) fisiologis kemampuan berjalan mandiri balita.',
      actionRequired: 'Wajib dirujuk ke Dokter Spesialis Anak untuk pemeriksaan ortopedi dan saraf anak.',
    ),
    RedFlagItem(
      title: 'Asimetri Gerakan Tubuh (Hemiparesis)',
      sector: DevelopmentSector.motorikKasar,
      ageRange: 'Segala Usia',
      warningText: 'Anak hanya aktif menggerakkan salah satu sisi tubuh (misal tangan/kaki kanan aktif tetapi kiri lemah/terkulai kaku).',
      clinicalSignificance: 'Tanda kecurigaan kelainan serebral fokal (cerebral palsy hemiplegik atau cidera pleksus).',
      actionRequired: 'Segera bawa ke RS / Dokter Spesialis Saraf Anak.',
    ),

    // MOTORIK HALUS
    RedFlagItem(
      title: 'Kedua Tangan Terus Mengepal Erat (Fisting Menetap)',
      sector: DevelopmentSector.motorikHalus,
      ageRange: '4 Bulan ke atas',
      warningText: 'Ibu jari terus terjepit di dalam kepalan dan telapak tangan tidak pernah membuka rileks saat tenang.',
      clinicalSignificance: 'Refleks primitif menggenggam menetap yang abnormal, tanda hipertonia atau spastisitas.',
      actionRequired: 'Pemeriksaan tonus otot oleh dokter spesialis anak.',
    ),
    RedFlagItem(
      title: 'Tidak Bisa Menjumput & Memegang Benda',
      sector: DevelopmentSector.motorikHalus,
      ageRange: '9 - 12 Bulan',
      warningText: 'Anak tidak berusaha meraih mainan di hadapannya atau tidak mampu menjumput benda kecil menggunakan ujung jari.',
      clinicalSignificance: 'Gangguan koordinasi motorik halus mata-tangan (visuomotor delay) atau gangguan penglihatan.',
      actionRequired: 'Evaluasi fungsi visual dan motorik halus di fasilitas kesehatan.',
    ),

    // BICARA & BAHASA
    RedFlagItem(
      title: 'Tidak Merespons Suara & Panggilan Nama',
      sector: DevelopmentSector.bicaraBahasa,
      ageRange: '6 Bulan ke atas',
      warningText: 'Anak tidak menoleh saat namanya dipanggil, tidak terkejut oleh bunyi keras, atau tampak seperti tidak mendengar.',
      clinicalSignificance: 'Kecurigaan utama gangguan pendengaran bawaan (congenital hearing loss).',
      actionRequired: 'Pemeriksaan fungsi pendengaran OAE / BERA ke Dokter Spesialis THT / Anak.',
    ),
    RedFlagItem(
      title: 'Tidak Ada Babbling & Gestur Menunjuk (Pointing)',
      sector: DevelopmentSector.bicaraBahasa,
      ageRange: '12 Bulan',
      warningText: 'Anak belum mengoceh suku kata ("ba-ba", "ma-ma") dan tidak menggunakan gestur melambai atau menunjuk saat meminta sesuatu.',
      clinicalSignificance: 'Keterlambatan fase pra-bicara (pre-linguistic delay) atau spektrum autisme.',
      actionRequired: 'Konsultasi skrining perkembangan komprehensif ke Puskesmas/RS.',
    ),
    RedFlagItem(
      title: 'Belum Ada Kata Bermakna Sama Sekali',
      sector: DevelopmentSector.bicaraBahasa,
      ageRange: '16 - 18 Bulan',
      warningText: 'Anak berusia 16 bulan belum mampu mengucapkan satu pun kata bermakna (misal "mama", "papa", "susu").',
      clinicalSignificance: 'Speech delay ekspresif signifikan.',
      actionRequired: 'Skrining wicara dan stimulasi intensif oleh terapis wicara / dokter anak.',
    ),
    RedFlagItem(
      title: 'Belum Ada Frasa 2 Kata Spontan',
      sector: DevelopmentSector.bicaraBahasa,
      ageRange: '24 Bulan (2 Tahun)',
      warningText: 'Anak belum bisa merangkai dua kata bermakna sendiri seperti "mau makan", "bapak datang" (bukan sekadar meniru iklan).',
      clinicalSignificance: 'Keterlambatan bahasa bermakna klinis.',
      actionRequired: 'Rujukan ke Poli Tumbuh Kembang Anak.',
    ),

    // SOSIAL & UMUM
    RedFlagItem(
      title: 'Tidak Ada Kontak Mata & Senyum Sosial',
      sector: DevelopmentSector.sosialisasiKemandirian,
      ageRange: '3 Bulan ke atas',
      warningText: 'Anak tidak menatap mata orang tua saat diajak bicara, tidak membalas senyuman, dan tampak acuh tak acuh.',
      clinicalSignificance: 'Tanda bahaya gangguan interaksi sosial dini atau gangguan penglihatan.',
      actionRequired: 'Evaluasi dini perkembangan psikososial dan penglihatan bayi.',
    ),
    RedFlagItem(
      title: 'Regresi / Hilangnya Kemampuan yang Sudah Dikuasai',
      sector: DevelopmentSector.sosialisasiKemandirian,
      ageRange: 'Segala Usia',
      warningText: 'Anak mendadak kehilangan kemampuan berbicara, berjalan, atau berinteraksi yang sebelumnya sudah lancar dilakukan.',
      clinicalSignificance: 'RED FLAG TINGKAT TINGGI: Indikasi penyakit neurodegeneratif, kejang subklinis, atau regresi spektrum.',
      actionRequired: 'DARURAT PERKEMBANGAN: Segera bawa ke Dokter Spesialis Anak Konsultan Saraf (Neuropediatri).',
    ),
  ];
}
