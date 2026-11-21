# Pixel Puzzle Edukasi

Puzzle edukasi pixel 2D untuk belajar berpikir algoritmik. Pemain menyusun program dari blok instruksi, lalu karakter menjalankannya langkah demi langkah. Dibuat dengan Processing (Java), 10 level, offline.

Status: **kerangka v0.1** - struktur, menu, pilih level, editor blok (klik), interpreter 10 opcode, validasi multi-tes, dan simpan progres sudah berjalan. Visual masih placeholder.

## Menjalankan

1. Install Processing 4.5+ (sudah tersedia di mesin ini: `C:\Program Files\Processing`).
2. Buka `game/game.pde` di Processing.
3. Tekan Run.

Penting: nama folder sketch harus `game` dan file utama harus `game.pde`. Jangan mengubah nama keduanya.

## Kontrol

| Aksi | Cara |
| --- | --- |
| Tambah blok | Klik blok di palet bawah |
| Ubah argumen blok | Klik blok di panel program dua kali (berputar 0..N) |
| Hapus blok | Klik kanan blok, atau pilih lalu Delete/Backspace |
| Geser urutan blok | Pilih blok lalu panah Atas/Bawah |
| Jalankan | Tombol JALANKAN atau Enter |
| Jeda | Tombol JEDA |
| Satu langkah | Tombol LANGKAH atau Spasi |
| Reset | Tombol RESET |
| Kecepatan | Tombol NORMAL 1x / CEPAT 4x |
| Kembali | Tombol `<` atau Esc |
| Navigasi tutorial | Tombol `< KEMBALI`, `LANJUT >`, panah kiri/kanan, atau Esc |
| Bantuan blok | Tombol `?` di pojok kanan atas setiap level |

Tutorial menjelaskan AMBIL, TARUH, SIMPAN, MUAT, TAMBAH, KURANG, LABEL, LONCAT, L-NOL, dan L-NEG dengan contoh.
Setiap level menampilkan tujuan dengan bahasa sederhana dan contoh INBOX → OUTBOX dari soal uji. Latar menu memiliki partikel pixel yang bergerak.

## Struktur

```
pixel-puzzle-edu/
├── README.md
├── CREDITS.md
├── LICENSE
├── .gitignore
├── docs/
│   └── PRD.md
└── game/
    ├── game.pde          setup(), draw(), input
    ├── GameState.pde     menu / pilih level / bermain / menang, progres
    ├── Level.pde         memuat data level dari JSON
    ├── Program.pde       Block + daftar blok pemain
    ├── Interpreter.pde   eksekusi satu blok per langkah
    ├── UI.pde            gambar layar, tombol, klik
    └── data/
        ├── levels/       level01.json ... level10.json
        ├── sprites/      (menyusul) PNG 16x16
        ├── fonts/        (menyusul) font pixel
        └── sounds/       (menyusul) efek suara
```

Semua kelas murni Java dan hanya `Interpreter` yang mengubah state permainan; UI hanya menggambar dan meneruskan aksi ke `GameState`.

## Skema data level

```json
{
  "id": 1,
  "title": "Antar Paket",
  "concept": "Urutan",
  "brief": "Tugas singkat untuk pemain.",
  "memorySize": 0,
  "initialMemory": [],
  "availableBlocks": ["AMBIL", "TARUH"],
  "runLimit": 60,
  "sizeTarget": 6,
  "speedTarget": 6,
  "tests": [
    { "inbox": [11, 22, 33], "expected": [11, 22, 33] }
  ]
}
```

- `tests` berisi beberapa set data uji; level lulus hanya jika **semua** tes cocok.
- `sizeTarget` = jumlah blok solusi referensi; `speedTarget` = langkah maksimum solusi referensi.
- `initialMemory` adalah tambahan dari kerangka ini: isi awal kotak memori (dipakai level 9-10 sebagai konstanta 1).

## Keputusan semantik (sementara)

- **Inbox habis = program selesai.** `AMBIL` saat inbox kosong mengakhiri program secara normal, sehingga perulangan tanpa syarat "kosong" tetap bisa berhenti.
- **Satu nilai di tangan.** `AMBIL` menimpa nilai lama di tangan (nilai lama dibuang), sehingga penyaringan nol/negatif tidak butuh blok buang tambahan. `TARUH`/`SIMPAN`/`TAMBAH`/`KURANG` saat tangan kosong dianggap error dan menghentikan program.
- **SIMPAN menyalin** nilai tangan ke memori (tangan tetap memegang nilai); `MUAT` menyalin memori ke tangan.
- **Label berupa angka 0..9.** `LABEL 0`, `LONCAT 0`, `LONCAT JIKA NOL 0`, `LONCAT JIKA NEGATIF 0`.
- **Memori** diinisialisasi 0, kecuali diisi lewat `initialMemory`.
- **Batas langkah** (`runLimit`) mencegah perulangan tak berujung membekukan game.
- Bintang: 1 = lulus, 2 = Size terpenuhi, 3 = Speed terpenuhi.

## Belum dikerjakan

- Seret-dan-lepas penuh (sekarang klik untuk menambah; sesuai mitigasi risiko PRD).
- Sprite pixel 16x16, font pixel, animasi karakter.
- F9 hint bertahap dan F10 audio.
- Layar "menang" terpisah dan transisi.
- Uji pemain dan penyetelan target Size/Speed.

## Verifikasi

Kerangka sudah dikompilasi dengan `javac` memakai `core.jar` Processing 4.5.7, dan solusi referensi level 1-10 diuji headless terhadap semua data uji: **semua lulus**, dengan jumlah blok dan langkah maksimum sesuai `sizeTarget`/`speedTarget`.

Contoh program referensi ada di `docs/solusi-referensi.md` (untuk pengujian, bukan petunjuk pemain).
