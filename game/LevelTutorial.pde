// Data dan sesi tutorial khusus tiap level.

static class TutorialLevel {
  int id;
  String concept;
  String task;
  String[] guide;
  String[] tips;
  String[] seq;
  int[] inbox;

  TutorialLevel(int id, String concept, String task, String[] guide, String[] tips, String[] seq, int[] inbox) {
    this.id = id;
    this.concept = concept;
    this.task = task;
    this.guide = guide;
    this.tips = tips;
    this.seq = seq;
    this.inbox = inbox;
  }

  static TutorialLevel dataFor(int id) {
    if (id == 1) {
      return new TutorialLevel(1, "Urutan", "Ambil angka 7, lalu taruh ke OUTBOX.",
        new String[] {"AMBIL mengambil satu angka dari INBOX ke TANGAN.", "TARUH memindahkan angka di TANGAN ke OUTBOX.", "Ulangi sampai INBOX kosong."},
        new String[] {"Urutan OUTBOX harus sama dengan INBOX.", "TANGAN hanya memegang satu angka.", "AMBIL berikutnya menimpa angka lama di TANGAN."},
        new String[] {"AMBIL", "TARUH"}, new int[] {7, 7});
    }
    if (id == 2) {
      return new TutorialLevel(2, "Repetisi manual", "Lengkapi dua pasang AMBIL - TARUH.",
        new String[] {"Program dibaca dari baris 1 ke bawah.", "Untuk delapan angka, tulis AMBIL dan TARUH delapan kali.", "Belum ada LABEL atau LONCAT di level ini."},
        new String[] {"Satu pasang AMBIL + TARUH memindahkan satu angka.", "Hitung jumlah pasangan sebelum menekan JALANKAN.", "Level ini melatih ketelitian menyusun urutan."},
        new String[] {"AMBIL", "TARUH", "AMBIL", "TARUH"}, new int[] {1, 2, 3, 4});
    }
    if (id == 3) {
      return new TutorialLevel(3, "Variabel", "Tukar pasangan (A, B) menjadi (B, A).",
        new String[] {"SIMPAN 0 menyalin angka TANGAN ke memori 0.", "TANGAN tetap berisi angka setelah SIMPAN.", "MUAT 0 menyalin isi memori 0 kembali ke TANGAN."},
        new String[] {"Simpan A, ambil B, taruh B, muat A, taruh A.", "Angka 0 adalah nomor kotak memori.", "SIMPAN menyalin, bukan memindahkan."},
        new String[] {"AMBIL", "SIMPAN 0", "AMBIL", "TARUH", "MUAT 0", "TARUH"}, new int[] {1, 2});
    }
    if (id == 4) {
      return new TutorialLevel(4, "Aritmetika", "Jumlahkan dua angka, lalu keluarkan hasilnya.",
        new String[] {"TAMBAH 0 menambah isi memori 0 ke angka di TANGAN.", "KURANG 0 mengurangi angka di TANGAN dengan memori 0.", "Hasil perhitungan selalu ada di TANGAN."},
        new String[] {"Simpan angka pertama sebelum mengambil angka kedua.", "TAMBAH tidak mengubah isi memori.", "Perhatikan tanda angka negatif."},
        new String[] {"AMBIL", "SIMPAN 0", "AMBIL", "TAMBAH 0", "TARUH"}, new int[] {3, 4});
    }
    if (id == 5) {
      return new TutorialLevel(5, "Perulangan", "Gandakan tiap angka dengan perulangan.",
        new String[] {"LABEL 0 memberi nama pada sebuah baris.", "LONCAT 0 kembali ke baris LABEL 0.", "Perulangan berhenti saat AMBIL menemukan INBOX kosong."},
        new String[] {"SIMPAN angka ke memori, lalu TAMBAH dengan dirinya sendiri.", "LONCAT 0 harus memiliki LABEL 0.", "LONCAT membuat program berulang tanpa menulis ulang blok."},
        new String[] {"LABEL 0", "AMBIL", "SIMPAN 0", "TAMBAH 0", "TARUH", "LONCAT 0"}, new int[] {2, 3, 4});
    }
    if (id == 6) {
      return new TutorialLevel(6, "Akumulator", "Keluarkan jumlah berjalan tiap angka.",
        new String[] {"Akumulator adalah memori yang menyimpan total berjalan.", "Memori 0 menyimpan total, memori 1 menyimpan angka baru.", "Setiap langkah: total = total + angka baru."},
        new String[] {"MUAT 0 untuk mengambil total lama.", "TAMBAH 1 menambah angka baru.", "SIMPAN 0 menyimpan total yang sudah diperbarui."},
        new String[] {"LABEL 0", "AMBIL", "SIMPAN 1", "MUAT 0", "TAMBAH 1", "SIMPAN 0", "TARUH", "LONCAT 0"}, new int[] {1, 2, 3});
    }
    if (id == 7) {
      return new TutorialLevel(7, "Kondisi", "Lewati angka 0, keluarkan sisanya.",
        new String[] {"LONCAT JIKA NOL 1 lompat ke LABEL 1 jika TANGAN berisi 0.", "Jika bukan nol, program lanjut ke TARUH.", "Label tujuan harus ada di program."},
        new String[] {"LONCAT JIKA NOL bisa melewati blok TARUH.", "LONCAT 0 lalu mengulang untuk angka berikutnya.", "Cek kondisi dilakukan sebelum memutuskan."},
        new String[] {"LABEL 0", "AMBIL", "LONCAT JIKA NOL 1", "TARUH", "LONCAT 0", "LABEL 1", "LONCAT 0"}, new int[] {0, 5, 0, 3});
    }
    if (id == 8) {
      return new TutorialLevel(8, "Kondisi ganda", "Keluarkan hanya angka positif.",
        new String[] {"LONCAT JIKA NEGATIF 1 lompat jika TANGAN kurang dari 0.", "Gabungkan dengan LONCAT JIKA NOL untuk membuang nol dan negatif.", "Hanya angka positif yang sampai ke TARUH."},
        new String[] {"Cek nol dulu, lalu cek negatif.", "Kedua cabang menuju LABEL 1 yang berisi LONCAT 0.", "Urutan pengecekan tidak mengubah hasil."},
        new String[] {"LABEL 0", "AMBIL", "LONCAT JIKA NOL 1", "LONCAT JIKA NEGATIF 1", "TARUH", "LONCAT 0", "LABEL 1", "LONCAT 0"}, new int[] {3, -2, 0, 5});
    }
    if (id == 9) {
      return new TutorialLevel(9, "Penghitung", "Mulai hitung mundur dari N.",
        new String[] {"Memori 2 berisi konstanta 1 sejak awal.", "Untuk N, keluarkan N, N-1, ... sampai 1.", "Simpan N di memori 1 sebagai penghitung."},
        new String[] {"LONCAT JIKA NOL 2 berhenti saat penghitung mencapai 0.", "KURANG 2 mengurangi penghitung dengan angka 1.", "LABEL 1 menandai awal perulangan dalam."},
        new String[] {"AMBIL", "SIMPAN 1", "LABEL 1", "MUAT 1", "LONCAT JIKA NOL 2", "TARUH", "MUAT 1", "KURANG 2"}, new int[] {3, 1});
    }
    return new TutorialLevel(10, "Gabungan", "Siapkan A, B, dan awal perulangan.",
      new String[] {"Kalikan A dan B dengan penjumlahan berulang.", "Memori 0 = A, memori 1 = B, memori 2 = hasil.", "Memori 3 berisi konstanta 1."},
      new String[] {"Tambahkan A ke hasil, kurangi B dengan 1, ulangi sampai B = 0.", "Keluarkan hasil dari memori 2 setelah perulangan.", "Semua konsep sebelumnya dipakai di sini."},
      new String[] {"AMBIL", "SIMPAN 0", "AMBIL", "SIMPAN 1", "LABEL 0", "MUAT 1", "LONCAT JIKA NOL 1", "MUAT 2"}, new int[] {3, 4});
  }
}

