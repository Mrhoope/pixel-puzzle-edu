# PRD Game Puzzle Edukasi Pixel 2D

Versi ringkas untuk repositori. Sumber lengkap: `PRD Game Puzzle Edukasi Pixel 2D.docx` (19 Nov 2026, @Fahru).

## 1. Ringkasan

Puzzle edukasi pixel 2D: pemain menyusun program dari blok instruksi, karakter menjalankannya, hasil outbox divalidasi. 10 level, desktop, offline, tanpa akun. Processing (Java), repositori GitHub.

Tujuan: memahami berpikir algoritmik (urutan, variabel, perulangan, kondisi, debugging, optimasi) lewat mekanik, bukan kuis.

Referensi: Human Resource Machine (blok, inbox/outbox, lompatan), Lightbot (satu konsep per level), Lemmings (pixel, ulang cepat).

## 2. Target pengguna

Pelajar SMP sampai mahasiswa tahun pertama, tanpa latar coding. Setelah level 10 diharapkan mampu menyusun urutan, memakai variabel, mengulang, bercabang, dan memperbaiki program.

## 3. Mekanik inti

- Tugas singkat per level.
- Pemain menambah/menyusun blok, menekan Jalankan.
- Karakter mengeksekusi satu blok per langkah; blok aktif menyala.
- Outbox dibandingkan dengan hasil yang diharapkan.
- Gagal tidak menghukum: program tetap ada, pemain melihat langkah yang menyimpang.
- Elemen: inbox, outbox, tangan (satu nilai), memori bernomor, kontrol kecepatan.
- Tantangan opsional Size dan Speed memberi bintang tambahan.

## 4. Set instruksi

| Blok | Fungsi | Konsep | Dibuka |
| --- | --- | --- | --- |
| AMBIL | Ambil item dari inbox ke tangan | Input | 1 |
| TARUH | Taruh item ke outbox | Output | 1 |
| SIMPAN | Salin tangan ke memori | Variabel | 3 |
| MUAT | Salin memori ke tangan | Variabel | 3 |
| TAMBAH | Tangan += memori | Aritmetika | 4 |
| KURANG | Tangan -= memori | Aritmetika | 4 |
| LABEL | Tandai posisi | Penanda | 5 |
| LONCAT | Lompat ke label | Perulangan | 5 |
| LONCAT JIKA NOL | Lompat jika tangan = 0 | Kondisi | 7 |
| LONCAT JIKA NEGATIF | Lompat jika tangan < 0 | Kondisi | 8 |

Tidak ada for/while/if. Perulangan dan kondisi dibangun dari LONCAT.

## 5. Desain level

| Level | Judul | Konsep baru | Blok baru | Tugas |
| --- | --- | --- | --- | --- |
| 1 | Antar Paket | Urutan | AMBIL, TARUH | Pindahkan item dengan urutan sama |
| 2 | Antrean Panjang | Repetisi manual | - | Pindahkan 8 item |
| 3 | Tukar Tempat | Variabel | SIMPAN, MUAT | Tukar pasangan (A,B) menjadi (B,A) |
| 4 | Hitung Cepat | Aritmetika | TAMBAH, KURANG | Jumlahkan pasangan angka |
| 5 | Putar Terus | Perulangan | LABEL, LONCAT | Gandakan tiap angka, panjang tak tentu |
| 6 | Total Berjalan | Akumulator | - | Jumlah kumulatif tiap angka |
| 7 | Saringan | Kondisi | LONCAT JIKA NOL | Buang angka nol |
| 8 | Hanya Positif | Kondisi ganda | LONCAT JIKA NEGATIF | Keluarkan hanya positif |
| 9 | Hitung Mundur | Penghitung | - | N, N-1, ... 1 untuk tiap N |
| 10 | Mesin Pengali | Gabungan | - | Kalikan dua angka dengan penjumlahan berulang |

Lulus: outbox sama persis untuk semua data uji, termasuk kasus tepi. Bintang 1 lulus, 2 Size, 3 Speed.

## 6. Kebutuhan

Wajib: menu (F1), pilih level + status + bintang (F2), panel program tambah/hapus/susun (F3), eksekusi Jalankan/Jeda/Langkah/Reset (F4), validasi multi-tes dengan langkah menyimpang (F5), unlock berurutan + blok sesuai level (F6), simpan progres JSON lokal (F7), tutorial singkat level 1 (F8).
Opsional: hint bertahap (F9), audio + mute (F10).

Non-fungsional: 60 FPS di laptop biasa; paket <100 MB; jelas di 1280x720; level 1 dipahami <2 menit; data level terpisah dari kode.

## 7. Visual dan audio

Canvas internal 320x180, diperbesar 4x dengan `noSmooth()`. Sprite 16x16, palet 16 warna, font pixel berlisensi bebas. Layout: tugas atas, area kerja tengah, panel program kanan, palet blok bawah. Aset wajib buatan sendiri/berlisensi jelas dan dicatat di CREDITS.md.

## 8. Arsitektur

`game.pde` (loop draw 60 FPS, input) -> `GameState` (menu/pilih/bermain/menang, simpan progres) -> `UI` menggambar; `Interpreter` hanya mengubah state (tangan, memori, outbox, blok aktif) berdasarkan data uji dari `Level`; `Program` menyimpan blok pemain. Level JSON di `data/levels/`, progres `progress.json`, batas langkah per level.

## 9. Repositori dan alur kerja

`main` selalu runnable; fitur di cabang terpisah; satu Issue per fitur/level; commit kecil; tag v0.1, v0.2, v0.5, v0.8, v1.0; ekspor Processing diunggah sebagai Release; `.gitignore` mengecualikan hasil ekspor dan progres lokal.

## 10. Milestone

1. **v0.1 Fondasi** - sketch Processing, game loop, repositori. Gerbang: game berjalan dan kode di GitHub.
2. **v0.2 Interpreter** - semua blok berjalan, diuji tanpa UI lengkap. Gerbang: solusi referensi level 1-10 lulus.
3. **v0.5 UI + level 1-5** - tambah blok, pilih level, JSON. Gerbang: level 1-5 bisa dimainkan dari menu.
4. **v0.8 Level 6-10 + progres** - level akhir, bintang, simpan progres. Gerbang: level 1-10 lulus lewat UI.
5. **v1.0 Poles dan rilis** - pixel art final, tutorial, uji pemain, GitHub Release. Gerbang: pemain baru paham level 1 <2 menit.

## 11. Metrik dan risiko

Metrik: level 1 <2 menit, 60 FPS stabil, paket <100 MB, tingkat penyelesaian sampai level 10, kurva tanpa lonjakan tajam.

Risiko: bug interpreter (uji solusi referensi + kasus tepi), seret-dan-lepas sulit (mulai dari klik), lonjakan kesulitan (uji pemain + hint), pixel art lama (poles di tahap 5), lisensi aset (catat di CREDITS.md).

## 12. Di luar cakupan

Lebih dari 10 level, editor level, multipemain, versi web/mobile, bahasa pemrograman sungguhan, kuis/teori, akun dan fitur online.
