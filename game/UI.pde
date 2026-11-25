// UI: menggambar semua layar dan menangani klik/ketikan.
// Tidak mengubah aturan permainan; semua aksi diteruskan ke GameState.

class UI {
  static final int COL_BG = 0xFF1A1C2C;
  static final int COL_BG2 = 0xFF12141F;
  static final int COL_PANEL = 0xFF2B2F45;
  static final int COL_PANEL_DARK = 0xFF202336;
  static final int COL_PANEL_HI = 0xFF3B4060;
  static final int COL_TEXT = 0xFFF4F4F4;
  static final int COL_MUTED = 0xFF8A93B2;
  static final int COL_LOCK = 0xFF5A607F;
  static final int COL_IO = 0xFF4FC3F7;
  static final int COL_MEM = 0xFF8BC34A;
  static final int COL_ARITH = 0xFFF2A65A;
  static final int COL_FLOW = 0xFFB07CFF;
  static final int COL_WARN = 0xFFFF6B81;
  static final int COL_GOLD = 0xFFFFD166;
  static final int COL_BLUE = 0xFF5C7CFA;
  static final int COL_WHITE = 0xFFFFFFFF;

  static final int K_BACKSPACE = 8;
  static final int K_ENTER = 10;
  static final int K_RETURN = 13;
  static final int K_ESC = 27;
  static final int K_SPACE = 32;
  static final int K_LEFT = 37;
  static final int K_UP = 38;
  static final int K_RIGHT = 39;
  static final int K_DOWN = 40;
  static final int K_DELETE = 127;

  PApplet p;
  PFont fTiny, fSmall, fMid, fBig;
  float mx, my;

  UI(PApplet app, PFont tiny, PFont small, PFont mid, PFont big) {
    p = app;
    fTiny = tiny;
    fSmall = small;
    fMid = mid;
    fBig = big;
  }

  void render(GameState g) {
    mx = p.mouseX / (float) GameState.SCALE;
    my = p.mouseY / (float) GameState.SCALE;
    p.noStroke();
    if (g.screen == GameState.MENU) {
      renderMenu(g);
    } else if (g.screen == GameState.LEVEL_TUTORIAL) {
      renderLevelTutorial(g);
    } else if (g.screen == GameState.SELECT) {
      renderSelect(g);
    } else if (g.screen == GameState.TUTORIAL) {
      renderTutorial(g);
    } else {
      renderPlay(g);
    }
  }

  // ---------- util gambar ----------

  void box(float x, float y, float w, float h, int c) {
    p.noStroke();
    p.fill(c);
    p.rect(x, y, w, h);
  }

  void panel(float x, float y, float w, float h, int border) {
    box(x, y, w, h, border);
    box(x + 1, y + 1, w - 2, h - 2, COL_PANEL);
    box(x + 2, y + 2, w - 4, h - 4, 0xFF22263A);
    box(x + 2, y + 2, w - 4, 2, border);
  }

  void panelDark(float x, float y, float w, float h, int border) {
    box(x, y, w, h, border);
    box(x + 1, y + 1, w - 2, h - 2, COL_PANEL_DARK);
    box(x + 2, y + 2, w - 4, h - 4, 0xFF191D2D);
    box(x + 2, y + 2, w - 4, 1, border);
  }

  void panelCard(float x, float y, float w, float h, int accent) {
    box(x, y, w, h, accent);
    box(x + 1, y + 1, w - 2, h - 2, COL_PANEL);
    box(x + 2, y + 2, w - 4, h - 4, 0xFF22263A);
    box(x + 2, y + 2, w - 4, 6, p.lerpColor(COL_PANEL, accent, 0.12f));
    box(x + 2, y + 8, w - 4, 1, accent);
  }

  void text(String s, float x, float y, int c, PFont f) {
    p.textFont(f);
    p.fill(c);
    p.textAlign(p.LEFT, p.CENTER);
    p.text(s, x, y);
  }

  void textRight(String s, float x, float y, int c, PFont f) {
    p.textFont(f);
    p.fill(c);
    p.textAlign(p.RIGHT, p.CENTER);
    p.text(s, x, y);
  }

  void textCenter(String s, float x, float y, int c, PFont f) {
    p.textFont(f);
    p.fill(c);
    p.textAlign(p.CENTER, p.CENTER);
    p.text(s, x, y);
  }

  void drawPixelText(String s, float centerX, float centerY, int c, int scale) {
    float width = 0;
    for (int i = 0; i < s.length(); i++) {
      width += (s.charAt(i) == ' ' ? 4 : 6) * scale;
    }
    if (s.length() > 0) width -= scale;

    float x = centerX - width / 2;
    float y = centerY - 7 * scale / 2;
    for (int i = 0; i < s.length(); i++) {
      char letter = s.charAt(i);
      int[] rows = pixelGlyph(letter);
      for (int row = 0; row < rows.length; row++) {
        for (int col = 0; col < 5; col++) {
          if ((rows[row] & (1 << (4 - col))) != 0) {
            box(x + col * scale, y + row * scale, scale, scale, c);
          }
        }
      }
      x += (letter == ' ' ? 4 : 6) * scale;
    }
  }

  int[] pixelGlyph(char letter) {
    switch (letter) {
    case 'A': return new int[] {14, 17, 17, 31, 17, 17, 17};
    case 'D': return new int[] {30, 17, 17, 17, 17, 17, 30};
    case 'E': return new int[] {31, 16, 16, 30, 16, 16, 31};
    case 'G': return new int[] {14, 17, 16, 23, 17, 17, 15};
    case 'I': return new int[] {31, 4, 4, 4, 4, 4, 31};
    case 'K': return new int[] {17, 18, 20, 24, 20, 18, 17};
    case 'L': return new int[] {16, 16, 16, 16, 16, 16, 31};
    case 'M': return new int[] {17, 27, 21, 21, 17, 17, 17};
    case 'O': return new int[] {14, 17, 17, 17, 17, 17, 14};
    case 'P': return new int[] {30, 17, 17, 30, 16, 16, 16};
    case 'R': return new int[] {30, 17, 17, 30, 20, 18, 17};
    case 'S': return new int[] {15, 16, 16, 14, 1, 1, 30};
    case 'T': return new int[] {31, 4, 4, 4, 4, 4, 4};
    case 'U': return new int[] {17, 17, 17, 17, 17, 17, 14};
    case 'X': return new int[] {17, 17, 10, 4, 10, 17, 17};
    case 'Z': return new int[] {31, 1, 2, 4, 8, 16, 31};
    default: return new int[] {0, 0, 0, 0, 0, 0, 0};
    }
  }

  void button(float x, float y, float w, float h, String s, int base) {
    boolean hover = mx >= x && mx < x + w && my >= y && my < y + h;
    int edge = hover ? COL_GOLD : COL_LOCK;
    int face = hover ? p.lerpColor(base, COL_WHITE, 0.1f) : base;
    box(x, y, w, h, edge);
    box(x + 1, y + 1, w - 2, h - 2, face);
    box(x + 1, y + 1, w - 2, 1, p.lerpColor(face, COL_WHITE, 0.2f));
    box(x + 1, y + h - 2, w - 2, 1, COL_BG2);
    if (hover && w > 16) box(x + 1, y + 2, 2, h - 4, COL_GOLD);
    textCenter(s, x + w / 2, y + h / 2, COL_TEXT, fTiny);
  }

  boolean hit(float x, float y, float rx, float ry, float rw, float rh) {
    return x >= rx && x < rx + rw && y >= ry && y < ry + rh;
  }

