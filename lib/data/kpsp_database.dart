import '../models/kpsp_question.dart';

class KpspDatabase {
  static const List<int> availableAgeMilestones = [
    3, 6, 9, 12, 15, 18, 21, 24, 30, 36, 42, 48, 54, 60, 66, 72
  ];

  static List<KpspQuestion> getQuestionsForAge(int ageInMonths) {
    final questions = _allQuestions.where((q) => q.ageInMonths == ageInMonths).toList();
    if (questions.isEmpty) {
      // Fallback ke paket usia terdekat
      final closest = availableAgeMilestones.reduce((prev, curr) {
        return (curr - ageInMonths).abs() < (prev - ageInMonths).abs() ? curr : prev;
      });
      return _allQuestions.where((q) => q.ageInMonths == closest).toList();
    }
    return questions;
  }

  static const List<KpspQuestion> _allQuestions = [
    // ==========================================
    // USIA 3 BULAN (10 Butir)
    // ==========================================
    KpspQuestion(
      id: 'kpsp_3_1',
      ageInMonths: 3,
      sector: DevelopmentSector.motorikKasar,
      question: 'Pada waktu bayi telentang, apakah ia dapat mengikuti gerakan Anda dengan menggerakkan kepalanya dari satu sisi ke sisi lain?',
      instruction: 'Posisikan bayi telentang. Gerakkan wajah atau mainan berwarna mencolok dari sisi kiri ke kanan dengan jarak sekitar 20 cm di depan matanya.',
      toolsNeeded: 'Mainan berwarna cerah / wajah pemeriksa',
    ),
    KpspQuestion(
      id: 'kpsp_3_2',
      ageInMonths: 3,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Pada waktu bayi telentang, apakah ia dapat mendengarkan suara Anda dan mengeluarkan suara lain (bukan menangis) seperti "ooh", "aah"?',
      instruction: 'Ajak bayi berbicara dengan lembut saat ia sedang tenang dan senang. Perhatikan apakah ia membalas dengan ocehan vokal.',
    ),
    KpspQuestion(
      id: 'kpsp_3_3',
      ageInMonths: 3,
      sector: DevelopmentSector.motorikHalus,
      question: 'Pada waktu bayi telentang, apakah ia dapat melihat dan menatap matanya sendiri atau menatap tangan/gerakan jemarinya?',
      instruction: 'Perhatikan apakah bayi sering memperhatikan kedua tangannya sendiri yang digerakkan di depan wajahnya.',
    ),
    KpspQuestion(
      id: 'kpsp_3_4',
      ageInMonths: 3,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Apakah bayi tersenyum ketika Anda mengajak berbicara, tersenyum, atau membelai wajahnya?',
      instruction: 'Tersenyumlah dan tatap matanya, jangan menggelitik atau menyentuh bibir bayi. Lihat apakah ia membalas senyuman sosial.',
      isRedFlag: true,
    ),
    KpspQuestion(
      id: 'kpsp_3_5',
      ageInMonths: 3,
      sector: DevelopmentSector.motorikKasar,
      question: 'Pada waktu bayi ditengkurapkan, apakah ia dapat mengangkat kepalanya setinggi 45 derajat dengan bertumpu pada lengannya?',
      instruction: 'Tengkurapkan bayi di atas alas yang datar dan agak keras. Perhatikan apakah ia dapat mengangkat kepalanya tegak minimal 45 derajat.',
      toolsNeeded: 'Matras datar',
    ),
    KpspQuestion(
      id: 'kpsp_3_6',
      ageInMonths: 3,
      sector: DevelopmentSector.motorikHalus,
      question: 'Apakah bayi dapat memegang mainan gemerincing (rattle) yang diletakkan di tangannya selama beberapa detik?',
      instruction: 'Sentuhkan pegangan rattle ke telapak tangan bayi. Amati apakah refleks menggenggamnya menahan mainan tersebut.',
      toolsNeeded: 'Mainan gemerincing kecil',
    ),
    KpspQuestion(
      id: 'kpsp_3_7',
      ageInMonths: 3,
      sector: DevelopmentSector.motorikKasar,
      question: 'Pada waktu bayi ditengkurapkan, apakah ia dapat mengangkat kepalanya hingga 90 derajat?',
      instruction: 'Tengkurapkan bayi. Amati apakah ia mampu mengangkat kepala tegak dan dada terangkat sebagian.',
    ),
    KpspQuestion(
      id: 'kpsp_3_8',
      ageInMonths: 3,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Apakah bayi terkejut atau mengedipkan mata saat mendengar suara keras (misal tepukan tangan mendadak)?',
      instruction: 'Tepuk tangan keras sekitar 30 cm di belakang kepala bayi tanpa menyentuhnya. Perhatikan respon kejut / refleks Moro.',
      isRedFlag: true,
    ),
    KpspQuestion(
      id: 'kpsp_3_9',
      ageInMonths: 3,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Apakah bayi suka tertawa keras atau memekik gembira saat diajak bercanda?',
      instruction: 'Ajak bayi bermain cilukba sederhana atau bicara bernada riang. Amati suara tawa cerianya.',
    ),
    KpspQuestion(
      id: 'kpsp_3_10',
      ageInMonths: 3,
      sector: DevelopmentSector.motorikHalus,
      question: 'Apakah bayi mengarahkan kedua tangannya ke tengah tubuh dan membuka jari-jarinya (tidak selalu mengepal kencang)?',
      instruction: 'Amati saat bayi rileks di tempat tidur. Tangannya harus mulai sering terbuka bebas, bukan terus mengepal kaku.',
    ),

    // ==========================================
    // USIA 6 BULAN (10 Butir)
    // ==========================================
    KpspQuestion(
      id: 'kpsp_6_1',
      ageInMonths: 6,
      sector: DevelopmentSector.motorikHalus,
      question: 'Pada posisi telentang, apakah bayi mengulurkan tangannya untuk meraih benda atau mainan yang disodorkan di hadapannya?',
      instruction: 'Gantungkan atau ulurkan mainan menarik sekitar 20 cm di depan dada bayi.',
      toolsNeeded: 'Mainan berwarna cerah',
    ),
    KpspQuestion(
      id: 'kpsp_6_2',
      ageInMonths: 6,
      sector: DevelopmentSector.motorikKasar,
      question: 'Pada posisi telentang, pegang kedua tangan bayi lalu tarik perlahan ke posisi duduk. Apakah kepala bayi tegak mengikuti badan (tidak terkulai ke belakang)?',
      instruction: 'Tarik kedua pergelangan tangan bayi perlahan ke arah duduk. Amati kontrol kepalanya (Head Lag test).',
      isRedFlag: true,
    ),
    KpspQuestion(
      id: 'kpsp_6_3',
      ageInMonths: 6,
      sector: DevelopmentSector.motorikHalus,
      question: 'Apakah bayi dapat memindahkan mainan dari satu tangan ke tangan yang lain?',
      instruction: 'Berikan kubus/mainan kecil ke tangan kanan bayi, lalu tawarkan mainan lain ke tangan yang sama atau amati apakah ia mengalihkan mainan ke tangan kiri.',
      toolsNeeded: 'Kubus kecil / mainan genggam',
    ),
    KpspQuestion(
      id: 'kpsp_6_4',
      ageInMonths: 6,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Apakah bayi tersenyum ketika melihat gambar dirinya sendiri di cermin?',
      instruction: 'Pegang cermin bersih di depan bayi. Perhatikan apakah ia tersenyum, mengoceh, atau menyentuh bayangannya di cermin.',
      toolsNeeded: 'Cermin',
    ),
    KpspQuestion(
      id: 'kpsp_6_5',
      ageInMonths: 6,
      sector: DevelopmentSector.motorikKasar,
      question: 'Apakah bayi dapat berguling sendiri dari telentang ke tengkurap atau sebaliknya?',
      instruction: 'Letakkan bayi di matras datar, amati apakah ia mampu membalikkan tubuhnya secara mandiri.',
    ),
    KpspQuestion(
      id: 'kpsp_6_6',
      ageInMonths: 6,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Apakah bayi dapat mengeluarkan suara gembira bernada tinggi atau memekik (babbling/ocehan konsonan vokal seperti "da-da", "ba-ba")?',
      instruction: 'Dengarkan suara yang dihasilkan bayi saat ia bermain sendiri atau saat diajak berkomunikasi.',
    ),
    KpspQuestion(
      id: 'kpsp_6_7',
      ageInMonths: 6,
      sector: DevelopmentSector.motorikKasar,
      question: 'Dapatkah bayi duduk dengan ditopang kedua tangannya ke depan pada permukaan datar (tripod sitting)?',
      instruction: 'Dudukkan bayi di lantai beralas. Amati apakah ia bisa mempertahankan posisi duduk meski bertumpu pada kedua tangannya.',
    ),
    KpspQuestion(
      id: 'kpsp_6_8',
      ageInMonths: 6,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Apakah bayi menolehkan kepalanya ke arah sumber suara ketika dipanggil namanya dari samping/belakang?',
      instruction: 'Panggil nama bayi dengan suara lembut dari arah samping luar jangkauan pandangannya. Amati respon kepalanya.',
      isRedFlag: true,
    ),
    KpspQuestion(
      id: 'kpsp_6_9',
      ageInMonths: 6,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Apakah bayi berusaha menggapai biskuit atau makanan yang disodorkan padanya dan memasukkannya sendiri ke mulut?',
      instruction: 'Berikan biskuit bayi yang aman. Amati koordinasi tangan ke mulut.',
      toolsNeeded: 'Biskuit bayi',
    ),
    KpspQuestion(
      id: 'kpsp_6_10',
      ageInMonths: 6,
      sector: DevelopmentSector.motorikHalus,
      question: 'Jika mainan dijatuhkan tepat di dekatnya, apakah bayi memperhatikan arah jatuhnya mainan tersebut?',
      instruction: 'Jatuhkan mainan kecil di samping bayi saat ia melihatnya. Amati apakah pandangannya melacak benda yang jatuh.',
    ),

    // ==========================================
    // USIA 9 BULAN (10 Butir)
    // ==========================================
    KpspQuestion(
      id: 'kpsp_9_1',
      ageInMonths: 9,
      sector: DevelopmentSector.motorikKasar,
      question: 'Pada posisi berdiri yang dipegang ketiaknya, apakah kedua kaki bayi menyangga berat badannya dengan kokoh?',
      instruction: 'Pegang kedua ketiak bayi lalu letakkan kakinya menjejak meja/lantai. Amati kekuatan dorongan kakinya.',
    ),
    KpspQuestion(
      id: 'kpsp_9_2',
      ageInMonths: 9,
      sector: DevelopmentSector.motorikKasar,
      question: 'Dapatkah bayi duduk sendiri tanpa ditopang (punggung tegak dan kedua tangan bebas bergerak) selama minimal 60 detik?',
      instruction: 'Dudukkan bayi di lantai. Lepaskan pegangan dan amati keseimbangan duduknya tanpa terjungkal.',
      isRedFlag: true,
    ),
    KpspQuestion(
      id: 'kpsp_9_3',
      ageInMonths: 9,
      sector: DevelopmentSector.motorikHalus,
      question: 'Apakah bayi dapat memungut benda kecil seukuran kismis/kancing dengan menggunakan ibu jari dan jari telunjuknya (pincer grasp)?',
      instruction: 'Letakkan kismis/remah biskuit di atas meja bersih. Amati cara bayi mengambilnya (bukan menyapu dengan seluruh telapak tangan).',
      toolsNeeded: 'Remah biskuit / kismis',
    ),
    KpspQuestion(
      id: 'kpsp_9_4',
      ageInMonths: 9,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Apakah bayi dapat bermain "ciluk-ba" (peek-a-boo) dan tampak gembira menunggu wajah Anda muncul kembali?',
      instruction: 'Sembunyikan wajah di balik kain atau telapak tangan lalu buka kembali sambil berseru gembira.',
    ),
    KpspQuestion(
      id: 'kpsp_9_5',
      ageInMonths: 9,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Apakah bayi dapat mengucapkan suku kata ganda tanpa arti seperti "mamama", "bababa", "dadada"?',
      instruction: 'Tanyakan kepada orang tua apakah bayi sering mengulang rangkaian suku kata tersebut.',
    ),
    KpspQuestion(
      id: 'kpsp_9_6',
      ageInMonths: 9,
      sector: DevelopmentSector.motorikHalus,
      question: 'Apakah bayi dapat memegang dua buah kubus/mainan, masing-masing satu di setiap tangan, dan memukulkannya satu sama lain?',
      instruction: 'Berikan satu kubus di tangan kanan dan satu lagi di tangan kiri. Rangsang agar bayi memukulkannya bersama.',
      toolsNeeded: '2 kubus kayu / plastik',
    ),
    KpspQuestion(
      id: 'kpsp_9_7',
      ageInMonths: 9,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Apakah bayi melambaikan tangan "da-da" (bye-bye) ketika ada orang yang pamit atau diminta menirukannya?',
      instruction: 'Lambaikan tangan sambil mengucapkan "dadah/bye-bye". Amati apakah bayi meniru lambaian.',
    ),
    KpspQuestion(
      id: 'kpsp_9_8',
      ageInMonths: 9,
      sector: DevelopmentSector.motorikKasar,
      question: 'Apakah bayi dapat merangkak atau merayap maju dengan koordinasi lengan dan tungkai?',
      instruction: 'Letakkan mainan agak jauh di depannya, amati usaha bayi berpindah tempat menggunakan perut atau lutut dan tangannya.',
    ),
    KpspQuestion(
      id: 'kpsp_9_9',
      ageInMonths: 9,
      sector: DevelopmentSector.motorikHalus,
      question: 'Jika Anda menutup mainan yang disukai bayi dengan sehelai kain, apakah bayi menarik kain tersebut untuk mencari mainannya?',
      instruction: 'Tutup mainan dengan sapu tangan di depan bayi (Object Permanence). Amati apakah ia membuka kain penutup.',
      toolsNeeded: 'Sapu tangan & mainan',
    ),
    KpspQuestion(
      id: 'kpsp_9_10',
      ageInMonths: 9,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Apakah bayi menoleh atau berhenti sejenak ketika mendengar kata "Jangan" atau larangan bernada tegas?',
      instruction: 'Katakan kata "Jangan" dengan nada tegas saat bayi hendak menyentuh sesuatu. Amati reaksinya.',
    ),

    // ==========================================
    // USIA 12 BULAN (10 Butir)
    // ==========================================
    KpspQuestion(
      id: 'kpsp_12_1',
      ageInMonths: 12,
      sector: DevelopmentSector.motorikKasar,
      question: 'Apakah anak dapat berdiri sendiri selama minimal 30 detik tanpa berpegangan?',
      instruction: 'Posisikan anak berdiri di lantai bebas. Lepaskan pegangan perlahan dan hitung hingga 30 detik.',
    ),
    KpspQuestion(
      id: 'kpsp_12_2',
      ageInMonths: 12,
      sector: DevelopmentSector.motorikKasar,
      question: 'Apakah anak dapat berjalan dengan dibimbing atau berpegangan pada perabot rumah tangga (cruising)?',
      instruction: 'Amati anak melangkah menyusuri pinggiran sofa atau saat kedua tangannya dipegangi satu tangan Anda.',
    ),
    KpspQuestion(
      id: 'kpsp_12_3',
      ageInMonths: 12,
      sector: DevelopmentSector.motorikHalus,
      question: 'Apakah anak dapat memasukkan benda kecil (seperti kismis/batu kecil) ke dalam wadah/botol bermulut lebar?',
      instruction: 'Beri contoh memasukkan kubus kecil ke dalam mangkok/botol, lalu berikan kesempatan pada anak.',
      toolsNeeded: 'Cangkir/mangkuk & kubus kecil',
    ),
    KpspQuestion(
      id: 'kpsp_12_4',
      ageInMonths: 12,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Apakah anak dapat menyebut minimal 1 kata bermakna selain "mama" atau "papa" (misal: "cucu", "mimi", "bola")?',
      instruction: 'Tanyakan kepada ibu apakah anak sudah mengaitkan kata tertentu dengan objek spesifik.',
      isRedFlag: true,
    ),
    KpspQuestion(
      id: 'kpsp_12_5',
      ageInMonths: 12,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Apakah anak dapat mengulurkan lengan atau kakinya saat sedang dipakaikan baju/celana?',
      instruction: 'Amati atau tanyakan saat mengenakan baju, apakah anak kooperatif menjulurkan tangannya ke lengan baju.',
    ),
    KpspQuestion(
      id: 'kpsp_12_6',
      ageInMonths: 12,
      sector: DevelopmentSector.motorikHalus,
      question: 'Dapatkah anak menumpuk dua buah kubus kayu menjadi satu susunan tegak tanpa jatuh?',
      instruction: 'Tunjukkan cara menaruh satu kubus di atas kubus lainnya. Mintalah anak melakukan hal yang sama.',
      toolsNeeded: 'Kubus mainan',
    ),
    KpspQuestion(
      id: 'kpsp_12_7',
      ageInMonths: 12,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Apakah anak mengerti dan menuruti perintah sederhana yang disertai gestur (contoh: "kemari", "berikan bolanya")?',
      instruction: 'Ulurkan tangan dan katakan: "Sini berikan mainannya pada Ibu". Amati apakah ia menyerahkannya.',
    ),
    KpspQuestion(
      id: 'kpsp_12_8',
      ageInMonths: 12,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Apakah anak dapat minum dari cangkir/gelas sendiri (meskipun masih tumpah sedikit)?',
      instruction: 'Berikan gelas plastik kecil berisi sedikit air. Amati apakah anak dapat memegang dan mengarahkan ke mulutnya.',
      toolsNeeded: 'Cangkir kecil',
    ),
    KpspQuestion(
      id: 'kpsp_12_9',
      ageInMonths: 12,
      sector: DevelopmentSector.motorikKasar,
      question: 'Dari posisi membungkuk memungut mainan di lantai, apakah anak dapat kembali berdiri tegak tanpa terjatuh?',
      instruction: 'Jatuhkan mainan di depan anak yang sedang berdiri. Amati bagaimana ia berjongkok/membungkuk lalu bangkit berdiri lagi.',
    ),
    KpspQuestion(
      id: 'kpsp_12_10',
      ageInMonths: 12,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Apakah anak menunjuk dengan jari telunjuknya ketika menginginkan sesuatu atau menunjukkan hal menarik?',
      instruction: 'Perhatikan apakah anak menggunakan gestur menunjuk (pointing) saat ingin diambilkan sesuatu.',
      isRedFlag: true,
    ),

    // ==========================================
    // USIA 18 BULAN (10 Butir)
    // ==========================================
    KpspQuestion(
      id: 'kpsp_18_1',
      ageInMonths: 18,
      sector: DevelopmentSector.motorikKasar,
      question: 'Apakah anak dapat berjalan sendiri di dalam ruangan tanpa terhuyung-huyung atau terjatuh?',
      instruction: 'Amati anak berjalan bebas di atas lantai datar minimal 10 langkah berturut-turut.',
      isRedFlag: true,
    ),
    KpspQuestion(
      id: 'kpsp_18_2',
      ageInMonths: 18,
      sector: DevelopmentSector.motorikKasar,
      question: 'Apakah anak dapat berjalan mundur beberapa langkah (minimal 5 langkah)?',
      instruction: 'Minta anak berjalan mundur atau tarik mainan sambil melangkah mundur.',
    ),
    KpspQuestion(
      id: 'kpsp_18_3',
      ageInMonths: 18,
      sector: DevelopmentSector.motorikHalus,
      question: 'Dapatkah anak menumpuk minimal 3-4 kubus ke atas tanpa roboh?',
      instruction: 'Beri anak 4 kubus dan contohkan menumpuknya menjadi menara tinggi.',
      toolsNeeded: '4 kubus',
    ),
    KpspQuestion(
      id: 'kpsp_18_4',
      ageInMonths: 18,
      sector: DevelopmentSector.motorikHalus,
      question: 'Apakah anak dapat mencoret-coret kertas sendiri menggunakan krayon atau pensil?',
      instruction: 'Letakkan selembar kertas dan krayon. Biarkan anak membuat coretan spontan tanpa dibimbing tangannya.',
      toolsNeeded: 'Kertas & krayon',
    ),
    KpspQuestion(
      id: 'kpsp_18_5',
      ageInMonths: 18,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Apakah anak dapat mengucapkan sedikitnya 6 kata yang memiliki arti jelas (selain mama dan papa)?',
      instruction: 'Tanyakan perbendaharaan kata aktif yang sering diucapkan anak sehari-hari.',
      isRedFlag: true,
    ),
    KpspQuestion(
      id: 'kpsp_18_6',
      ageInMonths: 18,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Apakah anak dapat menunjuk sedikitnya 1 bagian tubuhnya saat ditanya (contoh: "Mana hidungmu?", "Mana matamu?")?',
      instruction: 'Tanyakan tanpa memberi kode isyarat tangan Anda ke bagian tubuh tersebut.',
    ),
    KpspQuestion(
      id: 'kpsp_18_7',
      ageInMonths: 18,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Apakah anak dapat makan sendiri menggunakan sendok tanpa menumpahkan sebagian besar isinya?',
      instruction: 'Amati saat waktu makan atau beri mangkuk camilan dengan sendok kecil.',
      toolsNeeded: 'Sendok & mangkuk',
    ),
    KpspQuestion(
      id: 'kpsp_18_8',
      ageInMonths: 18,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Apakah anak suka meniru kegiatan orang dewasa di rumah (seperti menyapu, mengelap meja, atau menelepon)?',
      instruction: 'Tanyakan kepada pengasuh/orang tua perilaku imitasi domestik anak.',
    ),
    KpspQuestion(
      id: 'kpsp_18_9',
      ageInMonths: 18,
      sector: DevelopmentSector.motorikKasar,
      question: 'Apakah anak dapat naik tangga dengan berpegangan pada dinding atau susuran tangga?',
      instruction: 'Ajak anak menaiki 2-3 anak tangga dengan pengawasan ketat.',
    ),
    KpspQuestion(
      id: 'kpsp_18_10',
      ageInMonths: 18,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Apakah anak dapat melepas pakaian atau sepatunya sendiri (misal kaus kaki atau celana longgar)?',
      instruction: 'Amati atau tanyakan kemampuan anak melepas alas kaki/kaus kaki.',
    ),

    // ==========================================
    // USIA 24 BULAN (2 TAHUN) (10 Butir)
    // ==========================================
    KpspQuestion(
      id: 'kpsp_24_1',
      ageInMonths: 24,
      sector: DevelopmentSector.motorikKasar,
      question: 'Apakah anak dapat menendang bola besar ke arah depan tanpa berpegangan pada benda lain?',
      instruction: 'Letakkan bola plastik di lantai sekitar 15 cm di depan anak. Minta ia menendangnya.',
      toolsNeeded: 'Bola sepak plastik',
    ),
    KpspQuestion(
      id: 'kpsp_24_2',
      ageInMonths: 24,
      sector: DevelopmentSector.motorikKasar,
      question: 'Apakah anak dapat melompat dengan mengangkat kedua kakinya sekaligus dari lantai?',
      instruction: 'Contohkan melompat di tempat. Amati apakah kedua telapak kaki anak terangkat bersamaan.',
    ),
    KpspQuestion(
      id: 'kpsp_24_3',
      ageInMonths: 24,
      sector: DevelopmentSector.motorikHalus,
      question: 'Dapatkah anak menyusun menara dari 6 buah kubus berturut-turut tanpa roboh?',
      instruction: 'Sediakan 6 kubus kayu. Minta anak membuat susunan menara setinggi mungkin.',
      toolsNeeded: '6 kubus',
    ),
    KpspQuestion(
      id: 'kpsp_24_4',
      ageInMonths: 24,
      sector: DevelopmentSector.motorikHalus,
      question: 'Dapatkah anak meniru membuat garis lurus ke bawah di atas kertas setelah Anda mencontohkannya?',
      instruction: 'Buatlah garis vertikal di atas kertas, lalu berikan krayon pada anak dan minta ia membuat garis serupa.',
      toolsNeeded: 'Kertas & pensil/krayon',
    ),
    KpspQuestion(
      id: 'kpsp_24_5',
      ageInMonths: 24,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Apakah anak dapat menggabungkan minimal 2 kata menjadi kalimat sederhana (contoh: "mau susu", "bapak pergi", "makan nasi")?',
      instruction: 'Tanyakan apakah anak menggunakan kombinasi 2 kata bermakna (bukan hanya meniru lagu).',
      isRedFlag: true,
    ),
    KpspQuestion(
      id: 'kpsp_24_6',
      ageInMonths: 24,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Apakah anak dapat menunjuk sedikitnya 4 bagian tubuh dengan benar saat ditanya (mata, hidung, mulut, telinga, tangan)?',
      instruction: 'Tanyakan secara acak 4 bagian tubuh tanpa gerakan petunjuk dari Anda.',
    ),
    KpspQuestion(
      id: 'kpsp_24_7',
      ageInMonths: 24,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Apakah anak dapat membuka kenop pintu atau menarik laci untuk mengambil barang?',
      instruction: 'Amati kemampuan eksplorasi fisik anak di rumah.',
    ),
    KpspQuestion(
      id: 'kpsp_24_8',
      ageInMonths: 24,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Apakah anak dapat memberitahukan bila celananya basah/kotor atau ingin buang air kecil/besar?',
      instruction: 'Tanyakan tanda awal kesiapan toilet training anak kepada orang tua.',
    ),
    KpspQuestion(
      id: 'kpsp_24_9',
      ageInMonths: 24,
      sector: DevelopmentSector.motorikKasar,
      question: 'Apakah anak dapat berlari dengan lancar tanpa mudah terjatuh?',
      instruction: 'Ajak anak berlari mengejar bola atau ke pelukan orang tua.',
    ),
    KpspQuestion(
      id: 'kpsp_24_10',
      ageInMonths: 24,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Apakah anak dapat menyebutkan nama minimal 2 benda yang ada di dalam gambar buku anak?',
      instruction: 'Buka buku bergambar (kucing, mobil, anjing, bola). Tanyakan: "Ini apa?" pada gambar tersebut.',
      toolsNeeded: 'Buku cerita bergambar',
    ),

    // ==========================================
    // USIA 36 BULAN (3 TAHUN) (10 Butir)
    // ==========================================
    KpspQuestion(
      id: 'kpsp_36_1',
      ageInMonths: 36,
      sector: DevelopmentSector.motorikKasar,
      question: 'Apakah anak dapat berdiri dengan satu kaki selama minimal 2-3 detik tanpa berpegangan?',
      instruction: 'Contohkan berdiri dengan satu kaki seperti bangau. Minta anak mencobanya.',
    ),
    KpspQuestion(
      id: 'kpsp_36_2',
      ageInMonths: 36,
      sector: DevelopmentSector.motorikKasar,
      question: 'Apakah anak dapat mengayuh sepeda roda tiga sejauh minimal 1-2 meter?',
      instruction: 'Tanyakan apakah anak bisa mengayuh pedal sepeda roda tiga (bukan hanya mendorong dengan kaki ke lantai).',
    ),
    KpspQuestion(
      id: 'kpsp_36_3',
      ageInMonths: 36,
      sector: DevelopmentSector.motorikHalus,
      question: 'Dapatkah anak meniru menggambar bentuk lingkaran setelah Anda mencontohkannya?',
      instruction: 'Gambar sebuah lingkaran tertutup di kertas, lalu minta anak menggambar hal yang sama.',
      toolsNeeded: 'Kertas & pensil',
    ),
    KpspQuestion(
      id: 'kpsp_36_4',
      ageInMonths: 36,
      sector: DevelopmentSector.motorikHalus,
      question: 'Dapatkah anak menyusun menara dari 8 buah kubus bertingkat tanpa roboh?',
      instruction: 'Sediakan 8 kubus dan minta anak menyusunnya ke atas.',
      toolsNeeded: '8 kubus',
    ),
    KpspQuestion(
      id: 'kpsp_36_5',
      ageInMonths: 36,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Apakah kalimat yang diucapkan anak sudah dapat dipahami oleh orang luar/orang asing sedikitnya 75%?',
      instruction: 'Tanyakan apakah orang yang jarang bertemu dengan anak dapat memahami maksud perkataannya.',
      isRedFlag: true,
    ),
    KpspQuestion(
      id: 'kpsp_36_6',
      ageInMonths: 36,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Apakah anak tahu nama lengkapnya sendiri, jenis kelaminnya, atau umurnya ketika ditanya?',
      instruction: 'Tanyakan langsung pada anak: "Siapa namamu?", "Kamu anak laki-laki atau perempuan?".',
    ),
    KpspQuestion(
      id: 'kpsp_36_7',
      ageInMonths: 36,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Dapatkah anak memakai kaos atau celana sendiri (tanpa kancing/resleting yang rumit)?',
      instruction: 'Minta anak mengenakan kaos oblong atau celana karet sendiri.',
    ),
    KpspQuestion(
      id: 'kpsp_36_8',
      ageInMonths: 36,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Apakah anak dapat mencuci dan mengeringkan kedua tangannya sendiri setelah makan atau bermain?',
      instruction: 'Arahkan anak ke wastafel/kran air, amati apakah ia bisa membasuh dan mengusap tangan dengan handuk.',
    ),
    KpspQuestion(
      id: 'kpsp_36_9',
      ageInMonths: 36,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Apakah anak mengerti konsep preposisi seperti "letakkan kubus di atas meja", "di bawah kursi"?',
      instruction: 'Uji anak dengan perintah meletakkan benda di atas atau di bawah tanpa gerakan tangan.',
    ),
    KpspQuestion(
      id: 'kpsp_36_10',
      ageInMonths: 36,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Apakah anak mulai bermain peran bersama teman sebayanya (misal bermain masak-masakan, mobil-mobilan bersama)?',
      instruction: 'Tanyakan interaksi sosial anak dengan teman sebaya atau saudaranya.',
    ),

    // ==========================================
    // USIA 48 BULAN (4 TAHUN) (10 Butir)
    // ==========================================
    KpspQuestion(
      id: 'kpsp_48_1',
      ageInMonths: 48,
      sector: DevelopmentSector.motorikKasar,
      question: 'Dapatkah anak berdiri dengan 1 kaki selama minimal 5 detik tanpa berpegangan dan tidak oleng?',
      instruction: 'Hitung 1 sampai 5 saat anak mengangkat satu kakinya.',
    ),
    KpspQuestion(
      id: 'kpsp_48_2',
      ageInMonths: 48,
      sector: DevelopmentSector.motorikKasar,
      question: 'Dapatkah anak melompat dengan 1 kaki (engklek / hopping) minimal 2-3 lompatan di tempat?',
      instruction: 'Contohkan melompat dengan satu kaki. Minta anak menirukan.',
    ),
    KpspQuestion(
      id: 'kpsp_48_3',
      ageInMonths: 48,
      sector: DevelopmentSector.motorikHalus,
      question: 'Dapatkah anak meniru menggambar tanda silang / palang (+) setelah Anda mencontohkannya?',
      instruction: 'Gambarkan tanda tambah (+) di kertas, berikan pensil dan minta anak meniru gambar tersebut.',
      toolsNeeded: 'Kertas & pensil',
    ),
    KpspQuestion(
      id: 'kpsp_48_4',
      ageInMonths: 48,
      sector: DevelopmentSector.motorikHalus,
      question: 'Dapatkah anak menggunting kertas menjadi dua bagian mengikuti garis lurus sederhana?',
      instruction: 'Berikan gunting anak yang tumpul dan kertas bergaris lurus.',
      toolsNeeded: 'Gunting tumpul & kertas',
    ),
    KpspQuestion(
      id: 'kpsp_48_5',
      ageInMonths: 48,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Dapatkah anak menyebutkan sedikitnya 3-4 warna dasar dengan benar (merah, biru, kuning, hijau)?',
      instruction: 'Tunjukkan benda/kertas berwarna dan tanyakan: "Ini warna apa?".',
      toolsNeeded: 'Balok/kertas warna',
    ),
    KpspQuestion(
      id: 'kpsp_48_6',
      ageInMonths: 48,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Apakah anak dapat menceritakan kejadian sederhana yang dialaminya hari ini dengan kalimat yang runut?',
      instruction: 'Tanyakan: "Tadi di sekolah/jalan bermain apa?", dengarkan alur ceritanya.',
    ),
    KpspQuestion(
      id: 'kpsp_48_7',
      ageInMonths: 48,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Dapatkah anak mengancingkan bajunya sendiri (minimal 1 atau 2 kancing)?',
      instruction: 'Amati saat berpakaian, berikan kemeja berukuran kancing sedang.',
    ),
    KpspQuestion(
      id: 'kpsp_48_8',
      ageInMonths: 48,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Apakah anak sudah dapat pergi ke toilet dan buang air kecil mandiri tanpa mengompol di siang hari?',
      instruction: 'Tanyakan rutinitas toilet anak kepada orang tua.',
    ),
    KpspQuestion(
      id: 'kpsp_48_9',
      ageInMonths: 48,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Jika Anda bertanya "Apa yang kamu lakukan bila kamu lapar / haus / mengantuk?", apakah anak dapat menjawab dengan benar?',
      instruction: 'Tanyakan minimal 2 dari 3 kondisi tersebut: makan, minum, tidur.',
    ),
    KpspQuestion(
      id: 'kpsp_48_10',
      ageInMonths: 48,
      sector: DevelopmentSector.motorikHalus,
      question: 'Dapatkah anak menggambar sosok orang dengan minimal memiliki 3 bagian tubuh (kepala, badan, kaki/tangan)?',
      instruction: 'Minta anak: "Gambarlah orang di kertas ini". Periksa kelengkapan bagian tubuhnya.',
      toolsNeeded: 'Kertas & pensil',
    ),

    // ==========================================
    // USIA 60 BULAN (5 TAHUN) (10 Butir)
    // ==========================================
    KpspQuestion(
      id: 'kpsp_60_1',
      ageInMonths: 60,
      sector: DevelopmentSector.motorikKasar,
      question: 'Dapatkah anak berdiri dengan 1 kaki selama 10 detik atau lebih tanpa berpegangan?',
      instruction: 'Ukur waktu berdiri satu kaki hingga 10 detik.',
    ),
    KpspQuestion(
      id: 'kpsp_60_2',
      ageInMonths: 60,
      sector: DevelopmentSector.motorikKasar,
      question: 'Dapatkah anak melompati tali/rintangan setinggi 15-20 cm dengan kedua kaki bersamaan?',
      instruction: 'Rentangkan tali setinggi betis anak, amati cara ia melompatinya.',
    ),
    KpspQuestion(
      id: 'kpsp_60_3',
      ageInMonths: 60,
      sector: DevelopmentSector.motorikHalus,
      question: 'Dapatkah anak meniru menggambar bentuk bujur sangkar / kotak persegi setelah Anda mencontohkannya?',
      instruction: 'Gambarkan persegi 4 sisi sama panjang di kertas. Minta anak menggambarnya (bukan lonjong).',
      toolsNeeded: 'Kertas & pensil',
    ),
    KpspQuestion(
      id: 'kpsp_60_4',
      ageInMonths: 60,
      sector: DevelopmentSector.motorikHalus,
      question: 'Dapatkah anak menggambar sosok orang dengan sedikitnya 6 bagian tubuh lengkap (kepala, mata, hidung, mulut, badan, tangan, kaki)?',
      instruction: 'Minta anak menggambar orang dan amati detail anggota tubuh yang digambar.',
      toolsNeeded: 'Kertas & pensil',
    ),
    KpspQuestion(
      id: 'kpsp_60_5',
      ageInMonths: 60,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Dapatkah anak menjawab pertanyaan perbandingan ukuran (misal: "Gajah itu besar, tikus itu apa?", "Es itu dingin, api itu apa?")?',
      instruction: 'Uji dengan konsep lawan kata sederhana.',
    ),
    KpspQuestion(
      id: 'kpsp_60_6',
      ageInMonths: 60,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Dapatkah anak berhitung secara benar sedikitnya 4 buah kubus/benda saat ditunjuk satu per satu?',
      instruction: 'Letakkan 4 kubus berjejer. Minta anak menghitung: "Satu, dua, tiga, empat".',
      toolsNeeded: '4 kubus',
    ),
    KpspQuestion(
      id: 'kpsp_60_7',
      ageInMonths: 60,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Dapatkah anak berpakaian sendiri secara lengkap tanpa dibantu (kecuali menalikan sepatu)?',
      instruction: 'Tanyakan apakah anak sudah mandiri memakai baju, celana, dan kancing/resleting.',
    ),
    KpspQuestion(
      id: 'kpsp_60_8',
      ageInMonths: 60,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Apakah anak dapat menggosok gigi sendiri dengan gerakan yang cukup bersih?',
      instruction: 'Tanyakan atau amati kemandirian anak menyikat gigi pagi dan malam.',
    ),
    KpspQuestion(
      id: 'kpsp_60_9',
      ageInMonths: 60,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Dapatkah anak mengerti dan melaksanakan 3 instruksi berurutan sekaligus (contoh: "Ambil bukumu, letakkan di meja, lalu duduklah di kursi")?',
      instruction: 'Berikan 3 perintah berantai tanpa mengulang atau memberi contoh.',
    ),
    KpspQuestion(
      id: 'kpsp_60_10',
      ageInMonths: 60,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Apakah anak dapat bermain secara kooperatif dan mematuhi aturan sederhana permainan kelompok bersama teman?',
      instruction: 'Amati apakah anak mau bergiliran (take turns) dalam permainan bersama.',
    ),

    // ==========================================
    // USIA 72 BULAN (6 TAHUN) (10 Butir)
    // ==========================================
    KpspQuestion(
      id: 'kpsp_72_1',
      ageInMonths: 72,
      sector: DevelopmentSector.motorikKasar,
      question: 'Dapatkah anak berjalan lurus ke depan dengan tumit menyentuh ujung jari kaki kaki lainnya (heel-to-toe walk) sejauh minimal 2 meter?',
      instruction: 'Buat garis lurus di lantai. Minta anak berjalan di atas garis dengan tumit rapat ke ujung jempol kaki secara bergantian.',
    ),
    KpspQuestion(
      id: 'kpsp_72_2',
      ageInMonths: 72,
      sector: DevelopmentSector.motorikKasar,
      question: 'Dapatkah anak melompat dengan 1 kaki bergantian kiri dan kanan secara lincah?',
      instruction: 'Amati koordinasi melompat engklek kaki kanan dan kaki kiri.',
    ),
    KpspQuestion(
      id: 'kpsp_72_3',
      ageInMonths: 72,
      sector: DevelopmentSector.motorikHalus,
      question: 'Dapatkah anak meniru menggambar bentuk segitiga bersudut rapi setelah Anda mencontohkannya?',
      instruction: 'Gambarkan segitiga sama sisi di kertas. Minta anak meniru bentuk segitiga tersebut.',
      toolsNeeded: 'Kertas & pensil',
    ),
    KpspQuestion(
      id: 'kpsp_72_4',
      ageInMonths: 72,
      sector: DevelopmentSector.motorikHalus,
      question: 'Dapatkah anak menulis namanya sendiri atau minimal menulis beberapa huruf alfabet dengan benar?',
      instruction: 'Berikan pensil dan kertas, minta anak menuliskan namanya.',
      toolsNeeded: 'Kertas & pensil',
    ),
    KpspQuestion(
      id: 'kpsp_72_5',
      ageInMonths: 72,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Dapatkah anak menjelaskan fungsi dari 3 benda sehari-hari (contoh: cangkir untuk minum, gunting untuk memotong, payung untuk melindungi dari hujan)?',
      instruction: 'Tanyakan kegunaan dari benda-benda tersebut satu per satu.',
    ),
    KpspQuestion(
      id: 'kpsp_72_6',
      ageInMonths: 72,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Dapatkah anak menyebutkan mana yang lebih berat di antara dua benda yang dipegangnya (contoh: buku tebal vs pensil)?',
      instruction: 'Berikan dua benda dengan perbedaan berat yang nyata ke tangan kanan dan kiri anak.',
    ),
    KpspQuestion(
      id: 'kpsp_72_7',
      ageInMonths: 72,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Dapatkah anak mengikat tali sepatunya sendiri atau membuat simpul pita?',
      instruction: 'Uji anak mengikat tali sepatu atau simpul sederhana.',
    ),
    KpspQuestion(
      id: 'kpsp_72_8',
      ageInMonths: 72,
      sector: DevelopmentSector.sosialisasiKemandirian,
      question: 'Apakah anak dapat menyiapkan makanan sederhananya sendiri (misal mengoleskan selai ke roti atau menuangkan susu dari teko kecil)?',
      instruction: 'Tanyakan kemandirian penyiapan bekal sederhana di rumah.',
    ),
    KpspQuestion(
      id: 'kpsp_72_9',
      ageInMonths: 72,
      sector: DevelopmentSector.bicaraBahasa,
      question: 'Dapatkah anak membedakan tangan kanan dan tangan kirinya sendiri dengan benar tanpa ragu?',
      instruction: 'Minta anak: "Angkat tangan kananmu", lalu "Pegang telinga kirimu".',
    ),
    KpspQuestion(
      id: 'kpsp_72_10',
      ageInMonths: 72,
      sector: DevelopmentSector.motorikHalus,
      question: 'Dapatkah anak melipat kertas origami secara diagonal atau menjadi bentuk lipatan simetris yang rapi?',
      instruction: 'Contohkan melipat kertas bujur sangkar menjadi segitiga yang sudut-sudutnya bertemu rapi.',
      toolsNeeded: 'Kertas origami',
    ),
  ];
}
