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

  static final int NIGHT_TOP = 0xFF090B20;
  static final int NIGHT_BOT = 0xFF1B1B4A;
  static final int STAR = 0xFFE6F7FF;
  static final int CLOUD_DARK = 0xFF332C6B;
  static final int CLOUD = 0xFF5B4BA8;
  static final int GRASS = 0xFF5FD35F;
  static final int GRASS_DARK = 0xFF2F8F4E;
  static final int DIRT = 0xFF7A4B34;
  static final int DIRT_DARK = 0xFF4E2F22;
  static final int NEON = 0xFF67E8F9;
  static final int GOLD2 = 0xFFFFD166;
  static final int CAT_WHITE = 0xFFF7F7FF;
  static final int CAT_SHADE = 0xFFD7D9F0;
  static final int PINK = 0xFFFF9EC4;
  static final int PLAY_SKY = 0xFF0C1028;
  static final int PLAY_SKY2 = 0xFF1B2456;
  static final int EDGE_DARK = 0xFF080A18;
  static final int PANEL_INNER = 0xFF111830;
  static final int INBOX_HI = 0xFF3B9DF6;
  static final int OUTBOX_HI = 0xFF76D43C;
  static final int PROG_HI = 0xFFA855F7;
  static final int HAND_HI = 0xFFFFC93C;
  static final int TILE_HI = 0xFF9BE7FF;

  static final int K_BACKSPACE = 8;
  static final int K_ENTER = 10;
  static final int K_RETURN = 13;
  static final int K_ESC = 27;
  static final int K_SPACE = 32;
  static final int K_PGUP = 33;
  static final int K_PGDWN = 34;
  static final int K_LEFT = 37;
  static final int K_UP = 38;
  static final int K_RIGHT = 39;
  static final int K_DOWN = 40;
  static final int K_DELETE = 127;

  PApplet p;
  PFont fTiny, fSmall, fMid, fBig;
  PImage starGold, starGray;
  float mx, my;
  int menuFocus = 0;

  UI(PApplet app, PFont tiny, PFont small, PFont mid, PFont big) {
    p = app;
    fTiny = tiny;
    fSmall = small;
    fMid = mid;
    fBig = big;
    starGold = p.loadImage("data/sprites/r3_07_icon_star_gold.png");
    starGray = p.loadImage("data/sprites/r3_08_icon_star_gray.png");
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
    if (g.transition != 0) drawTransition(g);
  }

  // ---------- util gambar ----------

  void box(float x, float y, float w, float h, int c) {
    p.noStroke();
    p.fill(c);
    p.rect(x, y, w, h);
  }

  void boxA(float x, float y, float w, float h, int c, float a) {
    p.noStroke();
    p.fill(c, a);
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

  void boldPanel(float x, float y, float w, float h, int accent) {
    box(x - 1, y - 1, w + 2, h + 2, EDGE_DARK);
    box(x, y, w, h, accent);
    box(x + 1, y + 1, w - 2, h - 2, p.lerpColor(accent, EDGE_DARK, 0.35f));
    box(x + 2, y + 2, w - 4, h - 4, PANEL_INNER);
    box(x + 2, y + 2, w - 4, 1, p.lerpColor(accent, COL_WHITE, 0.55f));
    box(x + 2, y + h - 3, w - 4, 1, p.lerpColor(accent, EDGE_DARK, 0.5f));
  }

  void boldHeader(float x, float y, float w, int accent, String label, int icon, int c) {
    box(x + 2, y + 2, w - 4, 9, accent);
    box(x + 2, y + 2, w - 4, 1, p.lerpColor(accent, COL_WHITE, 0.5f));
    box(x + 2, y + 10, w - 4, 1, p.lerpColor(accent, EDGE_DARK, 0.55f));
    uiTileIcon(icon, x + 3, y + 1, p.lerpColor(accent, EDGE_DARK, 0.45f), COL_WHITE);
    text(label, x + 16, y + 6.5f, c, fTiny);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 4; j++) {
        box(x + w - 27 + i * 7 + j, y + 3 + j, 2, 1, p.lerpColor(accent, COL_WHITE, 0.4f));
      }
    }
  }

  void uiButton(float x, float y, float w, float h, String label, int icon, int base, boolean active) {
    boolean hover = hit(mx, my, x, y, w, h);
    int face = active ? 0xFF2F6FE0 : base;
    if (hover) face = p.lerpColor(face, COL_WHITE, 0.18f);
    if (hover || active) {
      for (int k = 2; k >= 1; k--) boxA(x - k, y - k, w + k * 2, h + k * 2, active ? NEON : COL_GOLD, 22);
    }
    box(x, y, w, h, hover ? COL_WHITE : p.lerpColor(base, COL_WHITE, 0.35f));
    box(x + 1, y + 1, w - 2, h - 2, face);
    box(x + 1, y + 1, w - 2, 1, p.lerpColor(face, COL_WHITE, 0.3f));
    box(x + 1, y + h - 2, w - 2, 1, p.lerpColor(face, EDGE_DARK, 0.6f));
    uiTileIcon(icon, x + 1, y + 1, p.lerpColor(base, EDGE_DARK, 0.5f), COL_WHITE);
    p.textFont(fTiny);
    p.textSize(label.length() > 6 ? 3.5f : 4.5f);
    p.fill(COL_TEXT);
    p.textAlign(p.LEFT, p.CENTER);
    p.text(label, x + 16, y + h / 2);
  }

  void drawUiIcon(int kind, float x, float y, int c) {
    if (kind == 10) {
      box(x, y + 2, 10, 7, c);
      box(x + 1, y + 3, 8, 5, EDGE_DARK);
      box(x + 1, y + 3, 4, 1, c);
      box(x + 1, y + 4, 3, 1, c);
      box(x + 6, y + 4, 2, 1, c);
      box(x + 4, y + 6, 3, 1, c);
    } else if (kind == 11) {
      box(x + 6, y + 1, 3, 8, c);
      box(x + 1, y + 4, 6, 2, c);
      box(x + 5, y + 2, 2, 6, c);
    } else if (kind == 12) {
      box(x + 2, y + 2, 6, 6, c);
      box(x + 3, y + 3, 4, 4, EDGE_DARK);
      box(x + 1, y + 3, 1, 1, c);
      box(x + 1, y + 6, 1, 1, c);
      box(x + 8, y + 3, 1, 1, c);
      box(x + 8, y + 6, 1, 1, c);
      box(x + 3, y + 1, 1, 1, c);
      box(x + 6, y + 1, 1, 1, c);
      box(x + 3, y + 8, 1, 1, c);
      box(x + 6, y + 8, 1, 1, c);
    } else if (kind == 13) {
      for (int i = 0; i < 4; i++) {
        box(x + 3 - i, y + 2 + i, 2, 1, c);
        box(x + 3 - i, y + 7 - i, 2, 1, c);
        box(x + 5 + i, y + 2 + i, 2, 1, c);
        box(x + 5 + i, y + 7 - i, 2, 1, c);
      }
    } else if (kind == 14) {
      for (int r = 0; r < 5; r++) box(x + (4 - r), y + r * 2, (r + 1) * 2, 2, c);
    } else if (kind == 15) {
      box(x + 2, y + 2, 3, 7, c);
      box(x + 6, y + 2, 3, 7, c);
    } else if (kind == 16) {
      box(x + 1, y + 2, 2, 6, c);
      for (int r = 0; r < 3; r++) box(x + 3 + r, y + 3 + r * 2, 2, 2, c);
      box(x + 8, y + 2, 2, 6, c);
    } else if (kind == 17) {
      box(x + 2, y + 2, 6, 2, c);
      box(x + 1, y + 3, 2, 4, c);
      box(x + 7, y + 3, 2, 3, c);
      box(x + 3, y + 6, 5, 2, c);
      box(x + 2, y + 8, 2, 1, c);
    } else if (kind == 18) {
      box(x + 1, y + 6, 8, 2, c);
      box(x + 2, y + 4, 6, 2, c);
      box(x + 4, y + 2, 2, 3, c);
      box(x + 6, y + 3, 2, 1, c);
    } else if (kind == 19) {
      box(x + 3, y + 4, 5, 5, c);
      box(x + 2, y + 5, 1, 3, c);
      box(x + 4, y + 2, 1, 3, c);
      box(x + 6, y + 1, 1, 4, c);
      box(x + 8, y + 3, 1, 3, c);
      box(x + 1, y + 6, 2, 1, c);
    } else if (kind == 20) {
      box(x + 2, y + 2, 6, 6, c);
      box(x + 3, y + 1, 4, 1, c);
      box(x + 1, y + 3, 1, 4, c);
      box(x + 3, y + 3, 4, 4, EDGE_DARK);
    } else if (kind == 21) {
      box(x + 1, y + 1, 8, 8, c);
      box(x + 2, y + 2, 6, 5, EDGE_DARK);
      box(x + 3, y + 2, 4, 3, c);
      box(x + 3, y + 8, 4, 1, c);
    } else if (kind == 22) {
      box(x + 4, y + 1, 2, 5, c);
      box(x + 2, y + 3, 2, 2, c);
      box(x + 6, y + 3, 2, 2, c);
      box(x + 1, y + 7, 8, 2, c);
    } else if (kind == 23) {
      box(x + 4, y + 1, 2, 8, c);
      box(x + 1, y + 4, 8, 2, c);
    } else if (kind == 24) {
      box(x + 1, y + 4, 8, 2, c);
    } else if (kind == 25) {
      box(x + 2, y + 1, 5, 2, c);
      box(x + 1, y + 3, 7, 2, c);
      box(x + 2, y + 5, 5, 2, c);
      box(x + 3, y + 7, 3, 2, c);
      box(x + 7, y + 2, 1, 1, EDGE_DARK);
    } else if (kind == 26) {
      box(x + 1, y + 2, 2, 6, c);
      box(x + 3, y + 4, 6, 2, c);
      box(x + 7, y + 2, 2, 2, c);
      box(x + 8, y + 6, 2, 2, c);
    } else if (kind == 27) {
      box(x + 1, y + 1, 8, 2, c);
      box(x + 1, y + 7, 8, 2, c);
      box(x + 1, y + 3, 2, 4, c);
      box(x + 7, y + 3, 2, 4, c);
      for (int i = 0; i < 4; i++) box(x + 3 + i, y + 2 + i, 2, 1, c);
    } else if (kind == 28) {
      box(x + 2, y + 4, 6, 5, c);
      box(x + 3, y + 2, 4, 3, EDGE_DARK);
      box(x + 4, y + 1, 2, 4, c);
      box(x + 5, y + 6, 1, 2, EDGE_DARK);
    } else if (kind == 29) {
      box(x + 2, y + 1, 6, 5, c);
      box(x + 1, y + 1, 2, 2, c);
      box(x + 7, y + 1, 2, 2, c);
      box(x + 4, y + 6, 2, 2, c);
      box(x + 2, y + 8, 6, 2, c);
    } else if (kind == 30) {
      box(x + 4, y + 1, 2, 8, c);
      for (int i = 0; i < 4; i++) {
        box(x + 3 - i, y + 2 + i, 2, 1, c);
        box(x + 3 - i, y + 7 - i, 2, 1, c);
      }
    } else if (kind == 31) {
      box(x + 2, y + 1, 6, 2, c);
      box(x + 6, y + 3, 2, 2, c);
      box(x + 4, y + 5, 2, 2, c);
      box(x + 4, y + 8, 2, 2, c);
    }
  }

  void uiTileIcon(int kind, float x, float y, int badge, int glyph) {
    box(x + 2, y, 7, 1, badge);
    box(x + 1, y + 1, 9, 1, p.lerpColor(badge, COL_WHITE, 0.4f));
    box(x, y + 2, 11, 7, badge);
    box(x + 1, y + 9, 9, 1, p.lerpColor(badge, EDGE_DARK, 0.5f));
    box(x + 2, y + 10, 7, 1, badge);
    drawGlyph(kind, x + 2, y + 2, glyph);
  }

  void drawGlyph(int kind, float x, float y, int c) {
    String[] g = glyphRows(kind);
    if (g == null) return;
    for (int r = 0; r < 7; r++) {
      for (int col = 0; col < 7; col++) {
        if (g[r].charAt(col) == '#') box(x + col, y + r, 1, 1, c);
      }
    }
  }

  String[] glyphRows(int kind) {
    if (kind == 1) return new String[] {"..#....", ".##....", "#######", "#######", "#######", ".##....", "..#...."};
    if (kind == 2) return new String[] {".#####.", "#.....#", "#.....#", ".#####.", "..###..", "..###..", ".#####."};
    if (kind == 3) return new String[] {".###...", "#...#..", "....#..", "...##..", "...#...", ".......", "...#..."};
    if (kind == 4) return new String[] {"..###..", ".#...#.", "#.....#", "#.....#", ".#...#.", "..###..", "..#.#.."};
    if (kind == 5) return new String[] {"#######", "#.....#", "#..#..#", "#.###.#", "#..#..#", "#.....#", "#######"};
    if (kind == 6) return new String[] {"#######", "#..#..#", "#######", "#.###.#", "#.###.#", "#.###.#", "#######"};
    if (kind == 7) return new String[] {".#####.", "#.###.#", "#.....#", "#.###.#", "#.....#", "#.###.#", ".#####."};
    if (kind == 8) return new String[] {"..###..", ".#####.", "#######", "#######", ".#####.", "..###..", "..###.."};
    if (kind == 9) return new String[] {"#######", "#.....#", "#.#...#", "#..#..#", "#.#...#", "#.....#", "#######"};
    if (kind == 10) return new String[] {"..###..", "..###..", "..###..", "..###..", "#######", ".#####.", "..###.."};
    if (kind == 11) return new String[] {"..###..", ".#####.", "#######", "..###..", "..###..", "..###..", "..###.."};
    if (kind == 12) return new String[] {"#######", "#.###.#", "#.....#", "#.###.#", "#..#..#", "#.###.#", "#######"};
    if (kind == 13) return new String[] {"..###..", ".#####.", "#######", "...#...", "...#...", "...#...", "#######"};
    if (kind == 14) return new String[] {"...#...", "...#...", "#######", "#######", "#######", "...#...", "...#..."};
    if (kind == 15) return new String[] {".......", ".......", "#######", "#######", "#######", ".......", "......."};
    if (kind == 16) return new String[] {".#####.", "#..#..#", "#.....#", "#######", ".#####.", ".......", "......."};
    if (kind == 17) return new String[] {"....#..", "...##..", "#######", "#######", "...##..", "....#..", "......."};
    if (kind == 18) return new String[] {".#####.", "#.....#", "#.#.#.#", "#.#.#.#", "#.#.#.#", "#.....#", ".#####."};
    if (kind == 19) return new String[] {".#####.", "#.....#", "#.....#", "#.###.#", "#.....#", "#.....#", ".#####."};
    if (kind == 20) return new String[] {"#......", "##.....", "###....", "####...", "###....", "##.....", "#......"};
    if (kind == 21) return new String[] {".##.##.", ".##.##.", ".##.##.", ".##.##.", ".##.##.", ".##.##.", ".##.##."};
    if (kind == 22) return new String[] {"#..#...", "##.##..", "#######", "#######", "##.##..", "#..#...", "......."};
    if (kind == 23) return new String[] {".#####.", "#.....#", "#....##", "#...#..", "#.##...", "##.....", "......."};
    if (kind == 24) return new String[] {".......", "..###..", ".#...#.", "#..#..#", "#.###.#", ".#####.", "......."};
    if (kind == 25) return new String[] {"##.....", "#......", "#..###.", "#.#...#", "#..###.", "#......", "#......"};
    if (kind == 26) return new String[] {"##.###.", "##.###.", ".......", "##.###.", "##.###.", ".......", "##.###."};
    return null;
  }

  void drawGlyphScaled(int kind, float x, float y, int c, float s) {
    String[] g = glyphRows(kind);
    if (g == null) return;
    for (int r = 0; r < 7; r++) {
      for (int col = 0; col < 7; col++) {
        if (g[r].charAt(col) == '#') box(x + col * s, y + r * s, s, s, c);
      }
    }
  }

  void drawStar(float cx, float cy, float s, int c) {
    String[] rows = {"...#...", "..###..", "#######", ".#####.", "..###..", ".##.##.", "#.....#"};
    float x0 = cx - 3.5f * s;
    float y0 = cy - 3.5f * s;
    for (int r = 0; r < 7; r++) {
      for (int col = 0; col < 7; col++) {
        if (rows[r].charAt(col) == '#') box(x0 + col * s, y0 + r * s, s, s, c);
      }
    }
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
    drawPixelText(s, centerX, centerY, c, (float) scale);
  }

  void drawPixelText(String s, float centerX, float centerY, int c, float scale) {
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
    case '!': return new int[] {4, 4, 4, 4, 4, 0, 4};
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
    drawNightSky();
    drawClouds();
    drawFloatingPuzzles();

    drawIsland(-4, 142, 70);
    drawIsland(250, 152, 76);
    drawCat(14, 116);
    drawSign(254, 124);

    drawMenuTitle();
    drawBrackets(104, 68, 112, 20, COL_WHITE);
    drawRays(84, 70, false);
    drawRays(236, 70, true);

    menuButton(104, 68, 112, 20, "MULAI", 0, 0xFF3B82F6, NEON, 0, true);
    menuButton(110, 94, 100, 15, "TUTORIAL", 1, 0xFF8B5CF6, 0xFFC4B5FD, 1, false);
    menuButton(110, 112, 100, 15, "PILIH LEVEL", 2, 0xFF3A3A63, 0xFF9CA3AF, 2, false);
    menuButton(110, 130, 100, 15, "KELUAR", 3, 0xFF33334F, 0xFF9CA3AF, 3, false);

    drawFooter();
  }

  void drawNightSky() {
    for (int y = 0; y < 180; y += 2) {
      box(0, y, 320, 2, p.lerpColor(NIGHT_TOP, NIGHT_BOT, y / 180f));
    }
    int now = p.millis();
    for (int i = 0; i < 52; i++) {
      float sx = ((i * 67 + now * 0.006f * (1 + i % 3)) % 330) - 5;
      float sy = 6 + (i * 43) % 150 + p.sin(now * 0.001f + i) * 1.5f;
      float a = 110 + 120 * Math.abs(p.sin(now * 0.0018f + i * 1.3f));
      if (i % 7 == 0) {
        boxA(sx - 1, sy + 2, 5, 1, STAR, a);
        boxA(sx + 2, sy - 1, 1, 5, STAR, a);
      } else {
        int sz = (i % 6 == 0) ? 2 : 1;
        int c = (i % 9 == 0) ? NEON : ((i % 11 == 0) ? COL_FLOW : STAR);
        boxA(sx, sy, sz, sz, c, a);
      }
    }
  }

  void drawClouds() {
    int now = p.millis();
    float drift = -(now * 0.004f) % 60;
    for (int k = -1; k < 7; k++) {
      float x = k * 58 + drift;
      int h = 10 + ((k + 7) % 3) * 7;
      boxA(x, 108 - h, 58, h + 72, CLOUD_DARK, 90);
      boxA(x + 8, 102 - h, 42, 6, CLOUD_DARK, 90);
      boxA(x + 16, 96 - h, 26, 6, CLOUD_DARK, 90);
    }
    float drift2 = -(now * 0.007f) % 72;
    for (int k = -1; k < 6; k++) {
      float x = k * 72 + drift2;
      int h = 8 + ((k + 7) % 3) * 6;
      boxA(x, 142 - h, 72, h + 38, CLOUD, 150);
      boxA(x + 10, 136 - h, 52, 6, CLOUD, 150);
    }
  }

  void drawIsland(float x, float y, float w) {
    box(x + 2, y + 5, w - 4, 16, DIRT);
    box(x + 6, y + 21, w - 12, 6, DIRT_DARK);
    box(x + 14, y + 27, w - 28, 5, DIRT_DARK);
    for (int i = 6; i < w - 6; i += 12) box(x + i, y + 9, 3, 2, 0xFF9A6242);
    box(x, y, w, 5, GRASS_DARK);
    box(x + 2, y, w - 4, 3, GRASS);
    box(x + 1, y + 3, w - 2, 1, 0xFF2A6B3A);
    for (int i = 4; i < w - 4; i += 10) {
      box(x + i, y - 2, 3, 2, GRASS);
      box(x + i + 1, y - 4, 1, 2, GRASS_DARK);
    }
  }

  void drawCat(float x, float y) {
    int u = 2;
    int now = p.millis();
    float wag = p.sin(now * 0.006f) * u;
    box(x, y + 10 * u + wag, 2 * u, u, CAT_SHADE);
    box(x + u, y + 9 * u + wag, 2 * u, u, CAT_WHITE);
    box(x + u, y + 10 * u, u, 2 * u, CAT_WHITE);
    box(x + 3 * u, y + 8 * u, 8 * u, 5 * u, CAT_SHADE);
    box(x + 3 * u, y + 8 * u, 7 * u, 4 * u, CAT_WHITE);
    box(x + 3 * u, y + 12 * u, 3 * u, u, CAT_WHITE);
    box(x + 8 * u, y + 12 * u, 3 * u, u, CAT_WHITE);
    box(x + 2 * u, y + 9 * u, 10 * u, 2 * u, COL_FLOW);
    box(x + 2 * u, y + 9 * u, 10 * u, u, 0xFFC9A7FF);
    box(x + 10 * u, y + 11 * u, 2 * u, 2 * u, COL_FLOW);
    box(x + 2 * u, y, 3 * u, 3 * u, CAT_WHITE);
    box(x + 4 * u, y + 2 * u, u, u, PINK);
    box(x + 8 * u, y, 3 * u, 3 * u, CAT_WHITE);
    box(x + 8 * u, y + 2 * u, u, u, PINK);
    box(x + 2 * u, y + 2 * u, 9 * u, 7 * u, CAT_SHADE);
    box(x + 2 * u, y + 2 * u, 9 * u, 6 * u, CAT_WHITE);
    boolean blink = now % 3400 > 3260;
    if (blink) {
      box(x + 4 * u, y + 5 * u, 2 * u, u, COL_BG2);
      box(x + 8 * u, y + 5 * u, 2 * u, u, COL_BG2);
    } else {
      box(x + 4 * u, y + 5 * u, u, u, COL_BG2);
      box(x + 5 * u, y + 4 * u, u, u, COL_BG2);
      box(x + 6 * u, y + 5 * u, u, u, COL_BG2);
      box(x + 8 * u, y + 5 * u, u, u, COL_BG2);
      box(x + 9 * u, y + 4 * u, u, u, COL_BG2);
      box(x + 10 * u, y + 5 * u, u, u, COL_BG2);
    }
    box(x + 3 * u, y + 6 * u, u, u, PINK);
    box(x + 9 * u, y + 6 * u, u, u, PINK);
    box(x + 6 * u, y + 6 * u, u, u, PINK);
    box(x + 5 * u, y + 7 * u, u, u, 0xFF7A5A6A);
    box(x + 7 * u, y + 7 * u, u, u, 0xFF7A5A6A);
    box(x + 6 * u, y + 8 * u, u, u, 0xFF7A5A6A);
  }

  void drawSign(float x, float y) {
    box(x + 25, y + 24, 4, 16, DIRT_DARK);
    box(x + 2, y + 2, 52, 26, 0xFF3A2418);
    box(x + 3, y + 3, 50, 24, 0xFF9A6238);
    box(x + 5, y + 5, 46, 20, 0xFFB87A46);
    box(x + 5, y + 5, 46, 1, 0xFFD79B63);
    box(x + 7, y + 7, 2, 2, 0xFF6B4426);
    box(x + 49, y + 7, 2, 2, 0xFF6B4426);
    textCenter("Selamat", x + 28, y + 12, 0xFF3A2418, fTiny);
    textCenter("Bermain!", x + 28, y + 20, 0xFF3A2418, fTiny);
    textCenter("v", x + 28, y + 25, 0xFF6B4426, fTiny);
  }

  void drawPuzzle(float x, float y, int s, int c, int variant, float bob) {
    int[] rows = {12, 30, 62, 119, 127, 62, 28};
    float yy = y + bob;
    for (int r = 0; r < 7; r++) {
      for (int col = 0; col < 7; col++) {
        int rr, cc;
        if (variant == 0) {
          rr = r;
          cc = col;
        } else if (variant == 1) {
          rr = 6 - col;
          cc = r;
        } else if (variant == 2) {
          rr = 6 - r;
          cc = 6 - col;
        } else {
          rr = col;
          cc = 6 - r;
        }
        if ((rows[rr] & (1 << (6 - cc))) != 0) box(x + col * s, yy + r * s, s, s, c);
      }
    }
  }

  void drawFloatingPuzzles() {
    int now = p.millis();
    float[] xs = {22, 54, 286, 274, 300, 10};
    float[] ys = {34, 70, 78, 108, 28, 96};
    int[] cols = {0xFF3B9DF6, COL_FLOW, 0xFF3B9DF6, GOLD2, COL_FLOW, NEON};
    int[] sizes = {2, 1, 2, 2, 2, 1};
    for (int i = 0; i < xs.length; i++) {
      float dx = p.sin(now * 0.0006f + i * 1.7f) * 3;
      float dy = p.sin(now * 0.0011f + i) * 3;
      int v = (int) (now / 1800f + i) % 4;
      drawPuzzle(xs[i] + dx, ys[i] + dy, sizes[i], cols[i], v, 0);
    }
  }

  void drawMenuTitle() {
    for (int i = 0; i < 4; i++) {
      float dx = (i == 0) ? -1 : ((i == 1) ? 1 : 0);
      float dy = (i == 2) ? -1 : ((i == 3) ? 1 : 0);
      drawPixelText("PIXEL", 118 + dx, 37 + dy, 0xFF2A1B5E, 2.5f);
      drawPixelText("PUZZLE", 206 + dx, 37 + dy, 0xFF2A1B5E, 2.5f);
    }
    drawPixelText("PIXEL", 119, 39, 0xFF9A4A16, 2.5f);
    drawPixelText("PUZZLE", 207, 39, 0xFF3C2A72, 2.5f);
    drawPixelText("PIXEL", 118, 37, GOLD2, 2.5f);
    drawPixelText("PUZZLE", 206, 37, COL_WHITE, 2.5f);

    box(105, 48, 110, 12, 0xFF2A1B5E);
    box(106, 49, 108, 10, 0xFF111634);
    box(106, 49, 108, 1, NEON);
    box(106, 58, 108, 1, 0xFF2E7E9E);
    drawPixelText("EDUKASI ALGORITMIK", 160, 55, NEON, 1);
    box(89, 53, 12, 2, NEON);
    box(219, 53, 12, 2, NEON);

    drawPuzzle(284, 24, 2, COL_FLOW, 1, 0);
    box(298, 22, 2, 2, GOLD2);
    box(302, 26, 2, 2, GOLD2);
  }

  void drawBrackets(float x, float y, float w, float h, int c) {
    int L = 7;
    box(x - 6, y - 3, L, 1, c);
    box(x - 6, y - 3, 1, L, c);
    box(x + w + 6 - L, y - 3, L, 1, c);
    box(x + w + 5, y - 3, 1, L, c);
    box(x - 6, y + h + 2, L, 1, c);
    box(x - 6, y + h + 3 - L, 1, L, c);
    box(x + w + 6 - L, y + h + 2, L, 1, c);
    box(x + w + 5, y + h + 3 - L, 1, L, c);
  }

  void drawRays(float x, float y, boolean flip) {
    for (int i = 0; i < 3; i++) {
      float px = flip ? x - i * 3 : x + i * 3;
      box(px, y + i * 4, 5 - i, 2, GOLD2);
    }
  }

  void menuButton(float x, float y, float w, float h, String label, int icon, int base, int neon, int idx, boolean primary) {
    boolean hovered = hit(mx, my, x, y, w, h);
    if (hovered) menuFocus = idx;
    boolean hov = hovered || menuFocus == idx;
    float g = hov ? 1.5f : 0;
    float bx = x - g, by = y - g, bw = w + g * 2, bh = h + g * 2;
    if (hov) {
      for (int k = 4; k >= 1; k--) boxA(bx - k, by - k, bw + k * 2, bh + k * 2, neon, 14);
    } else if (primary) {
      for (int k = 3; k >= 1; k--) boxA(bx - k, by - k, bw + k * 2, bh + k * 2, neon, 10);
    }
    box(bx, by, bw, bh, hov ? COL_WHITE : neon);
    box(bx + 1, by + 1, bw - 2, bh - 2, base);
    box(bx + 1, by + 1, bw - 2, 1, p.lerpColor(base, COL_WHITE, 0.45f));
    box(bx + 1, by + bh - 2, bw - 2, 1, p.lerpColor(base, NIGHT_TOP, 0.55f));
    if (hov) box(bx + 1, by + 2, 2, bh - 4, neon);
    int ic = (primary || hov) ? COL_WHITE : p.lerpColor(base, COL_WHITE, 0.8f);
    if (primary) {
      drawIcon(icon, bx + 22, by + (bh - 10) / 2, ic);
      textCenter(label, bx + bw * 0.57f, by + bh / 2, COL_WHITE, fMid);
    } else {
      drawIcon(icon, bx + 12, by + (bh - 10) / 2, ic);
      textCenter(label, bx + bw * 0.56f, by + bh / 2, COL_TEXT, fSmall);
    }
  }

  void textMiniCenter(String s, float x, float y, int c) {
    p.textFont(fTiny);
    p.textSize(5);
    p.fill(c);
    p.textAlign(p.CENTER, p.CENTER);
    p.text(s, x, y);
  }

  void drawIcon(int kind, float x, float y, int c) {
    if (kind == 0) {
      for (int r = 0; r < 5; r++) box(x + (4 - r), y + r * 2, (r + 1) * 2, 2, c);
    } else if (kind == 1) {
      box(x, y + 2, 4, 8, c);
      box(x + 5, y + 2, 4, 8, c);
      box(x + 4, y + 1, 1, 9, c);
      box(x + 1, y + 4, 2, 1, NIGHT_TOP);
      box(x + 1, y + 6, 2, 1, NIGHT_TOP);
      box(x + 6, y + 4, 2, 1, NIGHT_TOP);
      box(x + 6, y + 6, 2, 1, NIGHT_TOP);
      box(x + 1, y + 1, 3, 1, c);
      box(x + 5, y + 1, 3, 1, c);
    } else if (kind == 2) {
      box(x + 3, y, 4, 10, c);
      box(x, y + 3, 10, 4, c);
      box(x + 2, y + 2, 6, 6, c);
      box(x + 4, y + 4, 2, 2, NIGHT_TOP);
      box(x + 2, y, 1, 2, c);
      box(x + 7, y, 1, 2, c);
      box(x + 2, y + 8, 1, 2, c);
      box(x + 7, y + 8, 1, 2, c);
    } else if (kind == 3) {
      box(x + 6, y, 4, 10, c);
      box(x + 6, y, 1, 10, NIGHT_TOP);
      box(x + 1, y + 4, 6, 2, c);
      box(x + 5, y + 2, 2, 6, c);
    } else if (kind == 4) {
      box(x + 2, y, 6, 1, c);
      box(x + 1, y + 1, 8, 1, c);
      box(x, y + 2, 10, 6, c);
      box(x + 1, y + 8, 8, 1, c);
      box(x + 2, y + 9, 6, 1, c);
      box(x + 4, y + 2, 2, 2, NIGHT_TOP);
      box(x + 4, y + 5, 2, 3, NIGHT_TOP);
    } else if (kind == 5) {
      box(x + 1, y + 7, 2, 3, c);
      box(x + 4, y + 4, 2, 6, c);
      box(x + 7, y + 1, 2, 9, c);
    }
  }

  void drawFooter() {
    boxA(4, 160, 194, 14, 0x000000, 70);
    box(4, 161, 192, 12, 0xFF3A3B73);
    box(5, 162, 190, 10, 0xFF151935);
    box(5, 162, 190, 1, 0xFF4A4C8C);
    drawIcon(4, 8, 162, NEON);
    text("10 level  -  satu konsep baru per level", 22, 167, COL_TEXT, fTiny);

    boxA(262, 160, 54, 14, 0x000000, 70);
    box(262, 161, 54, 12, 0xFF3A3B73);
    box(263, 162, 52, 10, 0xFF151935);
    drawIcon(5, 276, 162, NEON);
    textMiniCenter("v0.1", 294, 167, COL_TEXT);
  }

  void drawTransition(GameState g) {
    int dur = g.transition == 1 ? 260 : 240;
    float t = p.constrain((p.millis() - g.transitionAt) / (float) dur, 0, 1);
    float a = (g.transition == 1 ? t : 1 - t) * 255;
    p.fill(8, 10, 26, a);
    p.noStroke();
    p.rect(0, 0, 320, 180);
    if (a > 60) {
      int v = (int) (p.millis() / 180f) % 4;
      drawPuzzle(153 - v, 83 - v, 2 + v, COL_IO, v, 0);
    }
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

  // ---------- tutorial per level ----------

  void renderLevelTutorial(GameState g) {
    if (g.tutorialLevelIdx < 0 || g.tutorialLevelIdx >= g.levelCount) return;
    TutorialSession s = g.tutorialSession;
    if (s == null) return;
    Level lv = g.levels[g.tutorialLevelIdx];
    drawPlayBackground();
    box(0, 0, 320, 14, EDGE_DARK);
    box(0, 0, 320, 1, p.lerpColor(PROG_HI, COL_WHITE, 0.3f));
    uiButton(3, 2, 19, 11, "", 1, COL_PANEL_HI, false);
    box(25, 2, 200, 11, EDGE_DARK);
    box(26, 3, 198, 9, COL_PANEL);
    box(26, 3, 198, 1, COL_PANEL_HI);
    text("TUTORIAL LEVEL " + lv.id, 30, 7.5f, COL_GOLD, fSmall);
    text(s.data.concept, 140, 7.5f, COL_TEXT, fTiny);
    box(228, 2, 88, 11, EDGE_DARK);
    box(229, 3, 86, 9, COL_PANEL_DARK);
    textRight((s.page + 1) + "/3", 312, 7.5f, COL_TEXT, fTiny);
    if (s.page < 2) drawGuideStage(lv, s);
    else drawInteractiveStage(s);
  }

  void drawGuideStage(Level lv, TutorialSession s) {
    String[] lines = s.page == 0 ? s.data.guide : s.data.tips;
    String heading = s.page == 0 ? "KENALAN DENGAN KONSEP" : "TIPS SEBELUM BERMAIN";
    panel(6, 18, 308, 134, COL_FLOW);
    box(7, 19, 306, 1, PROG_HI);
    text(heading, 14, 26, COL_GOLD, fSmall);
    text(s.data.task, 14, 36, COL_TEXT, fTiny);
    demoBox(12, 46, 84, 44, "INBOX", COL_IO);
    demoItems(new int[] {1, 2, 3}, 20, 62, -1);
    drawRobot(116, 52);
    demoBox(214, 46, 88, 44, "OUTBOX", COL_MEM);
    textCenter("kosong", 258, 70, COL_MUTED, fTiny);
    for (int i = 0; i < lines.length && i < 4; i++) {
      text("- " + lines[i], 14, 100 + i * 11, COL_TEXT, fTiny);
    }
    drawTutorialNav(s);
  }

  void drawTutorialNav(TutorialSession s) {
    button(6, 158, 54, 16, "< KEMBALI", COL_PANEL_HI);
    button(112, 158, 64, 16, "LEWATI", COL_PANEL_HI);
    String next = s.page == 1 ? "COBA >" : "LANJUT >";
    button(220, 158, 94, 16, next, COL_BLUE);
    for (int i = 0; i < 3; i++) {
      int c = (i == s.page) ? COL_GOLD : (i < s.page ? COL_IO : COL_LOCK);
      box(148 + i * 8, 176, 5, 2, c);
    }
  }

  void drawInteractiveStage(TutorialSession s) {
    panel(6, 18, 308, 134, COL_FLOW);
    box(7, 19, 306, 1, PROG_HI);
    text("LATIHAN INTERAKTIF", 14, 26, COL_GOLD, fSmall);
    text(s.data.task, 14, 35, COL_TEXT, fTiny);
    for (int i = 0; i < s.data.seq.length && i < 8; i++) {
      int col = i % 2;
      int row = i / 2;
      float x = 14 + col * 146;
      float y = 44 + row * 14;
      boolean done = i < s.progress;
      boolean cur = i == s.progress && !s.solved;
      box(x, y, 140, 12, done ? 0xFF2E5A34 : (cur ? 0xFF5A4A1E : 0xFF1B1F38));
      box(x, y, 2, 12, done ? COL_MEM : (cur ? COL_GOLD : COL_LOCK));
      String label = (i + 1) + ". " + s.shortOp(s.data.seq[i]);
      text(label, x + 5, y + 6, done ? 0xFFB8E986 : (cur ? COL_GOLD : COL_MUTED), fTiny);
    }
    panelDark(14, 104, 292, 18, COL_PANEL_HI);
    String in = "";
    for (int i = s.inboxIndex; i < Math.min(s.inboxIndex + 4, s.data.inbox.length); i++) {
      if (in.length() > 0) in += " ";
      in += s.data.inbox[i];
    }
    text("INBOX: " + (in.length() > 0 ? in : "-"), 18, 113, COL_IO, fTiny);
    text("TANGAN: " + (s.hand == null ? "-" : s.hand.toString()), 100, 113, COL_GOLD, fTiny);
    text("MEM: " + s.mem[0] + "," + s.mem[1] + "," + s.mem[2], 176, 113, COL_MEM, fTiny);
    text("OUTBOX: " + s.outbox.size(), 264, 113, COL_MEM, fTiny);
    for (int i = 0; i < 4; i++) {
      float x = 4 + i * 79;
      float y = 124;
      boolean hover = hit(mx, my, x, y, 75, 18);
      box(x, y + 1, 75, 18, hover ? COL_WHITE : PROG_HI);
      box(x + 1, y + 2, 73, 16, hover ? p.lerpColor(COL_FLOW, COL_WHITE, 0.2f) : 0xFF3B2A6B);
      textCenter(s.shortOp(s.options[i]), x + 36, y + 11, COL_TEXT, fTiny);
      textCenter(Integer.toString(i + 1), x + 70, y + 5, COL_MUTED, fTiny);
    }
    int fc = s.solved ? COL_MEM : (s.feedback.startsWith("Benar") ? COL_IO : COL_WARN);
    text(s.feedback, 14, 148, fc, fTiny);
    button(6, 158, 54, 16, "< ULANGI", COL_PANEL_HI);
    button(112, 158, 64, 16, "LEWATI", COL_PANEL_HI);
    button(220, 158, 94, 16, s.solved ? "MULAI LEVEL" : "SELESAI DULU", s.solved ? COL_MEM : COL_LOCK);
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
    drawPlayBackground();
    if (g.currentLevel < 0 || g.currentLevel >= g.levelCount) return;
    Level lv = g.levels[g.currentLevel];

    box(0, 0, 320, 14, EDGE_DARK);
    box(0, 0, 320, 1, p.lerpColor(PROG_HI, COL_WHITE, 0.3f));
    uiButton(3, 2, 19, 11, "", 1, COL_PANEL_HI, false);
    box(25, 2, 188, 11, EDGE_DARK);
    box(26, 3, 186, 9, COL_PANEL);
    box(26, 3, 186, 1, COL_PANEL_HI);
    text("LEVEL " + lv.id, 30, 7.5f, COL_GOLD, fSmall);
    text(lv.title, 71, 7.5f, COL_TEXT, fSmall);
    box(215, 2, 73, 11, EDGE_DARK);
    box(216, 3, 71, 9, COL_PANEL_DARK);
    textRight("SIZE " + lv.sizeTarget + "  SPEED " + lv.speedTarget, 284, 7.5f, COL_TEXT, fTiny);
    uiButton(290, 2, 12, 11, "", 4, COL_GOLD, false);
    uiButton(304, 2, 12, 11, "", 3, PROG_HI, false);

    panelDark(3, 15, 314, 18, COL_PANEL_HI);
    box(4, 16, 312, 1, COL_PANEL_HI);
    p.textFont(fTiny);
    p.fill(COL_TEXT);
    p.textAlign(p.LEFT, p.TOP);
    p.text(lv.brief, 7, 17, 300, 8);
    if (lv.tests.size() > 0) {
      TestCase example = lv.tests.get(0);
      text("Contoh: " + formatValues(example.inbox) + "  ->  " + formatValues(example.expected), 7, 27, COL_GOLD, fTiny);
    }
    for (int i = 0; i < 3; i++) box(306 - i * 3, 18 + i * 2, 2, 1, COL_PANEL_HI);

    drawInbox(g, 4, 35, 93, 30);
    drawOutbox(g, 100, 35, 93, 30);
    drawRobot(96, 68);
    drawHand(g, 126, 66, 28, 22);
    drawMemory(g, 4, 90, 189, 32);
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
    for (int y = 0; y < 180; y += 2) box(0, y, 320, 2, p.lerpColor(PLAY_SKY, PLAY_SKY2, y / 180f));
    int now = p.millis();
    for (int i = 0; i < 40; i++) {
      float sx = (i * 71 + now * 0.004f * (1 + i % 3)) % 330 - 5;
      float sy = 18 + (i * 37) % 120;
      float a = 90 + 130 * Math.abs(p.sin(now * 0.002f + i));
      boxA(sx, sy, (i % 6 == 0) ? 2 : 1, (i % 6 == 0) ? 2 : 1, STAR, a);
      if (i % 9 == 0) {
        boxA(sx - 2, sy, 5, 1, STAR, a);
        boxA(sx, sy - 2, 1, 5, STAR, a);
      }
    }
    float drift = -(now * 0.006f) % 72;
    for (int k = -1; k < 6; k++) {
      float x = k * 72 + drift;
      boxA(x, 104, 54, 8, CLOUD_DARK, 110);
      boxA(x + 8, 98, 38, 6, CLOUD_DARK, 110);
      boxA(x + 16, 94, 22, 4, CLOUD_DARK, 110);
    }
    float drift2 = -(now * 0.011f) % 96;
    for (int k = -1; k < 5; k++) {
      float x = k * 96 + drift2;
      boxA(x, 138, 66, 10, 0xFF2E2A6B, 140);
      boxA(x + 12, 132, 44, 6, 0xFF2E2A6B, 140);
    }
    for (int x = 0; x < 320; x += 8) {
      int h = 6 + ((x / 8 * 7) % 4) * 2;
      box(x, 180 - h, 8, h, 0xFF1E5A3C);
      box(x, 180 - h, 8, 2, 0xFF3FA34D);
    }
    for (int i = 0; i < 14; i++) {
      float fx = (i * 83 + Math.round(p.sin(now * 0.0008f + i) * 20)) % 320;
      if (fx < 0) fx += 320;
      float fy = 156 + (i * 11) % 18 + p.sin(now * 0.002f + i * 2) * 2;
      int fc = (i % 3 == 0) ? NEON : ((i % 3 == 1) ? COL_GOLD : COL_FLOW);
      boxA(fx, fy, 1, 1, fc, 150 + 100 * Math.abs(p.sin(now * 0.003f + i)));
    }
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
    uiTileIcon(3, 278, 19, PROG_HI, COL_WHITE);

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
      box(ix, iy, 10, 10, EDGE_DARK);
      box(ix + 1, iy + 1, 8, 8, tileColor);
      box(ix + 1, iy + 1, 6, 1, p.lerpColor(tileColor, COL_WHITE, 0.6f));
      box(ix + 2, iy + 7, 6, 1, p.lerpColor(tileColor, EDGE_DARK, 0.35f));
      textCenter(Integer.toString(items.get(i)), ix + 5, iy + 5.5f, EDGE_DARK, fTiny);
    }
    if (items.size() > maxShow) textRight("+" + (items.size() - maxShow), x + 84, y + 6, COL_MUTED, fTiny);
  }

  void drawInbox(GameState g, float x, float y, float w, float h) {
    boldPanel(x, y, w, h, INBOX_HI);
    boldHeader(x, y, w, INBOX_HI, "INBOX", 5, COL_TEXT);
    if (g.vm != null) drawItems(g.vm.inbox, x + 4, y + 13, 9, TILE_HI);
  }

  void drawOutbox(GameState g, float x, float y, float w, float h) {
    boldPanel(x, y, w, h, OUTBOX_HI);
    boldHeader(x, y, w, OUTBOX_HI, "OUTBOX", 6, EDGE_DARK);
    if (g.vm != null) drawItems(g.vm.outbox, x + 4, y + 13, 9, 0xFF9BEF6B);
  }

  void drawRobot(float x, float y) {
    int now = p.millis();
    float bob = p.sin(now * 0.004f) * 1.2f;
    boolean blink = now % 3400 > 3250;
    boolean wave = (now / 900) % 2 == 0;
    float ry = y + bob;

    box(x + 2, y + 22, 14, 1, 0x50202A45);
    box(x + 4, y + 23, 10, 1, 0x30202A45);
    box(x + 7, ry, 4, 2, (now / 600) % 2 == 0 ? COL_GOLD : NEON);
    box(x + 8, ry - 2, 2, 2, COL_GOLD);
    box(x + 2, ry + 2, 16, 11, 0xFF2FA84F);
    box(x + 3, ry + 3, 14, 9, COL_MEM);
    box(x + 3, ry + 3, 14, 1, 0xFFC8F58C);
    box(x + 2, ry + 5, 2, 5, 0xFF2FA84F);
    box(x + 16, ry + 5, 2, 5, 0xFF2FA84F);
    if (blink) {
      box(x + 5, ry + 7, 3, 1, EDGE_DARK);
      box(x + 12, ry + 7, 3, 1, EDGE_DARK);
    } else {
      int look = (now / 1700) % 3;
      box(x + 5 + look, ry + 6, 3, 3, EDGE_DARK);
      box(x + 12 + look, ry + 6, 3, 3, EDGE_DARK);
      box(x + 6 + look, ry + 6, 1, 1, COL_WHITE);
      box(x + 13 + look, ry + 6, 1, 1, COL_WHITE);
    }
    box(x + 8, ry + 10, 4, 1, 0xFF2A7A3A);
    box(x + 5, ry + 13, 10, 7, COL_BLUE);
    box(x + 6, ry + 14, 8, 1, 0xFF8AB4FF);
    box(x + 4, ry + 14, 2, wave ? 3 : 5, COL_MEM);
    box(x + 16, ry + 14, 2, wave ? 5 : 3, COL_MEM);
    box(x + 4, ry + 20, 4, 2, COL_GOLD);
    box(x + 12, ry + 20, 4, 2, COL_GOLD);
    box(x + 5, ry + 22, 3, 1, 0xFFC97A24);
    box(x + 12, ry + 22, 3, 1, 0xFFC97A24);
  }

  void drawHand(GameState g, float x, float y, float w, float h) {
    boolean has = g.vm != null && g.vm.hand != null;
    if (has) boxA(x - 1, y - 1, w + 2, h + 2, HAND_HI, 60 + 60 * Math.abs(p.sin(p.millis() * 0.004f)));
    boldPanel(x, y, w, h, HAND_HI);
    box(x + 2, y + 2, w - 4, 8, p.lerpColor(HAND_HI, EDGE_DARK, 0.2f));
    textCenter("TANGAN", x + w / 2, y + 6, COL_WHITE, fTiny);
    String v = "-";
    if (has) v = g.vm.hand.toString();
    textCenter(v, x + w / 2, y + 15, COL_TEXT, fSmall);
  }

  void drawMemory(GameState g, float x, float y, float w, float h) {
    if (g.currentLevel >= g.levelCount) return;
    Level lv = g.levels[g.currentLevel];
    boldPanel(x, y, w, h, OUTBOX_HI);
    boldHeader(x, y, w, OUTBOX_HI, "MEMORI", 7, EDGE_DARK);
    int shown = Math.min(lv.memorySize, 8);
    for (int i = 0; i < shown; i++) {
      float bx = x + 5 + i * 23;
      float by = y + 14;
      box(bx, by, 21, 14, EDGE_DARK);
      box(bx + 1, by + 1, 19, 12, p.lerpColor(OUTBOX_HI, EDGE_DARK, 0.55f));
      box(bx + 1, by + 1, 19, 1, p.lerpColor(OUTBOX_HI, COL_WHITE, 0.5f));
      text(Integer.toString(i), bx + 2, by + 3, COL_MUTED, fTiny);
      String val = "0";
      if (g.vm != null && g.vm.memory != null && i < g.vm.memory.length) {
        val = Integer.toString(g.vm.memory[i]);
      }
      textCenter(val, bx + 11, by + 9, COL_TEXT, fTiny);
    }
  }

  void drawStatus(GameState g, Level lv) {
    String s = "LANGKAH " + (g.vm != null ? g.vm.steps : 0) + "/" + lv.runLimit;
    if (g.vm != null && g.vm.failed) s += "  " + g.vm.message;
    text(s, 5, 126, g.vm != null && g.vm.failed ? COL_WARN : COL_GOLD, fTiny);
  }

  void drawControls(GameState g) {
    uiButton(4, 133, 50, 12, "JALANKAN", 20, COL_BLUE, g.running);
    uiButton(56, 133, 28, 12, "JEDA", 21, COL_PANEL_HI, false);
    uiButton(86, 133, 42, 12, "LANGKAH", 22, COL_PANEL_HI, false);
    uiButton(130, 133, 34, 12, "RESET", 23, COL_PANEL_HI, false);
    uiButton(166, 133, 48, 12, g.fastRun ? "CEPAT 4x" : "NORMAL 1x", 24, COL_PANEL_HI, g.fastRun);
  }

  int blockColor(String op) {
    if (op.equals(Block.AMBIL) || op.equals(Block.TARUH)) return COL_IO;
    if (op.equals(Block.SIMPAN) || op.equals(Block.MUAT)) return COL_MEM;
    if (op.equals(Block.TAMBAH) || op.equals(Block.KURANG)) return COL_ARITH;
    return COL_FLOW;
  }

  void drawPalette(GameState g, Level lv) {
    int[] icons = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19};
    for (int i = 0; i < BLOCK_ALL.length; i++) {
      String op = BLOCK_ALL[i];
      boolean open = lv.blocks.contains(op);
      float x = 1 + i * 32;
      float y = 148;
      boolean hover = hit(mx, my, x, y, 30, 20);
      int accent = open ? blockColor(op) : COL_LOCK;
      int face = open ? (hover ? p.lerpColor(accent, COL_WHITE, 0.24f) : accent) : 0xFF24263C;
      if (hover && open) {
        for (int k = 2; k >= 1; k--) boxA(x - k, y - k, 30 + k * 2, 20 + k * 2, accent, 32);
      }
      box(x, y + 1, 30, 19, EDGE_DARK);
      box(x + 1, y + 2, 28, 16, face);
      box(x + 1, y + 2, 28, 1, p.lerpColor(face, COL_WHITE, 0.5f));
      box(x + 1, y + 16, 28, 2, p.lerpColor(face, EDGE_DARK, 0.5f));
      box(x + 2, y, 8, 2, accent);
      uiTileIcon(icons[i], x + 1, y + 1,
        open ? p.lerpColor(accent, EDGE_DARK, 0.35f) : 0xFF3A3D58,
        open ? COL_WHITE : COL_MUTED);
      textCenter(shortOf(op), x + 16, y + 15.5f, open ? COL_TEXT : COL_LOCK, fTiny);
    }
  }


  String shortOf(String op) {
    if (op.equals(Block.LONCAT_NOL)) return "L-NOL";
    if (op.equals(Block.LONCAT_NEG)) return "L-NEG";
    return op;
  }

  void drawProgramPanel(GameState g, Level lv) {
    if (g.program == null) return;
    float x = 199, y = 34, w = 115, h = 98;
    boldPanel(x, y, w, h, PROG_HI);
    box(x + 2, y + 2, w - 4, 9, PROG_HI);
    box(x + 2, y + 2, w - 4, 1, p.lerpColor(PROG_HI, COL_WHITE, 0.5f));
    uiTileIcon(9, x + 3, y + 1, p.lerpColor(PROG_HI, EDGE_DARK, 0.45f), COL_WHITE);
    text("PROGRAM", x + 15, y + 6.5f, COL_TEXT, fTiny);
    textRight("SIZE " + g.program.blockCount(), x + w - 5, y + 6.5f,
      g.program.blockCount() <= lv.sizeTarget ? COL_GOLD : COL_WARN, fTiny);

    box(x + 3, y + 12, w - 6, 80, 0xFF0B1024);
    for (int r = 0; r <= Program.VISIBLE_ROWS; r++) box(x + 3, y + 12 + r * 8, w - 6, 1, 0xFF2A2350);
    for (int c = 1; c < 4; c++) boxA(x + 3 + c * 28, y + 12, 1, 80, 0xFF44306E, 140);
    int total = g.program.blocks.size();
    int maxScroll = Math.max(0, total - Program.VISIBLE_ROWS);
    box(x + w - 4, y + 13, 2, 78, 0xFF2A2350);
    if (maxScroll > 0) {
      float th = Math.max(8, 78 * Program.VISIBLE_ROWS / (float) total);
      float ty = y + 13 + (78 - th) * (g.program.scroll / (float) maxScroll);
      box(x + w - 4, ty, 2, th, PROG_HI);
    }

    int start = g.program.scroll;
    for (int r = 0; r < Program.VISIBLE_ROWS; r++) {
      int idx = start + r;
      if (idx >= g.program.blocks.size()) break;
      float ry = y + 13 + r * 8;
      Block b = g.program.blocks.get(idx);
      boolean sel = idx == g.program.selected;
      boolean active = g.vm != null && g.vm.activeIndex == idx;
      if (active) {
        boxA(x + 3, ry - 1, w - 6, 9, COL_GOLD, 90 + 80 * Math.abs(p.sin(p.millis() * 0.006f)));
        box(x + 4, ry, w - 8, 7, 0xFF7A5A16);
      } else if (sel) {
        box(x + 4, ry, w - 8, 7, COL_PANEL_HI);
      } else {
        boxA(x + 4, ry, w - 8, 7, 0xFF141A36, 170);
      }
      box(x + 4, ry, 2, 7, active ? COL_GOLD : blockColor(b.op));
      int tc = active ? COL_BG2 : COL_TEXT;
      text(b.display(), x + 8, ry + 3.5f, tc, fTiny);
      textRight(Integer.toString(idx + 1), x + w - 6, ry + 3.5f, active ? COL_BG2 : COL_MUTED, fTiny);
    }

    if (start > 0) {
      boolean hov = hit(mx, my, 296, 44, 18, 10);
      box(296, 44, 18, 10, hov ? COL_GOLD : 0xFF3A2A6B);
      textCenter("^", 305, 49, hov ? COL_BG2 : COL_GOLD, fTiny);
    }
    if (start + Program.VISIBLE_ROWS < total) {
      boolean hov = hit(mx, my, 296, 114, 18, 10);
      box(296, 114, 18, 10, hov ? COL_GOLD : 0xFF3A2A6B);
      textCenter("v", 305, 119, hov ? COL_BG2 : COL_GOLD, fTiny);
    }
    text("LANGKAH " + (g.vm != null ? g.vm.steps : 0), x + 5, y + h - 4, COL_MUTED, fTiny);
  }

  void drawResultStar(float cx, float cy, float sz, boolean earned, float t) {
    float x = cx - sz / 2;
    float y = cy - sz / 2;
    if (earned) {
      float glow = Math.abs(p.sin(p.millis() * 0.005f + cx));
      boxA(x - 5, y - 5, sz + 10, sz + 10, COL_GOLD, 12 + 12 * glow);
      boxA(x - 2, y - 2, sz + 4, sz + 4, COL_GOLD, 18 + 18 * glow);
    }
    if (starGold == null || starGray == null) {
      drawStar(cx, cy, sz / 7f, earned ? COL_GOLD : 0xFF3A3D58);
      return;
    }
    p.image(starGray, x, y, sz, sz);
    if (earned) {
      p.tint(255, 255 * p.constrain(t, 0, 1));
      p.image(starGold, x, y, sz, sz);
      p.noTint();
    }
  }

  void resultButton(float x, float y, float w, float h, String label, int icon, int base, int edge, boolean primary) {
    boolean hov = hit(mx, my, x, y, w, h);
    if (hov || primary) {
      for (int k = 3; k >= 1; k--) boxA(x - k, y - k, w + k * 2, h + k * 2, edge, hov ? 28 : 14);
    }
    if (primary) drawBrackets(x, y, w, h, COL_WHITE);
    box(x, y, w, h, hov ? COL_WHITE : edge);
    box(x + 1, y + 1, w - 2, h - 2, hov ? p.lerpColor(base, COL_WHITE, 0.2f) : base);
    box(x + 1, y + 1, w - 2, 1, p.lerpColor(base, COL_WHITE, 0.5f));
    drawGlyphScaled(icon, x + 8, y + 4, COL_WHITE, 2);
    textCenter(label, x + w / 2 + 8, y + h / 2, COL_WHITE, fSmall);
  }

  void drawResult(GameState g) {
    int now = p.millis();
    p.fill(8, 10, 26, 205);
    p.noStroke();
    p.rect(0, 0, 320, 180);

    int[] conf = {COL_GOLD, NEON, COL_FLOW, COL_IO, GRASS};
    for (int i = 0; i < 22; i++) {
      float cx = (i * 47 + 12) % 320;
      float cy = (now * 0.02f * (1 + i % 3) + i * 31) % 190;
      boxA(cx, cy, 2, 2, conf[i % 5], 180);
      if (i % 3 == 0) boxA(cx + 1, cy - 2, 1, 1, conf[i % 5], 160);
    }
    int pv = (int) (now / 900f) % 4;
    drawPuzzle(6, 36, 2, 0xFF3B9DF6, pv, 0);
    drawPuzzle(298, 52, 2, COL_FLOW, pv + 1, 0);
    drawPuzzle(4, 124, 2, GOLD2, pv + 2, 0);
    drawPuzzle(292, 130, 2, 0xFF3B9DF6, pv + 3, 0);

    box(14, 24, 292, 128, EDGE_DARK);
    box(15, 25, 290, 126, g.resultPass ? PROG_HI : COL_WARN);
    box(16, 26, 288, 124, 0xFF101634);
    box(16, 26, 288, 1, p.lerpColor(g.resultPass ? PROG_HI : COL_WARN, COL_WHITE, 0.6f));
    box(16, 148, 288, 2, p.lerpColor(g.resultPass ? PROG_HI : COL_WARN, EDGE_DARK, 0.5f));
    drawBrackets(16, 26, 288, 124, g.resultPass ? COL_IO : COL_WARN);

    if (g.resultPass) {
      drawRays(20, 18, false);
      drawRays(292, 18, true);
      box(34, 12, 252, 28, EDGE_DARK);
      box(35, 13, 250, 26, 0xFF4C1D95);
      box(36, 14, 248, 24, 0xFF7C3AED);
      box(36, 14, 248, 2, p.lerpColor(PROG_HI, COL_WHITE, 0.6f));
      box(36, 36, 248, 2, 0xFF3B1A70);
      box(38, 14, 24, 24, EDGE_DARK);
      box(39, 15, 22, 22, 0xFFC97A24);
      box(40, 16, 20, 20, 0xFFFFD166);
      drawGlyphScaled(2, 41, 16, COL_WHITE, 2.8f);
      drawPixelText("LULUS!", 177, 28, 0xFF3B1A70, 2.5f);
      drawPixelText("LULUS!", 176, 26, 0xFFFFF2C4, 2.5f);

      box(23, 43, 134, 26, EDGE_DARK);
      box(24, 44, 132, 24, NEON);
      box(25, 45, 130, 22, PANEL_INNER);
      uiTileIcon(9, 28, 47, 0xFF2456A8, COL_WHITE);
      text("Size", 44, 51, COL_MUTED, fTiny);
      text(g.program.blockCount() + "/" + g.levels[g.currentLevel].sizeTarget, 44, 63, NEON, fSmall);

      box(163, 43, 134, 26, EDGE_DARK);
      box(164, 44, 132, 24, NEON);
      box(165, 45, 130, 22, PANEL_INNER);
      uiTileIcon(25, 168, 47, 0xFF2456A8, COL_WHITE);
      text("Langkah", 184, 51, COL_MUTED, fTiny);
      text(g.lastSteps + "/" + g.levels[g.currentLevel].speedTarget, 184, 63, NEON, fSmall);

      box(24, 84, 84, 2, 0xFF1E4B7A);
      box(212, 84, 84, 2, 0xFF1E4B7A);
      long elapsed = now - g.resultAt;
      int revealed = (int) Math.min(3, Math.max(0, elapsed / 320));
      float[] sx = {126, 160, 194};
      for (int i = 0; i < 3; i++) {
        boolean earned = i < g.earnedStars;
        long since = elapsed - (long) (i + 1) * 320;
        if (earned && i < revealed) {
          float t = p.constrain(since / 320f, 0, 1);
          drawResultStar(sx[i], 86, 20f * (1 + 0.18f * (1 - t)), true, t);
        } else {
          drawResultStar(sx[i], 86, 20f, false, 0);
        }
      }

      drawRobot(20, 96);
      drawStar(44, 118, 1, COL_GOLD);
      drawStar(280, 118, 1, NEON);
      drawPuzzle(272, 48, 2, 0xFF3B9DF6, pv, 0);
      drawPuzzle(280, 82, 2, COL_FLOW, pv + 1, 0);
      resultButton(28, 124, 120, 20, "LANJUT", 20, 0xFF2563EB, NEON, true);
      resultButton(170, 124, 124, 20, "PILIH LEVEL", 26, 0xFF2E4A9E, COL_IO, false);
    } else {
      box(40, 16, 240, 26, EDGE_DARK);
      box(41, 17, 238, 24, 0xFF7A2030);
      box(42, 18, 236, 22, 0xFFB32B43);
      drawGlyphScaled(3, 48, 20, COL_WHITE, 2.4f);
      textCenter(g.resultTitle, 174, 29, 0xFFFFF2C4, fMid);

      box(23, 52, 274, 30, EDGE_DARK);
      box(24, 53, 272, 28, COL_WARN);
      box(25, 54, 270, 26, PANEL_INNER);
      p.textFont(fTiny);
      p.fill(COL_TEXT);
      p.textAlign(p.LEFT, p.CENTER);
      p.text(g.resultMessage, 32, 67, 258, 24);

      drawResultStar(160, 96, 20f, false, 0);
      drawRobot(20, 100);
      resultButton(28, 124, 120, 20, "ULANGI", 23, 0xFF2563EB, NEON, true);
      resultButton(170, 124, 124, 20, "PILIH LEVEL", 26, 0xFF2E4A9E, COL_IO, false);
    }
  }

  // ---------- input ----------

  void activateMenu(GameState g, int idx) {
    if (idx == 0) g.queue("MULAI");
    else if (idx == 1) g.queue("TUTORIAL");
    else if (idx == 2) g.queue("PILIH");
    else if (idx == 3) g.queue("KELUAR");
  }

  void mousePressed(GameState g, float x, float y, int mb) {
    if (g.transition != 0) return;
    if (g.screen == GameState.MENU) {
      if (hit(x, y, 102, 66, 116, 24)) activateMenu(g, 0);
      else if (hit(x, y, 108, 92, 104, 19)) activateMenu(g, 1);
      else if (hit(x, y, 108, 110, 104, 19)) activateMenu(g, 2);
      else if (hit(x, y, 108, 128, 104, 19)) activateMenu(g, 3);
      return;
    }

    if (g.screen == GameState.LEVEL_TUTORIAL) {
      TutorialSession s = g.tutorialSession;
      if (s == null) return;
      if (hit(x, y, 3, 2, 19, 11)) {
        g.openSelect();
        return;
      }
      if (hit(x, y, 6, 158, 54, 16)) {
        if (s.page == 2) s.retry();
        else if (s.page > 0) s.page--;
        else g.openSelect();
        return;
      }
      if (hit(x, y, 112, 158, 64, 16)) {
        g.finishLevelTutorial();
        return;
      }
      if (hit(x, y, 220, 158, 94, 16)) {
        if (s.page < 2) s.page++;
        else if (s.solved) g.finishLevelTutorial();
        return;
      }
      if (s.page == 2) {
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
      if (hit(x, y, 28, 124, 120, 20)) {
        if (g.resultPass) g.continueNext();
        else g.resetRun();
      } else if (hit(x, y, 170, 124, 124, 20)) {
        g.openSelect();
      }
      return;
    }

    if (hit(x, y, 3, 2, 19, 11)) {
      g.openSelect();
      return;
    }
    if (hit(x, y, 290, 2, 12, 11)) {
      g.running = false;
      g.hintStage = 1;
      return;
    }
    if (hit(x, y, 304, 2, 12, 11)) {
      g.helpShown = true;
      return;
    }

    if (hit(x, y, 4, 133, 50, 12)) { g.run(); return; }
    if (hit(x, y, 56, 133, 28, 12)) { g.pause(); return; }
    if (hit(x, y, 86, 133, 42, 12)) { g.stepOnce(); return; }
    if (hit(x, y, 130, 133, 34, 12)) { g.resetRun(); return; }
    if (hit(x, y, 166, 133, 48, 12)) { g.toggleSpeed(); return; }

    for (int i = 0; i < BLOCK_ALL.length; i++) {
      float px = 1 + i * 32;
      if (hit(x, y, px, 148, 30, 20)) {
        g.addBlock(BLOCK_ALL[i]);
        return;
      }
    }

    if (hit(x, y, 296, 44, 18, 10)) {
      g.scrollProgram(-1);
      return;
    }
    if (hit(x, y, 296, 114, 18, 10)) {
      g.scrollProgram(1);
      return;
    }

    if (x >= 199 && x < 314 && y >= 46 && y < 46 + Program.VISIBLE_ROWS * 8 && g.program != null) {
      int row = (int) ((y - 46) / 8);
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

  void mouseWheel(GameState g, float x, float y, float count) {
    if (g.screen != GameState.PLAY || g.resultShown || g.helpShown || g.hintStage > 0) return;
    if (g.program == null) return;
    if (x < 199 || x >= 314 || y < 46 || y >= 46 + Program.VISIBLE_ROWS * 8) return;
    g.scrollProgram(count > 0 ? 1 : -1);
  }

  void keyPressed(GameState g) {
    if (g.transition != 0) return;
    if (g.screen == GameState.MENU) {
      if (p.keyCode == K_UP || p.keyCode == K_LEFT) {
        menuFocus = (menuFocus + 3) % 4;
      } else if (p.keyCode == K_DOWN || p.keyCode == K_RIGHT) {
        menuFocus = (menuFocus + 1) % 4;
      } else if (p.keyCode == K_ENTER || p.keyCode == K_RETURN || p.key == ' ') {
        activateMenu(g, menuFocus);
      } else if (p.keyCode == K_ESC) {
        g.quit();
      }
      return;
    }
    if (g.screen == GameState.LEVEL_TUTORIAL) {
      TutorialSession s = g.tutorialSession;
      if (p.keyCode == K_ESC) {
        g.openSelect();
        return;
      }
      if (s == null) return;
      if (p.keyCode == K_LEFT) {
        if (s.page == 2) s.retry();
        else if (s.page > 0) s.page--;
      } else if (p.keyCode == K_RIGHT || p.keyCode == K_ENTER || p.keyCode == K_RETURN) {
        if (s.page < 2) s.page++;
        else if (s.solved) g.finishLevelTutorial();
      } else if (s.page == 2 && p.key >= '1' && p.key <= '4') {
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

    if (p.keyCode == K_PGUP) { g.scrollProgram(-1); return; }
    if (p.keyCode == K_PGDWN) { g.scrollProgram(1); return; }
    if (p.keyCode == K_ESC) { g.openSelect(); return; }
    if (p.keyCode == K_DELETE || p.keyCode == K_BACKSPACE) { g.removeSelected(); return; }
    if (p.keyCode == K_UP) { g.moveSelected(-1); return; }
    if (p.keyCode == K_DOWN) { g.moveSelected(1); return; }
    if (p.keyCode == K_ENTER || p.keyCode == K_RETURN) { g.run(); return; }
    if (p.key == ' ') { g.stepOnce(); return; }
  }
}