  void backButton() {
    button(2, 2, 12, 10, "<", COL_PANEL_HI);
  }

  // ---------- menu ----------

  void renderMenu(GameState g) {
    box(0, 0, 320, 180, COL_BG);
    box(0, 0, 320, 3, COL_BLUE);
    box(0, 177, 320, 3, COL_FLOW);

    int elapsed = p.millis();
    for (int i = 0; i < 24; i++) {
      int c = (i % 3 == 0) ? COL_BLUE : (i % 3 == 1 ? COL_FLOW : COL_IO);
      float speed = 0.025f + (i % 4) * 0.008f;
      float y = 18 + (i * 29 + elapsed * speed) % 140;
      float x = 8 + (i * 47) % 304;
      box(x, y, 2, 2, c);
      if (i % 3 == 0) box(312 - x, 176 - y, 2, 2, COL_PANEL_HI);
    }

    drawPixelText("PIXEL PUZZLE", 160, 38, COL_GOLD, 2);
    drawPixelText("EDUKASI ALGORITMIK", 160, 54, COL_IO, 1);
    box(136, 62, 48, 1, COL_BLUE);

    button(96, 70, 128, 16, "MULAI", COL_BLUE);
    button(96, 90, 128, 16, "TUTORIAL", COL_FLOW);
    button(96, 110, 128, 16, "PILIH LEVEL", COL_PANEL_HI);
    button(96, 130, 128, 16, "KELUAR", COL_PANEL_HI);

    text("10 level - satu konsep baru per level", 8, 164, COL_MUTED, fTiny);
    textRight("kerangka v0.1", 312, 174, COL_MUTED, fTiny);
  }

  // ---------- tutorial ----------

  void renderTutorial(GameState g) {
    box(0, 0, 320, 180, COL_BG);
    box(0, 0, 320, 3, COL_BLUE);
    box(0, 177, 320, 3, COL_FLOW);

    box(0, 0, 320, 14, COL_PANEL);
    backButton();
    text("TUTORIAL", 20, 7, COL_TEXT, fSmall);
    textRight((g.tutorialPage + 1) + "/" + GameState.TUTORIAL_PAGES, 312, 7, COL_MUTED, fTiny);

    panel(6, 18, 308, 122, COL_FLOW);
    if (g.tutorialPage == 0) {
      drawTutorialIntro();
    } else if (g.tutorialPage == 1) {
      drawTutorialAmbil();
    } else if (g.tutorialPage == 2) {
      drawTutorialTaruh();
    } else if (g.tutorialPage == 3) {
      drawTutorialMemory();
    } else if (g.tutorialPage == 4) {
      drawTutorialMath();
    } else if (g.tutorialPage == 5) {
      drawTutorialJump();
    } else if (g.tutorialPage == 6) {
      drawTutorialZeroJump();
    } else if (g.tutorialPage == 7) {
      drawTutorialNegativeJump();
    } else if (g.tutorialPage == 8) {
      drawTutorialRun();
    } else if (g.tutorialPage == 9) {
      drawTutorialEdit();
    } else {
      drawTutorialControls();
    }

    button(6, 146, 54, 18, "< KEMBALI", COL_PANEL_HI);
    button(112, 146, 64, 18, "LEWATI", COL_PANEL_HI);
    String next = (g.tutorialPage == GameState.TUTORIAL_PAGES - 1) ? "COBA LEVEL 1" : "LANJUT >";
    button(220, 146, 94, 18, next, COL_BLUE);

    for (int i = 0; i < GameState.TUTORIAL_PAGES; i++) {
      int c = (i == g.tutorialPage) ? COL_GOLD : (i < g.tutorialPage ? COL_IO : COL_LOCK);
      box(148 + i * 8, 169, 5, 3, c);
    }
  }

  void demoBox(float x, float y, float w, float h, String label, int c) {
    panelDark(x, y, w, h, c);
    text(label, x + 3, y + 5, c, fTiny);
  }

  void demoItems(int[] vals, float x, float y, int highlight) {
    for (int i = 0; i < vals.length; i++) {
      float ix = x + i * 14;
      int c = (i == highlight) ? COL_GOLD : COL_IO;
      box(ix, y, 12, 12, c);
      textCenter(Integer.toString(vals[i]), ix + 6, y + 6, COL_BG2, fTiny);
    }
  }

  void drawTutorialIntro() {
    text("TUJUAN", 12, 27, COL_GOLD, fSmall);
    text("Pindahkan semua angka dari INBOX ke OUTBOX.", 12, 38, COL_TEXT, fTiny);

    demoBox(10, 52, 92, 46, "INBOX", COL_IO);
    demoItems(new int[] {1, 2, 3}, 18, 68, -1);
    demoBox(218, 52, 92, 46, "OUTBOX", COL_MEM);
    textCenter("kosong", 264, 76, COL_MUTED, fTiny);

    drawRobot(150, 60);
    textCenter(">", 112, 72, COL_GOLD, fBig);
    textCenter(">", 200, 72, COL_GOLD, fBig);

    text("INBOX = kotak masuk.  OUTBOX = kotak keluar.", 12, 108, COL_MUTED, fTiny);
    text("Urutan angka harus tetap sama.", 12, 118, COL_MUTED, fTiny);
  }

  void drawTutorialAmbil() {
    text("LANGKAH 1: AMBIL", 12, 27, COL_GOLD, fSmall);
    text("Ambil 1 angka dari INBOX ke TANGAN.", 12, 38, COL_TEXT, fTiny);

    demoBox(10, 52, 88, 46, "INBOX", COL_IO);
    demoItems(new int[] {1, 2, 3}, 18, 68, 0);
    drawRobot(112, 60);
    text("AMBIL >", 136, 67, COL_GOLD, fSmall);
    demoBox(220, 52, 90, 46, "TANGAN", COL_GOLD);
    textCenter("1", 265, 78, COL_TEXT, fMid);

    text("Tangan menyimpan 1 angka sementara.", 12, 108, COL_MUTED, fTiny);
    text("Angka emas = yang diambil berikutnya.", 12, 118, COL_MUTED, fTiny);
  }

  void drawTutorialTaruh() {
    text("LANGKAH 2: TARUH", 12, 27, COL_GOLD, fSmall);
    text("Pindahkan angka dari TANGAN ke OUTBOX.", 12, 38, COL_TEXT, fTiny);

    demoBox(10, 52, 88, 46, "TANGAN", COL_GOLD);
    textCenter("1", 54, 78, COL_TEXT, fMid);
    drawRobot(112, 60);
    text("TARUH >", 136, 67, COL_MEM, fSmall);
    demoBox(220, 52, 90, 46, "OUTBOX", COL_MEM);
    demoItems(new int[] {1}, 230, 68, -1);

    text("Setelah TARUH, tangan kosong.", 12, 108, COL_MUTED, fTiny);
    text("Lalu ulangi untuk angka berikutnya.", 12, 118, COL_MUTED, fTiny);
  }

  void drawTutorialMemory() {
    text("SIMPAN & MUAT: GUNAKAN MEMORI", 12, 27, COL_GOLD, fSmall);
    text("Memori adalah kotak untuk menyimpan angka sementara.", 12, 38, COL_TEXT, fTiny);

    demoBox(16, 54, 74, 42, "TANGAN", COL_GOLD);
    textCenter("5", 53, 78, COL_TEXT, fMid);
    textCenter("SIMPAN 0 >", 150, 68, COL_BLUE, fTiny);
    demoBox(228, 54, 74, 42, "MEM 0", COL_MEM);
    textCenter("5", 265, 78, COL_TEXT, fMid);

    text("SIMPAN 0 menyalin angka tangan ke memori 0.", 12, 108, COL_MUTED, fTiny);
    text("MUAT 0 menyalin isi memori 0 kembali ke tangan.", 12, 120, COL_MUTED, fTiny);
    text("SIMPAN tidak mengosongkan tangan.", 12, 132, COL_GOLD, fTiny);
  }

