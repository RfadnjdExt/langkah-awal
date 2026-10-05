import '../models/kpsp_question.dart';

class StimulationItem {
  final String title;
  final DevelopmentSector sector;
  final String ageRangeText;
  final String description;
  final List<String> practicalSteps;
  final String tips;

  const StimulationItem({
    required this.title,
    required this.sector,
    required this.ageRangeText,
    required this.description,
    required this.practicalSteps,
    required this.tips,
  });
}

class StimulationDatabase {
  static List<StimulationItem> getStimulationsForSectorAndAge(DevelopmentSector sector, int ageInMonths) {
    return _items.where((item) => item.sector == sector).toList();
  }

  static List<StimulationItem> getAllStimulations() => _items;

  static const List<StimulationItem> _items = [
    // MOTORIK KASAR
    StimulationItem(
      title: 'Tummy Time & Melatih Otot Leher',
      sector: DevelopmentSector.motorikKasar,
      ageRangeText: '0 - 6 Bulan',
      description: 'Latihan tengkurap membantu memperkuat otot leher, bahu, dan punggung bayi untuk persiapan berguling dan duduk.',
      practicalSteps: [
        'Tengkurapkan bayi di atas matras datar yang nyaman selama 3-5 menit sebanyak 2-3 kali sehari saat bayi terjaga.',
        'Letakkan mainan berbunyi atau wajah orang tua sejajar dengan mata bayi untuk memancingnya mendongak.',
        'Gunakan guling kecil di bawah ketiak jika bayi masih kesulitan menopang dada.',
      ],
      tips: 'Lakukan hanya saat bayi tidak mengantuk atau baru saja selesai minum susu untuk menghindari gumoh.',
    ),
    StimulationItem(
      title: 'Latihan Duduk Mandiri & Keseimbangan',
      sector: DevelopmentSector.motorikKasar,
      ageRangeText: '6 - 9 Bulan',
      description: 'Membangun kekuatan otot panggul dan punggung untuk keseimbangan duduk mandiri.',
      practicalSteps: [
        'Dudukkan bayi di lantai dengan bantal pengaman melingkar di sekelilingnya.',
        'Letakkan mainan favorit sedikit di luar jangkauannya agar ia terbiasa menopang berat badan dengan kedua tangan ke depan.',
        'Pangku bayi dalam posisi duduk di paha Anda sambil menyanyikan lagu berirama ayun.',
      ],
      tips: 'Jangan biarkan bayi duduk bersandar di bouncer terlalu lama; berikan waktu bermain di lantai datar.',
    ),
    StimulationItem(
      title: 'Merangkak & Menjelajah Ruangan',
      sector: DevelopmentSector.motorikKasar,
      ageRangeText: '9 - 12 Bulan',
      description: 'Merangsang koordinasi silang otak kiri-kanan serta kekuatan lengan dan tungkai.',
      practicalSteps: [
        'Buat lintasan rintangan mini menggunakan bantal sofa rendah di lantai.',
        'Gulingkan bola kecil ke depan agar anak terdorong merangkak mengejarnya.',
        'Bantu anak belajar berdiri dengan berpegangan pada sofa yang kokoh (cruising).',
      ],
      tips: 'Pastikan lantai aman dari colokan listrik, sudut meja tajam, dan benda kecil yang bisa tertelan.',
    ),
    StimulationItem(
      title: 'Berjalan Bebas, Menendang Bola & Melompat',
      sector: DevelopmentSector.motorikKasar,
      ageRangeText: '12 - 24 Bulan',
      description: 'Melatih keseimbangan dinamis, kelincahan kaki, dan rasa percaya diri melangkah mandiri.',
      practicalSteps: [
        'Ajak anak mendorong mainan dorong (push walker atau kursi ringan beroda terkunci aman).',
        'Bermain oper bola plastik: ajari anak menendang bola dengan mengayunkan kaki.',
        'Ajak anak melompati garis selotip kertas yang ditempel di lantai.',
      ],
      tips: 'Biarkan anak berjalan tanpa alas kaki di atas rumput atau lantai bersih di rumah untuk menstimulasi saraf telapak kaki.',
    ),
    StimulationItem(
      title: 'Keseimbangan Satu Kaki & Bersepeda Roda Tiga',
      sector: DevelopmentSector.motorikKasar,
      ageRangeText: '2 - 5 Tahun',
      description: 'Koordinasi motorik tingkat lanjut, melatih refleks keseimbangan dan kelincahan.',
      practicalSteps: [
        'Mainkan permainan meniru patung burung bangau: berdiri satu kaki selama 3-5 detik.',
        'Bermain engklek (hopping) di halaman atau menggambar kotak di lantai.',
        'Ajak bersepeda roda tiga atau balance bike di taman datar.',
      ],
      tips: 'Selalu puji usaha anak saat berhasil menjaga keseimbangan tanpa terjatuh.',
    ),

    // MOTORIK HALUS
    StimulationItem(
      title: 'Menjumput Benda Kecil (Pincer Grasp)',
      sector: DevelopmentSector.motorikHalus,
      ageRangeText: '9 - 18 Bulan',
      description: 'Koordinasi presisi antara ibu jari dan jari telunjuk yang esensial untuk memegang pensil kelak.',
      practicalSteps: [
        'Sajikan finger food sehat seperti potongan kismis, wortel rebus empuk, atau sereal puff di piring plastik.',
        'Biarkan anak menjumput remahan dengan dua jarinya sendiri.',
        'Bermain mencabut stiker warna dari kertas dan menempelkannya kembali.',
      ],
      tips: 'Selalu awasi anak saat bermain dengan makanan berukuran kecil untuk mencegah tersedak.',
    ),
    StimulationItem(
      title: 'Menyusun Balok Menara & Memasukkan Benda',
      sector: DevelopmentSector.motorikHalus,
      ageRangeText: '1 - 3 Tahun',
      description: 'Melatih persepsi ruang, konsentrasi, stabilitas pergelangan tangan dan kesabaran.',
      practicalSteps: [
        'Sediakan balok kayu atau kubus plastik warna-warni.',
        'Ajak anak berlomba menyusun menara dari 4 hingga 8 kubus tanpa roboh.',
        'Bermain menyortir bentuk (shape sorter): memasukkan lingkaran, kotak, dan segitiga ke lubang wadah yang cocok.',
      ],
      tips: 'Bila menara roboh, tertawalah bersama dan ajak anak menyusun kembali agar ia tidak frustrasi.',
    ),
    StimulationItem(
      title: 'Coretan Spontan, Menggambar & Menggunting Kertas',
      sector: DevelopmentSector.motorikHalus,
      ageRangeText: '3 - 6 Tahun',
      description: 'Mempersiapkan kesiapan pra-menulis, kontrol tekanan pensil, dan kekuatan otot jemari.',
      practicalSteps: [
        'Sediakan krayon segitiga berukuran besar dan kertas gambar polos.',
        'Ajarkan meniru bentuk garis tegak, lingkaran, dan tanda silang (+).',
        'Latihan menggunting kertas tipis mengikuti garis lurus dengan gunting keselamatan tumpul.',
        'Bermain meremas dan membentuk plastisin/playdough menjadi bola dan ular.',
      ],
      tips: 'Jangan menuntut gambar rapi di awal; fokuslah pada kekuatan genggaman dan kenyamanan posisi tangan.',
    ),

    // BICARA & BAHASA
    StimulationItem(
      title: 'Mengobrol, Menirukan Suara & Narasi Aktivitas',
      sector: DevelopmentSector.bicaraBahasa,
      ageRangeText: '0 - 12 Bulan',
      description: 'Membangun pondasi bahasa reseptif dan ekspresif melalui respons dua arah.',
      practicalSteps: [
        'Tatap mata bayi saat berbicara dan tirukan suara ocehannya dengan intonasi hangat.',
        'Deskripsikan apa yang sedang Anda lakukan (sports casting): "Ibu sedang mengupas pisang kuning manis untuk adik".',
        'Nyanyikan lagu anak berima sederhana dan bacakan buku bertekstur/bergambar tebal sejak dini.',
      ],
      tips: 'Hindari paparan layar TV, tablet, atau gadget (zero screen time) untuk anak usia di bawah 2 tahun.',
    ),
    StimulationItem(
      title: 'Memperluas Kosakata & Kalimat Dua Kata',
      sector: DevelopmentSector.bicaraBahasa,
      ageRangeText: '12 - 24 Bulan',
      description: 'Mendorong transisi dari kata tunggal ke gabungan kata komunikatif.',
      practicalSteps: [
        'Ketika anak berkata "Mimi", perluas kalimatnya: "Adik mau mimi susu hangat di gelas ya?".',
        'Bermain tebak gambar hewan dan tirukan suara khasnya (kucing "meong", sapi "mooo").',
        'Beri anak kesempatan memilih secara verbal: "Mau baju merah atau baju biru?".',
      ],
      tips: 'Beri jeda 5-10 detik setelah bertanya agar anak memiliki waktu merumuskan jawaban.',
    ),
    StimulationItem(
      title: 'Dongeng Interaktif, Berhitung & Pemahaman Logika',
      sector: DevelopmentSector.bicaraBahasa,
      ageRangeText: '2 - 6 Tahun',
      description: 'Mengasah penalaran verbal, struktur kalimat lengkap, pemahaman fungsi benda dan preposisi.',
      practicalSteps: [
        'Bacakan dongeng sebelum tidur, lalu ajukan pertanyaan terbuka: "Mengapa kelinci tadi berlari kencang?".',
        'Bermain tebak fungsi: "Gunting untuk apa?", "Sendok untuk apa?".',
        'Latih memahami instruksi berantai: "Ambil sepatu, taruh di rak, lalu cuci tanganmu".',
      ],
      tips: 'Dengarkan cerita anak sampai selesai tanpa memotong kalimat atau menertawakan salah lafalnya.',
    ),

    // SOSIALISASI & KEMANDIRIAN
    StimulationItem(
      title: 'Kemandirian Makan Sendiri & Memakai Pakaian',
      sector: DevelopmentSector.sosialisasiKemandirian,
      ageRangeText: '1 - 3 Tahun',
      description: 'Menumbuhkan rasa otonomi, kepercayaan diri, dan kebiasaan hidup mandiri.',
      practicalSteps: [
        'Biarkan anak makan menggunakan sendok sendiri meskipun masih sedikit berantakan.',
        'Ajarkan anak membuka kaus kaki dan celana karet mandiri sebelum mandi.',
        'Libatkan anak dalam merapikan mainannya sendiri ke dalam kotak setelah selesai bermain.',
      ],
      tips: 'Sediakan peralatan makan yang aman dan tahan pecah, puji setiap usaha mandirinya.',
    ),
    StimulationItem(
      title: 'Toilet Training & Menggosok Gigi Mandiri',
      sector: DevelopmentSector.sosialisasiKemandirian,
      ageRangeText: '2 - 4 Tahun',
      description: 'Mengenalkan kebersihan diri dan kepekaan terhadap sinyal tubuh.',
      practicalSteps: [
        'Ajak anak ke toilet secara teratur setiap 2 jam atau sesaat setelah bangun tidur.',
        'Gunakan pispot anak bermotif ceria dan berikan apresiasi bila ia berhasil pipis di toilet.',
        'Ajari menyikat gigi bersama orang tua di depan cermin pagi dan sebelum tidur.',
      ],
      tips: 'Jangan memarahi atau mempermalukan anak jika ia masih mengompol atau terlambat ke toilet.',
    ),
    StimulationItem(
      title: 'Bermain Peran & Berbagi dengan Teman Sebaya',
      sector: DevelopmentSector.sosialisasiKemandirian,
      ageRangeText: '3 - 6 Tahun',
      description: 'Kecerdasan emosional, empati, antre bergiliran, dan regulasi emosi saat bermain.',
      practicalSteps: [
        'Ajak anak bermain peran (dokter-dokteran, masak-masakan, pasar-pasaran).',
        'Fasilitasi playdate dengan teman sebaya di taman atau posyandu.',
        'Ajari konsep bergantian: "Sekarang giliran temanmu memegang bola, setelah itu giliranmu".',
      ],
      tips: 'Bantu anak melabeli emosinya: "Kamu sedih ya karena mainannya diminta? Yuk kita bicarakan baik-baik".',
    ),
  ];
}
