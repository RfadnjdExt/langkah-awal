enum DevelopmentSector {
  motorikKasar,
  motorikHalus,
  bicaraBahasa,
  sosialisasiKemandirian;

  String get label {
    switch (this) {
      case DevelopmentSector.motorikKasar:
        return 'Motorik Kasar';
      case DevelopmentSector.motorikHalus:
        return 'Motorik Halus';
      case DevelopmentSector.bicaraBahasa:
        return 'Bicara & Bahasa';
      case DevelopmentSector.sosialisasiKemandirian:
        return 'Sosialisasi & Kemandirian';
    }
  }

  String get shortCode {
    switch (this) {
      case DevelopmentSector.motorikKasar:
        return 'MK';
      case DevelopmentSector.motorikHalus:
        return 'MH';
      case DevelopmentSector.bicaraBahasa:
        return 'BB';
      case DevelopmentSector.sosialisasiKemandirian:
        return 'SK';
    }
  }

  String get description {
    switch (this) {
      case DevelopmentSector.motorikKasar:
        return 'Pergerakan tubuh yang menggunakan otot-otot besar (duduk, berdiri, melompat, berlari).';
      case DevelopmentSector.motorikHalus:
        return 'Keterampilan koordinasi fisik yang melibatkan otot-otot kecil dan mata-tangan (menjumput benda kecil, menggambar).';
      case DevelopmentSector.bicaraBahasa:
        return 'Kemampuan merespons suara, berbicara, berkomunikasi, dan memahami perintah verbal.';
      case DevelopmentSector.sosialisasiKemandirian:
        return 'Kemandirian sehari-hari (makan, berpakaian) dan interaksi sosial dengan orang di sekitarnya.';
    }
  }
}

class KpspQuestion {
  final String id;
  final int ageInMonths;
  final DevelopmentSector sector;
  final String question;
  final String instruction;
  final String? toolsNeeded;
  final bool isRedFlag;

  const KpspQuestion({
    required this.id,
    required this.ageInMonths,
    required this.sector,
    required this.question,
    required this.instruction,
    this.toolsNeeded,
    this.isRedFlag = false,
  });
}