  void drawTutorialMath() {
    text("TAMBAH & KURANG: HITUNG ANGKA", 12, 27, COL_GOLD, fSmall);
    text("Operasi memakai angka di tangan dan memori yang dipilih.", 12, 38, COL_TEXT, fTiny);

    demoBox(16, 54, 78, 42, "TANGAN", COL_GOLD);
    textCenter("7", 55, 78, COL_TEXT, fMid);
    demoBox(226, 54, 78, 42, "MEM 0", COL_MEM);
    textCenter("3", 265, 78, COL_TEXT, fMid);

    text("TAMBAH 0: 7 + 3 = 10", 44, 108, COL_IO, fSmall);
    text("KURANG 0: 7 - 3 = 4", 44, 122, COL_ARITH, fSmall);
    text("Hasilnya disimpan di tangan.", 44, 135, COL_MUTED, fTiny);
  }

  void drawTutorialJump() {
    text("LABEL & LONCAT: ULANGI BLOK", 12, 27, COL_GOLD, fSmall);
    text("LABEL memberi nomor pada baris program.", 12, 38, COL_TEXT, fTiny);

    panel(12, 50, 124, 76, COL_FLOW);
    text("1  LABEL 0", 20, 62, COL_GOLD, fTiny);
    text("2  AMBIL", 20, 76, COL_TEXT, fTiny);
    text("3  TARUH", 20, 90, COL_TEXT, fTiny);
    text("4  LONCAT 0", 20, 104, COL_BLUE, fTiny);

    text("LONCAT 0 kembali ke LABEL 0.", 150, 59, COL_TEXT, fTiny);
    text("Blok di antaranya diulang.", 150, 72, COL_TEXT, fTiny);
    text("Angka 0 adalah nomor tujuan,", 150, 92, COL_MUTED, fTiny);
    text("bukan angka di tangan.", 150, 104, COL_MUTED, fTiny);
    text("LABEL tujuan harus ada.", 150, 121, COL_GOLD, fTiny);
  }

  void drawTutorialZeroJump() {
    text("L-NOL: LONCAT JIKA NOL", 12, 27, COL_GOLD, fSmall);
    text("Periksa angka yang sedang di tangan.", 12, 38, COL_TEXT, fTiny);

    demoBox(18, 54, 90, 42, "TANGAN", COL_GOLD);
    textCenter("0", 63, 78, COL_TEXT, fMid);
    text("L-NOL 1", 142, 69, COL_BLUE, fSmall);
    text("Jika 0: lompat ke LABEL 1.", 142, 84, COL_TEXT, fTiny);
    text("Jika bukan 0: lanjut ke blok berikutnya.", 28, 112, COL_MUTED, fTiny);
    text("Nomor LABEL 1 harus ada di program.", 28, 126, COL_GOLD, fTiny);
  }

  void drawTutorialNegativeJump() {
    text("L-NEG: LONCAT JIKA NEGATIF", 12, 27, COL_GOLD, fSmall);
    text("Angka negatif adalah angka di bawah 0, misalnya -3.", 12, 38, COL_TEXT, fTiny);

    demoBox(18, 54, 90, 42, "TANGAN", COL_GOLD);
    textCenter("-3", 63, 78, COL_TEXT, fMid);
    text("L-NEG 1", 142, 69, COL_BLUE, fSmall);
    text("Jika negatif: lompat ke LABEL 1.", 142, 84, COL_TEXT, fTiny);
    text("Jika 0 atau positif: lanjut ke blok berikutnya.", 28, 112, COL_MUTED, fTiny);
    text("Nomor LABEL 1 harus ada di program.", 28, 126, COL_GOLD, fTiny);
  }

  void drawTutorialRun() {
    text("LANGKAH 3: SUSUN PROGRAM", 12, 27, COL_GOLD, fSmall);
    text("Klik blok di palet bawah untuk menambah.", 12, 38, COL_TEXT, fTiny);

    panel(10, 50, 132, 84, COL_FLOW);
    text("PROGRAM", 14, 56, COL_TEXT, fTiny);
    box(14, 66, 124, 16, COL_IO);
    text("1  AMBIL", 18, 74, COL_BG2, fTiny);
    box(14, 84, 124, 16, COL_IO);
    text("2  TARUH", 18, 92, COL_BG2, fTiny);
    text("Dari atas ke bawah.", 14, 108, COL_MUTED, fTiny);

    text("CONTOH", 150, 56, COL_MUTED, fTiny);
    text("Urutan program dibaca", 150, 68, COL_TEXT, fTiny);
    text("dari blok nomor 1 ke bawah.", 150, 79, COL_TEXT, fTiny);
    text("Program tidak berjalan", 150, 96, COL_MUTED, fTiny);
    text("hanya dengan menyusunnya.", 150, 107, COL_MUTED, fTiny);
    text("Gunakan tombol eksekusi", 150, 122, COL_GOLD, fTiny);
    text("pada halaman berikutnya.", 150, 132, COL_GOLD, fTiny);
  }

  void drawTutorialEdit() {
    text("EDIT PROGRAM", 12, 27, COL_GOLD, fSmall);
    text("Klik blok untuk memilihnya.", 12, 38, COL_TEXT, fTiny);

    panel(10, 50, 300, 78, COL_FLOW);
    text("KLIK SEKALI", 18, 62, COL_BLUE, fTiny);
    text("Pilih blok. Klik dua kali untuk mengubah angka argumen.", 18, 73, COL_TEXT, fTiny);

    text("PANAH ATAS / BAWAH", 18, 88, COL_BLUE, fTiny);
    text("Geser urutan blok yang dipilih.", 18, 99, COL_TEXT, fTiny);

    text("KLIK KANAN / DELETE", 18, 114, COL_WARN, fTiny);
    text("Hapus blok.", 148, 114, COL_TEXT, fTiny);

    text("Argumen tersedia: memori 0..ukuran-1, label dan lompat 0..9.", 12, 133, COL_MUTED, fTiny);
  }

  void drawTutorialControls() {
    text("TOMBOL DI LAYAR PERMAINAN", 12, 27, COL_GOLD, fSmall);

    panel(10, 44, 300, 90, COL_FLOW);
    box(16, 52, 52, 12, COL_BLUE);
    textCenter("JALANKAN", 42, 58, COL_TEXT, fTiny);
    text("Mulai atau lanjutkan program.", 74, 58, COL_TEXT, fTiny);

    box(16, 70, 52, 12, COL_PANEL_HI);
    textCenter("JEDA", 42, 76, COL_TEXT, fTiny);
    text("Hentikan sementara eksekusi.", 74, 76, COL_TEXT, fTiny);

    box(16, 88, 52, 12, COL_PANEL_HI);
    textCenter("LANGKAH", 42, 94, COL_TEXT, fTiny);
    text("Jalankan satu blok saja.", 74, 94, COL_TEXT, fTiny);

    box(16, 106, 52, 12, COL_PANEL_HI);
    textCenter("RESET", 42, 112, COL_TEXT, fTiny);
    text("Kembalikan program ke awal.", 74, 112, COL_TEXT, fTiny);

    box(16, 124, 52, 10, COL_PANEL_HI);
    textCenter("NORMAL", 42, 129, COL_TEXT, fTiny);
    text("NORMAL 1x / CEPAT 4x mengubah kecepatan.", 74, 129, COL_TEXT, fTiny);

    text("Enter = Jalan, Spasi = Langkah, Esc = pilih level.", 12, 138, COL_MUTED, fTiny);
  }

