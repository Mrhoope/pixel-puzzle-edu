# Solusi referensi level 1-10

Dipakai untuk menguji interpreter dan menetapkan target Size/Speed. Bukan untuk ditampilkan ke pemain.

Format tiap baris adalah satu blok program. Argumen memori/label mengikuti nomor kotak.

## Level 1 - Antar Paket (6 blok, 6 langkah)

```
AMBIL
TARUH
AMBIL
TARUH
AMBIL
TARUH
```

## Level 2 - Antrean Panjang (16 blok, 16 langkah)

`AMBIL` / `TARUH` diulang 8 kali.

## Level 3 - Tukar Tempat (6 blok, 6 langkah)

```
AMBIL
SIMPAN 0
AMBIL
TARUH
MUAT 0
TARUH
```

## Level 4 - Hitung Cepat (5 blok, 5 langkah)

```
AMBIL
SIMPAN 0
AMBIL
TAMBAH 0
TARUH
```

## Level 5 - Putar Terus (6 blok, 20 langkah)

```
LABEL 0
AMBIL
SIMPAN 0
TAMBAH 0
TARUH
LONCAT 0
```

## Level 6 - Total Berjalan (8 blok, 26 langkah)

```
LABEL 0
AMBIL
SIMPAN 1
MUAT 0
TAMBAH 1
SIMPAN 0
TARUH
LONCAT 0
```

## Level 7 - Saringan (7 blok, 22 langkah)

```
LABEL 0
AMBIL
LONCAT JIKA NOL 1
TARUH
LONCAT 0
LABEL 1
LONCAT 0
```

## Level 8 - Hanya Positif (8 blok, 25 langkah)

```
LABEL 0
AMBIL
LONCAT JIKA NOL 1
LONCAT JIKA NEGATIF 1
TARUH
LONCAT 0
LABEL 1
LONCAT 0
```

## Level 9 - Hitung Mundur (13 blok, 66 langkah)

Memori 2 berisi konstanta 1 dari `initialMemory`.

```
LABEL 0
AMBIL
SIMPAN 1
LABEL 1
MUAT 1
LONCAT JIKA NOL 2
TARUH
MUAT 1
KURANG 2
SIMPAN 1
LONCAT 1
LABEL 2
LONCAT 0
```

## Level 10 - Mesin Pengali (17 blok, 80 langkah)

Memori 3 berisi konstanta 1 dari `initialMemory`; memori 0 = A, 1 = B, 2 = hasil.

```
AMBIL
SIMPAN 0
AMBIL
SIMPAN 1
LABEL 0
MUAT 1
LONCAT JIKA NOL 1
MUAT 2
TAMBAH 0
SIMPAN 2
MUAT 1
KURANG 3
SIMPAN 1
LONCAT 0
LABEL 1
MUAT 2
TARUH
```
