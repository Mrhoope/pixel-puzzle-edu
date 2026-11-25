// Program: daftar blok yang disusun pemain.

final String[] BLOCK_ALL = {
  "AMBIL", "TARUH", "SIMPAN", "MUAT", "TAMBAH", "KURANG",
  "LABEL", "LONCAT", "LONCAT JIKA NOL", "LONCAT JIKA NEGATIF"
};

class Block {
  static final String AMBIL = "AMBIL";
  static final String TARUH = "TARUH";
  static final String SIMPAN = "SIMPAN";
  static final String MUAT = "MUAT";
  static final String TAMBAH = "TAMBAH";
  static final String KURANG = "KURANG";
  static final String LABEL = "LABEL";
  static final String LONCAT = "LONCAT";
  static final String LONCAT_NOL = "LONCAT JIKA NOL";
  static final String LONCAT_NEG = "LONCAT JIKA NEGATIF";

  String op;
  int arg = 0;

  Block(String op) {
    this.op = op;
  }

  boolean needsArg() {
    return op.equals(SIMPAN) || op.equals(MUAT) || op.equals(TAMBAH) || op.equals(KURANG)
      || op.equals(LABEL) || op.equals(LONCAT) || op.equals(LONCAT_NOL) || op.equals(LONCAT_NEG);
  }

  boolean usesMemory() {
    return op.equals(SIMPAN) || op.equals(MUAT) || op.equals(TAMBAH) || op.equals(KURANG);
  }

  String display() {
    return needsArg() ? op + " " + arg : op;
  }

  String shortLabel() {
    if (op.equals(LONCAT_NOL)) return "L-NOL";
    if (op.equals(LONCAT_NEG)) return "L-NEG";
    return op;
  }

  String encode() {
    return display();
  }

  boolean known() {
    for (int i = 0; i < BLOCK_ALL.length; i++) {
      if (BLOCK_ALL[i].equals(op)) return true;
    }
    return false;
  }

}

Block decodeBlock(String s) {
  if (s == null) return null;
  s = s.trim();
  if (s.length() == 0) return null;

  String op = s;
  int arg = 0;
  int lastSpace = s.lastIndexOf(' ');
  if (lastSpace > 0) {
    try {
      arg = Integer.parseInt(s.substring(lastSpace + 1).trim());
      op = s.substring(0, lastSpace).trim();
    } catch (Exception e) {
      op = s;
      arg = 0;
    }
  }

  Block b = new Block(op);
  if (!b.known()) return null;
  b.arg = arg;
  return b;
}

class Program {
  static final int VISIBLE_ROWS = 12;
  static final int MAX_BLOCKS = 24;

  ArrayList<Block> blocks = new ArrayList<Block>();
  int selected = -1;
  int scroll = 0;

  boolean add(String op) {
    if (blocks.size() >= MAX_BLOCKS) return false;
    Block b = new Block(op);
    blocks.add(b);
    selected = blocks.size() - 1;
    ensureVisible(selected);
    return true;
  }

  void removeAt(int index) {
    if (index < 0 || index >= blocks.size()) return;
    blocks.remove(index);
    if (selected >= blocks.size()) selected = blocks.size() - 1;
    if (selected < 0 && blocks.size() > 0) selected = 0;
    ensureVisible(Math.max(0, selected));
  }

  void move(int index, int dir) {
    int target = index + dir;
    if (index < 0 || index >= blocks.size()) return;
    if (target < 0 || target >= blocks.size()) return;
    Block a = blocks.get(index);
    blocks.set(index, blocks.get(target));
    blocks.set(target, a);
    selected = target;
    ensureVisible(selected);
  }

  void cycleArg(int memorySize) {
    Block b = selectedBlock();
    if (b == null || !b.needsArg()) return;
    int max = b.usesMemory() ? Math.max(0, memorySize - 1) : 9;
    b.arg = (b.arg + 1) % (max + 1);
  }

  Block selectedBlock() {
    if (selected < 0 || selected >= blocks.size()) return null;
    return blocks.get(selected);
  }

  void ensureVisible(int index) {
    if (index < 0) return;
    int rows = VISIBLE_ROWS;
    if (index < scroll) scroll = index;
    if (index >= scroll + rows) scroll = index - rows + 1;
    int maxScroll = Math.max(0, blocks.size() - rows);
    scroll = Math.max(0, Math.min(scroll, maxScroll));
  }

  int blockCount() {
    return blocks.size();
  }

  String encode() {
    String s = "";
    for (int i = 0; i < blocks.size(); i++) {
      if (s.length() > 0) s += "|";
      s += blocks.get(i).encode();
    }
    return s;
  }

  void decode(String s) {
    blocks.clear();
    selected = -1;
    scroll = 0;
    if (s == null || s.length() == 0) return;
    String[] parts = s.split("\\|");
    for (int i = 0; i < parts.length && blocks.size() < MAX_BLOCKS; i++) {
      Block b = decodeBlock(parts[i]);
      if (b != null) blocks.add(b);
    }
  }
}