  void renderLevelTutorial(GameState g) {
    if (g.tutorialLevelIdx < 0 || g.tutorialLevelIdx >= g.levelCount) return;
    TutorialSession s = g.tutorialSession;
    if (s == null) return;

    Level lv = g.levels[g.tutorialLevelIdx];
    drawPlayBackground();
    box(0, 0, 320, 14, COL_PANEL);
    backButton();
    text("TUTORIAL LEVEL " + lv.id, 20, 7, COL_GOLD, fSmall);
    textRight((s.page + 1) + "/3", 312, 7, COL_TEXT, fTiny);

    if (s.page < 2) {
      String[] lines = s.page == 0 ? s.data.guide : s.data.tips;
      String heading = s.page == 0 ? "KENALAN DENGAN KONSEP" : "TIPS SEBELUM BERMAIN";
      panel(6, 18, 308, 134, COL_FLOW);
      text(heading, 14, 26, COL_GOLD, fSmall);
      text(s.data.concept + ": " + s.data.task, 14, 36, COL_TEXT, fTiny);
      demoBox(12, 48, 84, 40, "INBOX", COL_IO);
      demoItems(new int[] {1, 2, 3}, 20, 62, -1);
      drawRobot(116, 52);
      demoBox(214, 48, 88, 40, "OUTBOX", COL_MEM);
      textCenter("kosong", 258, 70, COL_MUTED, fTiny);
      for (int i = 0; i < lines.length && i < 4; i++) {
        text("- " + lines[i], 14, 101 + i * 10, COL_TEXT, fTiny);
      }
    } else {
      panel(6, 18, 308, 134, COL_FLOW);
      text("LATIHAN INTERAKTIF", 14, 26, COL_GOLD, fSmall);
      text(s.data.task, 14, 35, COL_TEXT, fTiny);
      for (int i = 0; i < s.data.seq.length && i < 8; i++) {
        int col = i % 2;
        int row = i / 2;
        float x = 14 + col * 146;
        float y = 44 + row * 14;
        boolean done = i < s.progress;
        boolean current = i == s.progress && !s.solved;
        box(x, y, 140, 12, done ? 0xFF2E5A34 : (current ? 0xFF5A4A1E : COL_PANEL_DARK));
        box(x, y, 2, 12, done ? COL_MEM : (current ? COL_GOLD : COL_LOCK));
        text((i + 1) + ". " + s.shortOp(s.data.seq[i]), x + 5, y + 6,
          done ? COL_MEM : (current ? COL_GOLD : COL_MUTED), fTiny);
      }
      panelDark(14, 104, 292, 18, COL_PANEL_HI);
      text("INBOX: " + s.inboxIndex + "/" + s.data.inbox.length, 18, 113, COL_IO, fTiny);
      text("TANGAN: " + (s.hand == null ? "-" : s.hand.toString()), 100, 113, COL_GOLD, fTiny);
      text("OUTBOX: " + s.outbox.size(), 220, 113, COL_MEM, fTiny);
      for (int i = 0; i < 4; i++) {
        float x = 4 + i * 79;
        button(x, 124, 75, 18, s.shortOp(s.options[i]), COL_FLOW);
      }
      int feedbackColor = s.solved ? COL_MEM : (s.feedback.startsWith("Benar") ? COL_IO : COL_WARN);
      text(s.feedback, 14, 148, feedbackColor, fTiny);
    }

    button(6, 158, 54, 16, s.page == 2 ? "< ULANGI" : "< KEMBALI", COL_PANEL_HI);
    button(112, 158, 64, 16, "LEWATI", COL_PANEL_HI);
    String next = s.page == 2 ? (s.solved ? "MULAI LEVEL" : "SELESAI DULU")
      : (s.page == 1 ? "COBA >" : "LANJUT >");
    button(220, 158, 94, 16, next, s.solved ? COL_MEM : COL_BLUE);
  }

  // ---------- pilih level ----------

  void renderSelect(GameState g) {
    box(0, 0, 320, 180, COL_BG);
    drawSelectBackground();
    box(0, 0, 320, 14, COL_PANEL);
    backButton();
    text("PILIH LEVEL", 20, 7, COL_TEXT, fSmall);
    textRight("BINTANG " + totalStars(g) + "/" + (g.levelCount * 3), 312, 7, COL_GOLD, fTiny);

    for (int i = 0; i < g.levelCount; i++) {
      drawLevelCard(g, i);
    }

    int openLevels = Math.min(g.unlocked, g.levelCount);
    text("LEVEL TERBUKA " + openLevels + "/" + g.levelCount, 12, 21, COL_TEXT, fTiny);
    box(12, 27, 296, 3, COL_PANEL_DARK);
    if (g.levelCount > 0) {
      float progressWidth = 296 * (openLevels / (float) g.levelCount);
      box(12, 27, progressWidth, 3, COL_BLUE);
      box(12, 27, progressWidth, 1, COL_IO);
    }

    text("Pilih kartu bertanda SIAP atau SELESAI untuk bermain.", 12, 164, COL_MUTED, fTiny);
  }

  void drawSelectBackground() {
    for (int y = 16; y < 180; y += 16) {
      box(0, y, 320, 1, 0x182B2F45);
    }
    for (int x = 16; x < 320; x += 16) {
      box(x, 16, 1, 164, 0x102B2F45);
    }
    for (int row = 0; row < 10; row++) {
      for (int col = 0; col < 20; col++) {
        if ((row * 5 + col * 7) % 19 == 0) {
          box(5 + col * 16, 19 + row * 16, 2, 2, 0x303B4060);
        }
      }
    }
  }

  void drawLevelCard(GameState g, int index) {
    Level lv = g.levels[index];
    float x = levelCardX(index);
    float y = levelCardY(index);
    boolean locked = index + 1 > g.unlocked;
    boolean complete = g.stars[lv.id] > 0;
    boolean hover = !locked && hit(mx, my, x, y, 56, 52);

    int accent = locked ? COL_LOCK : (complete ? COL_GOLD : levelAccent(lv));
    if (hover) accent = p.lerpColor(accent, COL_WHITE, 0.18f);
    int face = locked ? 0xFF1D2132 : (hover ? 0xFF2E344C : 0xFF24293C);

    box(x + 1, y + 2, 56, 52, 0x50202A45);
    box(x, y, 56, 52, accent);
    box(x + 1, y + 1, 54, 50, COL_PANEL);
    box(x + 2, y + 2, 52, 48, face);
    box(x + 2, y + 2, 52, 3, accent);
    box(x + 2, y + 2, 1, 1, COL_WHITE);

    int labelColor = locked ? COL_LOCK : COL_TEXT;
    text(String.format("%02d", lv.id), x + 5, y + 9, labelColor, fTiny);
    String status = locked ? "KUNCI" : (complete ? "SELESAI" : "SIAP");
    int statusColor = locked ? COL_LOCK : (complete ? COL_GOLD : COL_IO);
    textRight(status, x + 52, y + 9, statusColor, fTiny);

    String title = shorten(lv.title, 12);
    String concept = shorten(lv.concept, 12);
    textCenter(title, x + 28, y + 22, locked ? COL_LOCK : COL_TEXT, fTiny);
    textCenter(concept, x + 28, y + 32, locked ? COL_LOCK : COL_MUTED, fTiny);
    starRow(x + 28, y + 43, locked ? 0 : g.stars[lv.id], 4, 4);
  }