class TutorialSession {
  TutorialLevel data;
  Level level;
  int page = 0;
  int progress = 0;
  boolean solved = false;
  String feedback = "";
  Integer hand = null;
  int[] mem = new int[4];
  int inboxIndex = 0;
  ArrayList<Integer> outbox = new ArrayList<Integer>();
  String[] options = new String[4];

  TutorialSession(TutorialLevel data, Level level) {
    this.data = data;
    this.level = level;
    buildOptions();
  }

  void apply(String op) {
    String[] parts = op.split(" ");
    String name = parts[0];
    int arg = 0;
    if (parts.length > 1) {
      try {
        arg = Integer.parseInt(parts[parts.length - 1]);
      } catch (Exception e) {
        arg = 0;
      }
    }
    boolean valid = arg >= 0 && arg < mem.length;
    if (name.equals("AMBIL")) {
      if (inboxIndex < data.inbox.length) hand = Integer.valueOf(data.inbox[inboxIndex++]);
    } else if (name.equals("TARUH")) {
      if (hand != null) {
        outbox.add(hand);
        hand = null;
      }
    } else if (name.equals("SIMPAN")) {
      if (valid && hand != null) mem[arg] = hand.intValue();
    } else if (name.equals("MUAT")) {
      if (valid) hand = Integer.valueOf(mem[arg]);
    } else if (name.equals("TAMBAH")) {
      if (valid && hand != null) hand = Integer.valueOf(hand.intValue() + mem[arg]);
    } else if (name.equals("KURANG")) {
      if (valid && hand != null) hand = Integer.valueOf(hand.intValue() - mem[arg]);
    }
  }

