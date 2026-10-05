# Langkah Awal - Checklist Digital Milestone Perkembangan Motorik & Deteksi Dini Keterlambatan Tumbuh Kembang (KPSP Digital)
**Kelompok 13: BIK (Badan Intelejen Kesehatan)**  
**Standar Klinis:** Kuesioner Pra-Skrining Perkembangan (KPSP) & SDIDTK Kementerian Kesehatan Republik Indonesia

---

## 📌 Ringkasan Aplikasi
**"Langkah Awal"** adalah aplikasi multi-platform (Android, Web, Desktop) berbasis Flutter yang dirancang untuk mempermudah orang tua, kader Posyandu, dan tenaga kesehatan (Puskesmas) dalam memantau tumbuh kembang balita (usia 0 s/d 72 bulan) menggunakan instrumen resmi Kemenkes RI.

### 🌟 Fitur Utama:
1. **Kalkulator Usia Koreksi Prematur (Standar IDAI & Kemenkes)**:
   - Menghitung usia kronologis dan usia koreksi otomatis bagi anak yang lahir prematur (< 37 minggu gestasi) hingga usia 2 tahun.
   - Otomatis mencocokkan paket soal KPSP yang adil dan akurat sesuai usia koreksi anak.
2. **Bank Soal KPSP Resmi Kemenkes RI (16 Kelompok Umur)**:
   - Tersedia dari umur 3, 6, 9, 12, 15, 18, 21, 24, 30, 36, 42, 48, 54, 60, 66, hingga 72 bulan.
   - Mencakup 4 Domain Utama:
     * **Motorik Kasar** (*Gross Motor*)
     * **Motorik Halus** (*Fine Motor*)
     * **Bicara & Bahasa** (*Speech & Language*)
     * **Sosialisasi & Kemandirian** (*Social & Independence*)
   - Dilengkapi petunjuk teknis cara menguji anak serta alat bantu yang dibutuhkan.
3. **Mesin Klasifikasi Otomatis**:
   - **Skor Ya 9-10**: **Sesuai (S)** (Hijau)
   - **Skor Ya 7-8**: **Meragukan (M)** (Kuning) - Rekomendasi stimulasi intensif 2 minggu dan skrining ulang.
   - **Skor Ya <= 6**: **Kemungkinan Penyimpangan (P)** (Merah) - Rekomendasi rujukan medis faskes tingkat lanjut.
4. **Modul Panduan Stimulasi Terarah**:
   - Berisi langkah praktis harian stimulasi untuk mengejar keterlambatan domain yang belum tuntas.
5. **Kamus Tanda Bahaya (Red Flags)**:
   - Tanda-tanda bahaya perkembangan menurut IDAI/Kemenkes yang memerlukan pemeriksaan darurat ke dokter spesialis anak tanpa menunggu jadwal skrining.
6. **Ekspor & Cetak Laporan PDF Resmi**:
   - Format cetak standar dokumen SDIDTK Posyandu/Puskesmas dengan kop "Badan Intelejen Kesehatan (BIK) • Kelompok 13".
7. **Penyimpanan Lokal & Multi-Profil Anak**:
   - Data tersimpan aman di perangkat (offline-first).

---

## 🚀 Cara Menjalankan Aplikasi

Pastikan berada di folder project:
```bash
cd "C:\Users\User\.gemini\antigravity\scratch\langkah_awal"
```

### 1. Menjalankan di Perangkat Android yang Terhubung
```bash
flutter run -d 2409BRN2CY
```
*(atau cukup `flutter run` dan pilih nomor device Android)*

### 2. Menjalankan di Browser Chrome (Web)
```bash
flutter run -d chrome
```

### 3. Menjalankan di Windows Desktop
```bash
flutter run -d windows
```

### 4. Menjalankan Automated Unit Tests
```bash
flutter test
```

---

## 📂 Struktur Direktori Kode
```
lib/
├── data/
│   ├── kpsp_database.dart         # Bank kuesioner resmi Kemenkes RI (3-72 bulan)
│   ├── red_flags_database.dart    # Katalog tanda bahaya perkembangan medis IDAI
│   └── stimulation_database.dart  # Panduan stimulasi terarah 4 domain
├── models/
│   ├── child.dart                 # Model anak & kalkulator usia koreksi
│   ├── kpsp_question.dart          # Model butir KPSP & enum sektor perkembangan
│   └── screening_result.dart      # Model hasil evaluasi & klasifikasi status
├── screens/
│   ├── history_screen.dart        # Timeline & histori rekam milestone
│   ├── home_screen.dart           # Dashboard utama & profil balita
│   ├── red_flags_screen.dart      # Layar kamus tanda bahaya (Red Flags)
│   ├── result_screen.dart         # Hasil evaluasi skrining & analisis sektor
│   ├── screening_screen.dart      # Kuesioner interaktif KPSP 10 pertanyaan
│   └── stimulation_screen.dart    # Modul panduan stimulasi harian
├── services/
│   ├── pdf_report_service.dart    # Generator dokumen PDF & cetak laporan resmi
│   └── storage_service.dart       # Local persistence & starter pack balita
├── widgets/
│   └── child_form_dialog.dart     # Form tambah/edit data anak & kalkulator prematur
└── main.dart                      # Entry point Flutter & konfigurasi tema Material 3
```