  float levelCardX(int index) {
    return 12 + (index % 5) * 60;
  }

  float levelCardY(int index) {
    return 38 + (index / 5) * 58;
  }

  int levelAccent(Level lv) {
    if (lv.blocks.contains(Block.LONCAT) || lv.blocks.contains(Block.LONCAT_NOL)) return COL_FLOW;
    if (lv.blocks.contains(Block.TAMBAH) || lv.blocks.contains(Block.KURANG)) return COL_ARITH;
    if (lv.blocks.contains(Block.SIMPAN) || lv.blocks.contains(Block.MUAT)) return COL_MEM;
    return COL_IO;
  }

  String shorten(String value, int maxLength) {
    if (value.length() <= maxLength) return value;
    return value.substring(0, maxLength - 1) + ".";
  }

  void starRow(float cx, float y, int n, float size, float gap) {
    float total = 3 * size + 2 * gap;
    float x0 = cx - total / 2;
    for (int i = 0; i < 3; i++) {
      p.fill(i < n ? COL_GOLD : COL_PANEL_DARK);
      p.rect(x0 + i * (size + gap), y, size, size);
    }
  }

  int totalStars(GameState g) {
    int total = 0;
    for (int i = 1; i <= g.levelCount; i++) total += g.stars[i];
    return total;
  }

  // ---------- layar bermain ----------

  void renderPlay(GameState g) {
    box(0, 0, 320, 180, COL_BG);
    drawPlayBackground();
    if (g.currentLevel < 0 || g.currentLevel >= g.levelCount) return;
    Level lv = g.levels[g.currentLevel];

    box(0, 0, 320, 14, COL_PANEL);
    backButton();
    text("LEVEL " + lv.id + "  " + lv.title, 20, 7, COL_TEXT, fSmall);
    textRight("SIZE " + lv.sizeTarget + "  SPEED " + lv.speedTarget, 288, 7, COL_MUTED, fTiny);
    drawPixelIconButton(292, 2, true);
    drawPixelIconButton(306, 2, false);

    panelDark(0, 14, 320, 18, COL_PANEL_HI);
    p.textFont(fTiny);
    p.fill(COL_TEXT);
    p.textAlign(p.LEFT, p.TOP);
    p.text(lv.brief, 4, 15, 312, 8);
    if (lv.tests.size() > 0) {
      TestCase example = lv.tests.get(0);
      String exampleText = "Contoh: " + formatValues(example.inbox) + " -> " + formatValues(example.expected);
      p.fill(COL_GOLD);
      p.text(exampleText, 4, 23, 312, 8);
    }

    drawInbox(g, 4, 32, 92, 32);
    drawOutbox(g, 100, 32, 92, 32);
    drawRobot(94, 68);
    drawHand(g, 116, 66, 26, 22);
    drawMemory(g, 4, 100, 188, 32);
    drawStatus(g, lv);
    drawControls(g);
    drawPalette(g, lv);
    drawProgramPanel(g, lv);

    if (g.resultShown) drawResult(g);
    if (g.helpShown) drawBlockHelp(g, lv);
    if (g.hintStage > 0) drawHint(g, lv);
  }

  void drawPixelIconButton(float x, float y, boolean hint) {
    int accent = hint ? COL_GOLD : COL_FLOW;
    boolean hover = hit(mx, my, x, y, 12, 10);
    box(x, y, 12, 10, hover ? accent : COL_LOCK);
    box(x + 1, y + 1, 10, 8, COL_BG2);
    box(x + 2, y + 2, 8, 6, COL_PANEL);

    if (hint) {
      box(x + 4, y + 2, 4, 1, accent);
      box(x + 3, y + 3, 1, 2, accent);
      box(x + 8, y + 3, 1, 2, accent);
      box(x + 4, y + 5, 4, 1, accent);
      box(x + 5, y + 6, 2, 1, accent);
      box(x + 5, y + 7, 2, 1, accent);
    } else {
      box(x + 4, y + 2, 4, 1, accent);
      box(x + 8, y + 3, 1, 1, accent);
      box(x + 7, y + 4, 1, 1, accent);
      box(x + 6, y + 5, 1, 2, accent);
      box(x + 6, y + 8, 1, 1, accent);
    }
  }

  void drawHint(GameState g, Level lv) {
    p.fill(10, 12, 20, 230);
    p.rect(0, 0, 320, 180);

    if (g.hintStage == 1) {
      panel(28, 48, 264, 84, COL_GOLD);
      textCenter("BUKA HINT LEVEL " + lv.id + "?", 160, 62, COL_GOLD, fSmall);
      textCenter("Yakin mau lihat hint?", 160, 78, COL_TEXT, fSmall);
      textCenter("Gini doang gak paham?", 160, 90, COL_MUTED, fTiny);
      button(76, 104, 72, 18, "BUKA", COL_BLUE);
      button(172, 104, 72, 18, "TIDAK", COL_PANEL_HI);
      return;
    }

    panel(6, 8, 308, 164, COL_GOLD);
    text("SOLUSI LEVEL " + lv.id, 14, 17, COL_GOLD, fSmall);

    p.textFont(fTiny);
    p.fill(COL_TEXT);
    p.textAlign(p.LEFT, p.TOP);
    p.text(hintExplanation(lv.id), 14, 26, 292, 22);
    text("URUTAN PROGRAM", 14, 52, COL_IO, fTiny);

    String[] blocks = hintProgram(lv.id);
    if (blocks.length == 0) {
      text("Hint untuk level ini belum tersedia.", 14, 70, COL_WARN, fTiny);
    } else {
      int leftCount = (blocks.length + 1) / 2;
      for (int i = 0; i < leftCount; i++) {
        text((i + 1) + ". " + blocks[i], 14, 63 + i * 8, COL_TEXT, fTiny);
      }
      for (int i = leftCount; i < blocks.length; i++) {
        int row = i - leftCount;
        text((i + 1) + ". " + blocks[i], 164, 63 + row * 8, COL_TEXT, fTiny);
      }
    }

    text("Tambah blok dari atas ke bawah. Hint tidak mengubah programmu.", 14, 143, COL_MUTED, fTiny);
    button(268, 151, 38, 13, "TUTUP", COL_BLUE);
  }

  String hintExplanation(int levelId) {
    if (levelId == 1) return "Ambil satu angka, lalu taruh ke OUTBOX. Ulangi sampai INBOX habis.";
    if (levelId == 2) return "Susun AMBIL lalu TARUH sebanyak delapan kali untuk delapan angka.";
    if (levelId == 3) return "Simpan angka pertama di memori 0. Keluarkan angka kedua, lalu muat angka pertama.";
    if (levelId == 4) return "Simpan angka pertama di memori 0. Ambil angka kedua, tambahkan memori 0, lalu taruh hasil.";
    if (levelId == 5) return "LABEL 0 menandai awal. Tambahkan angka itu dengan salinannya, taruh hasil, lalu ulangi.";
    if (levelId == 6) return "Memori 0 menyimpan total. Tambahkan tiap angka baru ke total, lalu keluarkan totalnya.";
    if (levelId == 7) return "Jika angka nol, lompat melewati TARUH. Jika tidak nol, taruh. Ulangi untuk angka berikutnya.";
    if (levelId == 8) return "Lewati angka nol dan negatif. Hanya angka positif yang melewati blok TARUH.";
    if (levelId == 9) return "Memori 2 berisi angka 1. Simpan N di memori 1, keluarkan N, lalu kurangi hitungan sampai 0.";
    if (levelId == 10) return "Simpan A di memori 0 dan B di 1. Tambahkan A ke total di memori 2, kurangi B dengan memori 3 (angka 1), lalu ulangi sampai B nol.";
    return "";
  }