  void click(String op) {
    if (solved || op == null) return;
    String want = data.seq[progress];
    if (!op.equals(want)) {
      feedback = "Belum tepat. Coba blok " + shortOp(want) + ".";
      return;
    }
    apply(op);
    progress++;
    feedback = "Benar!";
    if (progress >= data.seq.length) {
      solved = true;
      feedback = "Mantap! Konsepnya sudah paham.";
    } else {
      buildOptions();
    }
  }

  void retry() {
    hand = null;
    mem = new int[4];
    inboxIndex = 0;
    outbox.clear();
    progress = 0;
    solved = false;
    feedback = "";
    buildOptions();
  }

  void buildOptions() {
    if (progress >= data.seq.length) return;
    String want = data.seq[progress];
    String[] pool = {"AMBIL", "TARUH", "SIMPAN 0", "MUAT 0", "TAMBAH 0", "KURANG 0",
      "LABEL 0", "LONCAT 0", "LONCAT JIKA NOL 1", "LONCAT JIKA NEGATIF 1"};
    ArrayList<String> list = new ArrayList<String>();
    list.add(want);
    int start = (progress * 3 + 1) % pool.length;
    for (int i = 0; i < pool.length && list.size() < 4; i++) {
      String cand = pool[(start + i) % pool.length];
      if (!cand.equals(want) && allowed(cand)) list.add(cand);
    }
    while (list.size() < 4) list.add("AMBIL");
    int shift = progress % list.size();
    for (int i = 0; i < 4; i++) options[i] = list.get((i + shift) % list.size());
  }

  boolean allowed(String op) {
    String name = op;
    int sp = op.lastIndexOf(' ');
    if (sp > 0) {
      try {
        Integer.parseInt(op.substring(sp + 1));
        name = op.substring(0, sp);
      } catch (Exception e) {
        name = op;
      }
    }
    for (int i = 0; i < level.blocks.size(); i++) {
      if (level.blocks.get(i).equals(name)) return true;
    }
    return false;
  }

  String shortOp(String op) {
    if (op.startsWith("LONCAT JIKA NOL")) return "L-NOL" + suffix(op, "LONCAT JIKA NOL");
    if (op.startsWith("LONCAT JIKA NEGATIF")) return "L-NEG" + suffix(op, "LONCAT JIKA NEGATIF");
    return op;
  }

  String suffix(String op, String prefix) {
    String s = op.substring(prefix.length()).trim();
    return s.length() > 0 ? " " + s : "";
  }
}