  String[] hintProgram(int levelId) {
    if (levelId == 1) {
      return new String[] {"AMBIL", "TARUH", "AMBIL", "TARUH", "AMBIL", "TARUH"};
    }
    if (levelId == 2) {
      String[] blocks = new String[16];
      for (int i = 0; i < 8; i++) {
        blocks[i * 2] = "AMBIL";
        blocks[i * 2 + 1] = "TARUH";
      }
      return blocks;
    }
    if (levelId == 3) {
      return new String[] {"AMBIL", "SIMPAN 0", "AMBIL", "TARUH", "MUAT 0", "TARUH"};
    }
    if (levelId == 4) {
      return new String[] {"AMBIL", "SIMPAN 0", "AMBIL", "TAMBAH 0", "TARUH"};
    }
    if (levelId == 5) {
      return new String[] {"LABEL 0", "AMBIL", "SIMPAN 0", "TAMBAH 0", "TARUH", "LONCAT 0"};
    }
    if (levelId == 6) {
      return new String[] {"LABEL 0", "AMBIL", "SIMPAN 1", "MUAT 0", "TAMBAH 1", "SIMPAN 0", "TARUH", "LONCAT 0"};
    }
    if (levelId == 7) {
      return new String[] {"LABEL 0", "AMBIL", "LONCAT JIKA NOL 1", "TARUH", "LONCAT 0", "LABEL 1", "LONCAT 0"};
    }
    if (levelId == 8) {
      return new String[] {"LABEL 0", "AMBIL", "LONCAT JIKA NOL 1", "LONCAT JIKA NEGATIF 1", "TARUH", "LONCAT 0", "LABEL 1", "LONCAT 0"};
    }
    if (levelId == 9) {
      return new String[] {"LABEL 0", "AMBIL", "SIMPAN 1", "LABEL 1", "MUAT 1", "LONCAT JIKA NOL 2", "TARUH", "MUAT 1", "KURANG 2", "SIMPAN 1", "LONCAT 1", "LABEL 2", "LONCAT 0"};
    }
    if (levelId == 10) {
      return new String[] {"AMBIL", "SIMPAN 0", "AMBIL", "SIMPAN 1", "LABEL 0", "MUAT 1", "LONCAT JIKA NOL 1", "MUAT 2", "TAMBAH 0", "SIMPAN 2", "MUAT 1", "KURANG 3", "SIMPAN 1", "LONCAT 0", "LABEL 1", "MUAT 2", "TARUH"};
    }
    return new String[0];
  }

  void drawPlayBackground() {
    for (int row = 0; row < 23; row++) {
      for (int col = 0; col < 40; col++) {
        int pattern = (row * 7 + col * 11) % 19;
        float x = col * 8 + 2;
        float y = row * 8 + 2;
        if (pattern == 0) {
          box(x, y, 2, 2, 0x202B2F45);
        } else if (pattern == 1) {
          box(x + 2, y + 1, 1, 1, 0x303B4060);
        }
      }
    }

    int phase = p.millis() / 35;
    box(10 + phase % 300, 8 + (phase / 12) % 164, 1, 1, 0x704FC3F7);
    box(12 + (phase * 2) % 296, 4 + (phase / 20) % 172, 1, 1, 0x70B07CFF);
  }

  String formatValues(int[] values) {
    String result = "[";
    int shown = Math.min(values.length, 3);
    for (int i = 0; i < shown; i++) {
      if (i > 0) result += ", ";
      result += values[i];
    }
    if (values.length > shown) {
      if (shown > 0) result += ", ";
      result += "...";
    }
    return result + "]";
  }

  void drawBlockHelp(GameState g, Level lv) {
    p.fill(10, 12, 20, 230);
    p.rect(0, 0, 320, 180);

    panel(20, 16, 280, 148, COL_FLOW);
    text("DEFINISI BLOK", 28, 25, COL_GOLD, fSmall);
    textRight("?", 292, 25, COL_FLOW, fMid);

    String[] names = {
      Block.AMBIL, Block.TARUH, Block.SIMPAN, Block.MUAT, Block.TAMBAH,
      Block.KURANG, Block.LABEL, Block.LONCAT, Block.LONCAT_NOL, Block.LONCAT_NEG
    };
    String[] defs = {
      "Ambil satu angka dari INBOX ke TANGAN.",
      "Pindahkan angka TANGAN ke OUTBOX.",
      "Salin TANGAN ke indeks memori.",
      "Salin memori ke TANGAN.",
      "Tambahkan memori ke TANGAN.",
      "Kurangkan TANGAN dengan memori.",
      "Tandai baris ini dengan nomor.",
      "Pergi ke LABEL bernomor ini.",
      "Jika tangan nol, lompat ke LABEL ini.",
      "Jika tangan negatif, lompat ke LABEL ini."
    };

    for (int i = 0; i < names.length; i++) {
      float x = (i < 5) ? 28 : 166;
      float y = 42 + ((i < 5) ? i : i - 5) * 21;
      boolean available = lv.blocks.contains(names[i]);
      int nameColor = available ? blockColor(names[i]) : COL_LOCK;
      int defColor = available ? COL_TEXT : COL_MUTED;

      String name = shortOf(names[i]);
      text(name, x, y, nameColor, fTiny);
      p.textFont(fTiny);
      p.fill(defColor);
      p.textAlign(p.LEFT, p.TOP);
      p.text(defs[i], x, y + 5, 126, 14);
    }

    text("Blok gelap = belum tersedia di level ini.", 28, 151, COL_MUTED, fTiny);
    button(254, 145, 38, 13, "TUTUP", COL_BLUE);
  }

  void drawItems(ArrayList<Integer> items, float x, float y, int maxShow, int tileColor) {
    int n = Math.min(items.size(), maxShow);
    for (int i = 0; i < n; i++) {
      float ix = x + (i % 9) * 10;
      float iy = y + (i / 9) * 10;
      box(ix + 1, iy + 1, 9, 9, COL_BG2);
      box(ix, iy, 9, 9, tileColor);
      box(ix + 1, iy + 1, 7, 1, p.lerpColor(tileColor, COL_WHITE, 0.28f));
      textCenter(Integer.toString(items.get(i)), ix + 4.5f, iy + 5, COL_BG2, fTiny);
    }
    if (items.size() > maxShow) {
      text("+" + (items.size() - maxShow), x + 86, y + 2, COL_MUTED, fTiny);
    }
  }

  void drawInbox(GameState g, float x, float y, float w, float h) {
    panelCard(x, y, w, h, COL_IO);
    text("INBOX", x + 3, y + 5, COL_IO, fTiny);
    if (g.vm != null) drawItems(g.vm.inbox, x + 3, y + 10, 18, COL_IO);
  }

  void drawOutbox(GameState g, float x, float y, float w, float h) {
    panelCard(x, y, w, h, COL_MEM);
    text("OUTBOX", x + 3, y + 5, COL_MEM, fTiny);
    if (g.vm != null) drawItems(g.vm.outbox, x + 3, y + 10, 18, COL_MEM);
  }

  void drawRobot(float x, float y) {
    int now = p.millis();
    int bob = (int) Math.round(Math.sin(now * 0.004) * 1.0);
    boolean blink = now % 3200 > 3070;
    float ry = y + bob;

    box(x + 4, y + 20, 8, 1, 0x50202A45);
    box(x + 6, y + 21, 4, 1, 0x30202A45);
    box(x + 4, ry, 8, 2, (now / 700) % 2 == 0 ? COL_MEM : COL_GOLD);
    box(x + 2, ry + 2, 12, 10, COL_MEM);
    box(x + 3, ry + 3, 10, 1, 0xFFB8E986);
    if (blink) {
      box(x + 4, ry + 5, 2, 1, COL_BG2);
      box(x + 10, ry + 5, 2, 1, COL_BG2);
    } else {
      box(x + 4, ry + 4, 2, 2, COL_BG2);
      box(x + 10, ry + 4, 2, 2, COL_BG2);
      box(x + 4, ry + 4, 1, 1, COL_WHITE);
      box(x + 10, ry + 4, 1, 1, COL_WHITE);
    }
    box(x + 4, ry + 12, 8, 7, COL_BLUE);
    box(x + 1, ry + 13, 2, 4, COL_BLUE);
    box(x + 13, ry + 13, 2, 4, COL_BLUE);
    box(x + 5, ry + 19, 3, 1, COL_GOLD);
    box(x + 10, ry + 19, 3, 1, COL_GOLD);
  }

  void drawHand(GameState g, float x, float y, float w, float h) {
    panelCard(x, y, w, h, COL_GOLD);
    textCenter("TANGAN", x + w / 2, y + 5, COL_GOLD, fTiny);
    String v = "-";
    if (g.vm != null && g.vm.hand != null) v = g.vm.hand.toString();
    textCenter(v, x + w / 2, y + 14, COL_TEXT, fSmall);
  }

  void drawMemory(GameState g, float x, float y, float w, float h) {
    if (g.currentLevel >= g.levelCount) return;
    Level lv = g.levels[g.currentLevel];
    panelCard(x, y, w, h, COL_MEM);
    text("MEMORI", x + 3, y + 5, COL_MEM, fTiny);
    for (int i = 0; i < lv.memorySize && i < 8; i++) {
      float bx = x + 3 + i * 22;
      float by = y + 10;
      box(bx + 1, by + 1, 20, 18, COL_BG2);
      box(bx, by, 20, 18, COL_MEM);
      box(bx + 1, by + 1, 18, 16, COL_PANEL_DARK);
      box(bx + 1, by + 1, 18, 1, 0xFFB8E986);
      text(Integer.toString(i), bx + 2, by + 3, COL_MUTED, fTiny);
      String val = "0";
      if (g.vm != null && g.vm.memory != null && i < g.vm.memory.length) {
        val = Integer.toString(g.vm.memory[i]);
      }
      textCenter(val, bx + 10, by + 12, COL_TEXT, fSmall);
    }
  }

  void drawStatus(GameState g, Level lv) {
    String s = "LANGKAH " + (g.vm != null ? g.vm.steps : 0) + "/" + lv.runLimit;
    if (g.vm != null && g.vm.failed) s += "  " + g.vm.message;
    text(s, 4, 138, g.vm != null && g.vm.failed ? COL_WARN : COL_MUTED, fTiny);
    if (g.resultShown) return;
    if (g.vm != null && g.vm.activeIndex >= 0) {
      textRight("BLOK AKTIF: " + (g.vm.activeIndex + 1), 312, 138, COL_GOLD, fTiny);
    }
  }

  void drawControls(GameState g) {
    button(4, 145, 46, 12, "JALANKAN", COL_BLUE);
    button(52, 145, 28, 12, "JEDA", COL_PANEL_HI);
    button(82, 145, 38, 12, "LANGKAH", COL_PANEL_HI);
    button(122, 145, 28, 12, "RESET", COL_PANEL_HI);
    button(152, 145, 38, 12, g.fastRun ? "CEPAT 4x" : "NORMAL 1x", COL_PANEL_HI);
  }

  int blockColor(String op) {
    if (op.equals(Block.AMBIL) || op.equals(Block.TARUH)) return COL_IO;
    if (op.equals(Block.SIMPAN) || op.equals(Block.MUAT)) return COL_MEM;
    if (op.equals(Block.TAMBAH) || op.equals(Block.KURANG)) return COL_ARITH;
    return COL_FLOW;
  }

  void drawPalette(GameState g, Level lv) {
    for (int i = 0; i < BLOCK_ALL.length; i++) {
      String op = BLOCK_ALL[i];
      boolean open = lv.blocks.contains(op);
      float x = 1 + i * 32;
      float y = 161;
      boolean hover = hit(mx, my, x, y, 30, 17);
      int accent = open ? blockColor(op) : COL_LOCK;
      int face = open ? (hover ? p.lerpColor(accent, COL_WHITE, 0.16f) : accent) : COL_PANEL_DARK;

      box(x + 1, y + 2, 30, 15, COL_BG2);
      box(x, y + 1, 30, 16, COL_LOCK);
      box(x + 1, y + 2, 28, 13, face);
      box(x + 1, y + 2, 28, 1, open ? COL_WHITE : COL_PANEL_HI);
      box(x + 1, y + 14, 28, 1, open ? accent : COL_BG2);
      box(x + 2, y, 8, 2, accent);
      textCenter(shortOf(op), x + 15, y + 9, open ? COL_BG2 : COL_LOCK, fTiny);
    }
  }

  String shortOf(String op) {
    if (op.equals(Block.LONCAT_NOL)) return "L-NOL";
    if (op.equals(Block.LONCAT_NEG)) return "L-NEG";
    return op;
  }

  void drawProgramPanel(GameState g, Level lv) {
    if (g.program == null) return;
    panelCard(198, 32, 118, 112, COL_FLOW);
    text("PROGRAM", 202, 36, COL_TEXT, fTiny);
    textRight("SIZE " + g.program.blockCount(), 312, 36, g.program.blockCount() <= lv.sizeTarget ? COL_GOLD : COL_WARN, fTiny);

    int start = g.program.scroll;
    for (int r = 0; r < Program.VISIBLE_ROWS; r++) {
      int idx = start + r;
      if (idx >= g.program.blocks.size()) break;
      float y = 40 + r * 8;
      Block b = g.program.blocks.get(idx);
      boolean sel = idx == g.program.selected;
      boolean active = g.vm != null && g.vm.activeIndex == idx;
      int bg = active ? COL_GOLD : (sel ? COL_PANEL_HI : COL_PANEL_DARK);
      box(200, y, 114, 7, bg);
      box(200, y, 2, 7, active ? COL_GOLD : blockColor(b.op));
      int tc = active ? COL_BG2 : COL_TEXT;
      text(b.display(), 203, y + 3.5f, tc, fTiny);
      textRight(Integer.toString(idx + 1), 312, y + 3.5f, active ? COL_BG2 : COL_MUTED, fTiny);
    }

    if (start > 0) textCenter("^", 312, 39, COL_MUTED, fTiny);
    if (start + Program.VISIBLE_ROWS < g.program.blocks.size()) {
      textCenter("v", 312, 133, COL_MUTED, fTiny);
    }
    text("LANGKAH " + (g.vm != null ? g.vm.steps : 0), 202, 139, COL_MUTED, fTiny);
  }

  void drawResult(GameState g) {
    p.fill(10, 12, 20, 225);
    p.rect(0, 0, 320, 180);
    panel(40, 38, 240, 104, g.resultPass ? COL_MEM : COL_WARN);
    textCenter(g.resultTitle, 160, 50, g.resultPass ? COL_MEM : COL_WARN, fMid);

    p.textFont(fTiny);
    p.fill(COL_TEXT);
    p.textAlign(p.CENTER, p.TOP);
    p.text(g.resultMessage, 52, 62, 216, 26);

    starRow(160, 90, g.earnedStars, 8, 6);

    button(76, 108, 72, 16, g.resultPass ? "LANJUT" : "ULANGI", COL_BLUE);
    button(172, 108, 64, 16, "PILIH LEVEL", COL_PANEL_HI);
  }

  // ---------- input ----------

  void mousePressed(GameState g, float x, float y, int mb) {
    if (g.screen == GameState.MENU) {
      if (hit(x, y, 96, 70, 128, 16)) {
        g.startContinue();
      } else if (hit(x, y, 96, 90, 128, 16)) {
        g.openTutorial();
      } else if (hit(x, y, 96, 110, 128, 16)) {
        g.openSelect();
      } else if (hit(x, y, 96, 130, 128, 16)) {
        g.quit();
      }
      return;
    }

    if (g.screen == GameState.TUTORIAL) {
      if (hit(x, y, 2, 2, 12, 10)) {
        g.openMenu();
      } else if (hit(x, y, 6, 146, 54, 18)) {
        if (g.tutorialPage == 0) g.openMenu();
        else g.tutorialPrev();
      } else if (hit(x, y, 112, 146, 64, 18)) {
        g.skipTutorial();
      } else if (hit(x, y, 220, 146, 94, 18)) {
        g.tutorialNext();
      }
      return;
    }

    if (g.screen == GameState.LEVEL_TUTORIAL) {
      TutorialSession s = g.tutorialSession;
      if (s == null) return;
      if (hit(x, y, 2, 2, 12, 10)) {
        g.openSelect();
      } else if (hit(x, y, 6, 158, 54, 16)) {
        if (s.page == 0) g.openSelect();
        else if (s.page == 2) s.retry();
        else s.page--;
      } else if (hit(x, y, 112, 158, 64, 16)) {
        g.finishLevelTutorial();
      } else if (hit(x, y, 220, 158, 94, 16)) {
        if (s.page < 2) s.page++;
        else if (s.solved) g.finishLevelTutorial();
      } else if (s.page == 2) {
        for (int i = 0; i < 4; i++) {
          float bx = 4 + i * 79;
          if (hit(x, y, bx, 124, 75, 18)) {
            s.click(s.options[i]);
            return;
          }
        }
      }
      return;
    }

    if (g.screen == GameState.SELECT) {
      if (hit(x, y, 2, 2, 12, 10)) {
        g.openMenu();
        return;
      }
      for (int i = 0; i < g.levelCount; i++) {
        if (hit(x, y, levelCardX(i), levelCardY(i), 56, 52)) {
          g.startLevel(i);
          return;
        }
      }
      return;
    }

    if (g.screen != GameState.PLAY) return;

    if (g.hintStage > 0) {
      if (g.hintStage == 1) {
        if (hit(x, y, 76, 104, 72, 18)) {
          g.hintStage = 2;
        } else if (hit(x, y, 172, 104, 72, 18)) {
          g.hintStage = 0;
        }
      } else if (hit(x, y, 268, 151, 38, 13)) {
        g.hintStage = 0;
      }
      return;
    }

    if (g.helpShown) {
      if (hit(x, y, 254, 145, 38, 13)) {
        g.helpShown = false;
      }
      return;
    }

    if (g.resultShown) {
      if (hit(x, y, 76, 108, 72, 16)) {
        if (g.resultPass) g.continueNext();
        else g.resetRun();
      } else if (hit(x, y, 172, 108, 64, 16)) {
        g.openSelect();
      }
      return;
    }

    if (hit(x, y, 2, 2, 12, 10)) {
      g.openSelect();
      return;
    }
    if (hit(x, y, 292, 2, 12, 10)) {
      g.running = false;
      g.hintStage = 1;
      return;
    }
    if (hit(x, y, 306, 2, 12, 10)) {
      g.helpShown = true;
      return;
    }

    if (hit(x, y, 4, 145, 46, 12)) { g.run(); return; }
    if (hit(x, y, 52, 145, 28, 12)) { g.pause(); return; }
    if (hit(x, y, 82, 145, 38, 12)) { g.stepOnce(); return; }
    if (hit(x, y, 122, 145, 28, 12)) { g.resetRun(); return; }
    if (hit(x, y, 152, 145, 38, 12)) { g.toggleSpeed(); return; }

    for (int i = 0; i < BLOCK_ALL.length; i++) {
      float px = 1 + i * 32;
      if (hit(x, y, px, 161, 30, 17)) {
        g.addBlock(BLOCK_ALL[i]);
        return;
      }
    }

    if (x >= 200 && x < 314 && y >= 40 && y < 40 + Program.VISIBLE_ROWS * 8 && g.program != null) {
      int row = (int) ((y - 40) / 8);
      int idx = g.program.scroll + row;
      if (idx >= 0 && idx < g.program.blocks.size()) {
        if (mb == p.RIGHT) {
          g.removeBlock(idx);
        } else {
          g.selectBlock(idx);
        }
      }
    }
  }

  void keyPressed(GameState g) {
    if (g.screen == GameState.LEVEL_TUTORIAL) {
      TutorialSession s = g.tutorialSession;
      if (p.keyCode == K_ESC) {
        g.openSelect();
      } else if (s != null && p.keyCode == K_LEFT) {
        if (s.page == 0) g.openSelect();
        else s.page--;
      } else if (s != null && (p.keyCode == K_RIGHT || p.keyCode == K_ENTER || p.keyCode == K_RETURN)) {
        if (s.page < 2) s.page++;
        else if (s.solved) g.finishLevelTutorial();
      } else if (s != null && s.page == 2 && p.key >= '1' && p.key <= '4') {
        s.click(s.options[p.key - '1']);
      }
      return;
    }
    if (g.screen == GameState.TUTORIAL) {
      if (p.keyCode == K_ESC) g.openMenu();
      else if (p.keyCode == K_LEFT) g.tutorialPrev();
      else if (p.keyCode == K_RIGHT || p.keyCode == K_ENTER || p.keyCode == K_RETURN) g.tutorialNext();
      return;
    }
    if (g.screen == GameState.SELECT) {
      if (p.keyCode == K_ESC) g.openMenu();
      return;
    }
    if (g.screen != GameState.PLAY) return;

    if (g.hintStage > 0) {
      if (p.keyCode == K_ESC) g.hintStage = 0;
      else if (g.hintStage == 1 && (p.keyCode == K_ENTER || p.keyCode == K_RETURN)) g.hintStage = 2;
      return;
    }

    if (g.helpShown) {
      if (p.keyCode == K_ESC || p.keyCode == K_RETURN || p.keyCode == K_ENTER) {
        g.helpShown = false;
      }
      return;
    }

    if (p.key == '?') {
      g.helpShown = true;
      return;
    }

    if (g.resultShown) {
      if (p.keyCode == K_ENTER || p.keyCode == K_RETURN) {
        if (g.resultPass) g.continueNext();
        else g.resetRun();
      } else if (p.keyCode == K_ESC) {
        g.openSelect();
      }
      return;
    }

    if (p.keyCode == K_ESC) { g.openSelect(); return; }
    if (p.keyCode == K_DELETE || p.keyCode == K_BACKSPACE) { g.removeSelected(); return; }
    if (p.keyCode == K_UP) { g.moveSelected(-1); return; }
    if (p.keyCode == K_DOWN) { g.moveSelected(1); return; }
    if (p.keyCode == K_ENTER || p.keyCode == K_RETURN) { g.run(); return; }
    if (p.key == ' ') { g.stepOnce(); return; }
  }
}
